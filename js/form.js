// Generated by CoffeeScript 1.7.1
(function() {
  module.exports = function(c) {
    return c.set('forms', c.share(function(c) {
      var forms;
      forms = {};
      forms.createRegistrationForm = function() {
        return c.form.create('registration').add('username', 'text', {
          validators: [c.form.validation.Required(), c.form.validation.Length(5, 100)],
          attributes: {
            "class": 'form-control',
            required: true
          }
        }).add('email', 'email', {
          validators: [c.form.validation.Required(), c.form.validation.Length(6, 100), c.form.validation.Email()],
          attributes: {
            "class": 'form-control'
          }
        }).add('password', 'repeated', {
          validators: [c.form.validation.Required(), c.form.validation.Length(5, 50)],
          attributes: {
            type: 'password',
            "class": 'form-control'
          }
        });
      };
      forms.createSignInForm = function() {
        return c.form.create('signin').add('email', 'email', {
          attributes: {
            required: true,
            "class": 'form-control'
          },
          validators: [c.form.validation.Required()]
        }).add('password', 'password', {
          attributes: {
            required: true,
            "class": 'form-control'
          },
          validators: [c.form.validation.Required()]
        });
      };
      forms.createSnippetForm = function(categories) {
        return c.form.create('snippet').add('title', 'text', {
          validators: [c.form.validation.Required()],
          attributes: {
            "class": 'form-control'
          }
        }).add('description', 'textarea', {
          validators: [c.form.validation.Required()],
          attributes: {
            maxlength: 255,
            rows: 3,
            "class": 'form-control'
          }
        }).add('category_id', 'select', {
          label: 'Language',
          choices: categories.map(function(cat) {
            return {
              key: cat.title,
              value: cat.id
            };
          }),
          validators: [c.form.validation.Required()],
          attributes: {
            "class": 'form-control'
          }
        }).add('content', 'textarea', {
          validators: [c.form.validation.Required()],
          attributes: {
            spellcheck: false,
            rows: 25,
            "class": 'form-control'
          }
        });
      };
      return forms;
    }));
  };

}).call(this);
