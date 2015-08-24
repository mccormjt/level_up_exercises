$(function() {
	var REMOVING_CLASS = 'removing',
		REMOVE_TOP     = 300;

	$('.prism').on('click', '.archive .remover:not(.' + REMOVING_CLASS + ')', openArchiveConfirmation);
	$('.prism').on('click', '.archive .cancel-btn', closeArchiveConfirmation);
	$('.prism').on('click', '.archive .archive-btn', archiveTask);

	function archiveTask(event) {
		var remover = $(event.currentTarget).closest('.remover'),
			taskRow = remover.closest('tr'),
			assignment_id = taskRow.data('task').assignment_id;


		toggleArchiveConfirmation(remover, false);
		taskRow.addClass('archiving');
		var animation = $.Deferred();
		var archiveRequest = $.ajax({
			type: 'delete',
			url:  '/assignments/archive/' + assignment_id
		});

		setTimeout(function() { animation.resolve() }, 800);
		$.when(animation, archiveRequest).done(function() { TaskManager.refreshAllTaskFilters() });
	}

	function openArchiveConfirmation(event) {
		var remover = $(event.currentTarget);
		toggleArchiveConfirmation(remover, true);
	}

	function closeArchiveConfirmation(event) {
		var remover = $(event.currentTarget).closest('.remover')
		toggleArchiveConfirmation(remover, false);
	}

	function toggleArchiveConfirmation(remover, isOpen) {
		isOpen ? centerElementOnViewportY(remover) : remover.css('top', '');
		remover.toggleClass(REMOVING_CLASS, isOpen);
		remover.closest('.task-container').toggleClass('no-scroll', isOpen);
		$('.overlay', remover.closest('.followup-content')).toggleClass('active', isOpen);
	}

	function centerElementOnViewportY(element) {
		var elmTop     = element.offset().top,
			adjustment = REMOVE_TOP - elmTop;
		element.css('top', adjustment + 'px');
	}
});
