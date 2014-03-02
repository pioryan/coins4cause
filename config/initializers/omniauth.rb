Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Coins4Cause::Application.twitter[:key], Coins4Cause::Application.twitter[:secret],
           {
               :secure_image_url => 'true',
               :image_size => 'original',
               :authorize_params => {
                   :lang => 'en'
               }
           }
end