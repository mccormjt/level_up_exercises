NewTaskForm = new function() {
	var self                          = this,
		CREATE_SUCCESS_CLASS          = 'create-success',
		CREATE_SUCCESS_FINISH_CLASS   = 'create-success',
		newTask                       = $('.new-task-container'),
		newTaskForm                   = $('.new-task-form', newTask),
		animationContainer            = $('.animation-container', newTask);

	$('.followup-categories')
		.on('click', '.new-task-container:not(.opened) .new-task', openNewTaskCreator)
		.on('click', '.new-task-form .cancel-btn', closeNewTaskCreator);

	newTaskForm.submit(preventFormSubmission);

	$('.create-btn', newTaskForm).on('click', createNewTask);

	$('.expander', newTaskForm).on('focusin', expandFormGroup)
							   .on('focusout form-group:refresh', collapseFormGroupIfEmpty);

	$('.date.expander .input-item').datepicker({
	    startDate: 'today',
	    format: 'dd/mm/yyyy'
	});


	self.reset = function() {
		Recipients.clear();
		newTaskForm[0].reset();
		$('.expand', newTaskForm).removeClass('expand');
	};

	self.extractFormData = function() {
		var assignments = _.map(Recipients.getAddedRecipientIds(), function(recipientId) {
			return { recipient_id: recipientId }
		});

		return { task: { 
			assignments_attributes: assignments,
			subject:  $('#subject', newTaskForm).val(),
			due_date: $('#due-date', newTaskForm).val(),
			estimated_completion_hours: $('#estimated-completion-hours', newTaskForm).val(),
			description: $('#description', newTaskForm).val()
		}}
	};


	function preventFormSubmission(event) {
		event.preventDefault();
	}

	function createNewTask() {
		toggleSendingTaskAnimation(true);
		
		$.post('/tasks', self.extractFormData())
		.done(function() {
			closeNewTaskCreator();
			showCreateSuccessCheckmark();
			TaskManager.refreshAllTaskFilters();
		})
		.always(function() {
			toggleSendingTaskAnimation(false);
		});
	}

	function toggleSendingTaskAnimation(isSending) {
		newTaskForm.toggleClass('sending', isSending);
	}

	function showCreateSuccessCheckmark() {
		if (self.isAlreadyShowingCheckmark) return;
		self.isAlreadyShowingCheckmark = true;
		animationContainer.addClass(CREATE_SUCCESS_CLASS);
		setTimeout(finishShowingSuccessCheckmark, 1500);
	}

	function finishShowingSuccessCheckmark() {
		animationContainer.addClass(CREATE_SUCCESS_FINISH_CLASS) 
		setTimeout(function() { 
			animationContainer.removeClass(CREATE_SUCCESS_CLASS + ' ' + CREATE_SUCCESS_FINISH_CLASS);
			self.isAlreadyShowingCheckmark = false;
		}, 900);
	}

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
		$('.new-task-overlay').toggleClass('active', isOpen);
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
