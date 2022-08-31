class VodsController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_access_allowed!
  before_action :set_vod, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout
  respond_to :html
  before_action :check_access_limit, only: [:show]

  def index
    if current_user.student? && !current_user.questionnaire.present?
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 3
    end
    @vods = policy_scope(Vod)
    @vod_tags = Tag.all
    @tags = current_user.current_product_verion_feature_price_tags('VideoFeature').map { |t| [t.name, t.id] }
    @level3_tags = []
    if current_user.student? && params[:vods_filter].present? && !params[:vods_filter][:by_level2_tag].blank?
      vod_tags_ids = Tag.find_by(id: params[:vods_filter][:by_level2_tag]).self_and_descendants_ids
      @level3_tags = Tag.includes(:taggings).where('tags.id IN (?) AND taggings.taggable_id IN (?) AND taggings.taggable_type=? ', vod_tags_ids, Vod.all.ids,'Vod').references(:taggings).map { |t| [t.name, t.id] }
    end

    if params[:pro_line] || params[:lvl2_id] || params[:lvl3_id]
      params[:vods_filter] = {"by_product_line"=>params[:pro_line], "by_level2_tag"=>params[:lvl2_id], "by_level3_tag"=>params[:lvl3_id]}
    end

    if params[:vods_filter].present?
      if  params[:vods_filter][:by_level3_tag].present? || params[:vods_filter][:by_level2_tag].present?
        tag_id = params[:vods_filter][:by_level3_tag].present?  ? params[:vods_filter][:by_level3_tag] : params[:vods_filter][:by_level2_tag]
        @vod_tags = @vods.by_level2_tag(tag_id)
      elsif params[:vods_filter][:by_product_line].present?
        @vod_tags = @vods.by_product_line(params[:vods_filter][:by_product_line])
      elsif params[:vods_filter][:by_tag_id].present?
        tag_id = params[:vods_filter][:by_tag_id]
        @vod_tags = @vods.by_tag_id(tag_id)
      else
      @vod_tags = Tag.includes(:taggings).where('taggings.taggable_id IN (?) AND taggings.taggable_type=? ', @vods.ids,'Vod').references(:taggings).collect(&:second_sub_root).uniq.compact.sort_by(&:name)
      end
    else
      @vod_tags = Tag.includes(:taggings).where('taggings.taggable_id IN (?) AND taggings.taggable_type=? ', @vods.ids,'Vod').references(:taggings).collect(&:second_sub_root).uniq.compact.sort_by(&:name)
    end

    live_mock_tag = Tag.find(362)
    online_mock_tag =Tag.find(363)
    @vod_tags.to_a << live_mock_tag unless @vod_tags.include?(live_mock_tag)
    @vod_tags.to_a << online_mock_tag unless @vod_tags.include?(online_mock_tag)
    if current_user.student? && current_user.not_vid_featue_log?
      vid_tags = current_user.accessible_features.where("name ilike (?)", "%mockexam%").pluck(:name)
      tag_ids = []
      tag_ids << 363 if vid_tags.include?("GamsatOnlineMockExamFeature1")
      tag_ids << 362 if vid_tags.include?("GamsatOnlineMockExamFeature2")

      @vod_tags = Tag.where(id: tag_ids)
      @tags = @vod_tags.map { |t| [t.name, t.id] }
    end
    if params[:tag_id]
      @tag = Tag.find(params[:tag_id])
    else
      @tag = @vod_tags.first
    end

    if current_user.student?
      @product_version = current_course.product_version
      if @tag.try(:id) == 362
        #live_mock_feature = current_user.accessible_features.find_by('name LIKE?', '%LiveMockExamFeature%')
        live_mock_feature = current_user.accessible_features.find_by('name LIKE?', '%GamsatOnlineMockExamFeature2%')
        if !live_mock_feature.present?
          live_feature = MasterFeature.type(@product_version.type).find_by('name LIKE?', '%GamsatOnlineMockExamFeature2%')
          redirect_to(feature_logs_path(feature_type: live_feature))
        end
      elsif @tag.try(:id) == 363
        #live_mock_feature = current_user.accessible_features.find_by('name LIKE?', '%OnlineMockExamFeature%')
        live_mock_feature = current_user.accessible_features.find_by('name LIKE?', '%GamsatOnlineMockExamFeature1%')
        if !live_mock_feature.present?
          live_feature = MasterFeature.type(@product_version.type).find_by('name LIKE?', '%GamsatOnlineMockExamFeature1%')
          redirect_to(feature_logs_path(feature_type: live_feature))
        end
      end
    end

    master_feature = current_user.accessible_features.find_by('name LIKE?', '%VideoFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @tab = params[:tab]
    authorize @vods
    @access = params[:access]
    if @access
      course_type = current_course.product_version.try(:type)
      case course_type
      when 'GamsatReady'
        @p_course_path = '/gamsat-preparation-courses#course-packages'
        @product_line = 'GAMSAT'
      when 'UmatReady'
        @p_course_path = '/umat-preparation-courses#course-packages'
        @product_line = 'UMAT'
      when 'HscReady'
        @p_course_path = '/hsc'
        @product_line = 'HSC'
      when 'VceReady'
        @p_course_path = '/vce'
        @product_line = 'VCE'
      end

    end
  end

  def filter_tags
    if params[:type].present?
      type = params[:type].upcase
      @level2_tags = Tag.level_one.where('name like ?', "%#{type}%").map(&:children).flatten
    elsif !params[:type].nil? && params[:type].blank?
      @level2_tags = Tag.none
    end

    if params[:level2_tag_id].present?
      vod_tags_ids = Tag.find(params[:level2_tag_id]).self_and_descendants_ids
      @level3_tags = Tag.includes(:taggings).where('tags.id IN (?) AND taggings.taggable_id IN (?) AND taggings.taggable_type=? ', vod_tags_ids, Vod.all.ids,'Vod').references(:taggings)
    elsif !params[:level2_tag_id].nil? && params[:level2_tag_id].blank?
      @level3_tags = Tag.none
    end

    if @level3_tags.nil? || @level3_tags.blank?
      @level3_tags = Tag.where(id: params[:level2_tag_id])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if current_user.student?
      @vods = policy_scope(Vod)
      @vod_ids = []
      @vod_tags = @vods.collect(&:tags).flatten.uniq.collect(&:second_sub_root).uniq.compact
      @vod_tags.sort_by(&:name).each do |tag|
        @vods.by_decendent_tag(tag).order(:title).each do |vod|
          @vod_ids << vod.id
        end
      end
      current_vod_index = @vod_ids.index(params[:id].to_i)
      return unless current_vod_index
      current_vod = @vod_ids[current_vod_index]
      @vod = @vods.find(current_vod)
      @previous_vod = @vod_ids[current_vod_index - 1]
      @next_vod = @vod_ids[current_vod_index + 1]
    end
    @tab = params[:tab]
    @page = params[:page]
    @tag_id = params[:tag_id]
    if @watched_count.to_i >= 3 && !current_user.questionnaire.present?
      redirect_to dashboard_home_path(update_background: true) and return
    end
    @vod.viewcount += 1
    @vod.watcheds.find_or_create_by(user_id: current_user.id)
    @vod.save
    respond_with(@vod)
  end


  def exercise_review_textbooks
    @video = Vod.find(params[:id])
    @type = 'Textbooks'
    if current_user.has_textbook_feature
      tags = current_user.current_feature_tags('TextbookFeature') & @video.tags
      @textbooks = Textbook.by_tags(tags)
    else
      @no_textbook_access = true
    end
    respond_to do |format|
      format.html {redirect_to "/404"}
      format.js
    end
  end

  def vod_feedback
    @content = Vod.find(params[:id])
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def download
    @video = Vod.find(params[:id])
    url = @video.generate_output_url_for('360p')
    data = open(url)
    send_data data.read, filename: @video.video_file_name, type: @video.video_content_type, stream: 'true'
  end

  def new
    @vod = Vod.new
    authorize @vod
    respond_with(@vod)
  end

  def edit
  end

  def create
    @vod = Vod.new(vod_params)
    authorize @vod
    respond_to do |format|
      if @vod.save
        format.html { redirect_to vod_path(@vod), notice: 'Video successfully uploaded. Current decoding...' }
        format.json { render :show, status: :created, location: @vod }
      else
        format.html { render :new }
        format.json { render json: @vod.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    @vod.update(vod_params)
    respond_with(@vod)
  end

  def destroy
    @tab = params[:tab]
    @tag_id = params[:tag_id]
    @vod.destroy
    redirect_to vods_path(tag_id: @tag_id, page: params[:page])
  end

  private

  def check_access_limit
    return unless current_user.student?
    access_feature = current_user.active_enrolment_features.includes(:master_feature).where('master_features.name LIKE (?)', '%VideoFeature%')
    pvfps = ProductVersionFeaturePrice.where(id: access_feature.map(&:product_version_feature_price_id))

    return if pvfps.where(qty: nil).present?
    return if pvfps.count > 1
    access_limit = pvfps.map(&:qty).compact.sum
    return if access_limit <= 0
    watched_ids =  current_user.watcheds.pluck(:vod_id).uniq
    @watched_count = watched_ids.count
    if (access_limit <= @watched_count) && !watched_ids.include?(@vod.id)
      redirect_to vods_path(access: false, page: params[:page], tab: params[:tab], tag_id: params[:tag_id])
    end
  end

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.role.to_sym
  end

  def set_vod
    @vod = Vod.find_by(id: params[:id])
    authorize @vod
  end

  def vod_params
    params.require(:vod).permit(:title, :date_published, :description, :published, :video, :subject_id, :video_category_id, :work_directory, tag_ids:[])
  end

  def resolve_layout
    (action_name == 'index' || action_name == 'show') && current_user.student? ? 'student_page' : 'dashboard'
  end

end
