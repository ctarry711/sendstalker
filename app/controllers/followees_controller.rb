class FolloweesController < ApplicationController
  def create
    @followee = current_user.followees.new(followee_params)

    if @followee.save
      redirect_to :root
    else
      p @followee.errors.full_messages
    end
  end

  def show # I put the destroy function here because I could not get the link to make a DESTROY request instead of a GET request
    @followee = Followee.find(params[:id])
    @followee.destroy

    redirect_to root_path
  end

  def destroy # Not currently being used because of reason mentioned above
    @followee = Followee.find(params[:id])
    @followee.destroy

    redirect_to root_path
  end

  private

  def followee_params
    params.require(:followee).permit(:username, :realname, :id)
  end
end
