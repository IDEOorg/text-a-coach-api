ActiveAdmin.register Platform do
  menu false

  sidebar "Platform Contents", only: [:show, :edit] do
    ul do
      li link_to "Conversations",   admin_platform_conversations_path(resource)
    end
  end
end
