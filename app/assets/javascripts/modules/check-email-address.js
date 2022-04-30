'use strict';

moj.Modules.checkEmail = {
  container: 'app-js--verify-password-form',
  email_element: 'input[name="user[email]"]',
  confirmation_panel_class: 'app-js--email-confirmation-panel',

  init: function() {
    var self = this,
        $emailField = $('.' + self.container).find(self.email_element);

    if($emailField.length) {
      self.$emailField = $emailField;
      self.bindEvents();
    }
  },

  bindEvents: function() {
    var self = this;

    self.$emailField.on('keyup change focus blur', function() {
      self.checkValue();
    });
  },

  checkValue: function() {
    var self = this,
        val = self.$emailField.val(),
        length = val.length;

    if(length) {
      self.showConfirmation(val);
    } else {
      self.hideConfirmation();
    }
  },

  showConfirmation: function(val) {
    var self = this,
        el = $('.' + self.confirmation_panel_class);

    if(!el.length) {
      self.createConfirmationPanel();
    }

    el.removeClass('govuk-!-display-none').find('.govuk-body').text(val);
    self.$emailField.closest('.govuk-form-group').addClass('govuk-!-margin-bottom-0');
  },

  createConfirmationPanel: function() {
    var self = this;

    self.$emailField.closest('.govuk-form-group').after(
        '<div class="' + self.confirmation_panel_class + '">' +
        '<p class="govuk-hint">' + moj.Modules.emailConfirmationText + '</p>' +
        '<p class="govuk-body"></p>' +
        '</div>'
    );
  },

  hideConfirmation: function() {
    var self = this,
        el = $('.' + self.confirmation_panel_class);

    el.addClass('govuk-!-display-none');
    self.$emailField.closest('.govuk-form-group').removeClass('govuk-!-margin-bottom-0');
  }
};
