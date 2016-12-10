json.array!(@employees) do |employee|
  json.extract! employee, :id, :identification_number, :identification_type, :first_name, :string, :last_name, :country, :city, :address, :phone_number, :email, :mailbox, :user_id,:postion, :profession, :agent_id
  json.url employee_url(employee, format: :json)
end
