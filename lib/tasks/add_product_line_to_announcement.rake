namespace :add_product_line_to_announcement do
  task update_product_line_to_announcement: :environment do
  	gamsat_announcement = Announcement.where("name like ?", "%Gamsat%")
  	gamsat_announcement.update_all(product: 'GamsatReady') if gamsat_announcement.present?

  	umat_announcement = Announcement.where("name like ?", "%Umat%")
  	umat_announcement.update_all(product: 'UmatReady') if umat_announcement.present?

  	hsc_announcement = Announcement.where("name like ?", "%Hsc%")
  	hsc_announcement.update_all(product: 'HscReady') if hsc_announcement.present?

  	vce_announcement = Announcement.where("name like ?", "%Vce%")
  	vce_announcement.update_all(product: 'VceReady') if vce_announcement.present?
  end

  task update_category: :environment do
    Announcement.where("name like ?", "%dashboard%").each do |ann|
      ann.update_attribute(:category, 'Dashboardpage')
    end

    # create Master Feature Announcement for Gamsat
    master_features = MasterFeature.includes(:product_versions).where(product_versions: {id: ProductVersion.where(type: 'GamsatReady')})

    master_features.each do |master_feature|
      name = master_feature.title == 'My essays' ? 'Essay Responses' : master_feature.title == 'Mock Exam' ? 'MockExamFeature' : master_feature.title
      ann = Announcement.find_by(name: name)
      if ann.present?
        new_ann = Announcement.create(name: 'Gamsat ' + ann.name,
                                      description: ann.description,
                                      category: 'features',
                                      url: ann.url,
                                      highlighted_text: ann.highlighted_text,
                                      show_highlight: false,
                                      master_feature_id: master_feature.id,
                                      product_line_id: 1
                                     )
      end
    end

    # create Master Feature Announcement for Umat
    master_features = MasterFeature.includes(:product_versions).where(product_versions: {id: ProductVersion.where(type: 'UmatReady')})

    master_features.each do |master_feature|
      name = master_feature.title == 'My essays' ? 'Essay Responses' : master_feature.title == 'Mock Exam' ? 'MockExamFeature' : master_feature.title
      ann = Announcement.find_by(name: name)
      if ann.present?
        new_ann = Announcement.create(name: 'Umat ' + ann.name,
                                      description: ann.description,
                                      category: 'features',
                                      url: ann.url,
                                      highlighted_text: ann.highlighted_text,
                                      show_highlight: false,
                                      master_feature_id: master_feature.id,
                                      product_line_id: 2
                                      )
      end
    end

    # create Master Feature Announcement for Umat
    master_features = MasterFeature.includes(:product_versions).where(product_versions: {id: ProductVersion.where(type: 'HscReady')})

    master_features.each do |master_feature|
      name = master_feature.title == 'My essays' ? 'Essay Responses' : master_feature.title == 'Mock Exam' ? 'MockExamFeature' : master_feature.title
      ann = Announcement.find_by(name: name)
      if ann.present?
        new_ann = Announcement.create(name: 'Hsc ' + ann.name,
                                      description: ann.description,
                                      category: 'features',
                                      url: ann.url,
                                      highlighted_text: ann.highlighted_text,
                                      show_highlight: false,
                                      master_feature_id: master_feature.id,
                                      product_line_id: 4
                                     )
      end
    end


    # create Master Feature Announcement for Umat
    master_features = MasterFeature.includes(:product_versions).where(product_versions: {id: ProductVersion.where(type: 'VceReady')})

    master_features.each do |master_feature|
      name = master_feature.title == 'My essays' ? 'Essay Responses' : master_feature.title == 'Mock Exam' ? 'MockExamFeature' : master_feature.title
      ann = Announcement.find_by(name: name)
      if ann.present?
        new_ann = Announcement.create(name: 'Vce ' + ann.name,
                                      description: ann.description,
                                      category: 'features',
                                      url: ann.url,
                                      highlighted_text: ann.highlighted_text,
                                      show_highlight: false,
                                      master_feature_id: master_feature.id,
                                      product_line_id: 3
                                     )
      end
    end

  end
end
