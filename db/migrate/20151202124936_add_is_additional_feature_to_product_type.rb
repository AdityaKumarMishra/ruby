class AddIsAdditionalFeatureToProductType < ActiveRecord::Migration[6.1]
  def up
    add_column :product_types, :is_additional_feature, :boolean


    # This migration contains data migrations
    # Retro-fitted 'unless defined' statments because some models got deleted in a later commit.
    # Only migrate the data if the models are defined.
    # TODO: Find better solution.

    ProductTypeCustomCourseVesrion.new(:name => 'Custom Course Vesrion').save(:validate => false) if Object.const_defined?('ProductTypeCustomCourseVesrion')
    ProductTypeEssay.update_all(:is_additional_feature => true)               if Object.const_defined?('ProductTypeEssay')
    ProductTypeOnlineTutorAccess.update_all(:is_additional_feature => true)   if Object.const_defined?('ProductTypeOnlineTutorAccess')
    ProductTypeOnlineExam.update_all(:is_additional_feature => true)          if Object.const_defined?('ProductTypeOnlineExam')
    ProductTypeMcq.update_all(:is_additional_feature => true)                 if Object.const_defined?('ProductTypeMcq')
    ProductTypeCourseVideo.update_all(:is_additional_feature => true)         if Object.const_defined?('ProductTypeCourseVideo')
    ProductTypeCourseBookHardCopy.update_all(:is_additional_feature => true)  if Object.const_defined?('ProductTypeCourseBookHardCopy')
    ProductTypeTextbookPage.update_all(:is_additional_feature => true)        if Object.const_defined?('ProductTypeTextbookPage')
    ProductTypeCourseVesrion.update_all(:is_additional_feature => false)      if Object.const_defined?('ProductTypeCourseVesrion')
    ProductTypeStudentClass.update_all(:is_additional_feature => true)        if Object.const_defined?('ProductTypeStudentClass')
    ProductTypeComment.update_all(:is_additional_feature => true)             if Object.const_defined?('ProductTypeComment')
    ProductTypeInstruction.update_all(:is_additional_feature => true)         if Object.const_defined?('ProductTypeInstruction')
    ProductTypeCustomCourseVesrion.update_all(:is_additional_feature => false) if Object.const_defined?('ProductTypeCustomCourseVesrion')
  end

  def down
    remove_column :product_types, :is_additional_feature, :boolean
  end
end
