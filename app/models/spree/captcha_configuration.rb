class Spree::CaptchaConfiguration < Spree::Preferences::Configuration
  THEMES = %w(red white blackglass clean custom)

  # These keys works for localhost.
  preference :private_key, :string,  default: '6LeygQ0TAAAAAHIv8a-uBmdfpmkO81n5YgBtKb6A'
  preference :public_key,  :string,  default: '6LeygQ0TAAAAAB3ayjq7hPzBeAEh7k0t_kFmeXPr'
  preference :theme,       :string,  default: 'red'
  preference :use_captcha, :boolean, default: true

  # can also run these commands from the rails console
  #Spree::Captcha::Config.public_key = '6LeygQ0TAAAAAB3ayjq7hPzBeAEh7k0t_kFmeXPr'
  #Spree::Captcha::Config.private_key = '6LeygQ0TAAAAAHIv8a-uBmdfpmkO81n5YgBtKb6A'

end
