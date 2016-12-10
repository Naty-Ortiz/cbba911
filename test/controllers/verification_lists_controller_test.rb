require 'test_helper'

class VerificationListsControllerTest < ActionController::TestCase
  setup do
    @verification_list = verification_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verification_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create verification_list" do
    assert_difference('VerificationList.count') do
      post :create, verification_list: { name: @verification_list.name }
    end

    assert_redirected_to verification_list_path(assigns(:verification_list))
  end

  test "should show verification_list" do
    get :show, id: @verification_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @verification_list
    assert_response :success
  end

  test "should update verification_list" do
    patch :update, id: @verification_list, verification_list: { name: @verification_list.name }
    assert_redirected_to verification_list_path(assigns(:verification_list))
  end

  test "should destroy verification_list" do
    assert_difference('VerificationList.count', -1) do
      delete :destroy, id: @verification_list
    end

    assert_redirected_to verification_lists_path
  end
end
