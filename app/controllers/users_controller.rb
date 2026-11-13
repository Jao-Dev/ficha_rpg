class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @characters = current_user.characters
  end
end
