class DocumentsController < ApplicationController
  before_action :authenticate_user!, except: [:download_file, :download_essential_file, :download_comprehensive_file, :download_weekend_course_file, :download_other_comprehensive_file]
  before_action :set_document, only: [:show, :edit, :update, :destroy, :access, :download_file, :download]
  before_action :load_tags, only: [:new, :create, :edit, :update]
  layout 'layouts/dashboard'

  def index
    if current_user.student? && !current_user.questionnaire.present?
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 3
    end

    redirect_to dashboard_home_path and return  if current_user.student? && policy_scope(Document).blank?

    master_feature = current_user.accessible_features.find_by('name LIKE?', '%DocumentsFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end

    (@filterrific = initialize_filterrific(
        policy_scope(Document),
        params[:filterrific],
        select_options: {
          tag: current_user.current_product_verion_feature_price_tags('DocumentsFeature').map { |t| [t.name, t.id] },
          sorted_by: Document.options_for_sorted_by,
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc'],
        }
    )) || return
    @documents = @filterrific.find.page(params[:page]).order('documents.created_at DESC').distinct

    unless ::DocumentPolicy.new(current_user, @documents).index?
      raise Pundit::NotAuthorizedError, "not allowed to view these documents"
    end

    rescue ActiveRecord::RecordNotFound => e
      puts "Had to reset filterrific params: #{ e.message }"
      redirect_to(reset_filterrific_url(format: :html)) and return

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @document_url = Rails.application.routes.url_helpers.url_for controller: 'documents', action: 'download', id: @document.id, only_path: true
    # TODO set last_accessed
    # @document.access_document.set_last_accessed
    render layout: 'layouts/application'
  end

  def new
    @document = Document.new
    @for_timetable_ids = Document.where(for_timetable: true).pluck(:product_line_id)
  end

  def edit
  end

  def create
    @document = current_user.documents.build(document_params)
    authorize @document
    respond_to do |format|
      if @document.save
        format.html { redirect_to documents_path, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def download
    #Download the documents from the S3 and stream it to the user
    response.headers['Content-Type'] = 'application/pdf'
    uri = URI(@document.attachment.url)
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

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def access
    @document.set_last_accessed(current_user)
    redirect_to @document.attachment.url(:original, false)
  end

  def document_feedback
    @content = Document.find(params[:id])
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def filter_topics
    if params[:type].present?
      @options = Tag.by_product_line(params[:type])
    else
      @options = Tag.all.order(:name)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def download_file
    unless @document.nil?
      url = @document.attachment.url
      data = open(url)
      send_data data.read, filename: @document.attachment_file_name, type: "application/pdf", stream: 'true', buffer_size: '4096'
    else
      #render :nothing => true, :status => 200, :content_type => 'text/html'
      redirect_to documents_url
    end
  end

  def download_essential_file
    send_file("#{Rails.root}/public/InterviewReady_Essentials_Sample_Timetable.pdf",
              filename: "InterviewReady Essentials Sample Timetable.pdf",
              type: "application/pdf"
    )
  end

  def download_comprehensive_file
    send_file("#{Rails.root}/public/InterviewReady_Comprehensive_Sample_Timetable.pdf",
              filename: "InterviewReady Comprehensive Sample Timetable.pdf",
              type: "application/pdf"
    )
  end

  def download_weekend_course_file
    send_file("#{Rails.root}/public/Sample_Timetable_Weekend_Course.pdf",
              filename: "Sample Timetable - Weekend Course.pdf",
               type: "application/pdf"
    )
  end

  def download_other_comprehensive_file
    send_file("#{Rails.root}/public/Sample_Class_Schedule.pdf",
              filename: "Sample Class Schedule.pdf",
              type: "application/pdf"
    )
  end

  private
    def set_document
      @document = Document.find_by(id: params[:id])
      authorize @document unless @document.nil?
    end

    def load_tags
      @tags = policy_scope(Tag)
    end

    def document_params
      params.require(:document).permit(:attachment, :for_timetable, :product_line_id, :for_paid, :for_trial, tag_ids: [])
    end
end
