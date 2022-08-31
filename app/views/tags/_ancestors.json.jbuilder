json.array!(@tags) do |tag|
	json.extract! tag, :id, :name, :parent_id
	json.parents do
		json.array!(tag.ancestors) do |p|
			json.extract! p, :id, :name, :parent_id
		end
	end
end