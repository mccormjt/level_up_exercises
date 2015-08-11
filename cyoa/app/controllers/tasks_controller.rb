class TasksController < ApplicationController
  respond_to :json

  validates_presence_of :subject, :due_date, :estimated_completion_hours, :description

  def create

  end

  private

  def task_params
    params.require(:task).permit(
      :recipient_ids
      :subject,
      :due_date,
      :estimated_completion_hours,
      :description,
    )
  end
end