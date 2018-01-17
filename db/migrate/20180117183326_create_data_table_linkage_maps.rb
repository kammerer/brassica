class CreateDataTableLinkageMaps < ActiveRecord::Migration
  def change
    create_view :data_table_linkage_maps
  end
end
