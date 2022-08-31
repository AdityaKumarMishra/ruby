class AddUniqueConstraintToUsers < ActiveRecord::Migration[6.1]
  def up
    User.transaction do
      dup_emails = User.select(:email)
                       .group(:email)
                       .having('COUNT(*) > 1')
                       .map(&:email)

      conflicts = []

      User.where(email: dup_emails).where(first_name: 'Anonymous', last_name: 'Anonymous').each do |user|
        if user.orders.count > 0
          puts "[!] Temporarily skipping user #{user.id} due to having an order"
          conflicts.push user.email
        else
          puts "[*] Destroying anonymous user #{user.id}"
          user.destroy
        end
      end

      conflicts.uniq!
      puts "[*] Resolving conflicts: #{conflicts}"
      conflicts.each do |email|
        users = User.where(email: email).order(last_sign_in_at: :desc)
        keep = users.find { |user| !user.last_sign_in_at.nil? }
        puts "[!] User IDs for #{email}: #{users.map(&:id)}. Keeping user #{keep.id} - last signed in at #{keep.last_sign_in_at}"

        users.where.not(id: keep.id).each do |user|
          user.tickets.destroy_all()
          user.transfer_transaction.destroy_all()
          user.destroy
        end
      end
    end

    remove_index  :users, :email
    add_index :users, :email, unique: true
  end

  def down
    remove_index  :users, :email
    add_index :users, :email, unique: false
  end
end
