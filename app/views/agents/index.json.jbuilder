json.array!(@legal_agents) do |legal_agent|
  json.extract! legal_agent, :id, :identification_number, :identification_type, :first_name, :string, :last_name, :country, :city, :address, :phone_number, :email, :mailbox, :user_id, :company_id
  json.url legal_agent_url(legal_agent, format: :json)
end
