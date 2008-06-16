class Channel < ActiveRecord::Base
	has_many :playlist
	has_many :reference_log
end
