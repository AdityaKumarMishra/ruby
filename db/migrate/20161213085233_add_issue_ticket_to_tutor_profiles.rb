class AddIssueTicketToTutorProfiles < ActiveRecord::Migration[6.1]
  def change
  	add_column :tutor_profiles, :issue_ticket, :boolean, default: true
  end
end
