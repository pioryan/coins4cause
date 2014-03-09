ActiveAdmin.register WithdrawalRequest do
  controller do
    def permitted_params
      if current_user.is_admin?
        params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                      withdrawal_request: [:amount, :address, :status]
      else
        params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                      withdrawal_request: [:user_id, :amount, :address]
      end

    end
  end


  form do |f|
    f.inputs do
      f.input :user_id, :value => current_user.id, :as => :hidden
      f.input :amount, :label => "Amount in BTC Cents"
      f.input :address
      if current_user.is_admin?
        f.input :status, :as => :select, :collection => Hash[WithdrawalRequest::STATES.to_a.reverse]
      end
    end
    f.actions
  end

  show do |request|
    attributes_table do
      row "BTC Cents", :amount do |request|
        request.amount
      end
      row :address
      row :status do |request|
        request.human_status_name
      end
    end
  end

  index do
    column :user do |request|
      request.user.nickname
    end
    column "BTC Cents", :amount
    column :address
    column :created_at
    column :status do |request|
      request.human_status_name
    end

    default_actions
  end
end