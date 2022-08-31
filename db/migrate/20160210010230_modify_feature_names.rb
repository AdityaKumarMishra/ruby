class ModifyFeatureNames < ActiveRecord::Migration[6.1]
  def change
    Feature.where(name: '6000 MCQs').update_all(name: 'Mcq')
    Feature.where(name: '6 Online Exams(Essays not included)').update_all(name: 'Exam')
    Feature.where(name: '6 Additional Essays').update_all(name: 'Essay')
  end
end
