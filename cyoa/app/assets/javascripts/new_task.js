(function() {
	var newTaskBtn = $('.new-task');
	$('.followup-categories')
		.on('click', '.new-task:not(.opened) button', openNewTaskCreator)
		.on('click', '.new-task.opened button', closeNewTaskCreator);

	function openNewTaskCreator() {
		swapNewTaskBtnStateClasses('closed', 'opened');
	}

	function closeNewTaskCreator() {
		swapNewTaskBtnStateClasses('opened', 'closed');
	}

	function swapNewTaskBtnStateClasses(fromClass, toClass) {
		newTaskBtn.removeClass(fromClass);
		newTaskBtn[0].offsetWidth = newTaskBtn[0].offsetWidth // trigger reflow = hack to allow reverse animation
		newTaskBtn.addClass(toClass);
	}
})();