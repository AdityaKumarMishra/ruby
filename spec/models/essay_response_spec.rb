# == Schema Information
#
# Table name: essay_responses
#
#  id            :integer          not null, primary key
#  response      :text
#  time_submited :time
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  essay_id      :integer
#  slug          :string
#

require 'rails_helper'

RSpec.describe EssayResponse, type: :model do


  context 'scopes' do
    let!(:essay1) { FactoryGirl.create :essay, title: "test" }
    let!(:student1) { FactoryGirl.create :user, role: 0, first_name: "student_first", last_name: "student_last", username: "student_username" }
    let!(:essay_response1) { FactoryGirl.create :essay_response, essay_id: essay1.id }
    let!(:essay_response2) { FactoryGirl.create :essay_response, essay_id: essay1.id, user_id: student1.id }
    let!(:essay_response3) { FactoryGirl.create :essay_response, essay_id: essay1.id, user_id: student1.id }
    let!(:staff_profile) { FactoryGirl.create :staff_profile }
    let!(:essay_tutor_response1) { FactoryGirl.create :essay_tutor_response, rating: 20, response: "OKAY",essay_response_id: essay_response3.id,
                                  created_at: "2016-08-16", staff_profile_id: staff_profile.id }
    let!(:essay_tutor_response2) { FactoryGirl.create :essay_tutor_response, rating: 20, response: "OKAY",essay_response_id: essay_response2.id,
                                    created_at: "2016-08-1", staff_profile_id: staff_profile.id }

    it "Should return Essay responses filter by title of essays" do
      EssayResponse.search_query_title("test") == essay1
    end


    it "Should return Essay response answered by student first_name" do
      EssayResponse.search_query_student("student") == essay_response2
    end
    it "Should return Essay response answered by student last_name" do
      EssayResponse.search_query_student("student_last") == essay_response2
    end
    it "Should return Essay response answered by student user_name" do
      EssayResponse.search_query_student("student_username") == essay_response2
    end


    it "should return essay responses by marked status" do
      EssayResponse.with_status("Marked") == EssayResponse.where(status: 2..3)
    end
    it "should return essay responses by unmarked status" do
      EssayResponse.with_status("Unmarked") == EssayResponse.where(status: 1)
    end
    it "should return essay responses by has_feedback status" do
      EssayResponse.with_status("Has feedback") == EssayResponse.where(status: 4)
    end

    it "should return essay responses by from date" do
      EssayResponse.with_start("2016-08-03") == essay_response3
    end
    it "should return essay responses by to date" do
      EssayResponse.with_end("2016-08-03") == essay_response2
    end

  end

  describe '#pay periods' do
    it 'should return current and last four pay periods' do
      Timecop.freeze(Time.local(2016, 8, 31, 12, 0, 0))
      result = [["2016-08-31 - 2016-09-13"],
                     ["2016-08-17 - 2016-08-30"],
                     ["2016-08-03 - 2016-08-16"]]
      expect(EssayResponse.pay_periods).to eq(result)
    end
  end
end
