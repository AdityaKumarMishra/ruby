(function() {
  function updatePlaceholderHeight() {
    var ph = $('.gamsat-placeholder');
    var nb = $('.navbar-fixed-top');
    if (ph.length && nb.length) { // check the elements exist
      ph.height(nb.height());
    }
  }
  $(document).ready(updatePlaceholderHeight);
  $(window).resize(updatePlaceholderHeight);
  // Make navbar transparent when scrolling down
})();

  <!--
  if (screen.width <= 1000) {
  $(document).ready(function() {
    $(window).scroll(function() {
      if ($(window).scrollTop() > 100) {
        // Class declaration can be found in utilities.scss
      }
    });

    $(".navbar-toggle").click(function(){
      $(".navbar-collapse").slideToggle();
      $('body').toggleClass('b_not_scroll');
    })

    $('body').click(function(evt){
      if($(evt.target).closest('#OtherNavbar').length)
        return;
      if($(evt.target).closest('#GradNavbar').length)
        return;
      if(!$(evt.target).closest('.navbar-toggle').length){
        $(".navbar-collapse").slideUp();
        $('body').removeClass('b_not_scroll');
      }
    });
    $("li.dropdown-toggle").click(function(){
      $(this).next(".dropdown-menu").slideToggle();
    })
  });
  }

