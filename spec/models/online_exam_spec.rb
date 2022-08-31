# == Schema Information
#
# Table name: exams
#
#  id          :integer          not null, primary key
#  title       :string
#  instruction :text
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe OnlineExam, type: :model do
  let(:online_exam) { FactoryGirl.create(:online_exam)}

  it 'validates presence of title' do
    expect(online_exam).to validate_presence_of(:title)
  end

  describe "publisability without sections" do
  	context "when published true" do
	  	let(:published_without_sections) { FactoryGirl.build(:online_exam, :published_without_sections) }
			it { expect(published_without_sections).to be_invalid }
		end
		
		context "when published false" do
	  	let(:published_with_sections) { FactoryGirl.create(:online_exam, :published_with_sections) }
			it {expect(published_with_sections).to be_valid}
		end
	end
end
