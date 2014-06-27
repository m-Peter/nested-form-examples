class FormCollection
  include ActiveModel::Validations
  include Enumerable

  attr_reader :association_name, :records, :parent, :proc, :forms

  def initialize(assoc_name, parent, proc, records)
    @association_name = assoc_name
    @parent = parent
    @proc = proc
    @records = records
    @forms = []
    assign_forms
    enable_autosave
  end

  def submit(params)
    check_record_limit!(records, params)

    params.each do |key, value|
      if parent.persisted?
        id = value[:id]
        form = find_form_by_model_id(id)
        form.submit(value)
      else
        i = key.to_i
        forms[i].submit(value)
      end
    end
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

  def association_reflection
    parent.class.reflect_on_association(association_name)
  end

  def enable_autosave
    reflection = association_reflection
    reflection.autosave = true
  end

  def assign_forms
    if parent.persisted?
      fetch_models
    else
      initialize_models
    end
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
end