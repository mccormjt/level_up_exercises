$.fn.ajaxifyForm = function(callbacks) { 
    $(this).submit(function(e) {
        e.preventDefault();
        var form = $(this);

        $.ajax({
            type:      form.attr('method'),
            url:       form.attr('action'),
            dataType:  'JSON',
            data:      form.serialize(),
            success:   callbacks.success,
            error:     callbacks.fail
        });
    });
};
