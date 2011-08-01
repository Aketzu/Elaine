module ProgramsHelper
	def tech_boolean_field(form, name, desc)
		content_tag :tr, :class => "tech" do
			content_tag(:th, :class => "edit") do
				form.label name, desc
			end + 
			content_tag(:td, :class => "edit") do
				form.check_box name
			end
		end
	end
	def tech_text_field(form, name, desc, extradesc="")
		content_tag :tr, :class => "tech" do
			content_tag(:th, :class => "edit") do
				form.label name, desc
			end + 
			content_tag(:td, :class => "edit") do
				form.text_field(name, :class => "text") +
				(extradesc.empty? ? "" : "<br /><span class='extradesc'>" + extradesc + "</span>")
			end
		end
	end
	def tech_number_field(form, name, desc, range)
		opts = {}
		range.each {|n| opts[n] = n }
		tech_select_field form, name, desc, opts
	end
	def tech_select_field(form, name, desc, options)
		content_tag :tr, :class => "tech" do
			content_tag(:th, :class => "edit") do
				form.label name, desc
			end + 
			content_tag(:td, :class => "edit") do
				form.select name, options
			end
		end
	end
end
