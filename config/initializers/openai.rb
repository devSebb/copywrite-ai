OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_API_KEY"]
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
  config.log_errors = true
end
