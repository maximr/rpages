var contentBlocks = (function(block) { 
  var theBlocks = null;
  var isLightBlock = false;

  function init() {
    _getContentBlocks();

    if(theBlocks.size() > 0) {
      if (!isInitialized()) {
        _initializeBlock();
        _checkBlockType();
        _fixFieldStyles();
        _setUpCssClasses();
        _addElementsToBlocks();
        _getContentBlockHeaderClick();
        _registerInputChanges();
      } else {
        console.log("skiping block, because its already intitialized...");
      }
    }
  }

  function _getContentBlocks() {
    theBlocks = block;
  }

  function _checkBlockType() {
    if(theBlocks.hasClass('light_content_block')) isLightBlock = true;
  }

  function _setUpCssClasses() {
    theBlocks.find('li[data-group="settings"]').addClass('header_object settings_object');
    theBlocks.find('li[data-group="advanced"]').addClass('header_object advanced_object');

    if(!isLightBlock) {
      theBlocks.find('li[data-group="style"]').addClass('header_object style_object');
      theBlocks.find('li[data-group="template"]').addClass('header_object template_object');
    }
  }

  function _addElementsToBlocks() {
    var block = theBlocks;

    _appendHeader(block);
    
    if(!isLightBlock) {
      _appedSection(block, 'template');
      _appedSection(block, 'style');
    }

    _appedSection(block, 'advanced');
    _appedSection(block, 'settings');
  }

  function _fixFieldStyles() {
    theBlocks.find('input[type="file"]').hide().parent().find('label').addClass('file_selector_label').append('<span class="file_selector fa fa-file"></span>');
    theBlocks.find('input[type="text"]').after('<span class="input_type fa fa-pencil-square-o"></span>');
    theBlocks.find('select').after('<span class="input_type fa fa-list-alt"></span>');
    _styleHandle(block);
  }

  function _initializeBlock() {
    theBlocks.addClass('initialized');
  }

  function _appendHeader(block) {
    append_html = '<div class="header header--style">' + 
      '<h3><span class="template_indicator"><strong>[ ' + 
        block.find('li[data-type="title_sub"] input, li[data-type="title_sub"] select').val() + 
      ' ]</strong>&nbsp;</span><span class="title">' + block.find('li[data-type="title"] input, li[data-type="title"] select').val() + '</span></h3>' +
      '<ul>';

    if(!isLightBlock) append_html += '<li class="h_item h_item_template fa fa-file-image-o">';
    if(!isLightBlock) append_html += '<li class="h_item h_item_style fa fa-paint-brush">';

    append_html += '<li class="h_item h_item_advanced fa fa-paperclip">' +
        '<li class="h_item h_item_setting fa fa-pencil-square-o">' +
        '<li class="h_item h_item_size fa fa-window-maximize">' +
        '<li class="h_item h_item_close fa fa-window-close">' +
      '</ul>' +
    '</div>';

    block.prepend(append_html);
  }

  function _appedSection(block, section) {
    block.find('.header').after('<div class="header_block block_' + section + '"><ol></ol></div>');
    var styles = block.find('li.' + section + '_object');
    styles.appendTo(block.find('.block_' + section + ' ol'));
  }

  function _styleHandle(block) {
    block.find('.ui-sortable-handle').wrapInner("<span class='text'></span>").append('<span class="move_indicator fa fa-arrows"></span>')
  }

  function _toggleContentBlockSize(block) {
    the_content_block = block.closest(".slim_content_block");

    if(the_content_block.hasClass("active_block")) {
      the_content_block.find("li:not('.has_many_delete').input:not('.header_object')").slideUp(800);

      setTimeout( function() {
        the_content_block.removeClass("active_block");
        the_content_block.find('.h_item_size').removeClass('fa-window-minimize').addClass('fa-window-maximize');
      }, 500);
    } else {
      the_content_block.find("li:not('.has_many_delete').input:not('.header_object')").slideDown(800);

      setTimeout( function() {
        the_content_block.addClass("active_block");
        the_content_block.find('.h_item_size').removeClass('fa-window-maximize').addClass('fa-window-minimize');
      }, 500);
    }
  }

  function _toggleBlockHeader(block, css_selector) {
    var settings_container = block.closest(".slim_content_block").find(css_selector);

    if(settings_container.hasClass('expanded')) {
      settings_container.removeClass("expanded").find("li.input").slideUp(800);
    } else {
      block.closest(".slim_content_block").find('.header_block').removeClass("expanded").find("li.input").hide();
      settings_container.addClass("expanded").find("li.input").slideDown(800);
    }
  }

  function _toggleRemove(block) {
    var main_block = block.closest(".slim_content_block");
    var remove_checkbox = main_block.find('li.has_many_delete input');

    if(remove_checkbox.prop('checked') == true) {
      remove_checkbox.prop('checked', false);
      main_block.removeClass('danger');
    } else {
      if (confirm('You are about to delete this content block. Do you want to continue?')) { 
        remove_checkbox.prop('checked', true);
        main_block.addClass('danger');
      }
    }
  }

  function _getContentBlockHeaderClick() {
    theBlocks.find(".header .h_item").click(function() {
      var actionItem = $(this);

      if(!isLightBlock) {
        if(actionItem.hasClass('h_item_template')) _toggleBlockHeader(actionItem, '.block_template');
        if(actionItem.hasClass('h_item_style')) _toggleBlockHeader(actionItem, '.block_style');
      }

      if(actionItem.hasClass('h_item_advanced')) _toggleBlockHeader(actionItem, '.block_advanced');
      if(actionItem.hasClass('h_item_setting')) _toggleBlockHeader(actionItem, '.block_settings');
      if(actionItem.hasClass('h_item_size')) _toggleContentBlockSize(actionItem);
      if(actionItem.hasClass('h_item_close')) _toggleRemove(actionItem);
    });
  }

  function _registerInputChanges() {
    theBlocks.find("input, select").on('change', function() {
      var item = $(this);

      if(_itemIs('title', item)) _updateHeader(item, item.val(), 'title');
      if(_itemIs('title_sub', item)) _updateHeader(item, item.val(), 'template');
    });
  }

  function _isSetting(item) {
    return item.parent().data('group') == 'settings' ? true : false;
  }

  function _isTemplate(item) {
    return item.parent().data('group') == 'template' ? true : false;
  }

  function _itemIs(name, item) {
    return item.parent().data('type') == name ? true : false;
  }

  function _updateHeader(item, content, type) {
    if(type == 'title') {
      item.closest(".slim_content_block").find('.header h3 .title').html(content);
    } else {
      item.closest(".slim_content_block").find('.header h3 .template_indicator').html('<strong>[ ' + content + ' ]</strong>');
    }
  }

  function isInitialized() {
    return theBlocks.hasClass('initialized') ? true : false;
  }

  return {
    init: init()
  }
});