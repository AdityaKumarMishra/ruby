class RemoveDuplicateFeatures < ActiveRecord::Migration[6.1]
  def change
    ProductVersion.all.each do |product_version|
      grouped = product_version.features.all.group_by{|feature| [feature.name] }
      grouped.values.each do |duplicates|
        first_one = duplicates.shift
        duplicates.each{|double| double.delete}
      end
    end
  end
end
