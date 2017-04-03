var slideOutTab = (function(container, offset) { 

  var dalayTimer = null;
  var defaultAction = null;

  function init() {
    if(container.length) { 
      _setDefaults();
      _setupSlideOut();
      //_delayedBounce();
    }

    $(window).on('scrollstart', {latency: 350}, function(e) { 
      if(container.tabSlideOut('isOpen')) container.tabSlideOut('close');
    });

    container.find('.handle').on('click', function(e) { 
      if(!container.tabSlideOut('isOpen')) {
        $('.slide-out').tabSlideOut('close');
      } else {
        container.tabSlideOut('open');
      }
    });
  }

  function _setDefaults() {
    defaultAction = 'hover'; //$.browserData.mobile ? 'click' : 'hover'
  }

  function _setupSlideOut() {
    container.tabSlideOut({
      tabLocation: 'right',
      speed: 500,
      action: defaultAction,
      offset: offset,
      bounceDistance: '0.4vw',
      bounceTimes: 2
    });
  }

  function _delayedBounce() {
    if(!dalayTimer) dalayTimer = setInterval(function() {
      if(!container.tabSlideOut('isOpen')) container.tabSlideOut('bounce');
    }, 10000);
  }

  function _handleEvents() {
    container.find('tab_link').click(function() {
      if(container.tabSlideOut('isOpen')) $('.slide-out').tabSlideOut('close');
    });
  }

  return { init: init() }
});