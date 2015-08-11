ActiveFilter = new function() {
	var self                      = this,
		BAR_STATE_CLASSES         = [ 'inbox-active', 'sent-active', 'archived-active' ],
		ACTIVE_FILTER_TAB_CLASS   = 'active',
		bar                       = $('.active-filter-bar'),
		filters                   = $('.followup-categories .filter').click(changeFilterHandler),
		filteredContent			  = $('.followup-filter-content'),
		lastStateIndex            = -1;

	self.goToState = function(nextStateIndex) {
		var lastStateClass = BAR_STATE_CLASSES[lastStateIndex]
			nextStateClass = BAR_STATE_CLASSES[nextStateIndex];

		bar.removeClass(lastStateClass).addClass(nextStateClass);
		$(filters[lastStateIndex]).removeClass(ACTIVE_FILTER_TAB_CLASS);
		$(filters[nextStateIndex]).addClass(ACTIVE_FILTER_TAB_CLASS);
		filteredContent.removeClass(lastStateClass);
		filteredContent.addClass(nextStateClass);
		lastStateIndex = nextStateIndex;
	};

	function changeFilterHandler(event) {
		var goToIndex = filters.index($(event.currentTarget));
		self.goToState(goToIndex);
	}
};

ActiveFilter.goToState(0);
