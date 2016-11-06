ActiveAdmin.register Conversation do
  belongs_to :platform, optional: true
  # navigation_menu :platform

  includes :platform, :agent, :user

  permit_params :platform_id, :agent_id, :user_id, :summary_question, :summary_answer, :tag_list, :last_message_at

  index do
    selectable_column
    id_column
    column :platform
    column :agent
    column :user
    column :summary_question
    column :created_at
    actions
  end

  filter :platform
  filter :agent
  filter :user
  filter :created_at

  form do |f|
    f.semantic_errors
    f.inputs "Conversation Details" do
      f.input :platform
      f.input :agent
      f.input :user
      f.input :summary_question
      f.input :summary_answer
      f.input :tag_list, input_html: {value: conversation.tag_list.to_s}, hint: "comma-separated list of tags"
      f.input :last_message_at, as: :datetime_picker
    end

    # f.inputs do
    #   f.has_many :messages, heading: 'Messages', allow_destroy: true do |b|
    #     b.input :direction
    #     b.input :message
    #     b.input :created_at, as: :datepicker
    #   end
    # end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :platform
      row :agent
      row :user
      row :summary_question
      row :summary_answer
      row :tag_list
      row :last_message_at
      row :created_at
      row :updated_at
    end

    panel "Messages" do
      table_for conversation.messages do
        column :direction
        column :message
        column :created_at
      end
    end
  end


  sidebar "Conversation Details", only: [:show, :edit] do
    ul do
      li link_to "Messages",   admin_conversation_messages_path(resource)
    end
  end

end
