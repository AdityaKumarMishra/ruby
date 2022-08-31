class SectionsController < ApplicationController
  layout 'layouts/admin'
  before_action :authenticate_user!
  before_action :set_parent_resource
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  # GET /sections
  # GET /sections.json
  def index
    @sections = policy_scope(Section).where(sectionable: @parent_resource)
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = build_polymorphic_section nil
  end

  # GET /sections/1/edit
  def edit
    @section_items = policy_scope(SectionItem).includes(:mcq, :mcq_stem).where(section: @section).where(mcq_stems: {published: true, examinable: true})
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = build_polymorphic_section(section_params)
    authorize @section

    respond_to do |format|
      if @section.save
        format.html do
          redirect_to edit_polymorphic_url([@parent_resource]), notice: 'Section was successfully created.'
        end
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html do
          redirect_to edit_polymorphic_path([@parent_resource, @section]), notice: 'Section was successfully updated.'
        end
        format.json { render :edit, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html do
        redirect_to edit_polymorphic_url([@parent_resource]),
                    notice: 'Section was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

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
    @section = @online_exam.sections.find(params[:id]) if @online_exam
    @section = @diagnostic_test.sections.find(params[:id]) if @diagnostic_test
    authorize @section
  end

  def build_polymorphic_section(params)
    section = @online_exam.sections.build(params) if @online_exam
    section = @diagnostic_test.sections.build(params) if @diagnostic_test
    section
  end

  def section_params
    params.require(:section).permit(:title, :duration, :position)
  end
end
