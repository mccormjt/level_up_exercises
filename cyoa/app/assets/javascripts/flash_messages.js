Flash = new function() {
	var self = this;

	self.warning = function(msg) {
		flashMessage(msg, 'alert');
	}

	self.error = function(msg) {
		flashMessage(msg, 'error');
	};

	self.notice = function(msg) {
		flashMessage(msg, 'info');
	}
    
    self.success = function(msg) {
		flashMessage(msg, 'success');
	}

	function flashMessage(msg, type) {
		$.growlyflash(new Growlyflash.FlashStruct(msg, type))
	}
}
