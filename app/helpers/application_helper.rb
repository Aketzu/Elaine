# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include UserEngine
  include TimeHelper

	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry[field], "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end

	def tooltip(text)
		image_tag('tooltip.png', :onmouseover => 'Tip("' + text + '")')
	end

	def tooltip_format_time
		image_tag('tooltip.png', :onmouseover => 'Tip("Format: hh:mm:ss<br/>You can omit zeros from the beginning of the string.")')
	end
end
