require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { address: @project.address, aop_type_id: @project.aop_type_id, canton: @project.canton, companty_id: @project.companty_id, departament: @project.departament, description: @project.description, latitude: @project.latitude, longitude: @project.longitude, name: @project.name, province: @project.province }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { address: @project.address, aop_type_id: @project.aop_type_id, canton: @project.canton, companty_id: @project.companty_id, departament: @project.departament, description: @project.description, latitude: @project.latitude, longitude: @project.longitude, name: @project.name, province: @project.province }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
