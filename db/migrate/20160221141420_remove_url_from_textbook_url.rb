class RemoveUrlFromTextbookUrl < ActiveRecord::Migration[6.1]
  def change
    remove_column :textbook_urls, :url
  end
end
