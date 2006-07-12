module <%= controller_class_name %>Helper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    <%= model_name %>.scaffold_columns
  end

end
