if (!window.RaiseNation) { window.RaiseNation = {} };

$.extend(window.RaiseNation, {
  /* Note that if $form is null the link
   * should be defined in routes as POST, otherwise GET
   */

  openModal: function(target, link, backdrop, keyboard, $form = null) {
    $modal = $(target || "#general-modal");
    if ($form == null) {
      data = "";
    } else {
      data = $form.serializeArray().reduce(function(map, item){
        map[item.name] = item.value;
        return map;
      });
    }
    $modal.load(link, data, function(){
      $modal.modal({
        backdrop: backdrop,
        keyboard: keyboard
      });
    })
  },

  hideModal: function(){
    $(".modal-link, .modal-form").removeData("modal")
    $(".modal-link").html("")
    $(".modal-form").html("")
  },

  initGeneralModal: function(){
    $("body").on("hidden", ".modal-link, .modal-form", function(){
      RaiseNation.hideModal();
    });

    $("body").on("click", ".modal-link", function(e){
      e.preventDefault();
      $link = $(this);
      RaiseNation.openModal($link.data("target"), $link.attr("href"), $link.data("backdrop"), $link.data("keyboard"))
    });

    $("body").on("submit", ".modal-form", function(e){
      e.preventDefault();
      $form = $(this);
      RaiseNation.openModal($form.data("target"), $form.data("href"), $form.data("backdrop"), $form.data("keyboard"), $form)
    })
  }
});

$(document).on('turbolinks:load', function(){
  RaiseNation.initGeneralModal();
})
