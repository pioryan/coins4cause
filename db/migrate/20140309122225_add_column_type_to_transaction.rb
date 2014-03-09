class AddColumnTypeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :type, :string, :limit => 50
  end
end
