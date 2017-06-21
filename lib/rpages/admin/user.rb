if defined?(ActiveAdmin)
  ActiveAdmin.register User do
    menu priority: 99

    permit_params :email, :name, :admin, :password, :password_confirmation

    index do
      selectable_column
      id_column
      column :name
      column :email
      column :sign_in_count
      column :created_at
      actions
    end

    filter :name
    filter :email
    filter :current_sign_in_at
    filter :sign_in_count
    filter :created_at

    form do |f|
      f.inputs "Admin Details" do
        f.input :name
        f.input :email
        f.input :admin
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end

    sidebar "User Overview", only: :show do
      attributes_table_for user do
        row :current_sign_in_at
        row :created_at
        row :updated_at
        row :sign_in_count
      end
    end

    show title: :name do
      attributes_table do
        row :name
        row :email
        row :admin
      end
    end

  end
end