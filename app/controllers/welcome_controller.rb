class WelcomeController < ApplicationController

  def index
    render nothing: true
  end

  def ping
    render text: "pong"
  end

end
