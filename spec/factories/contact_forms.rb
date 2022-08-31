# == Schema Information
#
# Table name: contact_forms
#
#  id                  :integer          not null, primary key
#  email               :string
#  phone               :string
#  subject             :string
#  message             :text
#  contact_location_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :contact_form do
    email "test@example.com"
    phone "111-111-111"
    subject "Subject"
    message "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In egestas varius ante, ut malesuada dui scelerisque id. Praesent aliquam porttitor nunc id semper. Vivamus ex risus, ornare a lacus eu, ultricies sagittis sapien. Maecenas eget mauris eu lectus molestie rhoncus. Sed euismod tincidunt massa, ac congue diam bibendum at. Cras efficitur pulvinar risus ut efficitur. In hac habitasse platea dictumst. Integer nec ante eget massa viverra rutrum eget sed ipsum. Vivamus aliquam blandit convallis. In vel consequat enim, a porttitor mauris. "
    contact_location_id {FactoryGirl.create(:contact_location).id}
  end
end
