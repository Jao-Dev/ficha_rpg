class CharactersController < ApplicationController
  before_action :authenticate_user!

  def index
    @characters = current_user.characters
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
