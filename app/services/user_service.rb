class UserService
  def params(params)
    country = params.try(:[],'address_attributes').try(:[], 'country')
    state = params.try(:[],'address_attributes').try(:[], 'state')
    params['address_attributes']['country'] = country.to_i if country
    params['address_attributes']['state'] = state.to_i if state
    params
  end
end
