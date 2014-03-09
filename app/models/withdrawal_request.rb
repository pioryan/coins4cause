class WithdrawalRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :withdrawal_transaction, :foreign_key => :transaction_id
  after_update :create_withdrawal_transaction, :if => Proc.new { status_changed? }

  validates_each :amount do |record, attr, value|
    if record.new_record? &&  BigDecimal.new(value.to_s) > record.user.transactions.sum(:amount)
      record.errors.add attr, 'Insufficient Funds.'
    end
  end

  STATES = {
      :pending => 0,
      :complete => 1,
      :insufficient => 2,
  }

  state_machine :status, :initial => :pending do
    STATES.each do |name, value|
      state name, :value => value
    end

    event :pending do
      transition all => :pending
    end

    event :complete do
      transition all => :complete
    end

    event :insufficient do
      transition all => :insufficient
    end

  end

  def create_withdrawal_transaction
    if self.complete?
      WithdrawalTransaction.create(:user => user, :amount => BigDecimal.new(self.amount * -1), :status => "completed")
    end
  end

end
