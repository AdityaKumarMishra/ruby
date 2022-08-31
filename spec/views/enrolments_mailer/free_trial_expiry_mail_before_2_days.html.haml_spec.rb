require 'rails_helper'

RSpec.describe "enrolments_mailer/free_trial_expiry_mail_before_2_days", type: :view do
  xit "render before free trial expire mail template" do
    @student = FactoryGirl.create :user, first_name: "Test"
    expect(render).to match(/Test/)
    expect(render).to match(/Access Program/)
    expect(render).not_to match(/GRFREETRIAL/)
    expect(render).not_to match(/If you're ready to start improving your GAMSAT results, explore one of our courses below/)
  end
end
