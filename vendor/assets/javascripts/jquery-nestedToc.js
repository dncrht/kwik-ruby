(function($) {

  /*
   jQuery nestedToc Plugin 0.2
   https://github.com/dncrht/nestedToc

   Copyright (c) 2014 Daniel Cruz Horts

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
   */

  function Toconize(settings) {
    this.settings = settings;
  }

  Toconize.prototype = {
    _headingsFound: [],
    _children: {},

    call: function() {
      this._generateUniqueIdsForHeadings();
      this._findAndNestHeadings(6);
      return this._children['root'];
    },

    // Generate a unique ID for every heading
    _generateUniqueIdsForHeadings: function() {
      var headingsFound = [];
      $(this.settings.container).find('h1, h2, h3, h4, h5, h6').each(function() {

        var id = $(this).html().replace(/ /g, '-');

        if (headingsFound.indexOf(id) != -1) { // dupe, let's make it unique by adding a random number
          var rand = parseInt(Math.random() * 100);
          id += '-' + rand;
        }
        headingsFound.push(id);
        $(this).attr('id', id);
      });
    },

    // Find all the elements for a certain level
    _findAndNestHeadings: function(level) {
      if (level == this.settings.ignoreH) {
        return; // we've reached the topmost level
      }

      var type = 'h' + level;
      if ($(this.settings.container).find(type).length != 0) { // are there elements in this level?
        $(this.settings.container).find(type).each(function(_, heading) {

          var siblings = '';

          // find all my siblings
          $(this.settings.container).find(heading).siblings(type).each(function(_, sibling) {
            this._headingsFound.push(this._id(sibling));
            siblings += this._asHtml(sibling);
          }.bind(this));

          siblings += this._asHtml(heading);
          siblings = '<ol>' + siblings + '</ol>'; // we're all together in this

          var parent = (level == this.settings.ignoreH + 1) ? 'root' : $(heading).prevAll('h' + (level - 1)).get(0).id;
          this._children[parent] = siblings; // attach siblings to their parent, up to root level
        }.bind(this));
      }
      this._findAndNestHeadings(level - 1); // dig next level
    },

    // Returns the HTML for a node and its children
    _asHtml: function(element) {
      var id = this._id(element);
      var children = this._children[id] || '';
      return '<li><a href="#' + id + '">' + $(element).html() + '</a>' + children + '</li>';
    },

    // Just a convenience method
    _id: function(element) {
      return $(element).attr('id');
    }
  }

  $.fn.nestedToc = function(options) {
    var settings = $.extend({
      container: 'body',
      ignoreH: 1
    }, options);

    var toconize = new Toconize(settings);

    try {
      var content = toconize.call();
    }
    catch (err) {
      var content = 'Error: non-linear levels';
    }

    this.html(content);

    return this;
  };

}(jQuery));
