require "rails_helper"

RSpec.describe BookTutorMailer, type: :mailer do

  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
  let!(:tutor_availability) { FactoryGirl.create(:tutor_availability, tutor_profile: tutor.tutor_profile) }
end
