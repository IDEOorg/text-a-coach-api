class Api::V1::WebhooksController < Api::V1::BaseController
  serialization_scope :view_context

  # POST /smooch.json
  def smooch
    @flavor = SmoochAPI::validateWebhook request
    @client = SmoochAPI::client @flavor
    # logger.info params.inspect
    begin
      # logger.info params[:messages].inspect
      @device = params[:appUser][:devices].find{|d| d[:platform] === "twilio".freeze}
      @user = SmoochUser.where(
        flavor_id: @flavor.id,
        smooch_id: params[:appUser][:_id],
        phone_number: @device[:info][:phoneNumber]
      ).first_or_create.update_attribute :seen_at, Time.now

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
