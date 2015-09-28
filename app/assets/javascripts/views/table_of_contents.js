TableOfContents = Backbone.View.extend({
  render: function(){
    $('.js-toc').nestedToc({container: '.js-maincontent'});

    if ($('.js-toc').html() == '') {
      $('.js-toc').remove();
    }

    $('.js-sidepanel').css('position', 'fixed');
    if ($('.js-toc').length == 1) {
      $('.js-toc').css('overflow-y', 'auto');

      $(window).resize(this._resizeToc);

      this._resizeToc();
    }
  },

  _resizeToc: function(){
    $('.js-toc').height($(window).height() - $('.js-toc').position().top - 106);
  }
});
