Devise.setup do |config|
  if Rails.env.production?
    Devise.secret_key = ENV['DEVISE_SECRET_KEY']
  else
    Devise.secret_key = "eaf2b4f717f5ae8bb600ca441227f4636cddb4c2450c58942cd059a49b49d9683bedda4367f8deaef09aa43532866416d934"
  end
end
