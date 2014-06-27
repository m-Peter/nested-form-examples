require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:yard)
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
      post :create, project: {
        name: "Life",
        
        tasks_attributes: {
          "0" => { name: "Eat" },
          "1" => { name: "Pray" },
          "2" => { name: "Love" },
        }
      }
    end

    project = assigns(:project)

    assert project.valid?
    project.tasks.each do |task|
      assert task.valid?
      assert task.persisted?
    end
    assert_redirected_to project_path(project)
    
    assert_equal "Life", project.name
    
    assert_equal "Eat", project.tasks[0].name
    assert_equal "Pray", project.tasks[1].name
    assert_equal "Love", project.tasks[2].name
    
    assert_equal "Project: Life was successfully created.", flash[:notice]
  end

  test "should not create project with invalid params" do
    existing_project = projects(:yard)

    assert_difference('Project.count', 0) do
      post :create, project: {
        name: existing_project.name,
        
        tasks_attributes: {
          "0" => { name: nil },
          "1" => { name: nil },
          "2" => { name: nil },
        }
      }
    end

    project = assigns(:project)

    assert_not project.valid?
    assert_includes project.errors.messages[:name], "has already been taken"

    project.tasks.each do |task|
      assert_not task.valid?
      assert_includes task.errors.messages[:name], "can't be blank"
    end
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
    assert_difference('Project.count', 0) do
      patch :update, id: @project, project: {
        name: "Car service",
        
        tasks_attributes: {
          "0" => { name: "Wash tires", id: @project.tasks[0].id },
          "1" => { name: "Clean inside", id: @project.tasks[1].id },
          "2" => { name: "Check breaks", id: @project.tasks[2].id },
        }
      }
    end

    project = assigns(:project)

    assert_redirected_to project_path(project)
    
    assert_equal "Car service", project.name
    
    assert_equal "Wash tires", project.tasks[0].name
    assert_equal "Clean inside", project.tasks[1].name
    assert_equal "Check breaks", project.tasks[2].name

    assert_equal "Project: Car service was successfully updated.", flash[:notice]
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
