$(document).on('ready page:load', function() {
  try{
    questions = $(".pagination_mcq_single_question > li").length;
    bars = parseInt(questions/10,10)
    last_bar = parseInt(questions%10,10)
    from = 0
    bar = []
    if (bars != 0){
      for(i=0;i<bars;i++){
        var collection = $(".pagination_mcq_single_question > li").slice(from,from+10)

        bar[i] = collection

        console.log(bar[i])
        from = from + 10
      }
      if(last_bar != 0){
        bar[bar.length] = $(".pagination_mcq_single_question > li").slice(from,from+last_bar+1)
      }
    }
    else{
      if(last_bar != 0){
        bar[0] = $(".pagination_mcq_single_question > li").slice(from,from+last_bar+1)
      }
    }
    for(i = 0; i<bar.length;i++){
      bar[i].wrapAll("<div class='q_nav' id='q_nav_"+i+"'></div>")
      if (i != (bar.length-1)){
        $("#q_nav_"+i).append("<li role='presentation' class='next_icon' style='cursor: pointer;'><a role='tab' onclick='find_div(this)'>>></a></li>")
      }
      if (i != 0){
        $("#q_nav_"+i).prepend("<li role='presentation' class = 'prev_icon' style='cursor: pointer;'><a role='tab' onclick= 'find_prev_div(this)'><<</a></li>")
      }
    }
    $(".q_nav").slice(1,bar.length).hide();
  }
  catch(err){
  }

    $('.btnNext1').click(function() {
      var questions = $('.tab-pane.active').find(".question");
      questions.each(function(){
        var checked_radio = ($(this).find("input:checked"))
        if (parseInt($('.pagination_mcq_single_question').find('li.active').text())%10 == 0){
          if ((checked_radio.length == 0) && ($(this).hasClass("warning_shown") == false)){
            $(this).addClass("warning_shown");
            showUnattemptedFlash();
          }
          else{
            removeUnattemptedFlash();
            $(this).removeClass("warning_shown")
            var nav_bar = $('.pagination_mcq_single_question').find('li.active')
            nav_bar.parent().hide();
            var next_nav_bar = nav_bar.parent().next()
            next_nav_bar.show();
            next_nav_bar.find('li:nth-child(2)').addClass('active').find('a').trigger('click');
          }
        }
        else if (checked_radio.length > 0){
          removeUnattemptedFlash();
          $(this).removeClass("warning_shown")
          $('.pagination_mcq_single_question').find('li.active').removeClass('active').addClass('add_green').next().find('a').trigger('click');
        }
        else{
          if($(this).hasClass("warning_shown")){
            removeUnattemptedFlash();
            $(this).removeClass("warning_shown")
            $('.pagination_mcq_single_question').find('li.active').removeClass('active').next().find('a').trigger('click');
          }
          else{
            $(this).addClass("warning_shown");
            showUnattemptedFlash();
          }
        }
      });
      // $('.gr-nav-tabs > .active').next('li').find('a').trigger('click');
      $('html, body').animate({ scrollTop: 0 }, 'slow');
    });

    $('.btnPrevious1').click(function() {
      var questions = $('.tab-pane.active').find(".question");
      questions.each(function(){
        var checked_radio = ($(this).find("input:checked"))
        if (parseInt($('.pagination_mcq_single_question').find('li.active').text())%10 == 1){
          if ((checked_radio.length == 0) && ($(this).hasClass("warning_shown") == false)){
            $(this).addClass("warning_shown");
            showUnattemptedFlash();
          }
          else{
            removeUnattemptedFlash();
            $(this).removeClass("warning_shown")
            var nav_bar = $('.pagination_mcq_single_question').find('li.active')
            nav_bar.parent().hide();
            var prev_nav_bar = nav_bar.parent().prev()
            prev_nav_bar.show();
            prev_nav_bar.find('li:nth-child(10)').addClass('active').find('a').trigger('click');
          }
        }
        else if (checked_radio.length > 0){
          removeUnattemptedFlash();
          $(this).removeClass("warning_shown")
          $('.pagination_mcq_single_question').find('li.active').removeClass('active').addClass('add_green').prev().find('a').trigger('click');
        }
        else{
          if($(this).hasClass("warning_shown")){
            removeUnattemptedFlash();
            $(this).removeClass("warning_shown")
            $('.pagination_mcq_single_question').find('li.active').removeClass('active').prev().find('a').trigger('click');
          }
          else{
            $(this).addClass("warning_shown");
            showUnattemptedFlash();
          }
        }
      });
      $('html, body').animate({ scrollTop: 0 }, 'fast');
    });

    $('.btnNext').click(function() {
      $('.nav-tabs > .active').next('li').find('a').trigger('click');
      $('.gr-nav-tabs > .active').next('li').find('a').trigger('click');
      $('html, body').animate({ scrollTop: 0 }, 'fast');
    });

    return $('.btnPrevious').click(function() {
      $('.nav-tabs > .active').prev('li').find('a').trigger('click');
      $('.gr-nav-tabs > .active').prev('li').find('a').trigger('click');
      $('html, body').animate({ scrollTop: 0 }, 'fast');
    });
});
$(document).ready(function(){
  $(".unattempt_question").click(function(){
    if($(this).hasClass("checked_option")){
      $(this).prop('checked', false);
      $(this).removeClass("checked_option")
    }
    else{
      $(this).parent().parent().find(".unattempt_question").removeClass("checked_option")
      $(this).addClass("checked_option")
    }
  })
})

