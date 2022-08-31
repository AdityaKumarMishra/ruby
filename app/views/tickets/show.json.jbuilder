json.extract! @ticket, :id, :title, :question, :asker_id, :answerer_id, :public, :answered_at, :questionable_id, :questionable_type, :created_at, :updated_at
json.children children_for_tag_tag_seacrh_url id: @ticket.tags.first.id
json.answerers answerer_for_tag_tag_search_url id: @ticket.tags.first.id
