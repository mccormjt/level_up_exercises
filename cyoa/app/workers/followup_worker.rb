class FollowupWorker
  include Sidekiq::Worker

  def perform(assignment_id)
    assignment = Assignment.find(assignment_id)
    return if assignment.task.archived? 
    assignment.followup
    assignment.schedule_next_followup
  end
end
