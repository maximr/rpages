//= require jquery
//= require jquery_ujs
//= require tether

// = require bootstrap/util
// = require bootstrap/alert
// = require bootstrap/button
// = require bootstrap/carousel
// = require bootstrap/collapse
// = require bootstrap/dropdown
// = require bootstrap/modal

//= require jquery.mobile-events.min
// require jquery.tabSlideOut.js
//= require waypoint.min

// require jquery.counterup.min
// require particles.min
// require jquery.flip.min
// require jquery.vide
// require jquery.scrollstop
// require webfontloader

//= require turbolinks

//custom
//= require ./defaults
//= require ./fixes
//= require ./nav
//= require ./slide_out_tab
//= require ./map
//= require ./particles_start
//= require ./video
//= require ./reveal_slider

//= require ./rpages/link_actions

function clickTargetActions() {
  $(".action_link").on("click", function(e) {
    var item = $(this);

    if($(this).data('target')) {
      $('html, body').animate({
        scrollTop: $('.' + $(this).data('target')).offset().top
      }, 2000);
    } else {
      return true;
    }
    e.preventDefault();
  });
}

function iconItemActions() {
  var icon_items = $(".slide .icon-item-container");

  if(icon_items.size()) {
    //var item_height = getMaxHeight(icon_items.find('div')) + 40;

    icon_items.flip({
      'trigger': 'hover',
      'forceHeight': 'true',
      'autoSize': 'true',
      'speed': 300
    });

    icon_items.on('flip:done',function(){
      var flip_item = $(this);

      if(flip_item.hasClass('active')) {
        flip_item.removeClass('active');
      } else {
        flip_item.addClass('active');
      }
    });

    fixIconItemHight();

    setInterval(function() {
      fixIconItemHight();
    }, 6000);
  }
}

function fixIconItemHight(resetHights) {
  $('.slide').each(function() {
    var slide = $(this);
    var ii = slide.find(".icon-item-container");

    ii.find('.front').css({'height': ''});
    ii.find('.back').css({'height': ''});

    var item_height = getMaxHeight(ii.find('div')) + 40;
    
    ii.css({
      'height': item_height, 
      'min-height': item_height
    });
    ii.find('.front').css({'height': item_height});
    ii.find('.back').css({'height': item_height});
  });
}

function runDelayedScripts() {
  runAndLoadScriptWhenElementExists($('.intro_slide.slide--video'), 'vide', function() {
    initVideo();
  });

  runAndLoadScriptWhenElementExists($('.number'), 'counter', function() {
    $('.number').counterUp({
      delay: 15,
      time: 1500
    });
  });

  runAndLoadScriptWhenElementExists($('.particle_container'), 'particles', function() {
    loadParticlesJS();
  });

  runAndLoadScriptWhenElementExists($(".icon-item-container"), 'flip', function() {
    iconItemActions();
  });

  runAndLoadScriptWhenElementExists($(".video_iframe_container"), 'fitvids', function() {
    $(".video_iframe_container").fitVids();
  });

  if($('#map_container').size()) {
    mapInitializer($map_key, $brand_primary, 'map_container', 100).build;
  }
}

function buttonActions() {
  $('.slide .slide_content_container input[type="button"]').each(function() {
    $(this).addClass('btn btn-outline-primary btn-cta btn-lg btn-cta-main');
    $(this).on('click', function() {
      var target = $('.' + $(this).attr('name'));

      if (target.size) {
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 2000);
      }
    });
  });
}

function colFixes() {
  $('.fix-col').each(function() {
    var regex = new RegExp("col-" + $.revealBreakpoint + "-\\d{1,2}");
    var search = $(this).attr('class').match(regex);

    if(search != null) {
      var num = parseInt(search[0].split('-')[2]);
      if($(this).hasClass('fix-col-x2')) num = num * 2;

      var width = 100 / (12 / num);

      $(this).css({
        'max-width': width + '%',
        '-webkit-box-flex': 0,
        '-ms-flex': '0 0' + width + '%',
        'flex': '0 0' + width + '%'
      });
    }
  });
}

function browserCorrections() {  
  //correct something
}

var customSlideEvents = function(slide) {
   $(".slide").each(function(s) {
    var slide = $(this);

    if(slide.find(".reveal_container").size() > 0) revealSlider(slide.find(".reveal_container")).init;
  });
}

function runReloadEvents() {
  //events that get trigger on window size change...

  console.log("reloading....");
  customSlideEvents();
  navActions();
}

$(document).on("turbolinks:load", function() {
  $.browserData = $("body").data('device');
  browserCorrections();

  window.requestAnimationFrame(function() {
    fixes().run;
    updateIframes();
    navActions();
    clickTargetActions();
    customSlideEvents();
    buttonActions();
    colFixes();

    onScrollInit( $('.slide_content_container.animated_container') );

    $('.btn-disabled').click(function(e){
      e.preventDefault();
    });

    runDelayedScripts();
    linkActions();
  });
});

$(document).on("turbolinks:before-visit", function() {
  Waypoint.destroyAll();
});