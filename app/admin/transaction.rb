ActiveAdmin.register Transaction do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    transaction: [:user_id, :amount, :status]
    end
  end

  index do
    column :user do |request|
      request.user.nickname
    end
    column "Amount in BTC Cents", :amount
    column :type do |request|
      if request.type == "WithdrawalTransaction"
        "Withdrawal"
      else
        "Donation"
      end
    end
    column :status do |request|
      request.status
    end
    column :created_at
    column :updated_at

    default_actions
  end
end