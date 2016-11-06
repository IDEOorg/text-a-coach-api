ActiveAdmin.register Message do
  belongs_to :conversation
  navigation_menu :conversation

  includes :conversation

  permit_params :conversation_id, :direction, :message, :created_at

  index do
    selectable_column
    id_column
    column :direction
    column :message
    column :created_at
    actions
  end

  filter :direction
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "Message Details" do
      f.input :direction
      f.input :message
      f.input :created_at, as: :datetime_picker
    end
    f.actions
  end

  sidebar "Conversation Details", only: [:show, :edit] do
    ul do
      li link_to "Messages",   admin_conversation_messages_path(resource.conversation)
    end
  end
end
