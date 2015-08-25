TaskManager = new function() {
	var self                      = this,
		SORT_OPTION_CLASS         = 'sort-option',
		ACTIVE_SORT_OPTION_CLASS  = 'active',
		REFRESH_TASKS_INTERVAL    = 30000000,
		archiveControlsTemplate   = $($('#archive-controls-template').html()),
		taskDetailsTemplate       = $($('#task-details-template').html());

	self.filters = {};

	setInterval(self.refreshAllTaskFilters = function() {
		_.each(self.filters, function(filter) { filter.refreshTasks() });
	}, REFRESH_TASKS_INTERVAL);

	self.createFilter = function(filterName, options) {
		var filter = {};
		self.filters[filterName] = filter;
		insertSortOptionsHeader();
		options.sortOptionsContainer.on('click', 'th', applySortOption);

		filter.refreshTasks = function() {
			var params = _.pick(options, 'fields');
			params.sort_by = activeSortOption().data('sort-by');
			$.getJSON(options.url, params).done(loadTaskJsonIntoFilterView);
		}

		function applySortOption(event) {
			activeSortOption.removeClass(ACTIVE_SORT_OPTION_CLASS);
			$(event.currentTarget).addClass(ACTIVE_SORT_OPTION_CLASS);
			refreshTasks();
		}

		function activeSortOption() {
			return $('.' + ACTIVE_SORT_OPTION_CLASS, options.sortOptionsContainer);
		}

		function insertSortOptionsHeader() {
			var fields = { to: 'To', from: 'From', subject: 'Subject', due_date: 'Due', status_state: 'Status' };
			createTaskFilterRow(fields, true).prependTo(options.sortOptionsContainer);
		}

		function loadTaskJsonIntoFilterView(tasks) {
			taskData = $.isEmptyObject(tasks) ? noTasksMessage(filterName) : reduceTasksToRows(tasks);
			options.taskContainer.empty().append(taskData);
		}

		function reduceTasksToRows(tasks) {
			return _.reduce(tasks, function(memo, task) {
				return memo.add(createTaskFilterRow(task, false));
			}, $(''));
		}

		function createTaskFilterRow(task, isHeaderRow) {
			var cellType          = isHeaderRow ? 'th' : 'td',
				headerRowClass    = isHeaderRow ? 'header-row' : ''
				relatedRecipient  = options.fields.to ? task.to : task.from;
				to                = options.fields.to   ? createCell(cellType, task.to, 'to')     : '',
			    from              = options.fields.from ? createCell(cellType, task.from, 'from') : '',
			    subject           = createCell(cellType, task.subject, 'subject'),
			    statusState       = createCell(cellType, task.status_state, 'current-status-state'),
			    due               = createCell(cellType, task.due_date, 'due'),
			    remove            = createRemoveCell(cellType, relatedRecipient, options.removeType),
			    taskDetails       = createTaskDetailsBlock(task.description);

			var row = $('<tr />', { class: 'task-row ' + headerRowClass }).append(to, from, subject, statusState, due, remove);
			var rowContainer = $('<div />', { class: 'task-row-container'}).append(row, taskDetails);
			rowContainer.data('task', task);
			!headerRowClass && StatusUpdater.updateTaskCurrentStatus(rowContainer, task.status_state);
			return rowContainer;
		}
	}

	function createCell(cellType, html, clazz) {
		return $('<' + cellType + '/>', { class: 'task-field ' + clazz, html: html });
	}

	function createRemoveCell(cellType, relatedRecipient, removeType) {
		var removerTemplate = archiveControlsTemplate.clone();
		$('.related-recipient', removerTemplate).text(relatedRecipient);
		return createCell(cellType, removerTemplate, 'remove-task ' + removeType);
	}

	function createTaskDetailsBlock(description) {
		var detailsTemplate = taskDetailsTemplate.clone();
		$('.description p', detailsTemplate).text(description);
		return detailsTemplate;
	}

	function noTasksMessage(type) {
		return '<h2 class="no-tasks-msg"> No ' + type + ' tasks </h2>';
	} 
};


TaskManager.createFilter('recieved', {
	sortOptionsContainer:  $('.recieved-sort-options'),
	taskContainer:         $('.recieved-tasks'),
	url:                   '/assignments/recieved',
	fields:                { to: false, from: true },
	removeType:            'archive'
});

TaskManager.createFilter('sent', {
	sortOptionsContainer:  $('.sent-sort-options'),
	taskContainer:         $('.sent-tasks'),
	url:                   '/assignments/sent',
	fields:                { to: true, from: false },
	removeType:            'archive'
});

TaskManager.createFilter('archived', {
	sortOptionsContainer:  $('.archived-sort-options'),
	taskContainer:         $('.archived-tasks'),
	url:                   '/assignments/archived',
	fields:                { to: true, from: true },
	removeType:            'delete'
});

TaskManager.refreshAllTaskFilters();
