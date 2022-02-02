class FolloweesController < ApplicationController
  def new
    @followee = current_user.followees.new
  end

  def create
    @followee = current_user.followees.new(followee_params)

    if @followee.save
      redirect_to :root
    else
      render :new
    end
  end

  private

  def followee_params
    params.require(:followee).permit(:username, :realname, :user_ids)
  end
end
