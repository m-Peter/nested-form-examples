module ApplicationHelper
  def link_to_remove_fields(name, f, options = {})
    html_options = {}
    is_existing = f.object.persisted?
    
    classes = []
    classes << "remove_fields"
    classes << (is_existing ? 'existing' : 'dynamic')
    html_options[:class] = [classes.join(' ')]

    if is_existing
      f.hidden_field(:_destroy) + link_to(name, '#', html_options)
    else
      link_to(name, '#', html_options)
    end
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    assoc = association.to_s.singularize
    
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{assoc}") do |builder|
      render(assoc.to_s + "_fields", :f => builder)
    end

    html_options = {}
    html_options[:class] = "add_fields"
    html_options[:'data-association'] = assoc
    html_options[:'data-association-insertion-template'] = CGI.escapeHTML(fields).html_safe

    link_to(name, '#', html_options)
  end
end
