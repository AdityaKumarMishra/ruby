class MailingListSubscription < ApplicationRecord
  filterrific(
    available_filters: [
      :sorted_by_blog,
      :with_name_blog,
      :with_start_blog,
      :with_end_blog
    ]
  )

  belongs_to :user, optional: true
  belongs_to :mailing_list

  cattr_accessor :filter_params

  scope :with_email, -> (email) {
    includes(:user)
    .where('users.email = :email OR mailing_list_subscriptions.email = :email', email: email)
    .references(:users)
  }

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  # scope :sorted_by, -> (sort_key){order sort_key }

  scope :sorted_by_blog, -> (sort_key){order sort_key }

  # scope :with_name, -> (name){
  #   where("mailing_list_subscriptions.email LIKE ?", "%#{name}%") }

  scope :with_name_blog, -> (name){
    where("mailing_list_subscriptions.email LIKE ?", "%#{name}%") }

  # scope :with_start, -> (with_start) do
  #   where('mailing_list_subscriptions.created_at >= ?', with_start)
  # end

  scope :with_start_blog, -> (with_start) do
    begin
      DateTime.parse with_start
      where('mailing_list_subscriptions.created_at >= ?', with_start)
    rescue
    end
  end

  # scope :with_end, -> (with_end) do
  #   where('mailing_list_subscriptions.created_at <= ?', with_end)
  # end

  scope :with_end_blog, -> (with_end) do
    begin
      DateTime.parse with_end
      where('mailing_list_subscriptions.created_at <= ?', with_end)
    rescue
    end
  end

  def first_name
    return user.first_name unless user.nil?
    super
  end

  def last_name
    return user.last_name unless user.nil?
    super
  end

  def email
    return user.email unless user.nil?
    super
  end

  def self.options_for_sorted_by
    [
      ['Email (a-z)', 'email desc']
    ]
  end

end
