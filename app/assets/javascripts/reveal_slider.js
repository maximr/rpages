/**
 * RevealSlider
 *
 * @description A Slider alternative that can change parts of the html, based on dynamic data attributes
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

var revealSlider = (function(the_container, undefined) {

  var reveal_content = null;
  var reveal_keys = [];
  var item_limit = 0;
  var settings = null;
  var numberOfItems = 0;
  var limiterNumber = 3;
  var currentOffset = 0;
  var flex = false;
  var blockable = false;
  var inline = false;
  var keep = false;
  var delay = 3000;
  var revealItems = null;
  var numberOfSlides = 0;
  var nextSlide = 0;
  var revealIndicator = null;
  var updateInterval = false;
  var hideAnimation = null;
  var revealAnimation = null;
  var animationDuration = 600;
  var containerHeight = 0;
  var blockOnHover = true;
  var withArrows = false;

  function init() {
    _setSettingVariables();

    if(!_containerIsInitialized()) {
      the_container.addClass('initializing');

      if(typeof $.revealBreakpoint == 'undefined') _setScreenBreakPoint()

      _setRevealItems();
      _setRevealData();
      _setRevealKeys();
      _setNumberOfItems();
      _setNumberOfVisibleItems();
      _setNumberOfSlides();
      _appendSlideIndicator();

      if(numberOfItems > limiterNumber) {
        _activitySettings();

        if(blockOnHover) _bindBlockOnHover();
        if(withArrows)   _arrowSwitchLogic();
      }

      the_container.removeClass('initializing');
      _revealLogic();
      the_container.addClass('intialized');
    } else {
      console.log("reveal: skipping - container is initialized")
    }
  }

  function _containerIsInitialized() {
    if (the_container.hasClass('intialized') || the_container.hasClass('initializing')) {
      return true;
    } else {
      return false;
    }
  }

  function _setSettingVariables() {
    settings = the_container.data("reveal-settings");

    if(settings.flex) flex = true;
    if(settings.blockable) blockable = true;
    if(settings.inline) inline = true;
    if(settings.keep) keep = true;
    if(settings.delay) delay = settings.delay;
    if(settings.hideAnimation) hideAnimation = settings.hideAnimation;
    if(settings.revealAnimation) revealAnimation = settings.revealAnimation;
    if(settings.blockOnHover) blockOnHover = settings.blockOnHover;
    if(settings.withArrows) withArrows = settings.withArrows;
  }

  function _bindBlockOnHover(items) {
    if(typeof items == 'undefined') {
      items = revealItems;
    }

    items.hover(
      function() {
        the_container.addClass("reveal-paused");
      },
      function() {
        the_container.removeClass("reveal-paused");
      }
    )

    items.on('click', function() {
      the_container.removeClass("reveal-paused");
    });
  }

  function _arrowSwitchLogic() {
    _appendArrows();
    var arrows = the_container.find('.reveal_arrow');

    if(blockOnHover) _bindBlockOnHover(arrows);

    the_container.swipeleft(function() {
      switchSlideArrow('forward');
    });

    the_container.swiperight(function() {
      switchSlideArrow('backward');
    });

    arrows.on('click', function() {
      var arrow = $(this);

      if(arrow.data('direction') == 'forward') {
        switchSlideArrow('forward');
      } else {
        switchSlideArrow('backward');
      }
    });
  }

  function switchSlideArrow(direction) {
    clearInterval(updateInterval);
    updateInterval = false;

    if(direction == 'forward') {
      _increaseOffset();
    } else {
      _decreaseOffset();
    }

    _fillDataContainer();

    setTimeout(function() {
      _setAutoUpdate();
    }, (delay * 4) > 10000 ? 10000 : (delay * 4));
  }

  function _appendArrows() {
    the_container.prepend("<div class='reveal_arrow reveal_arrow_left' data-direction='backward'></div>");
    the_container.append("<div class='reveal_arrow reveal_arrow_right' data-direction='forward'></div>");
  }

  function _activitySettings() { 
    $(window).focus(function() {
      the_container.removeClass("reveal-unfocus");
    });

    $(window).blur(function() {
      the_container.addClass("reveal-unfocus");
    });
  }

  function _setScreenBreakPoint() {
    var data = $('.bootstrap_containers i:visible').first().data("size");
    var output = typeof data == 'undefined' ? 'md' : data;

    $.revealBreakpoint = output;
  }

  function _setRevealData() {
    var output = [];

    revealItems.each(function(i) {
      var item = $(this);
      var itemData = item.data("reveal-item-data");

      output.push(itemData);
    });

    reveal_content = output;
  }

  function _setRevealKeys() {
    for (var key in reveal_content[0]) {
      if (reveal_content[0].hasOwnProperty(key)) {
        reveal_keys.push(key);
      }
    }
  }

  function _setNumberOfItems() {
    numberOfItems = getObjectLength(reveal_content);
  }

  function _setNumberOfSlides() {
    numberOfSlides = numberOfItems / limiterNumber;
  }

  function _setRevealItems() {
    revealItems = the_container.find(".reveal_item_container");
    revealItems.css({'animation-duration': parseInt(animationDuration * 0.99) + 'ms'});
  }

  function _appendSlideIndicator() {
    var append_content = "<div class='d-flex justify-content-center align-items-end'><div class='col-xs-4 col-sm-3 col-md-2 col-lg-1 reveal_indicator align-self-end'>"

    for (var i = 1; i < numberOfSlides + 1; i++) {
      append_content += "<span class='slide_dot' data-num='" + i + "'></span>"
    }

    append_content += "</div></div>"

    the_container.after(append_content);

    revealIndicator = the_container.siblings(".d-flex").find('.reveal_indicator');

    if($.browserData.browser == "Safari") revealIndicator.css({left: '', right: 0});
    _setActiveIndicator(0);

    _revealIndicatorLogic();
  }

  function _revealIndicatorLogic() {
    var dots = revealIndicator.find('.slide_dot');
    if(blockOnHover) _bindBlockOnHover(dots);

    dots.click(function() {
      if(!$(this).hasClass('slide_dot--active')) _switchToSlide($(this).data("num"));
    });
  }

  function _switchToSlide(num) {
    if(_revealIsActive()) {
      clearInterval(updateInterval);
      updateInterval = false;

      _increaseOffset(num);
      _fillDataContainer();

      setTimeout(function() {
        _setAutoUpdate();
      }, (delay * 4) > 10000 ? 10000 : (delay * 4));
    }
  }

  function _setActiveIndicator(num) {
    revealIndicator.find('.slide_dot').removeClass('slide_dot--active');

    revealIndicator.find('.slide_dot')
                   .eq(num).first()
                   .addClass('slide_dot--active')
                   .animateCss("bounce");
  }

  function _setNumberOfVisibleItems() {
    var data = settings.limit[$.revealBreakpoint];
    limiterNumber = typeof data == 'undefined' ? 3 : data;
  }

  function _increaseOffset(num) {
    if(typeof num == 'undefined') {
      currentOffset += limiterNumber;
      nextSlide += 1;
    } else {
      currentOffset = limiterNumber * num;
      nextSlide = num - 1;
    }

    if (currentOffset >= numberOfItems) {
      currentOffset = 0;
      if(typeof num == 'undefined') nextSlide = 0;
    }
  }

  function _decreaseOffset() {
    currentOffset -= limiterNumber;
    nextSlide -= 1;  

    if (currentOffset < 0) {
      currentOffset = numberOfItems - limiterNumber;
    }
  }

  function _findRevealField(container, key) {
    return container.find(".reveal_item[data-reveal-id='" + key + "']")
  }

  function _setAllItemFields(number) {
    var item_container = revealItems.eq(number);
    var content = reveal_content[number];

    for (x = 0; x < reveal_keys.length; x++) { 
      var key = reveal_keys[x];
      var field = _findRevealField(item_container, key);

      if(field.hasClass("reveal_item--image")) {
        field.html("<img src='" + content[key] + "'>");
      } else {
        field.html(content[key]);
      }

      if(field.data("reveal-animation")) field.animateCss(field.data("reveal-animation"));

      item_container.addClass('visible_data_container').animateCss(revealAnimation);
    }
  }

  function _fillDataContainer() {
    the_container.addClass("reveal-switching");

    var targetOffset  = currentOffset + limiterNumber;
    var correctLimiter = targetOffset > numberOfItems ? numberOfItems : targetOffset;

    var visibles = the_container.find('.visible_data_container');
    var timeoutDuration = visibles.size() == 0 ? 0 : animationDuration;
    visibles.animateCss(hideAnimation);

    _updateContainerHeight();

    setTimeout(function() {
      var sel = visibles.removeClass('visible_data_container');
      if(!keep) sel.find(".reveal_item").html(''); 

      for (i = currentOffset; i < correctLimiter; i++) {
        _setAllItemFields(i);
      }

      _setActiveIndicator(nextSlide);
      the_container.removeClass("reveal-switching");
    }, timeoutDuration);

    _updateContainerHeight();

    //visibles.removeClass('visible_data_container').find(".reveal_item").html('');   
  }

  function _calculateMaxWidth() {
    var containerWidth = the_container.outerWidth();
    return (((window.innerWidth - containerWidth) / 1.5) + containerWidth) / (limiterNumber / 2);
  }

  function _updateContainerHeight() {

    var current_height = containerHeight == 0 ? the_container.innerHeight() + 50 : the_container.innerHeight();
    var new_height = containerHeight < current_height ? current_height : containerHeight;

    if(new_height != containerHeight) {
       if(containerHeight != 0) the_container.css({height: new_height + 'px'});
       containerHeight = new_height;
    }
  }

  function _revealLogic() {
    if(flex && !$.browserData.mobile) {
      var basis = 100 / (limiterNumber / 2);

      revealItems.css({
        'flex-basis': basis + '%'
      });

      if(basis < 28) {
        revealItems.css({
          'max-height': window.innerHeight / 2 + 'px',
          'max-width': 90 / (limiterNumber / 2) + '%'
        });
      }
    }

    if(inline && !$.browserData.mobile) {
      the_container.css({
        'flex-wrap': 'nowrap'
      });

      revealItems.css({
        'max-width': the_container.outerWidth() / limiterNumber + 'px',
      });
    }

    var slide = the_container.closest('.slide');
    var content_height = (slide.outerHeight() - revealIndicator.outerHeight()) / 2;

    the_container.css({minHeight: content_height + 'px'});

    _fillDataContainer();

    setTimeout(function() {
      _setAutoUpdate();
    }, delay);
  }

  function _setAutoUpdate() {
    if(!updateInterval) updateInterval = setInterval(_intervalLogic, delay);
  }

  function _revealIsActive() {
    if(!the_container.hasClass("reveal-blocked") 
    && !the_container.hasClass("reveal-unfocus")
    && !the_container.hasClass("reveal-paused")) {
      return true;
    } else {
      return false;
    }
  }

  function _intervalLogic() {
    if(_revealIsActive()) {
      _increaseOffset();
      _fillDataContainer();
    }
  }

  return { init: init() }
});