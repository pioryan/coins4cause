ActiveAdmin.register Viral do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    viral: [:bounty, :status, :duration, :body, :user_id]
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id, :value => current_user.id, :as => :hidden
      f.input :bounty
      f.input :duration, :include_blank => false, :member_label => :to_label
      f.input :body, :as => :text
    end
    f.actions
  end
end