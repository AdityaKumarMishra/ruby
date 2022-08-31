class PopulateDegree < ActiveRecord::Migration[6.1]
  def change
    ['Bachelor of Arts',
     'Bachelor of Biomedicine/Medical Science',
     'Bachelor of Commerce',
     'Bachelor of Nursing',
     'Bachelor of Pharmacy',
     'Bachelor of Science/Health Sciences',
     'Others Others'].each do |d|
      Degree.create(name: d)
    end
  end
end
