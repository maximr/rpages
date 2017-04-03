function initVideo() {
  var video_container = $('.video_prepend');

  if(video_container.size()) {
    video_container.vide(video_container.data('video-urls'), {muted: true, autoplay: true, loop: true, bgColor: 'rgba(0,0,0,1)'});

    var next_container = video_container.parent().next();
    var video_item = video_container.find('video').attr('id', 'video_item');

    //if(!$.browserData.browser == 'Chrome') video_item.addClass('paused'); //todo: fix me
    video_item.addClass('paused');

    onScrollBy(next_container, 'down', 25, function() { if(video_item.size()) pauseVideo(video_item); });
    onScrollBy(next_container, 'up', 25, function() { if(video_item.size()) playVideo(video_item); });
  }
}

function pauseVideo(item) {
  //item.addClass('paused');
  document.getElementById(item.attr('id')).pause();
}

function playVideo(item) {
  //if($.browserData.browser == 'Chrome') item.removeClass('paused');
  document.getElementById(item.attr('id')).play();
}