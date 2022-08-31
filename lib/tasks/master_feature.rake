namespace :master_feature do
  desc 'associate existing ProductVersions with product line'
  task associate_with_product_lines: :environment do
    ProductLine.all.each do |product_line|
      MasterFeature.where(product_line_id: nil).where('name ilike ?', "#{product_line.name}%").update_all(product_line_id: product_line.id)
    end
  end

  desc 'increase max_qty by one'
  task increase_max_qty_by_one: :environment do
    MasterFeature.find_by(name: "GamsatExamFeature").update_attribute(:max_qty, 10)
  end
end
