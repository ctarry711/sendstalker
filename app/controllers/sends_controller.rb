class SendsController < ApplicationController
  def index
    @followees = current_user.followees
  end
end