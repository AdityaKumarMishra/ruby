# == Schema Information
#
# Table name: textbooks
#
#  id                    :integer          not null, primary key
#  title                 :string
#  document_file_name    :string
#  document_content_type :string
#  document_file_size    :integer
#  document_updated_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Textbook, type: :model do

  it 'should have valid factory' do
    expect(FactoryGirl.build(:textbook)).to be_valid
  end

  it {should have_attached_file(:document)}

end
