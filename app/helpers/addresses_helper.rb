module AddressesHelper
  def display_state
    I18n.t("address.display_state.#{state}", default: state.titleize)
  end

  def state_names_for_select
    names = []
    Address.states.map do |state, key|
      display_name = I18n.t("address.display_state.#{state}", default: state.titleize)
      names << [display_name, key]
    end
    names.sort
  end

  def display_country
    I18n.t("address.display_country.#{country}", default: country.titleize)
  end

  def country_names_for_select
    names = []
    Address.countries.map do |country, key|
      display_name = I18n.t("address.display_country.#{country}", default: country.titleize)
      names << [display_name, key]
    end
    names
  end

  def state_for_select
    names = []
    Address.states.map do |state, key|
      display_name = I18n.t("address.display_state.#{state}", default: state.titleize)
      names << [display_name, state]
    end
    other_state = names.shift
    names.sort!
    names  = names << other_state
  end

  def country_for_select
    names = []
    Address.countries.map do |country, key|
      display_name = I18n.t("address.display_country.#{country}", default: country.titleize)
      names << [display_name, country]
    end
    names.sort
  end

  def city_for_select
    [
      ["Melbourne", "Melbourne"],
      ["Sydney","Sydney"],
      ["Brisbane","Brisbane"],
      ["Adelaide","Adelaide"],
      ["Perth","Perth"],
      ["Other", "Other"]
    ].sort
  end

end
