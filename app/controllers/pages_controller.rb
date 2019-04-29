class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @uploads = current_user.uploads
  end
end
