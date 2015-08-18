class TasksController < ApplicationController
  respond_to :json

  def recieved
    tasks = Task.recieved_by(current_user.phone_number).unarchived
    render_filtered_tasks(tasks)
  end

  def sent
    tasks = Task.sent_by(current_user.id).unarchived
    render_filtered_tasks(tasks)
  end

  def archived
    tasks = Task.related_to(current_user.id, current_user.phone_number).archived
    render_filtered_tasks(tasks)
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

  def archive
    Task.find(params[:id]).archive!
    flash[:success] = 'Successfully Archived Task'
    head :no_content
  end

  private

  def render_filtered_tasks(tasks)
    render json: Task.expand_into_detailed_assignments(tasks)
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
