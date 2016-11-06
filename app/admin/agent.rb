ActiveAdmin.register Agent do
  permit_params :name, :job_title, :email

  menu parent: "People"

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :job_title
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :job_title
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "Agent Details" do
      f.input :name
      f.input :job_title
      f.input :email
    end
    f.actions
  end

end
