module Users
  class ResetDiagnostic
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    class << self
      def call(params)
        new(params).call
      end
    end

    def call
      if params[:diagnostic_id].present?
        diagnostic = AssessmentAttempt.find(params[:diagnostic_id])
        diagnostic.destroy
        msg = 'DiagnosticTest was reset successfully.'
      else
        user = User.find(params[:user_id])
        diagnostics = user.assessment_attempts.where(assessable_type: "DiagnosticTest")
        diagnostics.destroy_all
        msg = 'DiagnosticTests was reset successfully.'
      end

      msg
    end
  end
end
