class Api::V1::MessagesController < Api::V1::BaseController
  serialization_scope :view_context

  before_action :related_conversation, only: [:index]
  before_action :find_message, only: [:show]

  # GET /messages/:id.json
  def show
    render json: @message
  end

  # GET /messages.json
  def index
    render json: @conversation.messages.paginate(:page => params[:page] || 1)
  end

  private

  def find_message
    @message = Message.find params[:id]
  end

  def related_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end
