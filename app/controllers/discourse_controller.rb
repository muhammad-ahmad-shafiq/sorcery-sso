class DiscourseController < ApplicationController
  SECRET = 'abcdefghij'

  skip_before_action :require_login
  before_action :validate_request
  before_action :set_data

  def sso
    if current_user.present?
      return_sso_url = @data['return_sso_url']

      payload, new_sig = sso_payload_and_sig
      redirect_to "#{return_sso_url}?sso=#{payload}&sig=#{new_sig}"
    else
      redirect_to login_path(sso: params[:sso], sig: params[:sig])
    end
  end

  private
    def sso_payload_and_sig
      payload = {
        nonce:       @data['nonce'],
        email:       current_user.email,
        username:    current_user.email.split('@').first,
        external_id: current_user.id
      }

      payload_data    = Rack::Utils.build_query(payload)
      base64_payload  = Base64.encode64(payload_data)
      encoded_payload = URI.escape(base64_payload)
      new_signature   = OpenSSL::HMAC.hexdigest('sha256', SECRET, base64_payload)

      [encoded_payload, new_signature]
    end

    def validate_request
      signature = OpenSSL::HMAC.hexdigest('sha256', SECRET, params[:sso])

      redirect_to root_path, alert: 'Invalid SSO request.' if signature != params[:sig]
    end

    def set_data
      base64_sso  = URI.unescape(params[:sso])
      decoded_sso = Base64.decode64(base64_sso)
      @data       = Rack::Utils.parse_nested_query(decoded_sso)
    end
end
