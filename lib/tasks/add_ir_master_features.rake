namespace :add_ir_master_features do
  task add_IR_features: :environment do
    mcq_feature = MasterFeature.find_or_create_by(name: 'GamsatIRMcqFeature',
                                    url: 'new_exercise_path', title: 'MCQs',
                                    icon: 'fa fa-plus-square', show_in_sidebar: true,
                                    position: 2
                                   )
    mcq_feature.types = ['GamsatReady']
    mcq_feature.model_permissions = ['mcq_stem']
    mcq_feature.save

    document_feature = MasterFeature.find_or_create_by(name: 'GamsatIRDocumentsFeature',
                                    url: 'documents_path', title: 'Documents',
                                    icon: 'fa fa-folder', show_in_sidebar: true,
                                    position: 10
                                   )

    document_feature.types = ['GamsatReady']
    document_feature.model_permissions = ['document']
    document_feature.save

  end
end
