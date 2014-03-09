class AddColumnTransactionToWithdrawalRequest < ActiveRecord::Migration
  def change
    add_column :withdrawal_requests, :transaction_id, :integer
  end
end
