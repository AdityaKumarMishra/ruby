require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.create :comment }
  xit 'validates presences of commentor' do
    expect(comment).to validate_presence_of(:user)
  end

  it 'validates presence of content' do
    expect(comment).to validate_presence_of(:content)
  end

  it 'validates presence of commentable' do
    expect(comment).to validate_presence_of(:commentable)
  end

  it 'content cannot be blank' do
    expect(comment).not_to allow_value('').for(:content)
  end
end
