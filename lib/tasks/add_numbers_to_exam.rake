namespace :add_numbers_to_exam do
  desc "GRAD-2391 add quantity for exam"
  task add_quantity_for_exam: :environment do
    feature_ids = MasterFeature.where('name LIKE ? AND name NOT LIKE ?', '%ExamFeature%', '%Live%').ids
    logs_ids = FeatureLog.includes(:master_feature).where(acquired: nil, master_features: {id: feature_ids}).ids
    FeatureLog.where(id: logs_ids).update_all(qty: 0)

    # Gamsat Feature Logs
    feature_logs = FeatureLog.where.not(acquired: nil)
    gamsat_feature_id = MasterFeature.where('name LIKE ?', '%GamsatExamFeature').ids
    gamsat_features = feature_logs.includes(:master_feature).where(master_features: {id: gamsat_feature_id})
    puts "Updating #{gamsat_features.count} Gamsat Exam Feature number access"
    FeatureLog.where(id: gamsat_features.ids).update_all(qty: 6)
    puts "Done"

    #Umat Feature Logs
    umat_feature_id = MasterFeature.where('name LIKE ?', '%UmatExamFeature').ids
    umat_features = feature_logs.includes(:master_feature).where(master_features: {id: umat_feature_id})
    puts "Updating #{umat_features.count} Umat Exam Feature number access"
    FeatureLog.where(id: umat_features.ids).update_all(qty: 3)
    puts "Done"

    #Hsc Feature Logs
    hsc_feature_id = MasterFeature.where('name LIKE ?', '%HscExamFeature').ids
    hsc_features = feature_logs.includes(:master_feature).where(master_features: {id: hsc_feature_id})
    puts "Updating #{hsc_features.count} Hsc Exam Feature number access"
    FeatureLog.where(id: hsc_features.ids).update_all(qty: 0)
    puts "Done"

    #Vce Feature Logs
    vce_feature_id = MasterFeature.where('name LIKE ?', '%VceExamFeature').ids
    vce_features = feature_logs.includes(:master_feature).where(master_features: {id: vce_feature_id})
    puts "Updating #{vce_features.count} Vce Exam Feature number access"
    FeatureLog.where(id: vce_features.ids).update_all(qty: 2)
    puts "Done"
  end

  desc "Add qty to Exam for new student"
  task add_quantity_for_exam: :environment do
    fl_ids = FeatureLog.where.not(acquired: nil).includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ? AND feature_logs.qty IS NULL', '%ExamFeature%', '%Live%').references(:master_features).ids
    puts "Updating #{fl_ids.count} New student Exam Feature number access"
    FeatureLog.where(id: fl_ids).update_all(qty: 6)
    puts "Done"
  end
end
