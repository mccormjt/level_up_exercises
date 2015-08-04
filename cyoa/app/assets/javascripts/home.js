(function() {
	var BTN_SELECTOR      = '.button-container'
		ACTIVE_CLASS      = 'active',
		HIDDEN_BTN_CLASS  = 'inactive',
		closeButton       = $('.close-container');

	$(document).on('click', '.home ' + BTN_SELECTOR, openButton)
			   .on('click', '.home .close-container.' + ACTIVE_CLASS, closeAllButtons);


	function openButton(event) {
		var openButton  = $(event.currentTarget),
			hideButton = openButton.siblings(BTN_SELECTOR);

		openButton.addClass(ACTIVE_CLASS);
		hideButton.addClass(HIDDEN_BTN_CLASS);
		closeButton.addClass(ACTIVE_CLASS);
	}

	function closeAllButtons() {
		$(BTN_SELECTOR).removeClass(ACTIVE_CLASS + ' ' + HIDDEN_BTN_CLASS);
		closeButton.removeClass(ACTIVE_CLASS);
	}
})();
