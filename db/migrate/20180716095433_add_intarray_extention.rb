class AddIntarrayExtention < ActiveRecord::Migration[6.1]
  def change
    execute("CREATE EXTENSION intarray")
  end
end
