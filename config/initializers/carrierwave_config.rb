CarrierWave.configure do |config|
  config.dropbox_app_key = ENV['CARRIERWAVE_DROPBOX_APP_KEY']
  config.dropbox_app_secret = ENV['CARRIERWAVE_DROPBOX_APP_SECRET']
  config.dropbox_access_token = ENV['CARRIERWAVE_DROPBOX_ACCESS_TOKEN']
  config.dropbox_access_token_secret = ENV['CARRIERWAVE_DROPBOX_ACCESS_TOKEN_SECRET']
  config.dropbox_user_id = ENV['CARRIERWAVE_DROPBOX_USER_ID']
  config.dropbox_access_type = 'dropbox'
end
