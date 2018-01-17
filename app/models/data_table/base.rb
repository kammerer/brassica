class DataTable::Base < ActiveRecord::Base
  self.abstract_class = true

  include Filterable
  include Pluckable
  include TableData

  # Provides table_names for related, counted models
  def self.counter_names
    count_columns.map do |column|
      get_related_model(column)
    end
  end

  def self.get_related_model(counter_name)
    counter_name = counter_name.split(/ as /i)[-1]  # honor aliasing
    counter_name.gsub!('_count','')   # support cached count columns as well
    counter_name.gsub!('qtls','qtl')  # unfortunate special case... :(
    counter_name
  end

  def self.privacy_adjusted_count_columns
    count_columns.map do |column|
      counter_column = column.split(/ as /i)[0]
      as_column = column.split(/ as /i)[-1]
      "(#{table_name}.#{counter_column} - coalesce(#{get_related_model(counter_column)}.hidden, 0)) AS #{as_column}"
    end
  end

  def self.permitted_params
    []
  end

  def self.table_columns
    []
  end

  def self.count_columns
    []
  end

  def self.ref_columns
    []
  end

  def read_only?
    true
  end
end
