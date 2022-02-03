class SendsController < ApplicationController
  def index
    if user_signed_in?
      @followees = current_user.followees
      @followee = current_user.followees.new
    else
      redirect_to new_user_session_path
    end
  end

  private

  def followee_params
    params.require(:followee).permit(:username, :realname, :user_ids)
  end
end