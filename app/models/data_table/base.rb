class DataTable::Base < ActiveRecord::Base
  self.abstract_class = true

  include Filterable
  include Pluckable
  include TableData

  def read_only?
    true
  end
end
