class EnquiryUser < ApplicationRecord

  has_many :clarifications, class_name: 'Comment', foreign_key: 'enquiry_user_id'

  filterrific(
    available_filters: [
      :sorted_by_enquiry,
      :with_name_enquiry,
      :with_start_enquiry,
      :with_end_enquiry
    ]
  )

  cattr_accessor :filter_params

  scope :sorted_by, -> (sort_key){ order sort_key }
  scope :sorted_by_enquiry, -> (sort_key){ order sort_key }

  # scope :with_name, -> (name){
  #   where("((enquiry_users.first_name ILIKE ?) OR (enquiry_users.last_name ILIKE ?) OR (enquiry_users.email ILIKE ?) OR (lower(concat(enquiry_users.first_name,' ',enquiry_users.last_name)) ILIKE ?))",name,name,name,name).references(:enquiry_users) }

  scope :with_name_enquiry, -> (name){
    where("((enquiry_users.first_name ILIKE ?) OR (enquiry_users.last_name ILIKE ?) OR (enquiry_users.email ILIKE ?) OR (lower(concat(enquiry_users.first_name,' ',enquiry_users.last_name)) ILIKE ?))","%#{name}%", "%#{name}%", "%#{name}%", "%#{name}%").references(:enquiry_users) }

  # scope :with_start, -> (with_start) do
  #   where('created_at >= ?', with_start)
  # end

  scope :with_start_enquiry, -> (with_start) do
    begin
      DateTime.parse with_start
      where('created_at >= ?', with_start)
    rescue
    end
  end

  # scope :with_end, -> (with_end) do
  #   where('created_at <= ?', with_end)
  # end

  scope :with_end_enquiry, -> (with_end) do
    begin
      DateTime.parse with_end
      where('created_at <= ?', with_end)
    rescue
    end
  end

  def self.options_for_sorted_by
    [
      ['First Name (a-z)', 'first_name asc'],
      ['Last Name (a-z)', 'last_name asc'],
      ['Registration date (newest first)', 'created_at desc'],
      ['Registration date (oldest first)', 'created_at asc']
    ]
  end

end
