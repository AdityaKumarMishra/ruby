(function () {
  $(document).ready(function() {
    /**
     * Alphanumeric sort
     */
    var reA = /[^a-zA-Z]/g;
    var reN = /[^0-9]/g;
    function sortAlphaNum(a,b) {
      var aA = a.replace(reA, "");
      var bA = b.replace(reA, "");
      if(aA === bA) {
        var aN = parseInt(a.replace(reN, ""), 10);
        var bN = parseInt(b.replace(reN, ""), 10);
        return aN === bN ? 0 : aN > bN ? 1 : -1;
      } else {
        return aA > bA ? 1 : -1;
      }
    }

    /**
     * Sort chosen js input alphanumerically
     */
    function chosenSort(selectId) {
      // run on page load
      updateSelect($(selectId));
      // run on update
      $(selectId).change(function() {
        updateSelect($(this));
      });
    }

    function updateSelect(ele) {
      var options = ele.children('option').sort(function (a, b) {
        return sortAlphaNum(a.text, b.text);
      });
      ele.empty().append(options);
      ele.trigger('chosen:updated');
    }

    // run sorting on the given select forms
    chosenSort('#mcq_stem_ids_');
  });
})();