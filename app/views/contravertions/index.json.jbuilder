json.array!(@contravertions) do |contravertion|
  json.extract! contravertion, :id, :name, :code
  json.url contravertion_url(contravertion, format: :json)
end
