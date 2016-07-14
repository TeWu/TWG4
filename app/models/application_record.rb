class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def convert_exception_to_boolean(&block)
    block.call
    true
  rescue Exception
    false
  end

end
