module EventableItem
  extend ActiveSupport::Concern
  included do
    has_one :address, as: :addresable
    accepts_nested_attributes_for :address

    scope :ordered , -> {where('start_time >= NOW()').order('start_time DESC')}
  end

  class_methods do
    def for_tutor user
      raise "This for_tutor must be overwrite in #{self} model!!"
    end

    def for_student user
      raise "This for_student must be overwrite in #{self} model!!"
    end
  end

  def retrieve_events
    raise "This to_event must be overwrite in #{self} model!!"
  end

  private
  def to_event
    raise "This to_event must be overwrite in #{self} model!!"
  end

  class EventItem
    attr_accessor :name, :tutor, :student, :time_start, :time_end, :type, :id

    def initialize(attributes = {})
      @name = attributes[:name]
      @tutor = attributes[:tutor]
      @student = attributes[:student]
      @time_start = attributes[:time_start]
      @time_end = attributes[:time_end]
      @type = attributes[:type]
      @id = attributes[:id]
    end

    def to_model
      eval "#{type}.find #{id}"
    end

    def edit_path
      eval "Rails.application.routes.url_helpers.edit_#{type.underscore}_path(#{id})"
    end
  end

end