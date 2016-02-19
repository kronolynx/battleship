ActiveAdmin.register User do
  #permit_params :id, :username, :wins, :losses, :email, :created_at, :updated_at, :encrypted_password, :remember_created_at, :current_sign_in_at,
               # :current_sign_in_at
  #controller do
  #  def permitted_params
  #    params.permit admin_user: [:id, :username, :wins, :losses, :email, :created_at, :updated_at, :encrypted_password]
   # end
  #end
  #controller do
    #def scoped_collection
    #  super.includes  :username, :wins, :losses, :email, :created_at, :updated_at, :encrypted_password, :updated_at
   # end
  #end

  actions :index, :show
  filter :username
  filter :wins
  filter :losses
  filter :email
  filter :sign_in_count
  filter :created_at
  filter :updated_at
  filter :failed_attempts

  form do |f|
    f.semantic_errors # shows errors on :base
    f.input :id
    f.input :id
    f.input :username
    f.input :wins
    f.input :losses
    f.input :email
    f.input :created_at
    f.input :updated_at
    f.input :encrypted_password
    f.actions         # adds the 'Submit' and 'Cancel' buttons
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
    actions
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
