namespace :document_feature do
  task create_document_feature: :environment do
    vce_document = MasterFeature.find_by(name: 'VceDocumentsFeature')
    unless vce_document
      MasterFeature.create(name: 'VceDocumentsFeature',
                     partials: ['pages/partial/vce_ready_features/documents'],
                     types: ['VceReady'],
                     url: "documents_path",
                     title: "Documents",
                     icon: "fa fa-folder",
                     show_in_sidebar: true,
                     model_permissions: ["document"],
                     )
    end
    hsc_document = MasterFeature.find_by(name: 'HscDocumentsFeature')
    unless hsc_document
      MasterFeature.create(name: 'HscDocumentsFeature',
                     partials: ['pages/partial/hsc_ready_features/documents'],
                     types: ['HscReady'],
                     url: "documents_path",
                     title: "Documents",
                     icon: "fa fa-folder",
                     show_in_sidebar: true,
                     model_permissions: ["document"],
                     )
    end
  end
end
