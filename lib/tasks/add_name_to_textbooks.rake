namespace :add_name_to_textbooks do
  task name_for_document_textbooks: :environment do
    Document.all.each do |doc|
      Textbook.all.each do |book|
        next unless book.document_file_name == doc.attachment_file_name
        last_index = doc.title.rindex(".")
        book.update(title: doc.title[0...last_index])
      end
    end
  end

  task disable_document_master_feature: :environment do
    document_features = MasterFeature.where('name like ?', "%DocumentsFeature%")
    document_features.update_all(show_in_sidebar: false)
  end
end
