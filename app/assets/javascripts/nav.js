function navActions() {
  var toggle = $('#navtoggle:visible');
  var collapse_content = $('.navbar-collapse');

  if(toggle.length) {
    toggle.collapse('hide');
    $(".navbar .navbar-collapse").addClass('collapse');
  } else {
    toggle.collapse('show');
    $(".navbar .navbar-collapse").removeClass('collapse');
  }

  collapse_content.on('shown.bs.collapse', function () {
    $('.navbar').addClass("navbar--no-trans");
  });

  collapse_content.on('hide.bs.collapse', function () {
    $('.navbar').removeClass("navbar--no-trans");
  });

  // $(".navbar .nav-item").on("click", function(e) {
  //   var item = $(this);

  //   if($(this).data('target')) {
  //     $('html, body').animate({
  //       scrollTop: $('.' + $(this).data('target')).offset().top
  //     }, 2000);
  //   } else {
  //     return true;
  //   }

  //   e.preventDefault();
  // });
}