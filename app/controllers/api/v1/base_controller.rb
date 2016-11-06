class Api::V1::BaseController < Api::BaseController

  respond_to :json

  before_filter :set_headers
  around_filter :time_request

  # This is our new function that comes before Devise's one
  # before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  # before_filter :authenticate_user!

  protected

  # Public: Check request headers for authentication
  # information. Use as a before_filter.
  #
  # Renders 401 or 403 depending on the discrepency.
  def secure_api
    if !authorized
      render status: 401, text: 'Please log in to use this API' and return
    end
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Expose-Headers'] = 'ETag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end

  def time_request
    start = Time.now
    yield
    delta = (Time.now - start).to_f
    logger.debug "API request to #{request.fullpath} took #{delta} seconds."
    if delta > 1.0
      logger.warn "WARN: API request to #{request.fullpath} took #{delta} seconds."
    end
  end

  private

  def authorized
    return true
    token = request.headers['HTTP_AUTHENTICATION']
    id = request.headers['HTTP_AUTHENTICATING_USER']
    @user = User.find_by_id(id)

    @user && @user.api_key.authentication_token == token ? true : false
  end

end