function updateSectionItemAttemptAnswer(){
  removeUnattemptedFlash();
  $(".quest-col").removeClass("warning_shown")
  var questions = $('.tab-pane.active').find(".question");
  if ($("#sa-form").length>0){
    var section_item_attempts = {};
    section_item_attempts['section_item_attempts'] = {};
    questions.each(function(){
      var question_id = $(this).attr('id');
      var answer_id = null ;
      var checked_radio = ($(this).find("input:checked"))
      if (checked_radio.length > 0){
        answer_id = checked_radio.val();
        $('.pagination_mcq_single_question').find('li.active').addClass('add_green')
      }
      if (answer_id){
        section_item_attempts['section_item_attempts'][question_id] = {};
        section_item_attempts['section_item_attempts'][question_id]['mcq_answer_id'] = answer_id;
      }
    })
    var url = $("#sa-form").attr('action').replace('complete', 'update_answer')
    $.ajax({
      type: 'PUT',
      url: url,
      data: section_item_attempts,
    }).done(function (response) {
    });

  }else
  {
    var mcq_attempts = {};
    mcq_attempts['mcq_attempt'] = {};
    questions.each(function(){
      var question_id = $(this).attr('id');
      var answer_id = null ;
      var checked_radio = ($(this).find("input:checked"))
      if (checked_radio.length > 0){
        answer_id = checked_radio.val();
        $('.pagination_mcq_single_question').find('li.active').addClass('add_green')
      }
      if (answer_id){
        mcq_attempts['mcq_attempt'][question_id] = {};
        mcq_attempts['mcq_attempt'][question_id]['mcq_answer_id'] = answer_id;
      }
    })
    var mcq_stem = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer');
    var url = $("#mcqa-form").attr('action').replace('update_answer', 'update_mcq_answer')
    $.ajax({
      type: 'PUT',
      url: url,
      dataType: 'script',
      data: mcq_attempts,
    }).done(function (response) {
      mcq_stem.attr('is-ans', response);
    });

  }
}

