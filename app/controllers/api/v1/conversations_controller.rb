class Api::V1::ConversationsController < Api::V1::BaseController
  serialization_scope :view_context

  before_action :related_flavor, only: [:index, :search]
  before_action :find_conversation, only: [:show]

  # GET /conversations/:id.json
  def show
    render json: @conversation
  end

  # GET /conversations.json
  def index
    render json: @flavor.conversations.filter(filter_params).paginate(:page => params[:page] || 1)
  end

  # GET /conversations.json
  def search
    base_query = @flavor.conversations.filter(filter_params)
    base_query = base_query.search_by_topic(params[:query]) if params[:query].present?
    render json: base_query.paginate(:page => params[:page] || 1)
  end

  private

  def find_conversation
    @conversation = Conversation.find params[:id]
  end

  def related_flavor
    @flavor = Flavor.find(params[:flavor_id] || 1)
  end

  def filter_params
    params.permit [
      :flavor_id,
      :agent_id,
      :user_id,
      :tag
    ]
  end
end
