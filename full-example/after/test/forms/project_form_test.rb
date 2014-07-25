require 'test_helper'
require_relative 'project_form_fixture'

class ProjectFormTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @project = Project.new
    @form = ProjectFormFixture.new(@project)
    @tasks_form = @form.forms[0]
    @contributors_form = @form.forms[1]
    @owner_form = @form.forms[2]
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

  test "forms list contains sub-form definitions" do
    assert_equal 3, ProjectFormFixture.forms.size

    tasks_definition = ProjectFormFixture.forms[0]
    contributors_definition = ProjectFormFixture.forms[1]
    owner_definition = ProjectFormFixture.forms[2]

    assert_equal :tasks, tasks_definition.assoc_name
    assert_equal :contributors, contributors_definition.assoc_name
    assert_equal :owner, owner_definition.assoc_name
  end

  test "project form provides getter method for tasks sub-form" do
    assert_instance_of FormCollection, @tasks_form
  end

  test "project form provides getter method for contributors sub-form" do
    assert_instance_of FormCollection, @contributors_form
  end

  test "project form provides getter method for owner sub-form" do
    assert_instance_of Form, @owner_form
  end

  test "tasks sub-form contains association name and parent" do
    assert_equal :tasks, @tasks_form.association_name
    assert_equal 2, @tasks_form.records
    assert_equal @project, @tasks_form.parent
  end

  test "contributors sub-form contains association name and parent" do
    assert_equal :contributors, @contributors_form.association_name
    assert_equal 2, @contributors_form.records
    assert_equal @project, @contributors_form.parent
  end

  test "owner sub-form contains association name and parent" do
    assert_equal :owner, @owner_form.association_name
    assert_equal @project, @owner_form.parent
  end

  test "#represents? returns true if the argument matches the Form's association name, false otherwise" do
    assert @tasks_form.represents?("tasks")
    assert_not @tasks_form.represents?("task")

    assert @contributors_form.represents?("contributors")
    assert_not @contributors_form.represents?("contributor")
  end

  test "project form provides getter method for task objects" do
    assert_respond_to @form, :tasks

    tasks = @form.tasks

    tasks.each do |form|
      assert_instance_of Form, form
      assert_instance_of Task, form.model
    end
  end

  test "project form provides getter method for contributor objects" do
    assert_respond_to @form, :contributors

    contributors = @form.contributors

    contributors.each do |form|
      assert_instance_of Form, form
      assert_instance_of Person, form.model
    end
  end

  test "project form initializes the number of records specified for tasks" do
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

  test "project form initializes the number of records specified for contributors" do
    assert_respond_to @contributors_form, :models
    assert_equal 2, @contributors_form.models.size

    @contributors_form.each do |form|
      assert_instance_of Form, form
      assert_instance_of Person, form.model
      assert form.model.new_record?

      assert_respond_to form, :name
      assert_respond_to form, :name=
      assert_respond_to form, :role
      assert_respond_to form, :role=
      assert_respond_to form, :description
      assert_respond_to form, :description=
    end

    assert_equal 2, @form.model.tasks.size
  end

  test "project form fetches task objects for existing Project" do
    project = projects(:yard)

    form = ProjectFormFixture.new(project)

    assert_equal project.name, form.name
    assert_equal 2, form.tasks.size
    assert_equal project.tasks[0], form.tasks[0].model
    assert_equal project.tasks[1], form.tasks[1].model
  end

  test "project form fetches contributor objects for existing Project" do
    project = projects(:gsoc)

    form = ProjectFormFixture.new(project)

    assert_equal project.name, "Add Form Models"
    assert_equal project.description, "Nesting models in a single form"
    assert_equal 2, form.contributors.size
    assert_equal project.contributors[0], form.contributors[0].model
    assert_equal project.contributors[1], form.contributors[1].model
  end

  test "project form syncs its model and its tasks" do
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

  test "project form syncs its model and its contributors" do
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      contributors_attributes: {
        "0" => { name: "Peter Markou", role: "GSoC Student", description: "Working on adding Form Models" },
        "1" => { name: "Carlos Silva", role: "RoR Core Member", description: "Assisting Peter throughout GSoC" }
      }
    }

    @form.submit(params)

    assert_equal "Add Form Models", @form.name
    assert_equal "Nesting models in a single form", @form.description

    assert_equal "Peter Markou", @form.contributors[0].name
    assert_equal "GSoC Student", @form.contributors[0].role
    assert_equal "Working on adding Form Models", @form.contributors[0].description

    assert_equal "Carlos Silva", @form.contributors[1].name
    assert_equal "RoR Core Member", @form.contributors[1].role
    assert_equal "Assisting Peter throughout GSoC", @form.contributors[1].description

    assert_equal 2, @form.contributors.size
  end

  test "project form saves its model and its tasks" do
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

  test "project form saves its model and its contributors" do
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      contributors_attributes: {
        "0" => { name: "Peter Markou", role: "GSoC Student", description: "Working on adding Form Models" },
        "1" => { name: "Carlos Silva", role: "RoR Core Member", description: "Assisting Peter throughout GSoC" }
      }
    }

    @form.submit(params)

    assert_difference('Project.count') do
      @form.save
    end

    assert_equal "Add Form Models", @form.name
    assert_equal "Nesting models in a single form", @form.description

    assert_equal "Peter Markou", @form.contributors[0].name
    assert_equal "GSoC Student", @form.contributors[0].role
    assert_equal "Working on adding Form Models", @form.contributors[0].description

    assert_equal "Carlos Silva", @form.contributors[1].name
    assert_equal "RoR Core Member", @form.contributors[1].role
    assert_equal "Assisting Peter throughout GSoC", @form.contributors[1].description

    assert_equal 2, @form.contributors.size

    assert @form.persisted?
    @form.contributors.each do |contributor_form|
      assert contributor_form.persisted?
    end
  end

  test "project form updates its model and its tasks" do
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

  test "project form updates its model and its contributors" do
    project = projects(:gsoc)
    form = ProjectFormFixture.new(project)
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      contributors_attributes: {
        "0" => { role: "CS Student", id: people(:peter).id },
        "1" => { role: "Plataformatec Engineer", id: people(:carlos).id }
      }
    }

    form.submit(params)

    assert_difference('Project.count', 0) do
      form.save
    end

    assert_equal "Add Form Models", form.name
    assert_equal "Nesting models in a single form", form.description

    assert_equal "Peter Markou", form.contributors[0].name
    assert_equal "CS Student", form.contributors[0].role
    assert_equal "Working on adding Form Models", form.contributors[0].description

    assert_equal "Carlos Silva", form.contributors[1].name
    assert_equal "Plataformatec Engineer", form.contributors[1].role
    assert_equal "Assisting Peter throughout GSoC", form.contributors[1].description

    assert_equal 2, form.contributors.size
  end

  test "project form responds to owner_id attribute" do
    attributes = [:owner_id, :owner_id=]

    attributes.each do |attribute|
      assert_respond_to @form, attribute
    end
  end

  test "assign owner to new project" do
    params = {
      name: "Add Form Models",
      description: "Nested models in a single form",
      
      owner_attributes: {
        name: "Peter Markou",
        role: "Contributor",
        description: "not now please"
      }
    }

    @form.submit(params)

    assert_equal 0, @form.errors.size
    assert_difference('Project.count') do
      @form.save
    end

    assert_equal "Add Form Models", @form.name
    assert_equal "Nested models in a single form", @form.description
    assert_equal "Peter Markou", @form.owner.name
    assert_equal "Contributor", @form.owner.role
    assert_equal "not now please", @form.owner.description
  end

  test "assign owner to existing project" do
    project = projects(:yard)
    form = ProjectFormFixture.new(project)
    params = {
      owner_attributes: {
        name: "Peter Markou",
        role: "Contributor",
        description: "not now please"
      }
    }

    form.submit(params)

    assert_difference('Project.count', 0) do
      form.save
    end

    assert_equal "Peter Markou", form.owner.name
    assert_equal "Contributor", form.owner.role
    assert_equal "not now please", form.owner.description
  end

  test "project form responds to tasks writer method" do
    assert_respond_to @form, :tasks_attributes=
  end

  test "project form responds to contributors writer method" do
    assert_respond_to @form, :contributors_attributes=
  end

  test "project form responds to owner writer method" do
    assert_respond_to @form, :owner_attributes=
  end
end