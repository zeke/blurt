class GuessesController < ApplicationController

  before_filter :authenticate_user!

  def create
    @game = Game.find(params[:game_id])
    current_user.guesses.create!(:word => params[:word], :game => @game)
    render :nothing => true
  end
  
end
