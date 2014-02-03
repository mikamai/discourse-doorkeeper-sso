// puts your custom javascripts here. See the example code for inspiration ;-)

(function() {
  Discourse.LoginView.reopen({
    didInsertElement: function() {
      this._super();
      $('#discourse-modal .modal-body').hide();
      $('#discourse-modal .btn.doorkeeper').trigger('click');
    }
  });

  Discourse.CreateAccountView.reopen({
    didInsertElement: function() {
      this._super();
      $('#discourse-modal .modal-body').hide();
      $('#discourse-modal .modal-footer').hide();
    }
  });

  Discourse.CreateAccountController.reopen({
    autoCreateAccount: function() {
      if (!this.get("submitDisabled")) {
        this.send("createAccount")
      }
    }.observes('submitDisabled')
  })

  Discourse.LoginController.reopen({
    authenticateChanged: function() {
      if (this.get('authenticate') === null && this.get('autoClosing')) {
        this.send("closeModal");
      }
    }.observes('authenticate')
  });

  Discourse.ApplicationRoute.reopen({
    actions: {
      showLogin: function() {
        this.controllerFor('login').set('autoClosing', true);
        this._super();
      },
      showCreateAccount: function() {
        this.controllerFor('login').set('autoClosing', false);
        this._super();
      }
    }
  })
}).call(this);