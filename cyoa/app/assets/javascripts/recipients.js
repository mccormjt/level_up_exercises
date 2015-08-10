Recipients = $(function() {
	var ADDED_RECIPIENT_CLASS  = 'added-recipient',
		recipients             = $('.recipients'),
		recipientHolder        = $('.recipient-holder'),
		addName                = $('#name', recipients),
		addNumber              = $('#telephone', recipients),
		addBtn                 = $('.btn', recipients);

	addBtn.click(addRecipient);
	recipients.on('focusin focusout', toggleFocusClass);
	recipients.on('click', '.remove', removeRecipient);

	function addRecipient() {
		if (!validateAddRecipientFields()) return;
		recipientHolder.append(buildRecipientDiv());
		clearAddFields();
	}

	function removeRecipient(event) {
		var recipient = $(event.target).parent('.' + ADDED_RECIPIENT_CLASS);
		recipient.fadeOut(200, function() { 
			recipient.remove();
			recipientHolder.trigger('form-group:refresh');
		});
	}

	function buildRecipientDiv() {
		var recipient = '<strong>' + addName.val()   + '</strong>' 
						+ ' <em> &lt;' + addNumber.val() + '&gt; </em>'
						+ ' <i class="fa fa-times remove"></i>';
		return $('<span />', { class: ADDED_RECIPIENT_CLASS }).html(recipient);
	}

	function validateAddRecipientFields() {
		var hasEmptyFields = !(addName.val() && addNumber.val());
		hasEmptyFields && Flash.error('Cannot add recipient without name & number');
		return !hasEmptyFields;
	}

	function clearAddFields() {
		addName.val('');
		addNumber.val('');
	}

	function toggleFocusClass() {
		recipients.toggleClass('focused');
	}
});
