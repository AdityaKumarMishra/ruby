namespace :email_deliveries do
  task import_to_model: :environment do
  	require 'csv'
    CSV.foreach("#{Rails.root}/public/data.csv", :headers => true) do |row|
      EmailDelivery.create!(row.to_hash.except("id","created_at", "updated_at"))
    end
  end
end