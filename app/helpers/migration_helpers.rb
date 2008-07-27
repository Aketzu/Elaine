module MigrationHelpers
	class ActiveRecord::ConnectionAdapters::AbstractAdapter
		def foreign_key(table, field, options)
			tbl2 = options[:foreign_table]
			tbl2 ||= field.to_s.chop.chop.chop.pluralize
			fld2 = options[:foreign_key]
			fld2 ||= "id"

			params = ""
			options[:update] ||= "CASCADE"
			params += " ON UPDATE " + options[:update].to_s

			options[:delete] ||= "RESTRICT"
			params += " ON DELETE " + options[:delete].to_s


			execute "ALTER TABLE `#{table}` ADD CONSTRAINT fk_#{table}_#{field} FOREIGN KEY (#{field}) REFERENCES #{tbl2} (#{fld2}) #{params}"
		end

		def drop_foreign_key(table, field)
			execute "ALTER TABLE #{table} DROP FOREIGN KEY fk_#{table}_#{field}"
		end
	end
end

