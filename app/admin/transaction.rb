ActiveAdmin.register Transaction do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    transaction: [:user_id, :amount, :status]
    end
  end
end