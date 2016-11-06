class Api::BaseController < ApplicationController

  # Allow controller to specify what it responds_to
  include ActionController::MimeResponds

  # Finish action after a call to render
  include ActionController::ImplicitRender

  protect_from_forgery with: :null_session

  before_action :skip_sessions

  def skip_sessions
    request.session_options[:skip] = true
  end

end
