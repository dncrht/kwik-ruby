TableOfContents = Backbone.View.extend({
  render: function(){
    $('#jumpers').nestedToc({container: '.span9', ignoreH: 1});

    if ($('#jumpers').html() == '') {
      $('#jumpers').remove();
    }

    $('#panel').css('position', 'fixed');
    if ($('#jumpers').length == 1) {
      $('#jumpers').css('overflow-y', 'auto');

      $(window).resize(this._resizeToc);

      this._resizeToc();
    }
  },

  _resizeToc: function(){
    $('#jumpers').height($(window).height() - $('#jumpers').position().top - 106);
  }
});
