# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include UserEngine
  include TimeHelper

	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry[field], "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end
end
