class AddAttachmentIconToFaqCategories < ActiveRecord::Migration[6.1]
  def self.up
    change_table :faq_categories do |t|
      t.attachment :icon
    end
  end

  def self.down
    remove_attachment :faq_categories, :icon
  end
end
