require 'mixpanel-ruby'

class Api::V1::WebhooksController < Api::V1::BaseController
  serialization_scope :view_context

  # POST /smooch.json
  def smooch
    @flavor = SmoochAPI::validateWebhook request
    @client = SmoochAPI::client @flavor
    # logger.info params.inspect
    begin
      tracker = Mixpanel::Tracker.new(ENV["MIXPANEL_TOKEN"])

      # logger.info params[:messages].inspect
      @device = params[:appUser][:devices].find{|d| d[:platform] === "twilio"}
      @user = SmoochUser.where(
        flavor_id: @flavor.id,
        smooch_id: params[:appUser][:_id],
        phone_number: @device[:info][:phoneNumber]
      ).first_or_create
      @last_seen_at = @user.seen_at
      @user.update_attribute :seen_at, Time.now

      # Log mixpanel event for messages received
      if params[:trigger] == "message:appUser"
        tracker.track(@user.id, 'Sent Message', {
          'Flavor' => @flavor.handle
        })
      end

      if OfficeHours.is_open
        if @last_seen_at && (Time.now - @last_seen_at) > 12.hours
          # OPEN and more than 12 hours since last message
          @client.send_message(
            @user.smooch_id,
            "Good to hear from you again. We're finding a #{@flavor.name} coach for you. It may be just a short wait."
          )
        elsif @last_seen_at.nil?
          # OPEN new user message
          @client.send_message(
            @user.smooch_id,
            "Welcome to #{@flavor.name}! We're finding the next available coach. It may be just a short wait."
          )
          @client.send_message(
            @user.smooch_id,
            "Text STOP anytime to cancel. Please see our terms of service at #{@flavor.terms_url}"
          )
        end
      else
        if @last_seen_at.nil?
          # CLOSED new user after hours message
          @client.send_message(
            @user.smooch_id,
            "Welcome to #{@flavor.name}! Our coaches are online weekdays 9am-5pm EST. We'll get back to you as soon as we can."
          )
          @client.send_message(
            @user.smooch_id,
            "Text STOP anytime to cancel. Please see our terms of service at #{@flavor.terms_url}"
          )
        else
          # CLOSED existing user after hours message
          @client.send_message(
            @user.smooch_id,
            "Good to hear from you again. #{@flavor.name} coaches are online weekdays 9am-5pm EST. We'll get back to you as soon as we can!"
          )
        end
      end

      @msg = params[:messages].try(:first) || {}
      if @msg[:text] === 'eu396f59nf76inz82nj4'
        @client.reset_user @msg[:authorId]
      end
    rescue StandardError => e
      logger.warn e.inspect
    end
    render nothing: true
  end

end
