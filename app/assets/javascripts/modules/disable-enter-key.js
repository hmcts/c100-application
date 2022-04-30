'use strict';

moj.Modules.disableEnterKey = {
  init: function() {
    var self = this;
    self.bindEvents();
  },

  bindEvents: function() {
    $("form[data-disable-enter] input[type='text']").on('keyup keypress', function(e) {
      var keyCode = e.keyCode || e.which;
      if (keyCode === 13) {
        e.preventDefault();
        return false;
      }
    });
  },
};
