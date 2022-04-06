class NotificationsMailer < ApplicationMailer
  default from: 'notifications@sendstalker.com'

  def daily_update
    @user = params[:user]
    @url  = 'http://sendstalker.com/login'
    mail(to: @user.email, subject: 'Daily update!')
  end
end