class AddStateToAddress < ActiveRecord::Migration[6.1]
  def up
    # adding temp columns for state and country
    add_column :addresses, :temp_state, :string
    add_column :addresses, :temp_country, :string
    # fetch old data to temp columns
    Address.all.each do |ad|
      s = ad[:state].present? ? ad[:state].downcase : Address.states.first[0]
      case s
      when "vic"
        s = "victoria"
      when "nsw"
        s = "new_south_wales"
      when "act"
        s = "australian_capital_territory"
      when "qld"
        s = "queensland"
      when "nt"
        s = "northern_territory"
      when "sa"
        s = "south_australia"
      when "wa"
        s = "western_australia"
      when "tas"
        s = "tasmania"
      else
        s = "other"
      end
      ad.temp_state = s
      ad.temp_country = ad[:country].present? ? ad[:country].parameterize('_') : Address.countries.first[0]
      ad.save(validate: false)
    end
    # remove old state and country columns
    remove_column :addresses, :state
    remove_column :addresses, :country
    # add new state and country coulmns with datatype integer
    add_column :addresses, :state, :integer, null: false, default: 1
    add_column :addresses, :country, :integer, null: false, default: 1
    # transfer data from temp columns to original columns
    Address.all.each do |ad|
      ad.state = ad.temp_state.to_sym
      if ad.temp_country == 'mx' || 'au'
        ad.country = Address.countries.first[0]
      else
        ad.country = ad.temp_country.to_sym
      end
      ad.save(validate: false)
    end
    # remove temp columns
    remove_column :addresses, :temp_state
    remove_column :addresses, :temp_country
  end

  def down
    # adding temp columns for state and country
    add_column :addresses, :temp_state, :string
    add_column :addresses, :temp_country, :string
    # fetch old data to temp columns
    Address.all.each do |ad|
      ad.temp_state = ad[:state].present? ? ad.state : Address.states.first[0]
      ad.temp_country = ad[:country].present? ? ad.country : Address.countries.first[0]
      ad.save(validate: false)
    end
    # remove old state and country columns
    remove_column :addresses, :state
    remove_column :addresses, :country
    # add new state and country coulmns with datatype string
    add_column :addresses, :state, :string, null: false, default: "other"
    add_column :addresses, :country, :string, null: false, default: "australia"
    # transfer data from temp columns to original columns
    Address.all.each do |ad|
      ad.state = ad.temp_state
      ad.country = ad.temp_country
      ad.save(validate: false)
    end
    # remove temp columns
    remove_column :addresses, :temp_state
    remove_column :addresses, :temp_country
  end
end
