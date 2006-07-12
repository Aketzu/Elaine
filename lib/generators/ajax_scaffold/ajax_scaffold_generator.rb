require "rails_generator/generators/components/scaffold/scaffold_generator"

class AjaxScaffoldingSandbox < ScaffoldingSandbox
  def default_input_block
    Proc.new { |record, column| "<div class=\"form-element\">\n  <label for=\"#{record}_#{column.name}\">#{column.human_name}</label>\n  #{input(record, column.name)}\n</div>\n" }
  end
  
  def all_input_tags(record, record_name, options) 
    input_block = options[:input_block] || default_input_block
    
    if !options[:exclude].blank?
      filtered_content_columns = record.class.content_columns.reject { |column| options[:exclude].include?(column.name) }
    else
      filtered_content_columns = record.class.content_columns
    end
    
    filtered_content_columns.collect{ |column| input_block.call(record_name, column) }.join("\n")
  end
  
end

class ActionView::Helpers::InstanceTag
  alias_method :base_to_input_field_tag, :to_input_field_tag

  def to_input_field_tag(field_type, options={})
    options[:class] = 'text-input'  
    base_to_input_field_tag field_type, options
  end
  
  def to_boolean_select_tag(options = {})
    options = options.stringify_keys
    add_default_name_and_id(options)
    tag_text = "<%= select \"#{@object_name}\", \"#{@method_name}\", [[\"True\", true], [\"False\", false]], { :selected => @#{@object_name}.#{@method_name} } %>"
  end
  
end

class AjaxScaffoldGenerator < ScaffoldGenerator

  alias_method :base_controller_file_path, :controller_file_path
  
  def controller_file_path
    "/" + base_controller_file_path
  end

  def manifest
  
    record do |m|
      
      # Check for class naming collisions.
      m.class_collisions controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}ControllerTest", "#{controller_class_name}Helper"
      m.class_collisions class_path, class_name, "#{singular_name}Test"

      # Model, controller, helper, views, and test directories.
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)
      m.directory File.join('test/fixtures', class_path)
      m.directory File.join('app/controllers', controller_class_path)
      m.directory File.join('app/helpers', controller_class_path)
      m.directory File.join('app/views', controller_class_path, controller_file_name)
      m.directory File.join('app/views/layouts', controller_class_path)
      m.directory File.join('public/images')
      m.directory File.join('test/functional', controller_class_path)

      # Model class, unit test, and fixtures.
      m.template 'model.rb',      File.join('app/models', "#{singular_name}.rb")
      m.template 'unit_test.rb',  File.join('test/unit', "#{singular_name}_test.rb")
      m.template 'fixtures.yml',  File.join('test/fixtures', "#{singular_name}.yml")
      
      # Scaffolded forms.
      m.complex_template 'form.rhtml',
        File.join('app/views',
                  controller_class_path,
                  controller_file_name,
                  '_form.rhtml'),
        :insert => 'form_scaffolding.rhtml',
        :sandbox => lambda { create_sandbox },
        :begin_mark => 'form',
        :end_mark => 'eoform',
        :mark_id => singular_name

      # Scaffolded partials.
      m.template "partial_item.rhtml",
                    File.join('app/views',
                              controller_class_path,
                              controller_file_name,
                              "_#{singular_name}.rhtml")

      scaffold_partials.each do |name|
        m.template "partial_#{name}.rhtml",
                    File.join('app/views',
                              controller_class_path,
                              controller_file_name,
                              "_#{name}.rhtml")
      end

      # Scaffolded views.
      scaffold_views.each do |action|
        m.template "view_#{action}.rhtml",
                    File.join('app/views',
                              controller_class_path,
                              controller_file_name,
                              "#{action}.rhtml"),
                    :assigns => { :action => action }
      end
      
      # RJS templates
      scaffold_rjs_templates.each do |template|
        m.template "rjs_#{template}.rjs",
                    File.join('app/views',
                              controller_class_path,
                              controller_file_name,
                              "#{template}.rjs")
      end
      
      # Libraries
      scaffold_lib.each do |filename|
        m.template "lib_#{filename}.rb",
                    File.join('lib',
                              "#{filename}.rb")
      end

      # Controller class, functional test, helper, and views.
      m.template 'controller.rb',
                  File.join('app/controllers',
                            controller_class_path,
                            "#{controller_file_name}_controller.rb")

      m.template 'functional_test.rb',
                  File.join('test/functional',
                            controller_class_path,
                            "#{controller_file_name}_controller_test.rb")

      m.template 'helper.rb',
                  File.join('app/helpers',
                            controller_class_path,
                            "#{controller_file_name}_helper.rb")

      # Layout and stylesheet.
      m.template 'layout.rhtml',
                  File.join('app/views/layouts', 
                            controller_class_path, 
                            "#{controller_file_name}.rhtml")
      
      m.template 'ajax_scaffold.css',   "public/stylesheets/ajax_scaffold.css"
      
      scaffold_javascripts.each do |javascript|
        m.template javascript, "public/javascripts/#{javascript}"
      end
      
      scaffold_images.each do |image|
        m.template image, "public/images/#{image}"
      end

    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} ajax_scaffold ModelName [ControllerName]"
    end

    def scaffold_views
      %w( list component )
    end
    
    def scaffold_rjs_templates
      %w( create destroy edit new update cancel )
    end
    
    def scaffold_partials
      %w( form_messages messages column_headings new_edit pagination_links )
    end
    
    def scaffold_lib
      %w( ajax_scaffold )
    end

    def scaffold_images
      %w( indicator.gif indicator-small.gif add.gif error.gif warning.gif information.gif arrow_down.gif arrow_up.gif )
    end
    
    def scaffold_javascripts
      %w( ajax_scaffold.js rico_corner.js )
    end
    
    def create_sandbox
      sandbox = AjaxScaffoldingSandbox.new
      sandbox.singular_name = singular_name
      begin
        sandbox.model_instance = model_instance
        sandbox.instance_variable_set("@#{singular_name}", sandbox.model_instance)
      rescue ActiveRecord::StatementInvalid => e
        logger.error "Before updating scaffolding from new DB schema, try creating a table for your model (#{class_name})"
        raise SystemExit
      end
      sandbox.suffix = suffix
      sandbox
    end

end
