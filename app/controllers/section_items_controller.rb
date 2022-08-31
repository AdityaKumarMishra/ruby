class SectionItemsController < ApplicationController
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :set_parent_resource, :set_section
  before_action :set_section_item, only: [:show, :edit, :update, :destroy, :remove_question]

  def index
    # @section_items = policy_scope(SectionItem).where(section: @section)
    @section_items = policy_scope(SectionItem).includes(:mcq, :mcq_stem).where(section: @section).where(mcq_stems: {published: true, examinable: true})
  end

  def show
  end

  def new
    @section_item = @section.section_items.new
  end

  def edit
  end

  def create
    params[:mcq_stem_ids].each do |mcq_stem_id|
      mcq_stem = McqStem.find(mcq_stem_id)
      mcq_stem.mcqs.each do |mcq|
        @section_item_mcq = SectionItem.find_by(mcq_id: mcq.id,section_id: @section.id)
        if @section_item_mcq.blank?
          @section_item_mcq = SectionItem.create(mcq_stem: mcq_stem, mcq_id: mcq.id,section: @section)
        end
        authorize @section_item_mcq
      end
    end
    respond_to do |format|
      if @section_item_mcq.save
        format.html do
          redirect_to edit_polymorphic_path([@parent_resource, @section]),notice: 'All questions in the Stem were successfully added.'
        end
        format.json { render :edit, status: :created, location: @section }
      else
        format.html do
          flash[:error] = @section_item_mcq.errors.full_messages.join(", ")
          redirect_to edit_polymorphic_path([@parent_resource, @section])
        end
        format.json { render :edit, status: :failed, location: @section }
      end
    end
  rescue => e
    respond_to do |format|
      format.html { render :new, locals: { error: e.message } }
      format.json { render json: { message: 'Something went wrong' }, status: :unprocessable_entity }
    end
  end

  def update
    respond_to do |format|
      if @section_item.update(section_item_params)
        format.html { redirect_to polymorphic_path([@parent_resource, @section, @section_item]), notice: 'Section item was successfully updated.' }
        format.json { render :show, status: :ok, location: @section_item }
      else
        format.html { render :edit }
        format.json { render json: @section_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section_item.destroy
    respond_to do |format|
      format.html { redirect_to edit_polymorphic_url([@parent_resource, @section]), notice: 'Section item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_question
    section_items = @section.section_items.includes(mcq: :mcq_stem).where(mcq_stems: {id: @section_item.mcq_stem.id})
    if !@section_item.section.sectionable.locked && section_items.destroy_all
      flash[:notice] = 'Question is removed from exam.'
    else
      exam_type = @section.sectionable_type == 'OnlineExam' ? 'Exam' : 'Diagnostic Test'
      flash[:error] = "Cannot remove the question since #{exam_type} is locked. Please contact support team if any updates required."
    end
    respond_to do |format|
      format.html { redirect_to edit_polymorphic_url([@parent_resource, @section]) }
    end
  end

  private

  def set_parent_resource
    if params[:online_exam_id]
      @online_exam = OnlineExam.find(params[:online_exam_id])
      @parent_resource = @online_exam
    elsif params[:diagnostic_test_id]
      @diagnostic_test = DiagnosticTest.find(params[:diagnostic_test_id])
      @parent_resource = @diagnostic_test
    end
  end

  def set_section
    @section = @online_exam.sections.find(params[:section_id]) if @online_exam
    @section = @diagnostic_test.sections.find(params[:section_id]) if @diagnostic_test
  end

  def set_section_item
    @section_item = @section.section_items.find(params[:id])
    authorize @section_item
  end

  def section_item_params
    params.require(:section_item).permit(:mcq_id, mcq_stem_ids: [])
  end
end
