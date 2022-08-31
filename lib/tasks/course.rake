namespace :course do
  task :destroy_courses_no_pv => :environment do
    Course.all.select{|course| course.product_version.nil?}.each do |course|
      # Some courses have a product version that has been destoryed but relation wasn't nullified
      course.destroy
    end
  end
end
