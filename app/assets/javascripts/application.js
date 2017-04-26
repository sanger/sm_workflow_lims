(function() {
  function getNextPosition(table) {
    var lastNode = $("tr:last", table);
    if (lastNode.length === 0) {
      return 0;
    } else {
      return lastNode.data("position") + 1;
    }
  }

  function hideAlert() {
    $("#alert-shown").remove();
  }

  function showAlert(type, message) {
    hideAlert();
    $("#alerts-box").append($("<div id='alert-shown' class='alert alert-" + type + "'>" + message + "</div>"));
  }

  /**
   * Validator of asset IDs entered for current batch
   */
  var validatorAssetId = {
    reset: function(list) {
      this._list = list;
      return this;
    },
    validate: function(identifier) {
      if ($.inArray(identifier, this._list)<0) {
        this._list.push(identifier);
        return true;
      }
      return false;
    },
    remove: function(identifier) {
      var idx = $.inArray(identifier, this._list);
      if (idx >= 0) {
        this._list.splice(idx,1);
      }
    }
  }.reset([]);

  function addAsset(asset) {
    if (!validatorAssetId.validate(asset.identifier)) {
      return null;
    }
    var fieldTemplate = "<td>#{value}<input type=\"hidden\" value=\"#{value}\" name=\"assets[#{position}][#{name}]\" /></td>";
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
    var removeButton = $("<td class=\"with-button\"><button class=\"btn btn-default\">Remove</button></td>");
    removeButton.on("click", function(event) {
      event.preventDefault();
      $(row).remove();
      validatorAssetId.remove(asset.identifier);
      updateBadgeCount();
    });
    row.data("position", position);
    row.append(removeButton);
    table.append(row);
    updateBadgeCount();
    $(".batch-view").removeClass("hidden");
    return asset;
  }

  function updateBadgeCount() {
    $(".batch-view .badge").html($(".batch-view tbody tr").length);
  }


  function onSuccessfulValidationForm(form) {
    var inputs = $("input", form);
    var assets = [];
    inputs.each(function(pos, input) {
      var tokenizer = $(input).attr("data-psg-tokenizer");
      var processValues;
      // If it is using the token separator in the input
      if ((typeof tokenizer !== "undefined") && (input.value.search(tokenizer)>=0)) {
        processValues = input.value.split(tokenizer);
      } else {
        // In other case, we'll create as many inputs as assets previously generated. At least
        // one in case this is the first asset generated
        processValues = [];
        for (var i=0; i<Math.max(1, assets.length); i++) {
          processValues.push(input.value);
        }
      }
      // Resets the value after reading it
      if ($(input).prop("type")!=="hidden") {
        input.value = "";
      }

      $.each(processValues, function(pos, processValue) {
        var obj = {};
        obj[input.name] = processValue;
        if (typeof assets[pos] === "undefined") {
          assets[pos] = Object.create({});
          if (pos>0) {
            assets[pos] = $.extend(assets[pos], assets[pos-1]);
          }
        }
        assets[pos] = $.extend(assets[pos], obj);
      });

    });
    $.each(assets, function(pos, asset) {
      if (addAsset(asset)===null) {
        showAlert("danger", "The asset identifier must be unique inside the batch");
      } else {
        showAlert("success", "Asset added to the batch");
      }
    });
  }

  function processFormAssetCreation(form) {
    if (ClientSideValidations.validateForm(form, onSuccessfulValidationInput, onErrorValidationInput)) {
      onSuccessfulValidationForm(form)
    } else {
      showAlert("danger", "The entry can't be created as the form contains some errors.");
    }
  }

  function attachAssetsCreationHandlers() {
    $("#creation-templates form").each(function(pos, form) {
      $("input[type!=hidden]:first", form).on("focus", function(event) {
        $("input[type!=hidden]", form).each(function(pos, node) {
          setValidationStatus($(node), true);
        });
      });

      var inputs = $("input[type!=hidden]", form);
      inputs.not(":last").on("keydown", function(event) {
        var input = event.target;
        if (event.which === 13) {
          event.preventDefault();
          inputs[$.inArray(input, inputs)+1].focus();
        }
      });
      inputs.filter(":last").on("keydown", function(event) {
        switch(event.which) {
        case 9:
        case 13:
          $("input[type!=hidden]:first", form).focus();
          processFormAssetCreation(form);
          event.preventDefault();
          break;
        }
      });

      $("button", form).click(function(event) {
        event.preventDefault();
        processFormAssetCreation(form);
      });
    });
  };

  function setValidationStatus(node, isSuccess, errorMessage) {
    node.parent().removeClass("has-success has-error");
    node.parent().addClass((isSuccess) ? "has-success" : "has-error");

    var spanIcon = $("span", node.parent())[0];
    if (typeof spanIcon !== "undefined") {
      spanIcon = $(spanIcon);
    } else {
      spanIcon = $("<span class=\"glyphicon form-control-feedback\"></span>");
      node.parent().append(spanIcon);
    }
    spanIcon.removeClass("glyphicon-ok glyphicon-remove");
    spanIcon.addClass((isSuccess) ? "glyphicon-ok" : "glyphicon-remove");

    hideAlert();
    if ((!isSuccess) && (typeof errorMessage !== 'undefined')) {
      showAlert("danger", errorMessage);
    }
  }

  function onSuccessfulValidationInput(input) {
    setValidationStatus($(input), true);
  }

  function onErrorValidationInput(input, errorMessage) {
    setValidationStatus($(input), false, errorMessage);
  }

  function attachValidations() {
    $("[data-psg-regexp]").each(function(pos, input) {
      var node = $(input);
      node.on("blur", function() {
        ClientSideValidations.validateInput(input, onSuccessfulValidationInput, onErrorValidationInput);
      });
    });
    attachBatchValidation();
    attachBatchSelection();
    attachEditBatch();
    attachSelectAllControls();
    attachComplete();
    attachInputSelectByTr();
  }

  function attachComplete() {
    $("input[type=checkbox]").on("change", function(event) {
      var node = event.currentTarget;
      var value = $(node).prop("checked");
      var row = $(node).closest("tr");
      $("[data-psg-batch-id]", row).each(function(pos, button) {
        row[value ? 'addClass' : 'removeClass']("selected-row");
        if ($(button).data('psg-select-button')===true) {
          $(button)[value ? 'addClass' : 'removeClass']('active');
          $(button).html(value ? "Unselect" : "Select");
        }
      });
    });
  }

  function attachInputSelectByTr() {
    $("td.common-attribute").on("click", function(event) {
      var node = $("[data-psg-select-asset]", $(event.currentTarget).closest("tr"));
      if (node[0] !== event.target) {
        node.click();
      }
    });
  }

  function attachBatchValidation() {
    var form = $("#form-batch");
    $("button[type=submit]", form).click(function(event) {
      if (!ClientSideValidations.validateForm(form, onSuccessfulValidationInput, onErrorValidationInput)) {
        event.preventDefault();
        showAlert("danger", "The batch provided contains some errors.");
      }
    });
    $("button[data-psg-action-type=acceptance-delete]", form).click(function(event) {
      event.preventDefault();
    });
    $("button[data-psg-action-type=delete]", form).click(function(event) {
      // Batch removal functionality
      event.preventDefault();
      $("input[name=_method]", form).val("DELETE");
      form.submit();
    });
  }
  // in_progress inbox
  function attachEditBatch() {
    var batchEditButtons = $("button[data-psg-edit-button]");
    batchEditButtons.each(function(pos, node) {
      var batchId = $(node).attr("data-psg-batch-id");
      $(node).click(function(event) {
        window.location.href="/batches/" + batchId;
      });
    });
  }

  function attachBatchSelection() {
    var batchSelectButtons = $("input[data-psg-select-batch]");
    batchSelectButtons.each(function(pos, node) {
      var batchId = $(node).attr("data-psg-batch-id");
      $(node).click(function(event) {
        var value = $(node).prop("checked");
        $("input[data-psg-batch-id="+batchId+"]", $(node).closest("table")).each(function(pos, selectedNode) {
          $(selectedNode).prop("checked", value).change();
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

  function filterAssetTR(tr, enabled) {
    if (enabled) {
      $(tr).show();
    } else {
      $("input[type=checkbox]", tr).prop("checked", false).change();
      $(tr).hide();
    }
  }

  function attachFilterWorkflow() {
    var filterWorkflow = $("#filter-workflow");
    filterWorkflow.on("change", function() {
      var value = filterWorkflow.val();
      $("tr[data-psg-workflow]").each(function(pos, tr) {
        filterAssetTR(tr, (($(tr).attr("data-psg-workflow")===value) || (value.length===0)));
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
            var isFiltered = (fieldSelected.text().search(filterStudyRegExp)>=0);
            filterAssetTR(tr, isFiltered);
            if (isFiltered) {
              // Highligths matching text on study filtering
              fieldSelected.html(fieldSelected.html().replace(filterStudy.val(), "<b>" + filterStudy.val() + "</b>"));
            }
          });
        }
      });
    });
  }

  function getFragmentId(url) {
    var list = url.split("#");
    if (list.length === 2) {
      return list[1];
    }
    return null;
  }

  function configMenuActiveTab() {
    var menu = $("#sm_workflow_menu");
    $("a", menu).each(function(pos, node) {
      if (typeof $(node).data("toggle") !== 'undefined') {
        /* Do not apply to the dropdown list */
        return;
      }
      var href = $(node).attr('href');
      var url = window.location.href;
      var posFinding = url.indexOf(href);
      if ((posFinding>=0) && (posFinding + href.length === url.length)) {
        /* Just one active */
        //$("li", menu).removeClass("active");
        $(node).closest("li").addClass("active");
      }
    });
  }

  function attachTabHandlers() {
    var tabId = getFragmentId(window.location.href);
    $("[data-toggle=tab]").each(function(pos, node) {
      if (tabId===null) {
        // Disables create assets outside /batches/new
        $(node).removeAttr("data-toggle");
      } else {
        // Select tab from URL using the fragment identifier
        if (getFragmentId($(node).attr("href")) === tabId) {
          $(node).tab("show");
        }
      }
      // Resets the batch every time a new template is selected
      $(node).on("show.bs.tab", function() {
        resetBatch();
      });
      $(node).on("click", function(event) {
        $(node).tab("show");
      });
    });
  }

  function attachBatchCreationHandlers() {
    var workflowControl = $("#workflow_id");
    workflowControl.on("change", function() {
      var disable = workflowControl[0].selectedOptions[0].dataset['workflowHasComment']!=="1"
      $("#comment").prop("disabled", disable);
    });
    workflowControl.change();
  }

  function resetBatch() {
    $("#batch-table").html("");
    $(".batch-view").addClass("hidden");
    validatorAssetId.reset([]);
  }

  function attachSelectAllControls() {
    function buildCheckedAction(enable, divContainer) {
      return function(event) {
        event.preventDefault();
        var node = event.currentTarget;
        var inputs = $("input[type=checkbox]" + (enable ? ":visible" : ""), divContainer);
        inputs.prop("checked", enable).change();
      }
    }
    $(".asset-group-view").each(function(pos, div) {
      var anchors = $("a.selectable", div);
      $(anchors[0]).on("click", buildCheckedAction(true, div));
      $(anchors[1]).on("click", buildCheckedAction(false, div));
    });
  }


  $(document).ready(function() {
    configMenuActiveTab();
    //attachFormMethodsSubmitHandlers();
    attachAssetsCreationHandlers();
    attachBatchCreationHandlers();
    attachValidations();
    attachFilters();
    attachTabHandlers();

    $("#start_date").datepicker({
        orientation: 'top auto'
    });
    $("#end_date").datepicker({
        orientation: 'top auto'
    });
  });

  window.psg = {};
  window.psg.addAsset = addAsset;
})();
