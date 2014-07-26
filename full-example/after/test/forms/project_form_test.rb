require 'test_helper'
require_relative 'project_form_fixture'

class ProjectFormTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @project = Project.new
    @form = ProjectFormFixture.new(@project)
    @tasks_form = @form.forms[0]
    @contributors_form = @form.forms[1]
    @project_tags_form = @form.forms[2]
    @owner_form = @form.forms[3]
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
    assert_equal 4, ProjectFormFixture.forms.size

    tasks_definition = ProjectFormFixture.forms[0]
    contributors_definition = ProjectFormFixture.forms[1]
    project_tags_definition = ProjectFormFixture.forms[2]
    owner_definition = ProjectFormFixture.forms[3]

    assert_equal :tasks, tasks_definition.assoc_name
    assert_equal :contributors, contributors_definition.assoc_name
    assert_equal :project_tags, project_tags_definition.assoc_name
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
    assert_equal 1, @tasks_form.records
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

    assert @owner_form.represents?("owner")
    assert_not @owner_form.represents?("person")
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

  test "project form provides getter method for owner object" do
    assert_respond_to @form, :owner

    owner = @form.owner

    assert_instance_of Form, owner
    assert_instance_of Person, owner.model
  end

  test "project form initializes the number of records specified for tasks" do
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

    assert_equal 2, @form.model.contributors.size
  end

  test "project form initializes the owner record" do
    assert @owner_form.model.new_record?

    assert_respond_to @owner_form, :name
    assert_respond_to @owner_form, :name=
    assert_respond_to @owner_form, :role
    assert_respond_to @owner_form, :role=
    assert_respond_to @owner_form, :description
    assert_respond_to @owner_form, :description=
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

  test "project form fetches owner object for existing Project" do
    project = projects(:gsoc)

    form = ProjectFormFixture.new(project)

    assert_equal project.name, "Add Form Models"
    assert_equal project.description, "Nesting models in a single form"
    assert_equal "Peter Markou", form.owner.name
    assert_equal "GSoC Student", form.owner.role
    assert_equal "Working on adding Form Models", form.owner.description
  end

  test "project form syncs its model and its tasks" do
    params = {
      name: "Add Form Models",

      tasks_attributes: {
        "0" => { name: "Form unit", description: "Form to represent a single model", done: false },
      }
    }

    @form.submit(params)

    assert_equal "Add Form Models", @form.name

    assert_equal "Form unit", @form.tasks[0].name
    assert_equal "Form to represent a single model", @form.tasks[0].description
    assert_equal false, @form.tasks[0].done

    assert_equal 1, @form.tasks.size
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

  test "project form syncs its model and its owner" do
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      owner_attributes: {
        name: "Petros Markou",
        role: "Rails GSoC student",
        description: "Working on adding Form Models"
      }
    }

    @form.submit(params)

    assert_equal "Add Form Models", @form.name
    assert_equal "Nesting models in a single form", @form.description

    assert_equal "Petros Markou", @form.owner.name
    assert_equal "Rails GSoC student", @form.owner.role
    assert_equal "Working on adding Form Models", @form.owner.description
  end

  test "project form saves its model and its tasks" do
    params = {
      name: "Add Form Models",
      description: "Nested models in a single form",

      tasks_attributes: {
        "0" => { name: "Form unit", description: "Form to represent a single model", done: "0" },
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

    assert_equal 1, @form.tasks.size

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

  test "project form saves its model and creates new owner" do
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      owner_attributes: {
        name: "Petros Markou",
        role: "Rails GSoC student",
        description: "Working on adding Form Models"
      }
    }

    @form.submit(params)

    assert_difference('Project.count') do
      @form.save
    end

    assert_equal "Add Form Models", @form.name
    assert_equal "Nesting models in a single form", @form.description

    assert_equal "Petros Markou", @form.owner.name
    assert_equal "Rails GSoC student", @form.owner.role
    assert_equal "Working on adding Form Models", @form.owner.description

    assert @form.persisted?
    assert @form.owner.persisted?
  end

  test "project form saves its model and assigns existing owner" do
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",

      owner_id: people(:carlos).id
    }

    @form.submit(params)

    assert_difference('Project.count') do
      @form.save
    end

    assert_equal "Add Form Models", @form.name
    assert_equal "Nesting models in a single form", @form.description

    assert_equal "Carlos Silva", @form.owner.name
    assert_equal "RoR Core Member", @form.owner.role
    assert_equal "Assisting Peter throughout GSoC", @form.owner.description

    assert @form.persisted?
    assert @form.owner.persisted?
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

  test "project form updates its model and creates new owner" do
    project = projects(:gsoc)
    form = ProjectFormFixture.new(project)
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",
      
      owner_attributes: {
        name: "Carlos Silva",
        role: "RoR Core Team",
        description: "Assisting Peter throughout GSoC"
      }
    }

    form.submit(params)

    assert_difference('Project.count', 0) do
      form.save
    end

    assert_equal "Add Form Models", form.name
    assert_equal "Nesting models in a single form", form.description

    assert_equal "Carlos Silva", form.owner.name
    assert_equal "RoR Core Team", form.owner.role
    assert_equal "Assisting Peter throughout GSoC", form.owner.description
  end

  test "project form updates its model and assigns existing owner" do
    project = projects(:gsoc)
    form = ProjectFormFixture.new(project)
    params = {
      name: "Add Form Models",
      description: "Nesting models in a single form",
      
      owner_id: people(:carlos).id
    }

    form.submit(params)

    assert_difference('Project.count', 0) do
      form.save
    end

    assert_equal "Add Form Models", form.name
    assert_equal "Nesting models in a single form", form.description

    assert_equal "Carlos Silva", form.owner.name
    assert_equal "RoR Core Member", form.owner.role
    assert_equal "Assisting Peter throughout GSoC", form.owner.description
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

  def clean_database
    Project.delete_all
    Person.delete_all
  end

  test "new Project with new Owner" do
    clean_database

    gsoc = Project.new(name: "Add Form Models", description: "Nesting Form Models")

    owner = gsoc.build_owner
    owner.name = "Peter Markou"
    owner.role = "GSoC Rails student"
    owner.description = "Working on adding Form Models"
    gsoc.save

    assert gsoc.persisted?
    assert gsoc.owner.persisted?

    assert_equal "Add Form Models", gsoc.name
    assert_equal "Nesting Form Models", gsoc.description

    assert_equal "Peter Markou", gsoc.owner.name
    assert_equal "GSoC Rails student", gsoc.owner.role
    assert_equal "Working on adding Form Models", gsoc.owner.description
  end

  test "new Project with existing Owner" do
    clean_database

    owner = Person.create(name: "Peter Markou", role: "GSoC Rails student", description: "Working on adding Form Models")

    assert owner.persisted?
    assert_nil owner.project_id

    gsoc = Project.new(name: "Add Form Models", description: "Nesting Form Models")

    gsoc.owner = Person.create

    #assert_nil gsoc.owner_id

    gsoc.owner_id = owner.id

    assert_equal owner.id, gsoc.owner_id

    gsoc.save

    assert gsoc.persisted?
    assert gsoc.owner.persisted?

    assert_equal "Add Form Models", gsoc.name
    assert_equal "Nesting Form Models", gsoc.description

    #assert_equal owner.id, gsoc.owner_id
    assert_equal "Peter Markou", gsoc.owner.name
    assert_equal "GSoC Rails student", gsoc.owner.role
    assert_equal "Working on adding Form Models", gsoc.owner.description
  end

  test "existing Project with new Owner" do
    clean_database

    gsoc = Project.create(name: "Add Form Models", description: "Nesting Form Models")

    owner = gsoc.build_owner
    owner.name = "Peter Markou"
    owner.role = "GSoC Rails student"
    owner.description = "Working on adding Form Models"
    gsoc.save

    assert gsoc.persisted?
    assert gsoc.owner.persisted?

    assert_equal "Add Form Models", gsoc.name
    assert_equal "Nesting Form Models", gsoc.description

    assert_equal "Peter Markou", gsoc.owner.name
    assert_equal "GSoC Rails student", gsoc.owner.role
    assert_equal "Working on adding Form Models", gsoc.owner.description
  end

  test "existing Project with existing Owner" do
    clean_database

    owner = Person.create(name: "Peter Markou", role: "GSoC Rails student", description: "Working on adding Form Models")
    gsoc = Project.create(name: "Add Form Models", description: "Nesting Form Models")

    #gsoc.build_owner
    
    gsoc.owner_id = owner.id

    gsoc.save

    assert_equal "Add Form Models", gsoc.name
    assert_equal "Nesting Form Models", gsoc.description

    assert_equal "Peter Markou", gsoc.owner.name
    assert_equal "GSoC Rails student", gsoc.owner.role
    assert_equal "Working on adding Form Models", gsoc.owner.description

    assert gsoc.persisted?
    assert gsoc.owner.persisted?
  end
end