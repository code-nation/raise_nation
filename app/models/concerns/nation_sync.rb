module NationSync
  extend ActiveSupport::Concern

  def nb_client
    @nb_client ||= NationBuilder::Client.new(slug, token)
  end

  def nb_auth_client
    OAuth2::Client.new(
      Rails.application.credentials.nationbuilder_app[:client_id],
      Rails.application.credentials.nationbuilder_app[:client_secret],
      site: "https://#{slug}.nationbuilder.com"
    )
  end

  def nb_api_token(code, oauth_url)
    nb_auth_client.auth_code.get_token(code, redirect_uri: oauth_url).token
  end

  def connected?
    token.present?
  end
end
