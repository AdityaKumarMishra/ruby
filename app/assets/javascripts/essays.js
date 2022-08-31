$(document).on('click', '#essay_select_all', function() {
  var status;
  status = $('#essay_select_all').prop('checked');
  $('#essay_select_all').parents('#assign-essays-tutor').find(':checkbox.essay-id-checkbox').prop('checked', status);
  change_assign_essay_btn_status(status);
  var type = $(this).attr('essay_type');
  var cookie_name;
  if(type == 'Mock'){
    cookie_name = 'to_mark_mock_essay'
  }else{
    cookie_name = 'to_mark_essay'
  }
  if(status){
    Cookies.set(cookie_name, status, { expires: 1 });
  }else{
    Cookies.remove(cookie_name);
  }
});

function change_assign_essay_btn_status(status){
  if(status){
    $('#mass_assign_tutor_essay').removeAttr('disabled');
  }else{
    $('#mass_assign_tutor_essay').attr('disabled','disabled');
  }
}

$(document).on('click', '.essay-id-checkbox', function() {
  var status = $('.essay-id-checkbox:checked').length > 0
  change_assign_essay_btn_status(status);
});
