//= require active_admin/base
//= require jquery-fileupload
//= require jquery-fileupload/vendor/tmpl
//= require active_admin/select2

//= require ckeditor/init
//= require ckeditor/config

//custom
//= require ./admin/content_blocks
//= require ./admin/dynamic_select2

function uniqId() {
  return Math.round(new Date().getTime() + (Math.random() * 100));
}

function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      var preview = $(input).parent().find('.image-preview');

      if(preview.length) {
        preview.attr('src', e.target.result);
      } else {
        $(input).after('<img class="image-preview" style="margin-bottom:0;width:75px;"src="' + e.target.result + '" alt="Preview">');
      }
    }

    reader.readAsDataURL(input.files[0]);
  }
}

$(document).ready(function() {

  console.log("loading rpages_admin js");

  $("div.content_block_container .slim_content_block").each(function() {
    contentBlocks($(this)).init;
  });

  $(".select2_enabler").each(function() {
    dynamicSelect2($(this)).init;
  });

  loadCKConfig();

  CKEDITOR.on("instanceReady", function(event){ 
    loadCKConfig();
  });

  $(document).delegate(".has_many_add", "click", function() {
    var item = $(this).prev(".slim_content_block");

    setTimeout( function() {
      contentBlocks(item).init;

      $(".select2_enabler").each(function() {
        dynamicSelect2($(this)).init;
      });
    }, 100);

    $("li[data-preview='true'] input[type='file']").change(function(){
      readURL(this);
    });
  });
});

