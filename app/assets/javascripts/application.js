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
  
  var validateAssetId = function(addedAssetIdsList) { 
    return function(identifier) { 
      if ($.inArray(identifier, addedAssetIdsList)<0) {
        addedAssetIdsList.push(identifier);
        return true;
      }
      return false;
    } 
  }([]);
  
  function addAsset(asset) {
    if (!validateAssetId(asset.identifier)) {
      return null;
    }
    var fieldTemplate = "<td>#{value}</td><input type=\"hidden\" value=\"#{value}\" name=\"assets[#{position}][#{name}]\" />";
    var fields = ["type", "identifier", "sample_count", "created"];
    var row = $("<tr></tr>");
    var table = $("#batch-table");
    $("input[name=asset_type_id]", table.parent().parent()).val(asset["asset_type_id"]);
    var position = getNextPosition(table);
    fields.forEach(function(name) {
      var fieldTdString = new String(fieldTemplate);
      if (typeof asset[name] === "undefined") {
        fieldTdString = "<td>-</td>";
      } else {
        fieldTdString = fieldTdString.replace(/#{name}/g, name);
        fieldTdString = fieldTdString.replace(/#{value}/g, asset[name]);
        fieldTdString = fieldTdString.replace(/#{position}/g, position);
      }
      row.append($(fieldTdString));
    });
    var removeButton = $("<td><button class=\"btn btn-default\">Remove</button></td>");
    removeButton.on("click", function(event) {
      event.preventDefault();
      $(row).remove();
    });
    row.append(removeButton);
    table.append(row);
    $(".batch-view").removeClass("hidden");
    return asset;
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
  
  function attachFilters() {
    attachFilterStudy();
    attachFilterWorkflow();
  }
  
  function attachFilterWorkflow() {
    var filterWorkflow = $("#filter-workflow");
    filterWorkflow.on("change", function() {
      var value = filterWorkflow.val();
      $("tr[data-psg-workflow]").each(function(pos, tr) {
        if (($(tr).attr("data-psg-workflow")===value) || (value.length===0)) {
          $(tr).show();
        } else {
          $(tr).hide();
        }
      });
    });    
  }
  
  function attachFilterStudy() {
    var filterStudy = $("#filter-study");
    filterStudy.on("keydown", function(event) {
      if(event.keyCode == 13) {
        event.preventDefault();
        return false;
      }      
    });
    filterStudy.on("keyup", function(event) {
      var filterStudyRegExp = new RegExp(filterStudy.val());
      $("table.filter-table").each(function(pos, table) {
        var studyPos = -1;
        $("th", table).each(function(pos, th) {
          if ($(th).text().toLowerCase() === "study") {
            studyPos = pos;
          }
        });
        if (studyPos > 0) {
          $("tbody tr", table).each(function(pos, tr) {
            var fieldSelected = $($("td", tr)[studyPos]);
            fieldSelected.html(fieldSelected.html().replace("<b>", "").replace("</b>", ""));              
            if (fieldSelected.text().search(filterStudyRegExp)>=0) {
              fieldSelected.html(fieldSelected.html().replace(filterStudy.val(), "<b>" + filterStudy.val() + "</b>"));
              $(tr).show();
            } else {
              $(tr).hide();
            }
          });
        }
      });
    });
  }
  
  $(document).ready(function() {
    //attachFormMethodsSubmitHandlers();
    attachAssetsCreationHandlers();
    attachValidations();
    attachFilters();
  });

  window.psg = {};
  window.psg.addAsset = addAsset;
})();