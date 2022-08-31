class AddNewColLinkWithHomepageFtToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column :courses, :link_with_homepage_ft, :boolean, default: false
  end
end
