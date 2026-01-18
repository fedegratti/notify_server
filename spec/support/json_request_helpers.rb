# frozen_string_literal: true

module JsonRequestHelpers
  def json_headers
    { 'Content-Type' => 'application/json' }
  end

  def post_json(path, params = {})
    post path, params: params.to_json, headers: json_headers
  end

  def put_json(path, params = {})
    put path, params: params.to_json, headers: json_headers
  end

  def patch_json(path, params = {})
    patch path, params: params.to_json, headers: json_headers
  end

  def json_response
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include JsonRequestHelpers, type: :request
end