function CalculateMcqStemTime(){
  $('#mcq-stem-timer').runner({
    autostart: true,
    milliseconds: false
  }).on('runnerStop', function(eventObject, info) {
    // var mcq_stem_id = $('.exam_list li.active .mcq-stem-question-id').text();
    var mcq_stem_id = $('.ques_exam_list .tab-pane.active .mcq-stem-question-id-active').text();
    var exercise_id = $('#mcq-stem-timer').attr('exercise-id');
    var sectionable_type = $('#mcq-stem-timer').attr('section-type');
    var url = '/mcq_stems/' + mcq_stem_id + '/update_complete_time';
    var tot_time = info['time'] / 1000 ;
    if(!Number.isNaN(parseInt(mcq_stem_id))){
      $.ajax({
        type: 'POST',
        url: url,
        dataType: 'script',
        data: {sectionable_id: exercise_id, sectionable_type: sectionable_type, tot_time: tot_time}
      }).done(function (response) {
        $('#mcq-stem-timer').runner('reset');
        $('#mcq-stem-timer').runner('start');
      });
    }
  })
}

function CalculateMcqStemTimeSingle(){  
  $('#mcq-stem-timer').runner({
    autostart: true,
    milliseconds: false
  }).on('runnerStop', function(eventObject, info) {
    var mcq_stem_id = $('#mcq-stem-timer').attr('mcq-question-id');
    var exercise_id = $('#mcq-stem-timer').attr('exercise-id');
    var sectionable_type = $('#mcq-stem-timer').attr('section-type');
    var url = '/mcq_stems/' + mcq_stem_id + '/update_complete_time';
    var tot_time = info['time'] / 1000 ;
    if(!Number.isNaN(parseInt(mcq_stem_id))){
      $.ajax({
        type: 'POST',
        url: url,
        data: {sectionable_id: exercise_id, sectionable_type: sectionable_type, tot_time: tot_time}
      }).done(function (response) {
        $('#mcq-stem-timer').runner('reset');
        $('#mcq-stem-timer').runner('start');
      });
    }
  });
}

function stopRunnerTimer_single(eventObject){
  $('#mcq-stem-timer').runner('stop');
  var total_time = $("#question-allotted-time").attr('value');
  if(total_time){
    var m_id = $('.pagination_mcq_single_question').find('li.active').find('.mcq-stem-id').text()
    anotherQuestionTimer(eventObject)
    stopRemaningTimer(m_id);
  }
  updateSectionItemAttemptAnswer();
  $('.pagination_mcq_single_question').find('li.active').removeClass('active');
}

function stopRunnerTimeSingle(eventObject){
   $('#mcq-stem-timer').runner('stop');
  var total_time = $("#question-allotted-time").attr('value');
  if(total_time){
    var m_id = $('.pagination_mcq_single_question').find('li.active').find('.mcq-stem-id').text()
    anotherQuestionTimer(eventObject)
    stopRemaningTimer(m_id);
  }
  updateSectionItemAttemptAnswer();
}

function stopRunnerTimer(eventObject){
  $('#mcq-stem-timer').runner('stop');
  var total_time = $("#question-allotted-time").attr('value');
  if(total_time){
    var m_id = $('.nav-tabs').find('li.active').find('.mcq-stem-id').text()
    anotherQuestionTimer(eventObject)
    stopRemaningTimer(m_id);
  }
  updateSectionItemAttemptAnswer();
}

function stopRunnerTimerindividual(eventObject, stem_id){
  $('#mcq-stem-timer').runner('stop');
  var total_time = $("#question-allotted-time_"+ stem_id ).attr('value');
  if(total_time){
    var m_id = $('.nav-tabs').find('li.active').find('.mcq-stem-id').text()
    anotherQuestionTimerIndividual(eventObject, stem_id)
    stopRemaningTimer(m_id);
  }
  updateSectionItemAttemptAnswer();
}

