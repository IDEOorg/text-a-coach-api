require 'jwt'

module SmoochAPI

  class << self
    def client(flavor)
      return SmoochAPI::Client.new(flavor)
    end

    def validateWebhook(request)
      begin
        token = request.headers['X-API-Key'.freeze]
        flavor = nil
        Flavor.all.each do |f|
          if ENV["FLAVOR_#{f.handle}_WEBHOOK"] === token
            flavor = f
            break
          end
        end
      rescue StandardError => e
        flavor = nil
      end
      return flavor unless flavor.nil?
      raise "Invalid Webhook payload"
    end

    # def createResponseObject(response_data)
    #   return SmoochAPI::Response.new(response_data)
    # end
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
      # output = []
      # if data && data["meta"]["status"] == "Success"
      #   data["result"].each do |survey_data|
      #     output << QualtricsV3Service::Survey.new(survey_data)
      #   end
      # end
      # output.sort! do |left, right|
      #   compare = left.status <=> right.status
      #   if compare != 0
      #     compare
      #   else
      #     left.name <=> right.name
      #   end
      # end
      # return output
    end

  end
end
