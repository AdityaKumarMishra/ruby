class ConvertCityToEnumInCourses < ActiveRecord::Migration[6.1]
  def up
    # adding temp columns for city
    add_column :courses, :temp_city, :string
    # fetch old data to temp columns
    Course.all.each do |course|
      course.update_attribute(:temp_city, course[:city].present? ? course[:city] : "Other")
    end

    # remove old city columns
    remove_column :courses, :city

    # add new city coulmns with datatype integer
    add_column :courses, :city, :integer, null: false, default: Course.cities["Other"]
    # transfer data from temp columns to original columns
    Course.all.each do |course|
      val = Course.cities[course.temp_city.gsub("Sept-GAMSAT-", "Sept-GAMSAT ") || "Other"]
      course.update_attribute(:city, val)
    end
    # remove temp columns
    remove_column :courses, :temp_city
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
