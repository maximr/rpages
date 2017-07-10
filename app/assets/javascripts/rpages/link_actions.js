function encodeQueryData(data) {
   var ret = [];
   for (var d in data) {
      ret.push(encodeURIComponent(d) + '=' + encodeURIComponent(data[d]));
   }
   return ret.join('&');
}

function linkActionResponse(e) {
  e.preventDefault();
  var item = $(this);
  var params = $(this).data('aparams');

  var id = params.id;
  delete params.id;
  var query = encodeQueryData(params);

  var u = "/cb/" + id + '?' + query;

  $.ajax({
    url: u,
    type: 'GET'
  }).done(function( data ) {
    fillModal(data, item);
  });
}

function linkActions() {
  if($('.popup-trigger').length) {
    $('.popup-trigger').unbind('click', linkActionResponse);
    $('.popup-trigger').bind('click', linkActionResponse);

    // $('.modal').on('shown.bs.modal', function(e) {

    // });
  }
}

function fillModal(data, item) {
  var modal = $('#main_modal');

  modal.find('.modal-body').html(data);
  modal.find('.modal-title').html(item.find('.item-title').html());
}