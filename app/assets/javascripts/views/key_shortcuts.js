KeyShortcuts = Backbone.View.extend({
  isControlPressed: false,

  render: function(){
    $(document).keyup(this._released).keydown(this._pressed);
  },

  _released: function(){
    this.isControlPressed = false;
  },

  // http://www.scottklarr.com/topic/126/how-to-create-ctrl-key-shortcuts-in-javascript/
  _pressed: function(e) {
    if (e.which == 17) {
      this.isControlPressed = true;
    }

    // Control + S
    if (e.which == 83 && this.isControlPressed) {
      $('.js-save').click();
      return false;
    }

    // Control + K
    if (e.which == 75 && this.isControlPressed) {
      $('.js-terms').focus();
      return false;
    }
  }
});
