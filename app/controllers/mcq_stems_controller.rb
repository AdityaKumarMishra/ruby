class McqStemsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_filtered_stems, only: [:mcq_unit_progress_dashboard,:mcq_creation_progress_statistics]
  before_action :initialize_service
  before_action :set_mcq_stem, only: [:show, :edit, :update, :destroy]
  before_action :load_tags, only: [:new, :edit, :create, :update]
  layout 'layouts/dashboard'
  before_action :create_difficulty_list, only: [:new, :create, :edit, :update]

  def initialize_service
    @mcq_stem_service = McqStemService.new(params[:id], @filterrific, params[:filterrific])
  end

  def mcq_unit_progress_dashboard
    @mcq_stems, @mcqs, _mcq_counts = @mcq_stem_service.index(request.format.symbol.to_s, params[:page], true)
    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :html)) && return
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="mcq_stems - ' +  '.xlsx"'
      }
    end
  end

  def mcq_creation_progress_statistics
    @mcq_stems, @mcqs, @mcq_counts = @mcq_stem_service.index(request.format.symbol.to_s, params[:page], false)
    @total_mcqs = @mcq_counts.values.sum

    rescue ActiveRecord::RecordNotFound => e
      # There is an issue with the persisted param_set. Reset it.
      redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def show
    # show all mcqs
    @mcq_id = params[:mcq_id]
    if current_user.student?
      render 'mcq_stems/student_show'
    else
      render 'mcq_stems/show'
    end
  end

  def new
    @mcq_stem = McqStem.new
  end

  def edit
  end


  def create
    @mcq_stem = McqStem.new(mcq_stem_params)
    authorize @mcq_stem
    # @mcq_stem.author = current_user
    @mcq_stem.published = params[:mcq_stem][:status] == "published" ? true : false
    @mcq_stem.examinable = params[:mcq_stem][:pool] == "exam" ? true : false
    respond_to do |format|
      if @mcq_stem.save
        McqStemMailer.to_review(@mcq_stem.reviewer, @mcq_stem).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        format.html { redirect_to @mcq_stem, notice: 'Mcq stem was successfully created' }
        format.json { render :show, status: :ok, location: @mcq_stem }
      else
        format.html { render :new }
        format.json { render json: @mcq_stem.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    stats = check_exam_lock_stats
    params[:mcq_stem][:published] = params[:mcq_stem][:status] == "published" ? true : false
    params[:mcq_stem][:examinable] = params[:mcq_stem][:pool] == "exam" ? true : false
    if stats
      flash[:error] = 'Cannot remove the question since Exam is locked. Please contact support team if any updates required.'
      redirect_to edit_mcq_stem_path(@mcq_stem)
    else
      respond_to do |format|
        if @mcq_stem.update(mcq_stem_params)
          format.html { redirect_to @mcq_stem, notice: 'Mcq stem was successfully updated' }
          format.json { render :show, status: :ok, location: @mcq_stem }
        else
          format.html { render :edit }
          format.json { render json: @mcq_stem.errors, status: :unprocessable_entity }
          flash[:error] = 'Please review the problems below.'
        end
      end
    end
  end

  def destroy
    @mcq_stem.destroy
    respond_to do |format|
      format.html { redirect_to mcq_stems_url, notice: 'Mcq stem was successfully deleted' }
      format.json { head :no_content }
    end
  end

  def change_examinable
    @mcq_stem = McqStem.find(params[:id])
    examinable = params[:pool_type].eql?('exam_pool') ? true : false
    pool = params[:pool_type].eql?('exam_pool') ? "exam" : "exercise"
    @mcq_stem.examinable = examinable
    @mcq_stem.pool = pool
    msg =  examinable ? 'MCQ Stem was move to Exam pool' : 'MCQ Stem was move to MCQ pool'
    if @mcq_stem.save
      SectionItem.includes(:mcq_stem).where(mcq_stems: { id: @mcq_stem.id }).destroy_all unless examinable
      flash[:notice] = msg
    else
      flash[:error] = "Cannot edit MCQ Stem since the MCQ is part of an locked exam. Please contact support team if any updates required."
    end
    redirect_back fallback_location: root_path
  end

  # todo in mcq
  def update_complete_time
    time = params[:tot_time].to_i
    mcq_attempt_time = McqAttemptTime.find_by(mcq_stem_id: params[:id], sectionable_id: params[:sectionable_id], sectionable_type: params[:sectionable_type])
    if mcq_attempt_time.present?
      mcq_attempt_time.update_attribute(:total_time, mcq_attempt_time.total_time + time)
    else
      McqAttemptTime.create(mcq_stem_id: params[:id], sectionable_id: params[:sectionable_id], sectionable_type: params[:sectionable_type], total_time: time)
    end
  end

  def check_exam_lock_stats
    if @mcq_stem.section_items.map(&:section).uniq.map(&:sectionable).map(&:locked).include? true
      return true
    else
      return false
    end
  end

  def update_work_status
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_column(:work_status, params[:work_status])
    @mcq_stem.update_column(:work_status_updated_at, Time.zone.now)

    head :ok
  end

  def update_pool
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_attribute(:pool, params[:pool])
    @mcq_stem.update_attribute(:updated_at, Time.zone.now)
    head :ok
  end

  def update_reviewer1
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_column(:reviewer_id, params[:reviewer_id])
    @mcq_stem.update_column(:updated_at, Time.zone.now)

    head :ok
  end

  def update_reviewer2
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_column(:reviewer2_id, params[:reviewer2_id])
    @mcq_stem.update_column(:updated_at, Time.zone.now)

    head :ok
  end

  def update_video_explainer
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_column(:video_explainer_id, params[:video_explainer_id])
    @mcq_stem.update_column(:updated_at, Time.zone.now)

    head :ok
  end

  def update_video_reviewer
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update_column(:video_reviewer_id, params[:video_reviewer_id])
    @mcq_stem.update_column(:updated_at, Time.zone.now)

    head :ok
  end

  def change_work_status
    @mcq_stem = McqStem.find_by(id: params[:id])
    @mcq_stem.update(work_status: params[:status], title: params[:title], status: params[:pub_status], pool: params[:pool], work_directory: params[:dir], description: params[:desc])
    respond_to do |format|
      format.html { redirect_to mcq_stems_url}
      format.js
    end
  end

  private

  def get_filtered_stems
    (@filterrific = initialize_filterrific(
      policy_scope(McqStem),
      params[:filterrific],
      select_options: {
          tag: Tag.options_for_select, #policy_scope(Tag).options_for_selec
          author: User.options_for_tutor_admin_filter,
          skill_tag: SkillTag.options_for_select,
          similarity_score: McqStem.options_for_select_score,
          reviewer: User.options_for_tutor_admin_filter,
          reviewer2: User.options_for_tutor_admin_filter,
          video_explainer: User.options_for_tutor_admin_filter,
          video_reviewer: User.options_for_tutor_admin_filter,
          difficulty: [:easy, :medium, :hard],
          with_pool: McqStem.options_for_new_pool,
          with_exam: McqStem.options_for_appear_in_exam,
          sorted_by: McqStem.options_for_sorted_by,
          with_work: McqStem.options_for_work_status,
          with_status: McqStem.options_for_publish,
          with_min: McqStem.options_for_min,
          with_max: McqStem.options_for_max,
          with_graphic: McqStem.options_for_graphic
      },
      persistence_id: "shared_key",
    )) || return
  end

  def set_mcq_stem
    @mcq_stem = McqStem.find(params[:id])
    authorize @mcq_stem
    @difficulty = @mcq_stem.difficulty
  end

  def load_tags
    @tags = policy_scope(Tag) # = Tag.all
  end

  def create_difficulty_list
    @difficulties =  []
    @difficulties.push ['', '']
    @difficulties += McqStem::DIFFICULTY_LEVELS.map { |k, v| [k, v[:default]] }
    @difficulties.to_h
  end

  def mcq_stem_params
    if params[:mcq_stem][:mcqs_attributes]
      params[:mcq_stem][:mcqs_attributes].each do |key, value|
        if params[:mcq_stem][:examinable] == "1" || params[:mcq_stem][:pool] == "exam"
          value[:examinable]=true
        else
          value[:examinable]=false
        end
      end
      params[:mcq_stem][:mcqs_attributes].each do |key, value|
        if params[:mcq_stem][:similarity_score].present?
          value[:similarity_score] = params[:mcq_stem][:similarity_score]
        end
      end
       params[:mcq_stem][:mcqs_attributes].each do |key, value|
        if params[:mcq_stem][:display_type].present?
          value[:display_type] = params[:mcq_stem][:display_type]
        end
      end
    end

    params.require(:mcq_stem).permit(:title, :description, :author_id, :difficulty, :pool, :work_status, :work_directory, :graphics_required, :reviewer2_id, :status,
        :student_id, :published, :examinable, :diagnostic, :reviewer_id, :last_editor_id, :reviewed, :skill_tag_id, :similarity_score, :display_type, :video_explainer_id, :video_reviewer_id, tag_ids: [],
        mcqs_attributes: [:id, :question, :display_type, :skill_tag_id, :similarity_score, :explanation, :difficulty, :examinable, :diagnostic, :mcq_stem_id, :_destroy,
        mcq_answers_attributes: [:id, :answer, :correct,
            :explanation, :_destroy],
        tagging_attributes: [:tag_id, :taggable_id, :taggable_type],
        mcq_video_attributes: [:title, :published, :description, :video, :id]])
  end
end
