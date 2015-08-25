StatusUpdater = new function() {
	var self = this,
		statusUpdateTemplate = $($('#status-update-template').html());

	self.updateTaskCurrentStatus = function(taskContainer, state) {
		var statusUpdate = createStatusUpdate(state);
		$('.current-status-state', taskContainer).html(statusUpdate);
	};

	self.updateAllTaskStatuses = function(taskContainer) {
		fetchTaskStatuses(taskContainer).done(function(statuses) {
			currentStatus = statuses[0];
			currentStatus && self.updateTaskCurrentStatus(taskContainer, currentStatus.state);
			var statusUpdates = statusUpdatesToHtml(statuses);
			$('.updates-container', taskContainer).html(statusUpdates);
		});
	};

	function fetchTaskStatuses(taskContainer) {
		var assignmentId = taskContainer.data('task').assignment_id;
		var url = '/assignments/' + assignmentId + '/statuses';
		return $.getJSON(url);
	}

	function createStatusUpdate(state, msg, date) {
		var statusTemplate = statusUpdateTemplate.clone();
		statusTemplate.addClass(state.toLowerCase());
		date && $('.status-created-at', statusTemplate).text(' @' + date);
		msg  && $('.status-message',    statusTemplate).text(msg);
		return statusTemplate;
	}

	function statusUpdatesToHtml(statuses) {
		if (!statuses.length) return noStatusesMsg();
		return _.reduce(statuses, function(memo, status) {
			var statusUpdate = createStatusUpdate(status.state, status.message, status.created_at);
			return memo.add(statusUpdate);
		}, $(''));
	}

	function noStatusesMsg() {
		return $('<p />', { class: 'no-status-updates' , text: 'No status updates yet' });
	}
};