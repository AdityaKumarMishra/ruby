class DiagnosticTestsController < ApplicationController
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :set_diagnostic_test, only: [:show, :edit, :update, :destroy, :change_lock]

  def index
    authorize DiagnosticTest
    @diagnostic_tests = policy_scope(DiagnosticTest)

    @filterrific = initialize_filterrific(
        @diagnostic_tests,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @diagnostic_tests = @filterrific.find.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @diagnostic_test = DiagnosticTest.new
    authorize @diagnostic_test
  end

  def edit
    @parent_resource = @diagnostic_test
    @sections = policy_scope(Section).where(sectionable: @parent_resource)
  end

  def create
    @diagnostic_test = DiagnosticTest.new(diagnostic_test_params)
    authorize @diagnostic_test

    respond_to do |format|
      if @diagnostic_test.save
        format.html { redirect_to @diagnostic_test, notice: 'DiagnosticTest was successfully created.' }
        format.json { render json: @resource }
      else
        format.html { render :new }
        format.json { render json: @diagnostic_test.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    respond_to do |format|
      if @diagnostic_test.update(diagnostic_test_params)
        format.html { redirect_to edit_polymorphic_path(@diagnostic_test), notice: 'DiagnosticTest was successfully updated.' }
        format.json { render :edit, status: :ok, location: @diagnostic_test }
      else
        format.html { render :edit }
        format.json { render json: @diagnostic_test.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @diagnostic_test.destroy
    respond_to do |format|
      format.html { redirect_to diagnostic_tests_url, notice: 'DiagnosticTest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_show_stat
    @test = DiagnosticTest.find(params[:id])
    @test.toggle(:show_stat)
    @test.save!
    if @test.show_stat
      msg = 'DiagnosticTest Stats will show to students'
    else
      msg = 'DiagnosticTest Stats will not show to students'
    end
    redirect_back fallback_location: root_path, notice: msg
  end

  # For Locking the Exam
  def change_lock
    @diagnostic_test.toggle(:locked)
    @diagnostic_test.save!
    if @diagnostic_test.locked
      msg = 'DiagnosticTest is locked successfully!'
    else
      msg = 'DiagnosticTest is unlocked successfully!'
    end
    redirect_to diagnostic_tests_path, notice: msg
  end

  private

  def set_diagnostic_test
    @diagnostic_test = DiagnosticTest.find(params[:id])
  end

  def diagnostic_test_params
    params.require(:diagnostic_test).permit(:title, :instruction, :published, :is_finish, tag_ids: [])
  end
end
