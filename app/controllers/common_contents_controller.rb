class CommonContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [:edit, :update]
  layout 'layouts/dashboard'
	def index
	  @comm_content = CommonContent.first
	end

	def new
	  @comm_content = CommonContent.new
	  respond_with(@comm_content)
	end

	def create
	  @comm_content = CommonContent.new(content_params)
	  if @comm_content.save
		  flash[:notice] = 'Content was successfully created.'
    else
      flash[:error] = 'Please review the problems below.'
    end
    redirect_to edit_common_content_path(@comm_content)
	end

	def edit
	end

	def update
    if @comm_content.update(content_params)
      flash[:notice] = 'Content was successfully updated.'
    else
      flash[:error] = 'Contact number is too long, maximum 45 characters are allowed.'
    end
    redirect_to edit_common_content_path(@comm_content)
	end

	private

	def set_content
	  @comm_content = CommonContent.find(params[:id])
	end

	def content_params
	  params.require(:common_content).permit(:contact_number, :contact_number2, :mock_exam_overdue)
	end
end
