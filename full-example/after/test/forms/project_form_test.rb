require 'test_helper'
require_relative 'project_form_fixture'

class ProjectFormTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @project = Project.new
    @form = ProjectFormFixture.new(@project)
    @tasks_form = @form.forms.first
    @model = @form
  end

  test "project form responds to attributes" do
    attributes = [:name, :name=, :description, :description=]

    attributes.each do |attribute|
      assert_respond_to @form, attribute
    end
  end

  test "declares collection association" do
    assert_respond_to ProjectFormFixture, :association
  end

  test "forms list contains tasks sub-form definition" do
    assert_equal 1, ProjectFormFixture.forms.size

    tasks_definition = ProjectFormFixture.forms[0]

    assert_equal :tasks, tasks_definition.assoc_name
  end

  test "project form provides getter method for tasks sub-form" do
    assert_instance_of FormCollection, @tasks_form
  end

  test "tasks sub-form contains association name and parent" do
    assert_equal :tasks, @tasks_form.association_name
    assert_equal 2, @tasks_form.records
    assert_equal @project, @tasks_form.parent
  end

  test "#represents? returns true if the argument matches the Form's association name, false otherwise" do
    assert @tasks_form.represents?("tasks")
    assert_not @tasks_form.represents?("task")
  end

  test "project form provides getter method for task objects" do
    assert_respond_to @form, :tasks

    tasks = @form.tasks

    tasks.each do |form|
      assert_instance_of Form, form
      assert_instance_of Task, form.model
    end
  end

  test "project form initializes the number of records specified" do
    assert_respond_to @tasks_form, :models
    assert_equal 2, @tasks_form.models.size
    
    @tasks_form.each do |form|
      assert_instance_of Form, form
      assert_instance_of Task, form.model
      assert form.model.new_record?

      assert_respond_to form, :name
      assert_respond_to form, :name=
      assert_respond_to form, :description
      assert_respond_to form, :description=
      assert_respond_to form, :done
      assert_respond_to form, :done=
    end

    assert_equal 2, @form.model.tasks.size
  end

  test "project form fetches models for existing parent" do
    project = projects(:yard)

    form = ProjectFormFixture.new(project)

    assert_equal project.name, form.name
    assert_equal 2, form.tasks.size
    assert_equal project.tasks[0], form.tasks[0].model
    assert_equal project.tasks[1], form.tasks[1].model
  end

  test "project form syncs its model and the models in nested sub-forms" do
    params = {
      name: "Add Form Models",

      tasks_attributes: {
        "0" => { name: "Form unit", description: "Form to represent a single model", done: false },
        "1" => { name: "Form collection", description: "A collection of Forms", done: false },
      }
    }

    @form.submit(params)

    assert_equal "Add Form Models", @form.name

    assert_equal "Form unit", @form.tasks[0].name
    assert_equal "Form to represent a single model", @form.tasks[0].description
    assert_equal false, @form.tasks[0].done

    assert_equal "Form collection", @form.tasks[1].name
    assert_equal "A collection of Forms", @form.tasks[1].description
    assert_equal false, @form.tasks[1].done

    assert_equal 2, @form.tasks.size
  end

  test "project form saves its model and the models in nested sub-forms" do
    params = {
      name: "Add Form Models",
      description: "Nested models in a single form",

      tasks_attributes: {
        "0" => { name: "Form unit", description: "Form to represent a single model", done: "0" },
        "1" => { name: "Form collection", description: "A collection of Forms", done: "0" },
      }
    }

    @form.submit(params)

    assert_difference('Project.count') do
      @form.save
    end

    assert_equal "Add Form Models", @form.name
    assert_equal "Nested models in a single form", @form.description

    assert_equal "Form unit", @form.tasks[0].name
    assert_equal "Form to represent a single model", @form.tasks[0].description
    assert_equal false, @form.tasks[0].done

    assert_equal "Form collection", @form.tasks[1].name
    assert_equal "A collection of Forms", @form.tasks[1].description
    assert_equal false, @form.tasks[1].done

    assert_equal 2, @form.tasks.size

    assert @form.persisted?
    @form.tasks.each do |task_form|
      assert task_form.persisted?
    end
  end

  test "project form updates its model and the models in nested sub-forms" do
    project = projects(:yard)
    form = ProjectFormFixture.new(project)
    params = {
      name: "Life",
      
      tasks_attributes: {
        "0" => { name: "Eat", done: "1", id: tasks(:rake).id },
        "1" => { name: "Pray", done: "1", id: tasks(:paint).id },
      }
    }

    form.submit(params)

    assert_difference('Project.count', 0) do
      form.save
    end

    assert_equal "Life", form.name
    assert_equal "Eat", form.tasks[0].name
    assert_equal true, form.tasks[0].done
    
    assert_equal "Pray", form.tasks[1].name
    assert_equal true, form.tasks[1].done
    
    assert_equal 2, form.tasks.size
  end
end