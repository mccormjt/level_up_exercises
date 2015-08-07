(function() {
	var BTN_SELECTOR      = '.button-container'
		ACTIVE_CLASS      = 'active',
		HIDDEN_BTN_CLASS  = 'inactive',
		closeButton       = $('.close-container');

	$(document).on('click', '.home ' + BTN_SELECTOR, openButton)
			   .on('click', '.home .close-container.' + ACTIVE_CLASS, closeAllButtons);

	$('.signup-form').ajaxifyForm({ success: goToDashboard });
	$('.login-form').ajaxifyForm({ success: goToDashboard, fail: flashInvalidLoginMsg });


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

	function goToDashboard(d) {
		window.location = '/dashboard';
	}

	function flashInvalidLoginMsg() {
		Flash.error('Invalid phone number or password');
	}
})();
