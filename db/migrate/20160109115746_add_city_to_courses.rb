class AddCityToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :city, :string
  end
end
