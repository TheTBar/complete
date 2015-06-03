Devise.setup do |config|
  Devise.secret_key = ENV['DEVISE_SECRET_KEY']
end
