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
    assert_equal 1, @tasks_form.records
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
    assert_equal 1, @tasks_form.models.size
    
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

    assert_equal 1, @form.model.tasks.size
  end

  test "project form fetches models for existing parent" do
    project = projects(:yard)

    form = ProjectFormFixture.new(project)

    assert_equal project.name, form.name
    assert_equal 1, form.tasks.size
    assert_equal project.tasks[0], form.tasks[0].model
  end
end