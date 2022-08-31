class RemoceCourseMcqStemrelation < ActiveRecord::Migration[6.1]
  def change
    drop_table :mcq_stem_courses
  end
end
