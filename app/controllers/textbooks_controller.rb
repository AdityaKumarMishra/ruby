class TextbooksController < ApplicationController
  before_action :set_textbook, only: [:show, :edit, :update, :destroy, :textbook_document, :mark_book_read]
  before_action :authenticate_user!
  before_action :check_access_limit, only: [:show]
  layout :resolve_layout

  respond_to :html

  def index
    @textbooks = policy_scope(Textbook).order(:title)
  end

  def show
    if @textbook.present?
      authorize(@textbook)
      if current_user.phone_number.present?
        number = current_user.phone_number.to_s
      else
        number = "N/A"
      end
      #new_url = TextbookUrl.create textbook: @textbook, user: current_user
      #@textbook_url = new_url.full_url
      @textbook_url = @textbook.document.url
      @print = TextbookPrint.find_by(user_id: current_user.id, textbook_id: @textbook.id)
      if current_user.student? 
        if (@textbook.for_textbook || @textbook.for_textbook_slide)
          @textbook.completed_textbooks.find_or_create_by(user_id: current_user.id, course_id: current_course.try(:id))
        end
        @textbook.textbook_reads.find_or_create_by(user_id: current_user.id)
      end
      @print_count = @print.print_count if @print
      @role = current_user.role
    end
  end

  def timetable
    @course = Course.find_by_id(params[:id])
    @course_url = Rails.application.routes.url_helpers.url_for controller: 'textbooks', action: 'download_timetable', id: @course.id, only_path: true
    # TODO set last_accessed
    # @document.access_document.set_last_accessed
    render layout: 'layouts/application'
  end

  def download_timetable
    @course = Course.find(params[:id])
    #Download the documents from the S3 and stream it to the user
    response.headers['Content-Type'] = 'application/pdf'
    uri = URI(@course.textbook.document.url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |res|
        res.read_body do |chunk|
          response.stream.write chunk
        end
      end
    end
    response.stream.close
  end

  def new
    @time_table_books_count = Textbook.where.not(product_line_id: nil).pluck(:product_line_id).count
    @for_timetable_ids = Textbook.where(for_timetable: true).pluck(:product_line_id)
    @textbook = Textbook.new
    respond_with(@textbook)
  end

  def textbook_document
    send_file @textbook.document.path, type: 'application/pdf', disposition: 'inline'
  end

  def edit
    @time_table_books_count = Textbook.where.not(product_line_id: nil).pluck(:product_line_id).count
  end

  def create
    @textbook = current_user.textbooks.build(textbook_params)
    authorize @textbook
    @textbook.save
    respond_with(@textbook)
  end

  def update
    if @textbook.user.nil?
      @textbook.user_id = current_user.id
    end
    @textbook.update(textbook_params)
    respond_with(@textbook)
  end


  def exercise_review_videos
    @textbook = Textbook.find_by(id: params[:id])
    if current_user.has_video_feature
      tags = current_user.current_feature_tags('VideoFeature') & @textbook.tags
      @videos = Vod.by_tag(tags)
    else
      @no_video_access = true
    end
    @type = 'Videos'
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def reset_access
    @textbook = Textbook.find_by(id: params[:id])
  end

  def update_print_access
    book_id = params[:id]
    user_ids = params[:user_id]
    user_ids = User.student.pluck(:id) if user_ids.nil?

    user_ids.each do |id|
      @print = TextbookPrint.find_by(user_id: id, textbook_id: book_id)
      @print.update(print_count: 1) if @print
    end

    respond_to do |format|
      format.html {redirect_to dashboard_textbooks_path, notice: 'Access was successfully resetted.'}
    end

  end

  def textbook_feedback
    @content = Textbook.find_by(id: params[:id])
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def print_count
    user_id = current_user.id
    book_id = params[:id]
    @print = TextbookPrint.find_by(user_id: user_id, textbook_id: book_id)
    if @print
      @print.update(print_count: @print.print_count + 1) if current_user.student?
    else
      @print = TextbookPrint.create(user_id: user_id, textbook_id: book_id, print_count: 1) if current_user.student?
    end
    @print
  end

  def destroy
    textbook_type = params[:type]
    @textbook.destroy
    redirect_to dashboard_textbooks_path(type: textbook_type), notice: 'Textbook was successfully destroyed.'
  end

  def mark_book_read
    if @textbook.present?
      @textbook.textbook_reads.find_or_create_by(user_id:  current_user.id).update(is_read: true)
    end
    respond_to do |format|
      format.html {redirect_to "/404"}
      format.js {render json: true}
    end
    
  end

  private

  def set_textbook
    @textbook = Textbook.find_by(id: params[:id])
  end

  def check_access_limit
    if @textbook.present? && current_user.present?
      return unless current_user.student? && @textbook.for_textbook
      access_feature = current_user.active_enrolment_features.includes(:master_feature).where('master_features.name LIKE (?)', '%TextbookFeature%')
      return if access_feature.where(qty: nil).present?
      access_limit = access_feature.sum(:qty)
      return if access_limit <= 0
      read_ids =  current_user.textbook_reads.pluck(:textbook_id).uniq
      @completed_count = read_ids.count

      if (@completed_count >= access_limit) && read_ids.exclude?(@textbook.id)
        redirect_to dashboard_textbooks_path(access: false)
      end
    end
  end

  def textbook_params
    params.require(:textbook).permit(:user_id,:updated_at,:title, :document, :for_textbook, :for_textbook_slide, :for_live_handout, :for_live_slide, :for_document, :for_downloadable_resource, :for_weekend, :for_additional_chapter, :for_paid, :for_trial,:for_revision_weekend, :for_mock_exam, tag_ids: [])
  end
 
  def resolve_layout
    if (action_name == 'show') && current_user.student?
      'student_page'
    end
  end
end
