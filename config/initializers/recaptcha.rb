Recaptcha.configure do |config|
  config.public_key  = '6LeygQ0TAAAAAB3ayjq7hPzBeAEh7k0t_kFmeXPr'
  config.private_key = '6LeygQ0TAAAAAHIv8a-uBmdfpmkO81n5YgBtKb6A'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
  # Uncomment if you want to use the newer version of the API,
  # only works for versions >= 0.3.7:
  # config.api_version = 'v2'

  # if Rails.env.production?
  #   config.public_key  = '6LeygQ0TAAAAAB3ayjq7hPzBeAEh7k0t_kFmeXPr'
  #   config.private_key = '6LeygQ0TAAAAAHIv8a-uBmdfpmkO81n5YgBtKb6A'
  # end
end