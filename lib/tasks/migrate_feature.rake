LIB_FEATURES = %w{HscGetClarityFeature HscTutorAccessFeature HscVideoFeature HscEnglishTextbookFeature HscMathTextbookFeature VceEssayFeature VceLiveExamFeature VcePrivateTutoringFeature VceTutorAccessFeature VceGetClarityFeature MathTextbookFeature VceMathTextbookFeature VceVideoFeature EnglishTextbookFeature VceEnglishTextbookFeature VceExamFeature UmatDocumentsFeature UmatTextbookHardCopyFeature UmatLiveExamFeature UmatPrivateTutoringFeature UmatAttendanceTutorialsFeature UmatTutorAccessFeature UmatDiagnosticsFeature DocumentsFeature GamsatDocumentsFeature GamsatTextbookHardCopyFeature EssayFeature GamsatEssayFeature PrivateTutoringFeature GamsatPrivateTutoringFeature LiveExamFeature GamsatLiveExamFeature AttendanceTutorialsFeature GamsatAttendanceTutorialsFeature GetClarityFeature GamsatGetClarityFeature GamsatIRVideoFeature VideoFeature GamsatVideoFeature TextbookFeature GamsatTextbookFeature ExamFeature GamsatExamFeature DiagnosticsFeature GamsatDiagnosticsFeature McqFeature GamsatMcqFeature GamsatIRTextbookFeature TutorAccessFeature GamsatTutorAccessFeature UmatMcqFeature UmatExamFeature UmatTextbookFeature UmatVideoFeature UmatGetClarityFeature UmatEssayFeature VceDiagnosticsFeature VceMcqFeature VceAttendanceTutorialsFeature HscDiagnosticsFeature HscMcqFeature HscExamFeature HscAttendanceTutorialsFeature HscLiveExamFeature HscPrivateTutoringFeature HscEssayFeature}

namespace :migrate_feature do
  task migrate_lib_feature_to_master_feature: :environment do
    LIB_FEATURES.each do |feature|
      f = feature.constantize.new
      partials = [f.class.try(:partial)].compact
      partials = f.class.try(:partials) unless partials.present?
      mf = MasterFeature.find_by_name(f.class.name)
      unless mf.present?
        m = MasterFeature.create!(name: f.class.name)
        m.types= f.class.types
        m.partials= f.class.partials
        m.url = f.class.try(:url)
        m.title= f.class.try(:title)
        m.icon= f.class.try(:icon)
        m.show_in_sidebar= f.class.try(:show_in_sidebar)
        m.model_permissions= f.class.try(:model_permissions)
        m.default_state= f.class.try(:default_state)
        m.save!
      end
    end
  end

  task migrate_feature_to_master_feature: :environment do
    Feature.all.each do |feature|

      next unless feature.product_version.present?
      master_feature = MasterFeature.find_or_create_by(name: feature.name)
      qty = feature.essay_num ? feature.essay_num : feature.tutor_time

      pvfp = ProductVersionFeaturePrice.find_or_create_by(product_version_id:
                                                   feature.product_version_id,
                                                   master_feature_id:
                                                   master_feature.id,
                                                   price: feature.price,
                                                   qty: qty,
                                                   is_default: feature.is_default
                                                  )
      feature.taggings.each do |tagging|
        tagging.update(taggable_id: pvfp.id,
                                  taggable_type: 'ProductVersionFeaturePrice'
                                 )
      end

      feature.feature_enrolments.each do |fe|
        if fe.active
          acquired = fe.created_at
          suspended = nil
        else
          acquired = nil
          suspended = fe.created_at
        end

        if feature.private_tutoring?
          options = JSON.parse fe.options
          qty = Feature.fetch_quantity(options)
          FeatureLog.create(acquired: acquired, suspended: suspended,
                            description: nil, qty: qty,
                            product_version_feature_price: pvfp,
                            enrolment_id: fe.enrolment_id
                           )
          acquired = nil
          suspended = fe.created_at
        end

        if fe.featurettes.any? && !feature.private_tutoring?
          fe.featurettes.each do |ft|
            options = JSON.parse ft.options
            qty = Feature.fetch_quantity(options)
            FeatureLog.create(acquired: acquired, suspended: suspended,
                              description: ft.description, qty: qty,
                              product_version_feature_price: pvfp,
                              enrolment_id: fe.enrolment_id
                             )
          end
        else
          options = JSON.parse fe.options
          qty = Feature.fetch_quantity(options)
          FeatureLog.create(acquired: acquired, suspended: suspended,
                            description: nil, qty: qty,
                            product_version_feature_price: pvfp,
                            enrolment_id: fe.enrolment_id
                           )
        end
      end
    end
  end
end
