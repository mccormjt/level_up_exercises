class AssignmentsController < ApplicationController
  respond_to :json

  def recieved
    assignments = Assignment.recieved_by(current_user.phone_number)
    render_filtered_task_assignments(assignments.unarchived)
  end

  def sent
    assignments = Assignment.sent_by(current_user.id)
    render_filtered_task_assignments(assignments.unarchived)
  end

  def archived
    assignments = Assignment.related_to(current_user.id, current_user.phone_number)
    render_filtered_task_assignments(assignments.archived)
  end

  def archive
    Assignment.find(params[:id]).archive!
    flash[:success] = 'Successfully Archived Task'
    head :no_content
  end
  
  def statuses
    render json: Status.apply_decorators(assignment.statuses)
  end

  private

  def render_filtered_task_assignments(assignments)
    render json: Assignment.expanded_task_details(assignments)
  end

  def assignment
    @assignment ||= Assignment.find(params[:id])
  end
end
