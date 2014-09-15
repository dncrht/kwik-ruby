//capture common keyboard shortcuts
//http://www.scottklarr.com/topic/126/how-to-create-ctrl-key-shortcuts-in-javascript/
var isCtrl = false;
$(document).keyup(function() {
    isCtrl = false;
}).keydown(function(e) {
    if (e.which == 17) {
        isCtrl = true;
    }
    if (e.which == 83 && isCtrl) { //Control+S
        $('button[name=save]').click();
        return false;
    }
    if (e.which == 75 && isCtrl) { //Control+K
        $('input[name=terms]').focus();
        return false;
    }
});

$('#jumpers').nestedToc({container: '.span9', ignoreH: 1});

if ($('#jumpers').html() == '') {
  $('#jumpers').remove();
}

$('#panel').css('position', 'fixed');
if ($('#jumpers').is('ul')) {
    $('#jumpers').css('overflow-y', 'auto');
    $('#jumpers').height($(window).height() - $('#jumpers').position().top - 106);
}
