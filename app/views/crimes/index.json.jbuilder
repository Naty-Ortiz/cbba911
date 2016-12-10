json.array!(@crimes) do |crime|
  json.extract! crime, :id, :name, :code
  json.url crime_url(crime, format: :json)
end
