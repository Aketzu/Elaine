class ProgramDescription < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

belongs_to :Program
belongs_to :Language

before_validation :strip_fields
validates_associated :Program
validates_associated :Language
validates_presence_of(:title, :message => "Title must be entered.")

acts_as_list :scope => :program_id

def language
  Language.find(self.language_id)
end

def strip_fields
  [:title, :private_description, :public_description].each do |field|
    self[field]=strip_tags(self[field])
  end
end

end
