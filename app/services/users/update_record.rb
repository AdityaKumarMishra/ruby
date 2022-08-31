module Users
  class UpdateRecord
    attr_accessor :params, :user_params, :user

    def initialize(params, user_params, user)
      @params = params
      @user_params = user_params
      @user = user
    end

    class << self
      def call(params, user_params, user)
        new(params, user_params, user).call
      end
    end

    def call
      params[:user][:questionnaire_attributes][:language_spoken] = params[:language_spoken] if  params[:language_spoken].present? && params[:user][:questionnaire_attributes][:language_spoken]=="other"
      params[:user][:questionnaire_attributes][:last_source] = params[:last_source] if  params[:last_source].present? && params[:user][:questionnaire_attributes][:last_source]=="other"
      params[:user][:questionnaire_attributes][:source]<<params[:source] if params[:source].present?


      user.update(user_params.except(:password,:questionnaire_attributes,:address_attributes))

      if user_params[:address_attributes].present?
        if user.address.nil?
          user.build_address((user_params[:address_attributes]))
          user.address.save
        else
          user.address.update((user_params[:address_attributes]))
        end
      end

      if user_params[:questionnaire_attributes].present?
        if user.questionnaire.nil?
          user.questionnaire = Questionnaire.create!(user_params[:questionnaire_attributes].merge!(user_id: user.id))
        else
          user.questionnaire.update(user_params[:questionnaire_attributes])
        end
      end

      user.password = user_params[:password] if(user_params[:password]) != ''
      user.save

      user
    end
  end
end
