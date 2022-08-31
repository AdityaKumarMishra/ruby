require 'rails_helper'

RSpec.describe SectionItemAttemptsController, type: :controller do
  login_student
  let(:online_exam_attempt) { FactoryGirl.create(:assessment_attempt, :online_exam_type, user: subject.current_user) }
  let(:section) { FactoryGirl.create :section }
  let(:sa) do
    FactoryGirl.create(:section_attempt, section: section,
                                         assessment_attempt: online_exam_attempt,
                                         mark: 2)
  end
  let(:section_attempt) { online_exam_attempt.section_attempts.find(sa.id) }
  let(:section_item_attempts) { sa.section_item_attempts }
  let!(:mcq_stem) { FactoryGirl.create(:mcq_stem, examinable: true) }
  let!(:mcq) { FactoryGirl.create(:mcq, mcq_stem: mcq_stem) }
  let!(:section_item) { FactoryGirl.create(:section_item, mcq_id: mcq.id) }
  let!(:section_item_attempt) { FactoryGirl.create(:section_item_attempt, section_attempt: section_attempt, section_attempt: section_attempt, section_item: section_item, mcq_stem_id: mcq_stem.id )}

  describe 'GET #index' do
    it 'assigns all section_items as section_items' do
      get :index, online_exam_attempt_id: online_exam_attempt.to_param, section_attempt_id: sa.to_param
      expect(response).to be_success
    end
  end

  describe 'PUT #update_answer' do
    it 'should not update answer because section_item_attempts is nil' do
      put :update_answer, online_exam_attempt_id: online_exam_attempt.to_param, section_item_attempts: nil, section_attempt_id: sa.to_param
      expect(response).to be_success
    end
  end
  xit "renders a relevant videos for mcq tags when student reviewing exam" do
    xhr :get, :exam_review_videos, online_exam_attempt_id: online_exam_attempt.to_param, section_attempt_id: sa.to_param, :format => "js"
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Link".to_s, :count => 2
  end
end
