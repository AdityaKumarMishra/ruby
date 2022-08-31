(function () {
  var finished = false;

  function updateExerciseTime() {
    if(finished) return;
    setExerciseCookie('current_exe_atmpt', 180)
    var bar = $('.exercise-attempt-countdown .progress-bar');
    var finish_on_time = $(".finish").attr('id');
    var cea_data = Cookies.get('current_exe_atmpt')
    cea_data = JSON.parse(cea_data);
    var time_elapsed = cea_data['start'];
    var end = cea_data['end'];

    var remaining = Math.ceil((end - time_elapsed) / 60);
    var atmp = (time_elapsed / end) * 100 ;

    // 5 minutes left
    if ((end - time_elapsed) < 5*60) {
      bar.addClass('progress-bar-warning');
    }

    // out of time
    if ((time_elapsed - end) >= 0) {
      finished = true;
      atmp = 100;
      remaining = 0;
      if (bar.hasClass('progress-bar-warning')) {
        bar.removeClass('progress-bar-warning');
      }
      bar.addClass('progress-bar-danger');
      if (finish_on_time == "true")
      {
        if ($('#mcqa-form').length){
          alert('Time has ended.');
          $('#mcqa-form').submit();
        }
      }
      else
      {
        if ($('#mcqa-form').length && $('#exercise-checkbox-end').length && ($('#exercise-checkbox-end').is(":checked"))) {
          alert('Time has ended.');
          $('#mcqa-form').submit();
        }
        else {
          alert('Time has ended. However, you may continue to work.');
        }
      }
    }

    $('.exercise-attempt-countdown .sa-remaining').html(remaining);
    bar.attr({
      'aria-valuenow': atmp,
      'style': 'width: ' + atmp + '%;'
    });
    $('.exercise-attempt-countdown .sr-only').html(atmp + '% Complete');
  }

  $(document).ready(function() {
    if($('.exercise-attempt-countdown').length > 0){
      var interval = setInterval(updateExerciseTime, 5000);
    }
  });
})();


function setExerciseCookie(c_name, cvalue) {
  var sa = Cookies.get('current_exe_atmpt')
  sa = JSON.parse(sa)
  sa['start'] = sa['start'] + 5
  var paused = sa['paused']
  if(paused){
    // do not update cookie
  }else{
    var new_c = JSON.stringify(sa);
    Cookies.remove('current_exe_atmpt');
    Cookies.set('current_exe_atmpt', new_c);
  }
}

function pauseExcercise(){
  var sa = Cookies.get('current_exe_atmpt')
  sa = JSON.parse(sa)
  var paused = sa['paused']
  if(paused){
    sa['paused'] = false
    $("#exercise-pause").html('Pause')
    $("#exercise-pause").removeClass('btn-danger');
    $("#exercise-pause").addClass('btn-success');
  }else{
    sa['paused'] = true
    $("#exercise-pause").html('Resume')
    $("#exercise-pause").removeClass('btn-success');
    $("#exercise-pause").addClass('btn-danger');
  }
  // for saving the tab and answer for question
  updateSectionItemAttemptAnswer();
  var mcq_stem_id = $( "div.exam_list" ).find( "li.active" ).find("div.mcq-stem-id.hidden").text();
  sa['mcq_stem'] = mcq_stem_id

  var new_c = JSON.stringify(sa);
  Cookies.remove('current_exe_atmpt');
  Cookies.set('current_exe_atmpt', new_c);
}
