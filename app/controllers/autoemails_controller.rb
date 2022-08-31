class AutoemailsController < ApplicationController
	before_action :authenticate_user!
	before_action :authorize_user
	before_action :find_autoemail, except: [:new]

	def new
		@autoemail = Autoemail.find_or_initialize_by(category: Autoemail.categories[:get_clarity])
	end

	def create
		save_and_redirect
	end

	def update
		save_and_redirect
	end

	def save_and_redirect
		respond_to do |format|
			if @autoemail.update(autoemail_params)
				format.html { redirect_to dashboard_unresolved_issues_path, notice: "Autoemail saved successfully" }
			else
				format.html { redirect_to dashboard_unresolved_issues_path}
				flash[:error] = @autoemail.errors.full_messages.join(', ')
			end
		end
	end

	private

	def authorize_user
		authorize Autoemail
	end

	def autoemail_params
		params.require(:autoemail).permit(:title, :is_active, :subject, :greeting, :content, :category)
	end

	def find_autoemail
		@autoemail = Autoemail.find_or_initialize_by(category: autoemail_params[:category])
	end
end
