class TransactionsController < ActionController::Base
  def create
    if params[:secret] == Coins4Cause::Application.coinbase_key
      #Transaction.create
      order = params["order"]
      user = User.where(:nickname => order["custom"]).first
      if user
        Transaction.create(:user => user, :amount => BigDecimal.new(order["total_btc"]["cents"]), :status => order["status"])
      end
    end
  end
end