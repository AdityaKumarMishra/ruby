class CreateTutorProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :tutor_profiles do |t|
      t.references :tutor, index: true
      t.boolean :private_tutor

      t.timestamps null: false
    end
  end
end
