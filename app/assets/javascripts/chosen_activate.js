$(function(){
    //enable chosen js
    $('.chosen-select').chosen({
        allow_single_deselect: true,
        no_results_text: 'No results matched',
        placeholder_text_multiple: 'Click here',
        //inherit_select_classes: true,
        width: '100%'
    });

    $('.chosen-select-course').chosen({
      allow_single_deselect: true,
      no_results_text: 'No results matched',
      placeholder_text_multiple: 'Click here',
      //inherit_select_classes: true,
      max_selected_options: 1,
      width: '100%'
    });
});
