$(function() {
  if($(".auto-hide-navbar").length){
    $(window).scroll(function () {
      var navbar = $('.navbar');
      if ($(this).scrollTop() < 100) {
        navbar.fadeIn();
      } else {
        navbar.fadeOut();
      }
    });
  }
});