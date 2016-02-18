ActiveAdmin.register User do
  controller do
    def permitted_params
      params.permit admin_user: [:id, :username, :wins, :losses, :email, :created_at, :updated_at, :encrypted_password]
    end
  end
  index do
    column :id
    column :username
    column :wins
    column :losses
    column :email
    column :sign_in_count
    column 'sign in at', :current_sign_in_at
    column 'ip', :current_sign_in_ip
    column :failed_attempts
    column :created_at
    column :updated_at

  end

  csv do
    column :id
    column :username
    column :wins
    column :losses
    column :email
    column :created_at
    column :updated_at
    column :encrypted_password
  end
end
