module ActiveForm
  class FormCollection
    include ActiveModel::Validations
    include Enumerable

    attr_reader :association_name, :records, :parent, :proc, :forms

    def initialize(assoc_name, parent, proc, options)
      @association_name = assoc_name
      @parent = parent
      @proc = proc
      @records = options[:records] || 1
      @forms = []
      assign_forms
    end

    def submit(params)
      #check_record_limit!(records, params)

      params.each do |key, value|
        if parent.persisted?
          create_or_update_record(value)
        else
          create_or_assign_record(key, value)
        end
      end
    end

    def get_model(assoc_name)
      Form.new(association_name, parent, proc)
    end

    def valid?
      aggregate_form_errors

      errors.empty?
    end

    def represents?(assoc_name)
      association_name.to_s == assoc_name.to_s
    end

    def models
      forms
    end

    def each(&block)
      forms.each do |form|
        block.call(form)
      end
    end

    private

    UNASSIGNABLE_KEYS = %w( id _destroy )

    def assign_to_or_mark_for_destruction(form, attributes)
      form.submit(attributes.except(*UNASSIGNABLE_KEYS))

      if has_destroy_flag?(attributes)
        form.delete
        remove_form(form)
      end
    end

    def existing_record?(attributes)
      attributes[:id] != nil
    end

    def update_record(attributes)
      id = attributes[:id]
      form = find_form_by_model_id(id)
      assign_to_or_mark_for_destruction(form, attributes)
    end

    def create_record(attributes)
      new_form = create_form
      new_form.submit(attributes)
    end

    def create_or_update_record(attributes)
      if existing_record?(attributes)
        update_record(attributes)
      else
        create_record(attributes)
      end
    end

    def create_or_assign_record(key, attributes)
      i = key.to_i

      if dynamic_key?(i)
        create_record(attributes)
      else
        forms[i].submit(attributes)
      end
    end

    def has_destroy_flag?(attributes)
      attributes['_destroy'] == "1"
    end

    def assign_forms
      if parent.persisted?
        fetch_models
      else
        initialize_models
      end
    end

    def dynamic_key?(i)
      i > forms.size
    end

    def aggregate_form_errors
      forms.each do |form|
        form.valid?
        collect_errors_from(form)
      end
    end

    def fetch_models
      associated_records = parent.send(association_name)
      
      associated_records.each do |model|
        forms << Form.new(association_name, parent, proc, model)
      end
    end

    def initialize_models
      records.times do
        forms << Form.new(association_name, parent, proc)
      end
    end

    def collect_errors_from(model)
      model.errors.each do |attribute, error|
        errors.add(attribute, error)
      end
    end

    def check_record_limit!(limit, attributes_collection)
      if attributes_collection.size > limit
        raise TooManyRecords, "Maximum #{limit} records are allowed. Got #{attributes_collection.size} records instead."
      end
    end

    def find_form_by_model_id(id)
      forms.each do |form|
        if form.id == id.to_i
          return form
        end
      end
    end

    def remove_form(form)
      forms.delete(form)
    end

    def create_form
      new_form = Form.new(association_name, parent, proc)
      forms << new_form
      new_form
    end
  end

end