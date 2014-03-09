class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications, :dependent => :delete_all
  has_many :transactions

  before_save :set_empty_logo
  after_create :index_cause
  after_update :index_cause

  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    if auth['extra']['raw_info']['email'].present?
      self.email = auth['extra']['raw_info']['email']
    elsif auth['info']['nickname'].present?
      self.nickname = auth['info']['nickname']
      self.email = "#{self.nickname}@Coins4Cause.com"
    end

    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def apply_omniauth_for_existing(auth)
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def cause=(value)
    if value == true  || value == "1"
      self.add_role :cause
    else
      if self.is_cause?
        self.remove_role :cause
      end
    end
  end

  def cause
    self.is_cause? ? true : false
  end

  def set_empty_logo
    if self.logo.blank?
      self.logo = scrape_logo
    end
  end

  def scrape_logo
    response = `curl -sL http://twitter.com/#{self.nickname} | grep profile_images | head -n1 | perl -p -e's/.*?http/http/;s/\".*//;s/_bigger//'`
    response.gsub("\n", "")
  end

  def index_cause
    if Rails.environment.production? && self.is_cause?
      params = {name: name, nickname: nickname, description: description}
      params = to_curl(params)
      response = Curl::Easy.http_post("#{ENV['BONSAI_URL']}/user/user/#{self.nickname}", *params){|curl| curl.timeout = 10}
      Rails.logger.error "Indexing >>>>>>>>>>>>>>#{response.inspect}"
    end
  end


  def to_curl(params = {})
    post_arr = []
    params.each { |k, v|
      next if v.nil?
      post_arr << Curl::PostField.content(k.to_s, v)
    }
    post_arr
  end
end
