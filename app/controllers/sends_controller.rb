class SendsController < ApplicationController
  def index
    if user_signed_in?
      @followees = current_user.followees

      @data = {users: [], sends: []}
      
      # Replace this with commented section below for live data
      # @data = filler_data

      # TODO: Add threading - will require refactoring code so that we don't multiple tasks trying to write to the database at the same time.
      # Looks some thing like: 
      # threads = []
      # threads << Thread.new {task}
      # threads.each { |thr| thr.join }

      @followees.each do |followee|
        user_info, user_sends = helpers.scrape_sendage_sends(followee, 5)
        user_sends.each do |send|
          area_info = get_area_info(send[:area_id])
          area_name = area_info["name"]
          area_parents = area_info["parents"]
          send[:area_name] = area_name
          send[:area_parents] = area_parents.reverse()
        end
        @data[:users] << user_info
        @data[:sends] += user_sends
      end

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