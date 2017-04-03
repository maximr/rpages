var fixes = (function(undefined) { 

  var reload_timeout = null;

  function init() {
    _fixReloadEvent();
    _fixOrientationChange();
  }

  function _fixReloadEvent() {
    $.windowLastWidth = window.innerWidth;
    $.windowLastHeight = window.innerHeight;

    window.onresize = function(){
      clearTimeout(reload_timeout);
      reload_timeout = setTimeout(_resizedw, 500);
    };
  }

  function _fixOrientationChange() {
    window.addEventListener("orientationchange", function() {
      _reload();
    }, false);
  }

  function _resizedw() {
    if(!$.browserData.mobile && ($.windowLastWidth != window.innerWidth || $.windowLastHeight != window.innerHeight)) {
      $.windowLastWidth = window.innerWidth;
      $.windowLastHeight = window.innerHeight;

      _reload();
    }
  }

  function _reload() {
    //maybe do something more clever here
    //window.location.reload();
    runReloadEvents();
  }


  return { run: init() }
});