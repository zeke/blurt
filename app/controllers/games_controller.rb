class GamesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @game = Game.current
    respond_to do |format|
      format.json { render :json => @game.to_json }
    end  
  end
  
end
