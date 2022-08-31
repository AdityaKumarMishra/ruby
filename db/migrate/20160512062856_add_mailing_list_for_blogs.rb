class AddMailingListForBlogs < ActiveRecord::Migration[6.1]
  def mailing_list_class_exists?
    begin
      MailingList
      return true
    rescue NameError
      return false
    end
  end

  def up
    if mailing_list_class_exists?
      MailingList.find_or_create_by!(name: "blog_umat")
      MailingList.find_or_create_by!(name: "blog_gamsat")
      MailingList.find_or_create_by!(name: "blog_vce")
      MailingList.find_or_create_by!(name: "blog_hsc")
    end
  end
  def down
  end
end
