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

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :vod do
    subject_id {FactoryGirl.create(:subject).id}
    title "MyString"
    date_published "2015-10-21 08:01:53"
    published false
    viewcount nil
    video { fixture_file_upload(Rails.root.join('spec', 'videos', 'test.mp4'), 'video/mp4') }
    video_file_name "test.mp4"
    video_content_type "video/mp4"
    video_file_size 1055736
    video_updated_at {DateTime.now}
  end

end
