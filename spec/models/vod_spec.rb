# == Schema Information
#
# Table name: vods
#
#  id                 :integer          not null, primary key
#  title              :string
#  date_published     :datetime
#  published          :boolean
#  viewcount          :integer
#  video_file_name    :string
#  video_content_type :string
#  video_file_size    :integer
#  video_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  subject_id         :integer
#  video_category_id  :integer
#
=begin
require 'rails_helper'

RSpec.describe Vod, type: :model do

  it 'should have valid factory' do
    expect(FactoryGirl.build(:vod)).to be_valid
  end

  it {should validate_presence_of :date_published}
  it {should validate_presence_of :title}
  it {should validate_presence_of :video}
  it {should validate_attachment_content_type(:video).
                 allowing('video/mp4').
                 rejecting('text/plain')
  }
  it {should validate_attachment_content_type(:video).
                 allowing('video/wmv').
                 rejecting('text/plain')
  }
  it {should validate_attachment_content_type(:video).
                    allowing('video/x-ms-wmv').
                    rejecting('text/plain')
  }
  describe 'before_create' do
    let(:vod) {FactoryGirl.build(:vod)}
    it 'should set viewcount to 0' do
      expect{vod.save}.to change{vod.viewcount}.from(nil).to(0)
    end
  end
end
=end
