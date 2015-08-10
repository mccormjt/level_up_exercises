(function() {
	var newTask = $('.new-task-container');

	$('.followup-categories')
		.on('click', '.new-task-container:not(.opened) .new-task', openNewTaskCreator)
		.on('click', '.new-task-form .cancel-btn', closeNewTaskCreator);

	$('.new-task-form').submit(createNewTask);

	$('.new-task-form .expander').on('focusin', expandFormGroup)
								 .on('focusout form-group:refresh', collapseFormGroupIfEmpty);

	$('.date.expander .input-item').datepicker({
	    startDate: 'today'
	});

	function openNewTaskCreator() {
		toggleNewTask(true);
	}

	function closeNewTaskCreator() {
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
})();
