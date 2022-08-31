class StudentClassesController < ApplicationController
  before_action :set_student_class, only: [:show, :edit, :update, :destroy]
  before_action :not_authorised_user, only: [:new, :edit, :update, :destroy, :create, :remove_student], :if => proc{!current_user.tutor?}

  respond_to :html

  def index
    @student_classes = StudentClass.all
    respond_with(@student_classes)
  end

  def show
    respond_with(@student_class)
  end

  def new
    @student_class = StudentClass.new
    respond_with(@student_class)
  end

  def edit
  end

  def create
    @student_class = StudentClass.new(student_class_params)
    @student_class.save
    respond_with(@student_class)
  end

  def update
    @student_class.update(student_class_params)
    respond_with(@student_class)
  end

  def destroy
    @student_class.destroy
    respond_with(@student_class)
  end

  def remove_student
    student = User.student.friendly.find params[:student_id]
    if student
      @student_class = StudentClass.find params[:student_class_id]
      if @student_class
        @student_class.students.delete student
        respond_with(@student_class, :notice => 'Student has been deleted')
      else
        respond_with(@student_class, :error => 'Class not found')
      end
    else
      respond_with(@student_class, :error => 'Student not found')
    end
  end

  private
    def set_student_class
      @student_class = StudentClass.find(params[:id])
    end

    def student_class_params
      params.require(:student_class).permit(:name, :size, :active_subject_id, :item_coverd, :tutor_ids =>[], :student_ids =>[])
    end

    def subject_params
      params[:student_class][:subject]
    end
end
