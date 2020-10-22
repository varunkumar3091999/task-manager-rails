class NotificationJobJob < ApplicationJob
  queue_as :default

  def perform(task)
    TaskMailer.notification_email(task).deliver
  end
end
