class FolloweesController < ApplicationController
  def create
    @followee = current_user.followees.new(followee_params)

    if @followee.save
      redirect_to :root
    else
      p @followee.errors.full_messages
    end
  end

  private

  def followee_params
    params.require(:followee).permit(:username, :realname, :user_ids)
  end
end
