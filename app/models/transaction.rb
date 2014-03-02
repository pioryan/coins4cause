class Transaction < ActiveRecord::Base
  belongs_to :user

  after_create :tweet

  def tweet
    if status == "completed"
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Coins4Cause::Application.twitter[:key]
        config.consumer_secret     = Coins4Cause::Application.twitter[:secret]
        config.access_token        = Coins4Cause::Application.twitter[:access_token]
        config.access_token_secret = Coins4Cause::Application.twitter[:access_token_secret]
      end

      client.update("#{user.nickname} received donation. claim donation here!")
    end
  end
end
