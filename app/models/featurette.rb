class Featurette < ApplicationRecord
  has_one :purchase_item, as: :purchasable, dependent: :destroy
  validate :compatible_json


  # def activate
  #   # Activate is called by purchase_item when featurette is bought
  #   parsed_options.each do |key,value|
  #     # key is genearlly 'tutor_time', value might be 3 as in 3 hours of tutoring
  #     next if (value.nil? || key.nil?)
  #     fe = feature_enrolment
  #     if fe.options.nil?
  #       fe.update_attribute(:options, '{}')
  #     end
  #     # Update the hash by calling a function in feature_enrolment
  #     fe.update_options(key, (fe.parsed_options[key] || 0) + value) if fe.active
  #   end
  #   feature_enrolment.active = true
  #   feature_enrolment.assign_essays if feature_enrolment.feature.essay?
  #   feature_enrolment.save!
  #   feature_enrolment.enrolment.update(trial: false, trial_expiry: nil)
  # end

  def compatible_json
    # confirms that the JSON present in options is of a structure that is compatible with rest of website
    begin
      JSON.parse(options) unless options.nil?
      return true
    rescue JSON::ParserError
      return false
    end
  end

  def valid_for_purchase?
    # At moment all featurettes are considered valid for purcahse
    true
  end
  def deactivate
    purchase_item.destroy
  end

  # def validate_attributes
  #   if initial_cost.nil?
  #     self.update(initial_cost: feature_enrolment.feature.price)
  #   end

  #   if description.nil?
  #     self.update(description: feature_enrolment.feature.name)
  #   end
  # end




  def tutor_time
    parsed_options["tutor_time"]
  end

  def parsed_options
    #returns the options as a hash
    JSON.parse(options)
  end

  def parsed_options=(new_options)
    #updates options with new_options which is a hash
    self.update_attribute(:options, new_options.to_json)
  end

end
