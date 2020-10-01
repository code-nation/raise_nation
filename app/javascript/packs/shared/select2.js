$(document).on('turbolinks:load', function(){
  $('.ajax-select2').select2();
  $('.ajax-select2').on('ajaxurl:changed', function(){
    $(this).select2();
  });
  $('.token-select2').select2({
    tags: true,
    tokenSeparators: [',', ' ']
  });
})
