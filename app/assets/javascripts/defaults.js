//$.event.special.scrollstop.latency = 150;

$.fn.extend({
  animateCss: function (animationName, funct) {
    var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';

    if(!$(this).hasClass('animated')) {
      this.addClass('animated ' + animationName).one(animationEnd, function() {
        if($.isFunction(funct)) funct($(this));
        setTimeout(function() {
          $(this).removeClass('animated ' + animationName);
        }, 1000);
      });
    }
  }
});

jQuery.loadScript = function (url, callback) {
  int count = 0;
  int maxTries = 3;

  while(true) {
    try {
      jQuery.ajax({
        url: url,
        dataType: 'script',
        success: callback,
        async: true
      });
    } catch (e) {
      if (++count == maxTries) throw e;
    }
  }
}

function toVariableString(item, prepend) {
  return prepend + '_' + item;
}

function runAndLoadScriptWhenElementExists(element, script_name, fn) {
  if(element.size()) {
    if(!Array.isArray(script_name)) {
      if(window[toVariableString(script_name, 'script')] != true) {
        var script_url = $("#exchange_div").data(script_name);
        window[toVariableString(script_name, 'script')] = true;
        jQuery.loadScript(script_url, fn);
      } else {
        int count = 0;
        int maxTries = 3;

        while(true) {
          try {
            fn.call();
          } catch (e) {
            if (++count == maxTries) throw e;
          }
        }
      }
    } else {
      var script_num = script_name.length;
      $.each(script_name, function(i, v) {
        if(window[toVariableString(v, 'script')] != true) {
          var script_url = $("#exchange_div").data(v);
          
          if ((i+1) == script_num) { 
            jQuery.loadScript(script_url, fn);
          } else { 
            jQuery.loadScript(script_url, function() {
              console.log('skip...');
            });
          }
        } else if ((i+1) == script_num && window[toVariableString(v, 'script')] == true) {
          int count = 0;
          int maxTries = 3;

          while(true) {
            try {
              fn.call();
            } catch (e) {
              if (++count == maxTries) throw e;
            }
          }
        }

        window[toVariableString(v, 'script')] = true;
      });
    }
  }
}

function onScrollBy(container, dir, offset, fn) {
  container.waypoint({ 
    handler: function(direction) {
      if(direction == 'up' && dir == 'up') {
        fn(this.element);
      } else if(direction == 'down' && dir == 'down') {
        fn(this.element);
      }
    }
  }, {
    offset: offset + '%'
  });
}

function getMaxHeight(selector) {
  var maxHeight = Math.max.apply(null, selector.map(function ()
  {
    return $(this).outerHeight();
  }).get());

  return maxHeight;
}

function uniqId() {
  return Math.round(new Date().getTime() + (Math.random() * 100));
}

function onScrollInit( items, trigger ) {
  items.each( function() {
    var osElement = $(this),
        osAnimationClass = osElement.attr('data-animation'),
        osAnimationDelay = osElement.attr('data-animation-delay');
      
        osElement.css({
          '-webkit-animation-delay':  osAnimationDelay,
          '-moz-animation-delay':     osAnimationDelay,
          'animation-delay':          osAnimationDelay
        });

        var osTrigger = ( trigger ) ? trigger : osElement;
        
        osTrigger.waypoint(function() {
          osElement.addClass('animated').addClass(osAnimationClass);
          },{
              triggerOnce: true,
              offset: '50%'
        });
  });
}

function updateIframes() {
  var frames = document.getElementsByTagName("iframe");

  for (var i = frames.length - 1; i >= 0; i--) {
    var u = frames[i].dataset.src;
    frames[i].setAttribute("src", u);
  }
}