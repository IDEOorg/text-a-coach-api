class Api::V1::AgentsController < Api::V1::BaseController
  serialization_scope :view_context

  before_action :find_agent, only: [:show]

  # GET /agents/:id.json
  def show
    output_ok @agent
  end

  # GET /agents.json
  def index
    output_ok Agents.all
  end

  private

  def find_agent
    @agent = Agent.find params[:id]
    if @agent.nil?
      output_error 404, id: "couldn't find record for agent with id #{params[:id]}"
    end
  end

  def agent_params
    params.permit [
      :name,
      :job_title,
      :email
    ]
  end
end
