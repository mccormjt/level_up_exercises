NewTaskForm = new function() {
	var self         = this,
		newTask      = $('.new-task-container'),
		newTaskForm  = $('.new-task-form');

	$('.followup-categories')
		.on('click', '.new-task-container:not(.opened) .new-task', openNewTaskCreator)
		.on('click', '.new-task-form .cancel-btn', closeNewTaskCreator);

	newTask.submit(createNewTask);

	$('.expander', newTaskForm).on('focusin', expandFormGroup)
								 .on('focusout form-group:refresh', collapseFormGroupIfEmpty);

	$('.date.expander .input-item').datepicker({
	    startDate: 'today'
	});

	self.reset = function() {
		Recipients.clear();
		newTaskForm[0].reset();
		$('.expand', newTaskForm).removeClass('expand');
	};

	self.extractFormData = function() {
		return { 
			recipient_ids: Recipients.getAddedRecipientIds(),
			subject:  $('#subject', newTaskForm).val(),
			due_date: $('#due-date', newTaskForm).val(),
			estimated_completion_hours: $('#estimated-completion-hours', newTaskForm).val(),
			description: $('#description', newTaskForm).val()
		}
	};

	function openNewTaskCreator() {
		toggleNewTask(true);
	}

	function closeNewTaskCreator() {
		self.reset();
		toggleNewTask(false);
	}

	function toggleNewTask(isOpen) {
		fromClass = isOpen ? 'closed' : 'opened';
		toClass   = isOpen ? 'opened' : 'closed';
		newTask.removeClass(fromClass);
		newTask[0].offsetWidth = newTask[0].offsetWidth // trigger reflow --> hack to allow reverse animation
		newTask.addClass(toClass);
	}

	function createNewTask(event) {
		event.preventDefault();
		$.post('/tasks', self.extractFormData()).done(closeNewTaskCreator);
	}

	function expandFormGroup(event) {
		toggleExpandableFormGroup(event, true);
	}

	function collapseFormGroupIfEmpty(event) {
		var inputItem  = $('.input-item', event.currentTarget)[0],
			isExpanded = getInputItemVal(inputItem) != '';
		toggleExpandableFormGroup(event, isExpanded);
	}

	function toggleExpandableFormGroup(event, isExpanded) {
		$(event.currentTarget).toggleClass('expand', isExpanded);
	}

	function getInputItemVal(item) {
		var valProperty = item.value === undefined ? 'innerHTML' : 'value';
    	return item[valProperty];
	}
};
