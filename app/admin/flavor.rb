ActiveAdmin.register Flavor do
  menu false

  index do
    selectable_column
    id_column
    column :name
    column :handle
    column :created_at
    actions
  end

  permit_params :name, :handle, :terms_url

  sidebar "Flavor Contents", only: [:show, :edit] do
    ul do
      li link_to "Conversations",   admin_flavor_conversations_path(resource)
    end
  end
end
