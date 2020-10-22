class TaskMailer < ApplicationMailer
  default from: 'varunkumar0930@gmail.com'

  def notification_email(task)
    @task = task
    mail(to: @task.assignee , subject: 'Notification')
  end
end
