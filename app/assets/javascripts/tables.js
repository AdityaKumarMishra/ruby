function bindTRLinks(){
  $('tr[data-link]').click(function() {
    window.location = $(this).data("link");
  });
}

(function () {
  $(document).ready(function() {
    bindTRLinks();
    // $('table.table').each(function() {
    //   if (!$(this).parent().hasClass('table-responsive')) {
    //     $(this).wrap('<div class="table-responsive"></div>');
    //   }
    // });
  });
})();