class Api::V1::UsersController < Api::V1::BaseController
  serialization_scope :view_context

  before_action :find_user, only: [:show]

  # GET /users/:id.json
  def show
    output_ok @user
  end

  # GET /users.json
  def index
    output_ok Users.all
  end

  private

  def find_user
    @user = User.find params[:id]
    if @user.nil?
      output_error 404, id: "couldn't find record for user with id #{params[:id]}"
    end
  end

  def user_params
    params.permit [
      :phone_number,
      :name,
      :email,
      :city,
      :state,
      :terms
    ]
  end
end
