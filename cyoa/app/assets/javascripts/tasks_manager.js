TasksManager = new function() {
	var self                      = this,
		SORT_OPTION_CLASS         = 'sort-option',
		ACTIVE_SORT_OPTION_CLASS  = 'active',
		REFRESH_TASKS_INTERVAL    = 30000;

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
			var fields = { to: 'To', from: 'From', subject: 'Subject', due_date: 'Due', status: 'Status' };
			createTaskFilterRow(fields, true).prependTo(options.sortOptionsContainer);
		}

		function loadTaskJsonIntoFilterView(tasks) {
			var taskRows =  _.reduce(tasks, function(memo, task) {
				return memo.add(createTaskFilterRow(task, false));
			}, $(''));
			options.taskContainer.empty().append(taskRows);
		}

		function createTaskFilterRow(task, isHeaderRow) {
			var cellType  = isHeaderRow ? 'th' : 'td',
				to        = options.fields.to   ? createCell(task.to, 'to')   : '',
			    from      = options.fields.from ? createCell(task.from, 'from') : '',
			    subject   = createCell(task.subject, 'subject'),
			    due       = createCell(task.due_date, 'due'),
			    // status    = createCell(task.status, 'status'),
			    remove    = createCell($('<i />'), 'remove-task ' + options.removeType);

			function createCell(html, clazz) {
				return $('<' + cellType + '/>', { class: 'task-field ' + clazz, html: html });
			}

			return $('<tr />', { class: 'task-row' }).append(to, from, subject, due, status, remove);
		}
	}
};


TasksManager.createFilter('recieved', {
	sortOptionsContainer:  $('.recieved-sort-options'),
	taskContainer:         $('.recieved-tasks'),
	url:                   '/tasks/recieved',
	fields:                { to: false, from: true },
	removeType:            'archive'
});

TasksManager.createFilter('sent', {
	sortOptionsContainer:  $('.sent-sort-options'),
	taskContainer:         $('.sent-tasks'),
	url:                   '/tasks/sent',
	fields:                { to: true, from: false },
	removeType:            'archive'
});

TasksManager.createFilter('archived', {
	sortOptionsContainer:  $('.archived-sort-options'),
	taskContainer:         $('.archived-tasks'),
	url:                   '/tasks/archived',
	fields:                { to: true, from: true },
	removeType:            'delete'
});

TasksManager.refreshAllTaskFilters();
