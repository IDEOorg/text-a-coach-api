ActiveAdmin.register User do
  permit_params :phone_number, :name, :email, :city, :state, :terms

  menu parent: "People"

  index do
    selectable_column
    id_column
    column :name
    column :phone_number
    column :city
    column :state
    column :created_at
    actions
  end

  filter :name
  filter :phone_number
  filter :email
  filter :state
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "User Details" do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :city
      f.input :state
      f.input :terms
    end
    f.actions
  end
end
