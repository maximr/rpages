var dynamicSelect2 = (function(selectEnabler) { 
  var defaultSelect = null;
  var selectField = null;
  var enablerField = null;
  var uniqID = null;
  var selectAllField = null;
  var selectionData = null;
  var selectorIds = [];
  var isMultiSelect = false;

  function init() {
    _setDefaults();

    _selectionLogic(enablerField);

    enablerField.on('change', function(e) {
      _selectionLogic($(this));
    });

    if(isMultiSelect) {
      defaultSelect.on("select2:close", function (e) {
        _selectAllFunctions();
      });
    }
  }

  function _setDefaults() {
    selectField   = selectEnabler.siblings('.select2_ajax');
    defaultSelect = selectField.find('select');
    enablerField  = selectEnabler.find('select');
    uniqID        = uniqId();
    if(defaultSelect.attr('multiple') && defaultSelect.attr('multiple').length) isMultiSelect = true;
  }

  function _initSelect() {
    defaultSelect.attr('id', uniqID);

    if(isMultiSelect) {
      _selectAllFunctions();
    }
  }

  function _selectAllFunctions() {
    defaultSelect.parent().find('.select2-selection__rendered').prepend('<span class="select2-selection__select-all">[a]</span>');

    selectAllField = defaultSelect.parent().find('.select2-selection__rendered .select2-selection__select-all');
    selectAllField.on('click', function(e) {
      defaultSelect.val(selectorIds).trigger("change");
      setTimeout(function() {
        defaultSelect.select2('close');
      }, 100);
      return true;
    });
  }

  function _isDisabled() {
    defaultSelect.attr('disabled') == 'disabled' ? true : false;
  }

  function _unblockSelect() {
    defaultSelect.removeAttr('disabled');
  }

  function _blockSelect() {
    defaultSelect.attr('disabled', 'disabled');
  }

  function _AppendSelectorOptions(selectionData) {
    selectorIds = [];

    for (var i = selectionData.length - 1; i >= 0; i--) {
      selectorIds.push(selectionData[i].id);

      if (!(defaultSelect.find("option[value=" + selectionData[i].id + "]").length)) {
        var newSelection = new Option(selectionData[i].text, selectionData[i].id, false, false);
        defaultSelect.append(newSelection).trigger('change');
      } 
    }

    _initSelect();  
  }

  function _selectionLogic(item) {
    if(item.val() != 'none') {
      _unblockSelect();
      _setUpSelect2(item.val());
    } else {
      _blockSelect();
      //defaultSelect.select2('destroy');
    }
  }

  function _setUpSelect2(value) {
    defaultSelect.select2({
      allowClear: true,
      tags: true,
      placeholder: "Select objects",
      ajax: {
        url: '/association/' + value,
        processResults: function (data) {
          selectionData = data.selection;

          return {
            results: data.selection
          };
        }
      }
    });

    defaultSelect.select2('open');
    defaultSelect.select2('close');

    setTimeout(function() {
      _AppendSelectorOptions(selectionData);
    }, 100);
  }

  return {
    init: init()
  };
});