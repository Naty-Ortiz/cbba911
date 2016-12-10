require 'test_helper'

class ListCategoriesControllerTest < ActionController::TestCase
  setup do
    @list_category = list_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:list_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create list_category" do
    assert_difference('ListCategory.count') do
      post :create, list_category: { name: @list_category.name }
    end

    assert_redirected_to list_category_path(assigns(:list_category))
  end

  test "should show list_category" do
    get :show, id: @list_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @list_category
    assert_response :success
  end

  test "should update list_category" do
    patch :update, id: @list_category, list_category: { name: @list_category.name }
    assert_redirected_to list_category_path(assigns(:list_category))
  end

  test "should destroy list_category" do
    assert_difference('ListCategory.count', -1) do
      delete :destroy, id: @list_category
    end

    assert_redirected_to list_categories_path
  end
end
