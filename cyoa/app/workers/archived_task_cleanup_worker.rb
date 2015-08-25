class ArchivedTaskCleanupWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Assignments.destroy_stale_archived
  end
end
