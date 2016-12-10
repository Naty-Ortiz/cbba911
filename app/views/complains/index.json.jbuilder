json.array!(@complains) do |complain|
  json.extract! complain, :id, :protagonists, :description, :address,  :latitude, :longitude, :crime, :contraversion,:crime_id,:contravertion_id,:auxValue
  json.url complain_url(complain, format: :json)
end
