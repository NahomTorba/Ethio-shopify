require 'dotenv'
Dotenv.load('.env')

TOKEN = ENV['TELEGRAM_BOT_TOKEN']
APP_URL = ENV['APP_URL']

puts "Setting webhook for bot: #{TOKEN[0..10]}..."
puts "APP_URL: #{APP_URL}"

# Set webhook for main bot
webhook_url = "#{APP_URL}/webhooks/telegram"
uri = URI("https://api.telegram.org/bot#{TOKEN}/setWebhook?url=#{URI.encode_www_form_component(webhook_url)}")

response = Net::HTTP.get_response(uri)
puts "Response: #{response.body}"
