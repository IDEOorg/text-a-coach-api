class Api::V1::ConversationsController < Api::V1::BaseController
  serialization_scope :view_context

  before_action :related_platform, only: [:index]
  before_action :find_conversation, only: [:show]

  # GET /conversations/:id.json
  def show
    render json: @conversation
  end

  # GET /conversations.json
  def index
    render json: @platform.conversations.paginate(:page => params[:page] || 1)
  end

  private

  def find_conversation
    @conversation = Conversation.find params[:id]
    if @conversation.nil?
      return forbid!
    end
  end

  def related_platform
    @platform = Platform.find(params[:platform_id])
  end

  def conversation_params
    params.permit [
      :platform_id,
      :agent_id,
      :user_id,
      :summary_question,
      :summary_answer,
      :last_message_at
    ]
  end
end
