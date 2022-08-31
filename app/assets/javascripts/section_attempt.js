(function () {
  var finished = false;

  function updateTime() {
    if(finished) return;
    setCookie('current_sa', 180)
    var bar = $('.section-attempt-countdown .progress-bar');
    var csa_data = Cookies.get('current_sa')
    csa_data = JSON.parse(csa_data);
    var time_elapsed = csa_data['time_elapsed'];
    var finish_on_time = csa_data['exam_finish'];
    var end = csa_data['end'];
    var remaining = Math.ceil((end - time_elapsed) / 60);
    var atmp = (time_elapsed / end) * 100 ;

    // 10 minutes left
    if ((end - time_elapsed) < 10*60) {
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
      if (finish_on_time == true)
      {
        if ($('#sa-form').length){
          alert('Time has ended.');
          $('#sa-form').submit();
        }
        else{
          alert('Time has ended. Go to attempt, your test will submit automatically.');
        }
      }
      else
      {
        if ($('#sa-form').length && $('#sa-checkbox-end').length && ($('#sa-checkbox-end').is(":checked"))) {
          alert('Time has ended.');
          $('#sa-form').submit();
        }
        else {
          alert('Time has ended. However, you may continue to work.');
        }
      }
    }

    $('.section-attempt-countdown .sa-remaining').html(remaining);
    bar.attr({
      'aria-valuenow': atmp,
      'style': 'width: ' + atmp + '%;'
    });
    $('.section-attempt-countdown .sr-only').html(atmp + '% Complete');
  }

  $(document).ready(function() {
    if($('.section-attempt-countdown').length > 0){
      var interval = setInterval(updateTime, 5000);
    }
  });
})();


function setCookie(c_name, cvalue) {
  var sa = Cookies.get('current_sa')
  sa = JSON.parse(sa)
  sa['time_elapsed'] = sa['time_elapsed'] + 5
  var paused = sa['paused']
  if(paused){
    // do not update cookie
  }else{
    var new_c = JSON.stringify(sa);
    Cookies.remove('current_sa');
    Cookies.set('current_sa', new_c);
  }
}

function pauseExam(){
  var sa = Cookies.get('current_sa')
  sa = JSON.parse(sa)
  var paused = sa['paused']
  if(paused){
    sa['paused'] = false
    $("#section-exam-pause").html('Pause')
    $("#section-exam-pause").removeClass('btn-danger');
    $("#section-exam-pause").addClass('btn-success');
  }else{
    sa['paused'] = true
    $("#section-exam-pause").html('Resume')
    $("#section-exam-pause").removeClass('btn-success');
    $("#section-exam-pause").addClass('btn-danger');
  }

  // for saving the tab and answer for question
  updateSectionItemAttemptAnswer();
  var mcq_stem_id = $( "div.exam_list" ).find( "li.active" ).find("div.mcq-stem-id.hidden").text();
  sa['mcq_stem'] = mcq_stem_id

  var new_c = JSON.stringify(sa);
  Cookies.remove('current_sa');
  Cookies.set('current_sa', new_c);
}

