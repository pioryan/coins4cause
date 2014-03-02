ActiveAdmin.register User do
  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :commit, :id,
                    user: [:nickname, :cause, :name, :description, :logo, :email]
    end

    def create
      user = User.new(permitted_params[:user])
      user.save(:validate => false)
      redirect_to admin_users_path
    end

  end

  index do
    column :name
    column :nickname
    column :description
    column :logo
    column :cause do |user|
      user.cause
    end

    default_actions
  end

  show do |user|
    attributes_table do
      row :name
      row :nickname
      row :description
      row :logo
      row :cause do |user|
        user.cause
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email, :as => :hidden, :value => "cause#{Time.now.to_i}@coins4cause.com"
      f.input :nickname
      f.input :description
      f.input :logo
      f.input :cause, :as => :boolean
    end
    f.actions
  end
end