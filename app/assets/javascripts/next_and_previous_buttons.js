var ready;
ready = $(function() {
    $('.btnNext').click(function() {
      $('.nav-tabs > .active').next('li').find('a').trigger('click');
      $('.gr-nav-tabs > .active').next('li').find('a').trigger('click');
    });
    $('.btnPrevious').click(function() {
      $('.nav-tabs > .active').prev('li').find('a').trigger('click');
      $('.gr-nav-tabs > .active').prev('li').find('a').trigger('click');
    });
});
$(document).ready(ready);
$(document).on('ready page:load', ready);
