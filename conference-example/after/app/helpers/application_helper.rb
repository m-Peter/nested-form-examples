module ApplicationHelper
  def link_to_remove_fields(name, f, options = {})
    if f.object.persisted?
      f.hidden_field(:_destroy) + link_to(name, '#', onclick: "remove_fields(this, false); return false;")
    else
      link_to(name, '#', onclick: "remove_fields(this, true); return false;")
    end
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.get_model(association)
    
    fields = f.fields_for(association, new_object, :child_index => "new_#{ association }") do |builder|
      render(association.to_s, :f => builder)
    end

    link_to name, '#', onclick: "add_fields(this, \"#{ association }\", \"#{ escape_javascript(fields) }\"); return false;"
  end
end
