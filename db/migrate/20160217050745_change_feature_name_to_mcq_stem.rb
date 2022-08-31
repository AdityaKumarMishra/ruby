class ChangeFeatureNameToMcqStem < ActiveRecord::Migration[6.1]
  def change
    Feature.where(name: 'Mcq').update_all(name: 'McqStem')
  end
end
