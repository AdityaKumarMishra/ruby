module TicketsHelper
  def parents_for_tags
      all_tags = policy_scope(Tag)
      #1.Get parent tags with paren id =nil (Student,tutor or whomever will get [] because of the policy)
      tags = all_tags.select { |tag| tag.parent_id == nil }
      #2. For students, tutors or whomever, they may not have any tags in step 1 (filtered out by public = true)
      #so, try to add the the top most level tags instead
      tags_with_parents = all_tags.select { |tag| tag.parent_id != nil }
      # get all tag ids list
      tags_ids = tags_with_parents.collect{ |tag| tag.id } + tags.collect{ |tag| tag.id }
      #if a parent_id does not exist in the list then it is the top level
      top_level_tags = tags_with_parents.select { |tag| !tags_ids.include? tag.parent_id }
      tags += top_level_tags
    return tags
  end

  def display_status
    I18n.t("ticket.display_status.#{status}", default: status.titleize)
  end

  def status_for_select
    names = []
    Ticket.statuses.map do |status, key|
      display_name = I18n.t("ticket.display_status.#{status}", default: status.titleize)
      names << [display_name, key]
    end
    names
  end

  def type_for_select
    [
      ['Phone', 'Phone'],
      ['Email', 'Email'],
      ['In-person', 'In-person']
    ]
  end
end
