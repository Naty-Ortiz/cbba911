require 'test_helper'

class VerifiedListsControllerTest < ActionController::TestCase
  setup do
    @verified_list = verified_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verified_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create verified_list" do
    assert_difference('VerifiedList.count') do
      post :create, verified_list: { date_of_verification: @verified_list.date_of_verification, employee_id: @verified_list.employee_id, verification_list_id: @verified_list.verification_list_id }
    end

    assert_redirected_to verified_list_path(assigns(:verified_list))
  end

  test "should show verified_list" do
    get :show, id: @verified_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @verified_list
    assert_response :success
  end

  test "should update verified_list" do
    patch :update, id: @verified_list, verified_list: { date_of_verification: @verified_list.date_of_verification, employee_id: @verified_list.employee_id, verification_list_id: @verified_list.verification_list_id }
    assert_redirected_to verified_list_path(assigns(:verified_list))
  end

  test "should destroy verified_list" do
    assert_difference('VerifiedList.count', -1) do
      delete :destroy, id: @verified_list
    end

    assert_redirected_to verified_lists_path
  end
end
