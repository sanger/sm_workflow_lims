(function() {
  function getNextPosition(table) {
    var max = -1;
    $("input", table).each(function(pos, input) {
      var str = new String(input.name);
      str = str.replace(/assets/, ""); // Removes asset string
      str = str.substring(1);  // Remove first char
      var value = parseInt(str.split("]")[0], 10); // Gets value
      max = Math.max(max, value);
    });
    return (max+1).toString();
  }
  
  function addAsset(asset) {
    var fieldTemplate = "<td>#{value}</td><input type=\"hidden\" value=\"#{value}\" name=\"assets[#{position}][#{name}]\" />";
    var fields = ["type", "identifier", "sample_count", "created", "updated", "completed"];
    var row = $("<tr></tr>");
    var table = $("#batch-table");
    var position = getNextPosition(table);
    fields.forEach(function(name) {
      var fieldTdString = new String(fieldTemplate);
      if (typeof asset[name] === "undefined") {
        fieldTdString = "<td></td>";
      } else {
        fieldTdString = fieldTdString.replace(/#{name}/g, name);
        fieldTdString = fieldTdString.replace(/#{value}/g, asset[name]);
        fieldTdString = fieldTdString.replace(/#{position}/g, position);
      }
      row.append($(fieldTdString));
    });
    table.append(row);
    $(".batch-view").removeClass("hidden");
  }

  function attachAssetsCreationHandlers() {
    $("#creation-templates form").each(function(pos, form) {
      
      $("button", form).click(function(event) {  
        event.preventDefault();
        var inputs = $("input", form);
        if (validateForm(form)) {
          var asset = {};
          inputs.each(function(pos, input) {
            var obj = {};
            obj[input.name] = input.value;
            asset = $.extend(asset, obj);
          });
          addAsset(asset);
        } else {
          
        }
      });
    });    
  };
  
  function validateForm(form) {
    var inputs = $("[data-psg-regexp]", form);
    var validations = $.map(inputs, validateInput);
    var i=0;
    var value = true;
    while (i<validations.length && value) {
      value = value && validations[i];
      i += 1;
    }
    return value;
  }
  
  function validateInput(input) {
    
    function validateRegexp(input) {
      var regexp = new RegExp(input.attr("data-psg-regexp"))
      return input.val().search(regexp)>=0;
    }
    
    var node = $(input);
    var validated = validateRegexp(node);
    node.parent().removeClass("has-success").removeClass("has-error");
    node.parent().addClass((validated) ? "has-success" : "has-error");
    
    var spanIcon = $("span", node.parent())[0];
    if (typeof spanIcon !== "undefined") {
      spanIcon = $(spanIcon);
    } else {
      spanIcon = $("<span class=\"glyphicon form-control-feedback\"></span>");
      node.parent().append(spanIcon);          
    }
    spanIcon.removeClass("glyphicon-ok").removeClass("glyphicon-remove");
    spanIcon.addClass((validated) ? "glyphicon-ok" : "glyphicon-remove");
    return validated;
  }
  
  
  function attachValidations() {
    $("[data-psg-regexp]").each(function(pos, input) {
      var node = $(input);      
      node.on("blur", function() {
        validateInput(input);
      });
    });
    attachBatchValidation();
    attachBatchSelection();
    attachComplete();
  }
  
  function attachComplete() {
    $("input[type=checkbox]").on("change", function(event) {
      var node = event.currentTarget;
      var value = $(node).prop("checked");
      var row = $(node).parent().parent().parent();
      $("[data-psg-batch-id]", row).each(function(pos, button) {
        row[value ? 'addClass' : 'removeClass']("success");
        $(button).html(value ? "Unselect batch" : "Select batch");
      });
    });
    
  }
  
  function attachBatchValidation() {
    var form = $("#form-batch");
    $("button[type=submit]", form).click(function(event) {
      if (!validateForm(form)) {
        event.preventDefault();
      }
    });
  }
  // in_progress inbox
  function attachBatchSelection() {
    function checkboxForNode(node) {
      return $("input[type=checkbox]", $(node).parent().parent());
    }
    
    var batchSelectButtons = $("[data-psg-batch-id]");
    batchSelectButtons.each(function(pos, node) {
      var batchId = $(node).attr("data-psg-batch-id");
      $(node).click(function(event) {
        var value = !checkboxForNode(node).prop("checked");        
        $(batchSelectButtons.filter(function(pos, evaluatedNode) {
          return ($(evaluatedNode).attr("data-psg-batch-id") === batchId);
        })).each(function(pos, selectedNode) {
          checkboxForNode(selectedNode).prop("checked", value).change();
        });
      });
    });
  }
  
  function attachFormMethodsSubmitHandlers() {
    var forms = $("form[data-psg-form-method]");
    forms.each(function(pos, form) {
      form = $(form);
      //$("[type=submit]", form)
      form.on("submit", function(event) {
        event.preventDefault();
        $.ajax(form.attr("action"), {
          type: form.attr("data-psg-form-method"),
          data: form.serialize(), 
          success: function() {
            
          },
          error: function() {
            
          }
        });
      });
    });
  }
  
  $(document).ready(function() {
    attachFormMethodsSubmitHandlers();
    attachAssetsCreationHandlers();
    attachValidations();
  });

  window.psg = {};
  window.psg.addAsset = addAsset;
})();