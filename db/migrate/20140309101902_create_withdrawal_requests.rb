class CreateWithdrawalRequests < ActiveRecord::Migration
  def change
    create_table :withdrawal_requests do |t|
      t.belongs_to :user
      t.decimal :amount, :scale => 8 ,:precision => 20, :default => 0
      t.string :address
      t.integer :status
      t.timestamps
    end
  end
end
