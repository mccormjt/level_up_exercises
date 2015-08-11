class TasksController < ApplicationController
  respond_to :json

  def create
    task = Task.new(task_params_for_nested_assignments)
    puts "!!!!! ---- " + task_params_for_nested_assignments.inspect
    if task.save
      render json: task
    else
      errors = task.errors.full_messages
      flash[:error] = errors.first;
      render(json: errors, status: :unprocessable_entity)
    end
  end

  private

  def task_params
    params.require(:task).permit(
      :subject,
      :due_date,
      :estimated_completion_hours,
      :description,
      :assignments_attributes => [:recipient_id],
    )
  end

  def task_params_for_nested_assignments
    task_params.merge({ user_id: current_user.id })
  end
end
