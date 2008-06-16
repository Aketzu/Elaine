class ReferenceLog < ActiveRecord::Base
	belongs_to :channel
	belongs_to :tape
end
