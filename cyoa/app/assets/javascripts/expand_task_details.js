$(function() {
	var EXPANDED_TASK_CLASS = 'expanded';

	$('.task-container').on('click', '.task-row', toggleExpandedTaskDetails);

	function toggleExpandedTaskDetails() {
		var taskContainer = $(event.target).closest('.task-row-container'),
			isExpanding = !taskContainer.hasClass(EXPANDED_TASK_CLASS);

		taskContainer.toggleClass(EXPANDED_TASK_CLASS);
		isExpanding && StatusUpdater.updateAllTaskStatuses(taskContainer);
	}
});