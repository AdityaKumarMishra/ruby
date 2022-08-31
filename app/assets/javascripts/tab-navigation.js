(function () {
  $(document).ready(function() {

    /**
     * Bootstrap tab navigation buttons e.g. next, previous
     */
    // $('.btnNext').click(function() {
    //   if($(this).hasClass('btn-review')){
    //   }else{
    //     anotherQuestionTimer('next')
    //   }
    //   $('.nav-tabs > li:nth-child(' + ($('.nav-tabs > li.active').index() + 1) + ')').find('a').trigger('click');
    // });
    // $('.btnPrevious').click(function() {
    //   // odd functionality; same as .btnNext but with different results
    //   $('.nav-tabs > li:nth-child(' + ($('.nav-tabs > li.active').index() + 1) + ')').find('a').trigger('click');
    // });

    /**
     * Bootstrap tab navigation buttons for recent_updates
     */
    $('#updates-js').click(function(e) {
      e.preventDefault();
      return $(this).tab('show');
    });
  });
})();
