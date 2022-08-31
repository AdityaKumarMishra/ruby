class Event

  def self.retriev_events user
    if user.tutor?
      self.tutor_events user
    elsif user.student?
      self.student_events user
    end
  end

  def self.tutor_events user
    events = []
    retrieve_eventable_models.each { |model|
      model.ordered.for_tutor(user).each { |record|
        events = events + record.retrieve_events
      }
    }
    events
  end

  def self.student_events user
    events = []
    retrieve_eventable_models.each { |model|
      model.ordered.for_student(user).each { |record|
        events = events + record.retrieve_events
      }
    }
    events
  end
  private

  def self.retrieve_eventable_models
    Rails.application.eager_load!
    record_models = ActiveRecord::Base.descendants
    record_models.select {|m| m.included_modules.include?(EventableItem)}
  end
end
