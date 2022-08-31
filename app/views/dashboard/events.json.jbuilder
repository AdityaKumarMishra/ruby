json.array! @json_events do |event|
  json.date event.date
  json.badge event.badge
  json.title event.title
  json.body event.body
  json.footer event.footer
end