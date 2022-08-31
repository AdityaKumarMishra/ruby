namespace :create_notifications do
	task add_notification: :environment do
		notification = Notification.create(title: "Notification Text",description: "Notification Description", active: false, page_type: 0)
	end
end