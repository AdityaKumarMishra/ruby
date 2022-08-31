class CreateSystemInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :system_infos do |t|

      t.string :ip
      t.string :user_agent

      t.timestamps null: false
    end
  end
end
