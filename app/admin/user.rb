ActiveAdmin.register User do
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
end
