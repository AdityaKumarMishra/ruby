# == Schema Information
#
# Table name: contacts
#
#  id                  :integer          not null, primary key
#  name                :string
#  position            :string
#  email               :string
#  visible             :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  contact_location_id :integer
#

class Contact < ApplicationRecord

  belongs_to :contact_location

  validates :name, presence: true
  validates :email, presence: true
  validates :contact_location_id, presence: true

  has_attached_file :avatar,
                    :styles => { :default => '140x140'}

  validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, :content_type => /\Aimage/

  scope :published, -> {where(:visible => true)}

  def city
    contact_location.name if contact_location
  end
end
