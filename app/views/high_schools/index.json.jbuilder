json.array!(@high_schools) do |high_school|
  json.label high_school.name
  json.value high_school.name
end