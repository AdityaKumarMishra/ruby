class EssayTutorResponsesController < EssaysController
  before_action :authenticate_user!
  # before_action :check_student_essays
  before_action :set_essay_response
  before_action :set_essay

  before_action :set_essay_tutor_response, only: [:edit, :update, :show]
  # before_action :set_essay_time, except: :submit
  layout "layouts/dashboard"

  respond_to :html

  def new
    @essay_tutor_response = EssayTutorResponse.new
    respond_with(@essay_tutor_response)
  end

  def create
    current_user.validate_staff_profile
    @essay_tutor_response = EssayTutorResponse.new(essay_tutor_response_params)
    @essay_tutor_response.elapsed_time = (Time.now - params[:essay_tutor_response][:initial_time].to_time)*1000
    @essay_tutor_response.essay_response=@essay_response
    if current_user.moderator?||current_user.tutor?
      current_user.validate_staff_profile
      @essay_tutor_response.staff_profile=current_user.staff_profile
    end

    if @essay_tutor_response.save
      # @essay_response.update_attribute(:tutor_id, current_user.id) GRAD-2481
      @essay_response.marked!
      respond_with(@essay_tutor_response, location: essay_path(@essay))
      flash[:notice] = 'EssayTutorResponse was successfully created.'
    else
      respond_with(@essay_tutor_response)
      flash[:error] = 'Please review the problems below.'
    end
  end


  def show
    respond_with(@essay_tutor_response)

  end
  def edit
  end

  def update
    @essay_tutor_response.update(elapsed_time: @essay_tutor_response.elapsed_time + (Time.now - params[:essay_tutor_response][:initial_time].to_time)*1000)
    if @essay_tutor_response.update(essay_tutor_response_params)
      respond_with(@essay_tutor_response, location: essay_path(id: @essay.slug))
      flash[:notice] = 'EssayTutorResponse was successfully updated.'
    else
      respond_with(@essay_tutor_response)
      flash[:error] = 'Please review the problems below.'
    end
  end



  private
    # def check_student_essays
    #   unless current_user.student_essays.active.pluck(:slug).include?(params[:essay_id])
    #     redirect_to essay_path, alert: 'You are not authorized.'
    #   end
    # end

    def set_essay_tutor_response
      @essay_tutor_response = @essay_response.essay_tutor_response
    end

    def set_essay_response
      @essay_response = EssayResponse.friendly.find(params[:essay_response_id])
    end

    def set_essay
      @essay = @essay_response.essay
    end

    def set_essay_time
      @essay_time = @essay.try(:exam).try(:subject).try(:course).try(:essay_time)
      @essay_time ||= 120
    end

    def essay_tutor_response_params
      params.require(:essay_tutor_response).permit(:response, :id, :rating, :essay_response_id)
    end
end
