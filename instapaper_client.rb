require "httparty"

class InstapaperClient
  include HTTParty
  base_uri "https://www.instapaper.com"

  def initialize(username, password)
    @auth_url = "/api/authenticate"
    @add_url = "/api/add"

    self.class.basic_auth(username, password)
    authenticate
  end

  def add_url(url, title)
    query = {
      url: url,
      title: title
    }

    response = self.class.post(@add_url, query: query)

    return if response.code == 201

    raise ArgumentError, "Error adding url to instapaper (#{response.code}): #{response.body}"
  end

  private

  def authenticate
    response = self.class.get(@auth_url)

    return if response.code == 200

    raise ArgumentError, "Error authenticating to instapaper (#{response.code}): #{response.body}"
  end
end
