require 'test_helper'

class LegalAgentsControllerTest < ActionController::TestCase
  setup do
    @legal_agent = legal_agents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:legal_agents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create legal_agent" do
    assert_difference('LegalAgent.count') do
      post :create, legal_agent: { address: @legal_agent.address, city: @legal_agent.city, company_id: @legal_agent.company_id, country: @legal_agent.country, email: @legal_agent.email, first_name: @legal_agent.first_name, identification_number: @legal_agent.identification_number, identification_type: @legal_agent.identification_type, last_name: @legal_agent.last_name, mailbox: @legal_agent.mailbox, phone_number: @legal_agent.phone_number, string: @legal_agent.string, user_id: @legal_agent.user_id }
    end

    assert_redirected_to legal_agent_path(assigns(:legal_agent))
  end

  test "should show legal_agent" do
    get :show, id: @legal_agent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @legal_agent
    assert_response :success
  end

  test "should update legal_agent" do
    patch :update, id: @legal_agent, legal_agent: { address: @legal_agent.address, city: @legal_agent.city, company_id: @legal_agent.company_id, country: @legal_agent.country, email: @legal_agent.email, first_name: @legal_agent.first_name, identification_number: @legal_agent.identification_number, identification_type: @legal_agent.identification_type, last_name: @legal_agent.last_name, mailbox: @legal_agent.mailbox, phone_number: @legal_agent.phone_number, string: @legal_agent.string, user_id: @legal_agent.user_id }
    assert_redirected_to legal_agent_path(assigns(:legal_agent))
  end

  test "should destroy legal_agent" do
    assert_difference('LegalAgent.count', -1) do
      delete :destroy, id: @legal_agent
    end

    assert_redirected_to legal_agents_path
  end
end
