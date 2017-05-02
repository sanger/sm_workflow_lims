(function() {

  /* Validation methods */
  function validateForm(form, onSuccessAction, onErrorAction) {
    var inputs = $("[data-psg-regexp]", form);
    return all(inputs, function(input) {
      return validateInput(input, onSuccessAction, onErrorAction);
    });
  }

  function validateInput(input, onSuccessAction, onErrorAction) {
    function validateRegexp(regexp, str) {
      var regexp = new RegExp(regexp);
      return str.search(regexp)>=0;
    }

    var node = $(input);
    var partialedValidation = partial(validateRegexp, node.data("psg-regexp"));

    var validated;
    var tokenizer = node.data("psg-tokenizer");
    if (typeof tokenizer !== "undefined") {
      validated = all(node.val().split(tokenizer), partialedValidation);
    } else {
      validated = partialedValidation(node.val());
    }
    /* Optional inputs are valid even when they are empty, which means the haven't been specified */
    if (node.val().length===0) {
      if (node.data("psg-input-optional")===true) {
        validated = true;
      }
    }
    (validated? onSuccessAction : onErrorAction).call(this, input, getErrorMessage(input));
    return validated;
  }

  function getErrorMessage(node) {
    return $(node).data('psg-validation-error-msg');
  }


  /* Helper functions */
  function partial() {
    var _function = arguments[0];
    var _arguments = Array.prototype.slice.call(arguments, 1);
    var _ctx = this;
    return function() {
      return _function.apply(_ctx, _arguments.concat(Array.prototype.slice.call(arguments, 0)));
    };
  }

  function all(list, checkMethod) {
    var validations = $.map(list, checkMethod);
    var i=0;
    var value = true;
    while (i<validations.length && value) {
      value = value && validations[i];
      i += 1;
    }
    return value;
  }

  /* */

  var INSTANCE =  {
    validateForm: validateForm,
    validateInput: validateInput
  };

  window.ClientSideValidations = INSTANCE;

  return INSTANCE;
})();
