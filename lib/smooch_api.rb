require 'jwt'

module SmoochAPI

  class << self
    def client(flavor)
      return SmoochAPI::Client.new(flavor)
    end

    def validateWebhook(request)
      token = request.headers['X-API-Key'.freeze]
      flavor = nil
      Flavor.all.each do |f|
        if ENV["FLAVOR_#{f.handle}_WEBHOOK"] === token
          flavor = f
          break
        end
      end
      if flavor.nil?
        raise "Invalid Webhook payload"
      else
        return flavor
      end
    end
  end

  class Client

    def initialize(flavor)
      @flavor = flavor
      @base_uri    = 'https://api.smooch.io/v1'
      @base_params = {
        scope: 'app'
      }
      @base_secrets = {
        jwt_id: ENV["FLAVOR_#{@flavor.handle}_JWT_ID"],
        jwt_secret: ENV["FLAVOR_#{@flavor.handle}_JWT_SECRET"]
      }
    end

    def request( path, method, params = {}, http_options = {} )
      @base_params.each do |key, value|
        params[key] ||= value
      end

      http_options[:verify] = !Rails.env.development?
      path = "#{@base_uri}#{path}" unless path.match('http(s)?://')

      if method == :get
        http_options[:query] = params

        token = JWT.encode http_options[:query],
          @base_secrets[:jwt_secret],
          'HS256',
          {kid: @base_secrets[:jwt_id]}

        http_options[:headers] = {
          "authorization" => "Bearer #{token}"
        }
        return HTTParty.get path, http_options

      elsif method == :post
        http_options[:body] = params

        token = JWT.encode http_options[:body],
          @base_secrets[:jwt_secret],
          'HS256',
          {kid: @base_secrets[:jwt_id]}

        http_options[:headers] = {
          "authorization" => "Bearer #{token}"
        }
        return HTTParty.post path, http_options

      elsif method == :delete
        http_options[:body] = params

        token = JWT.encode http_options[:body],
          @base_secrets[:jwt_secret],
          'HS256',
          {kid: @base_secrets[:jwt_id]}

        http_options[:headers] = {
          "authorization" => "Bearer #{token}"
        }
        return HTTParty.delete path, http_options
      end
    end

    def menu
      data = self.request '/menu', :get
      return data
    end

    def get_user(user_id)
      data = self.request "/appusers/#{user_id}", :get
      return data
    end

    def reset_user(user_id)
      data = self.request "/appusers/#{user_id}/channels/twilio", :delete
      return data
    end

    def create_user
      data = self.request '/appusers', :post, { userId: "+18183503510" }
      puts data.inspect
      return data
    end

    def user_event(user_id, event_name)
      data = self.request "/appusers/#{user_id}/events", :post, {
        name: event_name
      }
      return data
    end

    def send_message(user_id, message)
      data = self.request "/appusers/#{user_id}/messages", :post, {
        role: "appMaker",
        type: "text",
        text: message
      }
      return data
    end

  end
end
