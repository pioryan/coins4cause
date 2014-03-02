class WelcomeController < ApplicationController
  def index
    @causes =  User.with_role(:cause)
  end
end