class ActiveRecord::Base
  def self.get_desired_columns(wanted, cache=nil)
    cache ||= nil
    if cache.nil?
      h= columns_hash
      cache = wanted.collect { |n| h[n] }
    end
    cache 
  end
end