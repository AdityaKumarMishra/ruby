// /**
//  * This will add tag to the form if parent tag is selected
//  */
// (function () {
//   $(document).ready(function() {
//     $('#exercise_tag_ids').change(function() {
//       var tags = $(this).val();
//       var opts = $(this).children('option:not(:selected)');
//       $(this).children('option:selected').each(function() {
//         var pre = $(this).text().split(' ')[0];
//         opts.each(function(i) {
//           var item = $(this);
//           if (item.text().indexOf(pre) === 0) {
//             // tags.push(item.val());
//             item.prop('disabled', true);
//           }
//         });
//       });
//       $(this).val(tags).trigger('chosen:updated');
//     });
//   });
// })();

(function () {
  $(document).ready(function() {
    /**
     * This will disable tags in associative list if a parent tag is selected
     */
    function disableChildTags(selectTagId) {
      $(selectTagId).change(function() {
        var slct = $(this);
        var tags = slct.val(); // all chosen tags

        // undisable all unselected tags
        slct.children('option:not(:selected)').each(function() {
          $(this).prop('disabled', false);
        });

        // disable all tags with parents that are selected
        if (tags) {
          slct.children('option:selected').each(function() {
            var name = $(this).text().split(' ')[0];
            slct.children('option:not(:selected)').each(function() {
              var item = $(this);
              if (item.text().indexOf(name) === 0) {
                item.prop('disabled', true);
              }
            });
          });
        }

        // inform select of updates
        $(this).trigger('chosen:updated');
      });
    }

    disableChildTags('#exercise_tag_ids');
    disableChildTags('#ticket_tag_ids');

    /**
     * This should scroll select into view when inside a modal to avoid 'cutoff' effect
     */
    $('.modal select').on('chosen:showing_dropdown', function() {
      var _this = $(this);
      setTimeout(function() {
        _this.parents('.modal-body').animate({
          scrollTop: _this.offset().top
        });
      }, 200);
    });
  });
})();