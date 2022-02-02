class SendsController < ApplicationController
  def index
    @followees = current_user.followees
    @followee = current_user.followees.new
  end

  private

  def followee_params
    params.require(:followee).permit(:username, :realname, :user_ids)
  end
end