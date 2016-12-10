json.array!(@patrol_units) do |patrol_unit|
  json.extract! patrol_unit, :id, :name, :code
  json.url patrol_unit_url(patrol_unit, format: :json)
end
