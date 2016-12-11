ActiveAdmin.register Flavor do
  menu false

  sidebar "Flavor Contents", only: [:show, :edit] do
    ul do
      li link_to "Conversations",   admin_flavor_conversations_path(resource)
    end
  end
end
