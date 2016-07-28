class ApplicationRecord < ActiveRecord::Base
  include TWG4::ActiveRecordExtensions
  self.abstract_class = true
end
