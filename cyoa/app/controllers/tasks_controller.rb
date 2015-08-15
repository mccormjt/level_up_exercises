class TasksController < ApplicationController
  respond_to :json

  def recieved
    render_filtered_tasks(:recieved_by, current_user.phone_number)
  end

  def sent
    render_filtered_tasks(:sent_by)
  end

  def archived
    render_filtered_tasks(:archived_by)
  end

  def create
    task = Task.new(task_params_for_nested_assignments)
    if task.save
      render json: task
    else
      errors = task.errors.full_messages
      flash[:error] = errors.first;
      render(json: errors, status: :unprocessable_entity)
    end
  end

  private

  def render_filtered_tasks(filter, filter_arg=nil)
    filter_arg ||= current_user.id
    @tasks = Task.public_send(filter, filter_arg)
    render json: @tasks.expand_into_detailed_assignments
  end

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