function showRemaningTimerIndividual(time, stem_id){
  var mc_id = "#question_time_remaining_" + stem_id
  var total_time = $("#question-allotted-time_" + stem_id).attr('value');
  var mc_text = $(mc_id).text();
  if(total_time && !mc_text){
    $(mc_id).runner({
      autostart: true,
      milliseconds: false,
      countdown: true,
      startAt: time * 1000,
      stopAt: 0
    }).on('runnerFinish', function(eventObject, info) {
      var next_ele = $('.nav-tabs > .active').next('li').find('a');
      if(next_ele.length > 0){
        $('.nav-tabs > .active').next('li').find('a').trigger('click');
        $('html, body').animate({ scrollTop: 0 }, 'fast');
        mcq_stem_id = $('.nav-tabs > .active').find(".mcq-stem-id").text();
        time = $("#question-allotted-time_" + mcq_stem_id).attr('value');
        showRemaningTimerIndividual(time, mcq_stem_id)
      }
    });
  }
}


function showRemaningTimer(time, stem_id){
  var mc_id = "#question_time_remaining_" + stem_id
  var total_time = $("#question-allotted-time").attr('value');
  var mc_text = $(mc_id).text();
  if(total_time && !mc_text){
    $(mc_id).runner({
      autostart: true,
      milliseconds: false,
      countdown: true,
      startAt: time * 1000,
      stopAt: 0
    }).on('runnerFinish', function(eventObject, info) {
      var next_ele = $('.nav-tabs > .active').next('li').find('a');
      if(next_ele.length > 0){
        $('.nav-tabs > .active').next('li').find('a').trigger('click');
        $('html, body').animate({ scrollTop: 0 }, 'fast');
        mcq_stem_id = $('.nav-tabs > .active').find(".mcq-stem-id").text();
        time = $("#question-allotted-time").attr('value');
        showRemaningTimer(time, mcq_stem_id)
      }
    });
  }
}

function anotherQuestionTimerIndividual(eventObject, stem_id){
  var mcq_stem_id;
  var time;
  if(eventObject == 'complete'){
    time = 0;
    mcq_stem_id = $('.exam_list li.active').prev('li').first().find(".mcq-stem-id").text();
  }else{
    mcq_stem_id = $(eventObject.target).find('div.mcq-stem-id').text();
    time = $("#question-allotted-time_" + stem_id ).attr('value');
  }
  showRemaningTimerIndividual(time, mcq_stem_id)
}


function anotherQuestionTimer(eventObject){
  var mcq_stem_id;
  var time;
  if(eventObject == 'complete'){
    time = 0;
    mcq_stem_id = $('.exam_list li.active').prev('li').first().find(".mcq-stem-id").text();
  }else{
    mcq_stem_id = $(eventObject.target).find('div.mcq-stem-id').text();
    time = $("#question-allotted-time").attr('value');
  }
  showRemaningTimer(time, mcq_stem_id)
}

function stopRemaningTimer(m_id){
  var mc_id = "#question_time_remaining_" + m_id
  $(mc_id).runner('stop');
  $(mc_id).text('00')
}

function showExamRemaningTimer(time){
  $("#exam_total_time_remaining").runner({
    autostart: true,
    milliseconds: false,
    countdown: true,
    startAt: time * 1000,
    stopAt: 0
  })
  // .on('runnerFinish', function(eventObject, info) {
  //   if ($(".finish").attr('id') == "true")
  //     {
  //       if ($('#sa-form').length){
  //         alert('Time has ended.');
  //         $('#sa-form').submit();
  //       }
  //     }
  //     else
  //     {
  //       alert("Time alloted is finished!")
  //     }
  // });
}

function find_div(ele){
  var parent_id = "#" + ele.parentNode.parentElement.id
  var next_div_id = "#" + ele.parentNode.parentElement.nextElementSibling.id
  $(parent_id).hide();
  $(next_div_id).show();
}

function find_prev_div(ele){
  var parent_id = "#" + ele.parentNode.parentElement.id
  var prev_div_id = "#" + ele.parentNode.parentElement.previousElementSibling.id
  $(parent_id).hide();
  $(prev_div_id).show();
}

function showUnattemptedFlash(){
  $(".flash_message").text("This question has not been fully answered.").fadeIn("fast")
}

function removeUnattemptedFlash(){
  $(".flash_message").text("This question has not been fully answered.").fadeOut("fast")
}