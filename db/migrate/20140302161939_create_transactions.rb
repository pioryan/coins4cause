class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.decimal :amount, :scale => 8 ,:precision => 20, :default => 0
      t.string :status
      t.timestamps
    end
  end
end
