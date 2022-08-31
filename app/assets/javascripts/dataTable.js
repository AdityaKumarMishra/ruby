function data_table (class_name, date_list, string_list, select_list, numeric_list) {
  /* Create an array with the values of all the input boxes in a column */
  $.fn.dataTable.ext.order['dom-text'] = function  ( settings, col )
  {
    return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
      return $('input', td).val();
    } );
  }

  /* Create an array with the values of all the input boxes in a column, parsed as numbers */
  $.fn.dataTable.ext.order['dom-text-numeric'] = function  ( settings, col )
  {
    return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
      return $('input', td).val() * 1;
    } );
  }

  /* Create an array with the values of all the select options in a column */
  $.fn.dataTable.ext.order['dom-select'] = function  ( settings, col )
  {
      return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
          return $('select', td).val();
      } );
  }

  /* Create an array with the values of all the checkboxes in a column */
  $.fn.dataTable.ext.order['dom-checkbox'] = function  ( settings, col )
  {
      return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
          return $('input', td).prop('checked') ? '1' : '0';
      } );
  }

  $.fn.dataTable.ext.order['dom-date'] = function  ( settings, col )
  {
    return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
        var ukDatea = $('a', td).text().split('/');
        return (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1;
    } );
  }


  $('.'+class_name).dataTable( {
      "bFilter": false,
      "bPaginate": false,
      "order": [[4, "asc" ]],
      "aoColumnDefs": [
        { "sSortDataType": "dom-text-numeric", "aTargets": numeric_list },
        { "sSortDataType": "dom-date", "aTargets": numeric_list },
        { "sSortDataType": "dom-select", "aTargets": select_list },
        { "sType": "numeric", "aTargets": numeric_list },
        { orderable: false, targets: [3,6] }
      ]
  } );
}
