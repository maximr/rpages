/**
 * ClickExpand
 *
 * @description ---
 * @author      Maxim Roubinthik http://roubintchik.com
 * @version     0.0.1-alpha
 * @date        2016-10-12
 */

function getObjectLength( obj )
{
  var length = 0;
  for ( var p in obj )
  {
    if ( obj.hasOwnProperty( p ) )
    {
      length++;
    }
  }
  return length;
}

var clickExpand = (function(the_container, undefined) {
  var the_url = null;
  var the_template = null;
  var the_items = null;
  var data_items = null;
  var isReveal = false;

  function init() {
    if(!the_container.hasClass("click-expand-container")) return false;

    _setSettingVariables();
    _setItems();
  }

  function _setSettingVariables() {
    settings = the_container.data("reveal-settings");

    if(the_container.data("expand-url")) the_url = the_container.data("expand-url");
    if(the_container.data("expand-template")) the_template = the_container.data("expand-template");
    if(the_container.hasClass("reveal_container")) isReveal = true;
  }

  function _setItems() {
    data_items = the_container.find(".click-expand-data-item");
    the_items = the_container.find(".click-expand-item");

    data_items.on("click", function() {
      var item = $(this);

      if(item.hasClass('non-clickable') || the_container.hasClass('reveal-switching')) {
        return true;
      }

      _getData(this);
    });
  }

  function _getData(selector) {
    var data = _getAjax(selector);
    return data;
  }

  function _getAjax(selector) {
    var item = $(selector);
    var u = _buildUrl(item.data("expand-id"));

    $.ajax({
      url: u,
      type: 'GET'
    }).done(function( data ) {
      _expandData(item, data.content);
    });
  }

  function _expandData(item, content) {
    var expand_item = item.hasClass("click-expand-item") ? item : item.closest('.click-expand-item')

    item.addClass("non-clickable");
    _blockReveal();
    _keepHeightForExpands();
    _hideAllItems();
    _storeBootstrapClasses(expand_item);

    the_container.attr("data-current-height", the_container.css('height'));
    the_container.css({height: ''});
    
    if(expand_item != item) {
      _storeCurrentStyle(expand_item);
      _storeCurrentStyle(item);
      _setExpandedStyles(expand_item, true);
      _setExpandedStyles(item);
    } else {
      _storeCurrentStyle(expand_item);
      _setExpandedStyles(expand_item, true);
    }

    _initReveal(expand_item, item);
    
    _fillExpandContex(item, content);
    _appendCloseIndicator(expand_item, item);
    _scrollToPosition(expand_item);
  }

  function _scrollToPosition(item) {
    $('html, body').animate({
        scrollTop: item.offset().top - 50
    }, 500);
  }

  function _keepHeightForExpands() {
    var keep_height_containers = the_container.find('.click-expand-keep-height');

    if(keep_height_containers.length) {
      keep_height_containers.each(function() {
        var con = $(this);
        con.css({height: con.outerHeight() + 'px'});
      });
    }
  }

  function _fillExpandContex(item, content) {
    var keys = [];

    for (var key in content) {
      if (content.hasOwnProperty(key)) {
        keys.push(key);
      }
    }

    for (var i = keys.length - 1; i >= 0; i--) {
      var key = keys[i];
      var container = item.find(".click-expand-item-context[data-id='" + key + "']");
      container.html(content[key]);
    }
  }

  function _appendCloseIndicator(item, dataItem) {
    dataItem.append("<span class='close_button'>X</span>");

    dataItem.find('.close_button').on('click', function() {
      dataItem.find('.close_button').remove();
      item.removeClass("expanded col-xs-12").addClass(item.data('current-classes'));
      _resetToStoredStyle(item);
      _resetToStoredStyle(dataItem);

      if(parseInt(the_container.data('current-height')) > 0) the_container.css({'height': the_container.data('current-height')});

      the_container.attr("data-current-height", the_container.css('height'));

      _unblockReveal();
      the_items.removeClass('hidden');
      data_items.removeClass('hidden');

      setTimeout(function() {
        dataItem.removeClass("non-clickable");
        the_container.find('.click-expand-keep-height').css({height: ''});
      }, 1000);

      return true;
    });
  }

  function _storeCurrentStyle(item) {
    item.attr("data-current-flex", item.css('flex-basis'));
    item.attr("data-current-max-height", item.css('max-height'));
    item.attr("data-current-max-width", item.css('max-width'));
    item.attr("data-current-height", item.css('height'));

    //monkey patch for now
    item.css({'flex-basis': item.css('flex-basis')}); 
  }

  function _resetToStoredStyle(item) {
    item.css({
      'flex-basis': item.data('current-flex'),
      'max-height': item.data('current-max-height'),
      'max-width': item.data('current-max-width'),
      'height': parseInt(item.data('current-height')) > 0 ? item.data('current-height') : ''
    });
  }

  function _storeBootstrapClasses(item) {
    var class_arr = item[0].className.split(' ');
    var outputArr = [];

    for (var i = class_arr.length - 1; i >= 0; i--) {
      if(class_arr[i].indexOf("col-") !== -1) outputArr.push(class_arr[i]);
    }

    item.attr("data-current-classes", outputArr.join(' '));
  }

  function _setExpandedStyles(item, with_class) {
    item.css({
      'flex-basis': '',
      'max-height': '',
      'max-width': '',
      'height': ''
    });

    if(with_class) item.addClass("expanded")
  }

  function _initReveal(item, dataItem) {
    dataItem.removeClass('hidden');
    item.removeClass('hidden').removeClass(item.data('current-classes')).addClass("expanded col-xs-12").show();
  }

  function _hideAllItems() {
    the_items.addClass('hidden');
    data_items.addClass('hidden');
  }

  function _blockReveal() {
    if(isReveal) the_container.addClass("reveal-blocked");
  }

  function _unblockReveal() {
    if(isReveal) the_container.removeClass("reveal-blocked");
  }

  function _buildUrl(id) {
    return the_url + id;
  }

  return { init: init() }
});