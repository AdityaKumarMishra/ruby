module Users
  class NewRecord
    attr_accessor :params, :user_params

    def initialize(params, user_params)
      @params = params
      @user_params = user_params
    end

    class << self
      def call(params, user_params)
        new(params, user_params).call
      end
    end

    def call
      params[:user][:questionnaire_attributes][:language_spoken] = params[:language_spoken] if  params[:language_spoken].present? && params[:user][:questionnaire_attributes][:language_spoken]=="other"
      params[:user][:questionnaire_attributes][:last_source] = params[:last_source] if  params[:last_source].present? && params[:user][:questionnaire_attributes][:last_source]=="other"
      params[:user][:questionnaire_attributes][:source]<<params[:source] if params[:source].present?
      params[:user][:address_attributes][:state] = params[:user][:address_attributes][:state].to_i if params[:user][:address_attributes].present?
      params[:user].delete :questionnaire_attributes if user_params[:role] != 'student'

      user = User.new(user_params)
      user.phone_number = user_params[:phone_number]
      user.date_of_birth= user_params[:date_of_birth]

      user
    end
  end
end
