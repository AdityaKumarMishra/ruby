namespace :pull_documents_to_textbooks do
  task create_textbooks_of_document_type: :environment do
    Document.all.each do |doc|
      Textbook.create(
        title: doc.attachment_file_name,
        document_file_name: doc.attachment_file_name,
        document_content_type:  doc.attachment_content_type,
        document_file_size: doc.attachment_file_size,
        document_updated_at: doc.attachment_updated_at,
        user_id: doc.user_id,
        product_line_id: doc.product_line_id,
        for_timetable: doc.for_timetable,
        tag_ids: doc.tag_ids,
        created_at: doc.created_at,
        updated_at: doc.updated_at,
        for_downloadable_resource: true,
        for_paid: doc.for_paid,
        for_trial: doc.for_trial
      )
    end
  end
end
