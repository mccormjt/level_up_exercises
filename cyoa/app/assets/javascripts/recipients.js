Recipients = $(function() {
	var ADDED_RECIPIENT_CLASS         = 'added-recipient',
		SUGGESTED_RECIPIENT_CLASS     = 'suggested-recipient',
		FOCUSED_CLASS                 = 'focused',
		recipients                    = $('.recipients'),
		recipientHolder               = $('.recipient-holder'),
		recipientSuggestions          = $('.recipient-suggestions'),
		addName                       = $('#name', recipients),
		addNumber                     = $('#telephone', recipients),
		addBtn                        = $('.btn', recipients);

	addBtn.click(addRecipientToTask);
	recipients.on('focusin mousedown', focusRecipients);
	$(document).on('mousedown', unfocusRecipients);
	recipients.on('click',     '.' + ADDED_RECIPIENT_CLASS     + ' .remove', removeAddedRecipientFromTask);
	recipients.on('mousedown', '.' + SUGGESTED_RECIPIENT_CLASS + ' .remove', deleteRecipientFromUserSuggestions);
	recipients.on('mousedown', '.' + SUGGESTED_RECIPIENT_CLASS, addSuggestedRecipientToTaskDom);
	$(addName).add(addNumber).typeWatch({ callback: fetchRecipientSuggestions, captureLength: 0, wait: 50 });


	function focusRecipients(event) {
		event.stopPropagation();
		recipients.addClass(FOCUSED_CLASS);
	}

	function unfocusRecipients() {
		recipients.removeClass(FOCUSED_CLASS);
		clearAddRecipientFields();
		clearRecipientSuggestions();
	}

	function preventBlurEventInsideRecipientContainer(event) {
		event.stopPropagation();
	}

	function addRecipientToTask() {
		var recipientParams = { recipient: { name: addName.val(), phone_number: addNumber.val() } };
		$.post('/recipients/ensure', recipientParams).done(addRecipientToTaskDom);
		clearRecipientSuggestions();
	}

	function addRecipientToTaskDom(recipient) {
		var addRecipient = buildRecipient(recipient, ADDED_RECIPIENT_CLASS);
		addRecipient.hide().appendTo(recipientHolder).fadeIn(250);
		clearAddRecipientFields();
		setTimeout(function() { addName.focus() }, 0);
	}

	function removeAddedRecipientFromTask(event) {
		var recipient = $(event.target).parent('.' + ADDED_RECIPIENT_CLASS);
		removeRecipientFromDom(recipient);
	}

	function removeRecipientFromDom(recipientNode) {
		recipientNode.fadeOut(250, function() { 
			recipientNode.remove();
			recipientHolder.trigger('form-group:refresh');
		});
		addName.focus();
	}

	function fetchRecipientSuggestions(query) {
		if (!query.length) return clearRecipientSuggestions();
		var url = '/recipients/search?query=' + query;
		$.getJSON(url).done(addRecipientsToSuggestionDom);
	}

	function addRecipientsToSuggestionDom(suggestions) {
		clearRecipientSuggestions();
		var suggestionDom = $('');
		_.each(suggestions, function(recipient) { 
			suggestionDom = suggestionDom.add(buildRecipient(recipient, SUGGESTED_RECIPIENT_CLASS));
		});
		recipientSuggestions.append(suggestionDom);
	}

	function addSuggestedRecipientToTaskDom(event) {
		event.stopPropagation();
		var recipient = $(event.currentTarget);
		addRecipientToTaskDom(recipient.data());
		clearRecipientSuggestions();
	}

	function deleteRecipientFromUserSuggestions(event) {
		event.stopPropagation();
		var recipient   = $(event.target).parent('.' + SUGGESTED_RECIPIENT_CLASS),
			recipientId =  { id: recipient.data('id') };

		removeRecipientFromDom(recipient);
		$.ajax({ url: '/recipients', type: 'DELETE', data: recipientId });
	}

	function clearAddRecipientFields() {
		addName.val('');
		addNumber.val('');
	}

	function clearRecipientSuggestions() {
		recipientSuggestions.html('');
	}

	function buildRecipient(recipient, typeClass) {
		var name   = $('<strong />', { class: 'recipient-name',  text: recipient.name         }),
		    phone  = $('<em />',     { class: 'recipient-phone', text: recipient.phone_number }),
		    remove = $('<i />',      { class: 'fa fa-times remove'}),
		    recipientParts = remove.add(name).add(phone);

		var recipientObj = $('<span />', { class: typeClass }).append(recipientParts);
		recipientObj.data(recipient);
		return recipientObj;
	}
});
