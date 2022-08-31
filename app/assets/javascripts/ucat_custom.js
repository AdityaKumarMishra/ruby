$(document).on('ready page:load', function() {
	$('#ucat-mcq #continue').click(function(){
		var current_tab = $('#ucat-mcq .tab-pane.active.active-tabs')
		if(current_tab.hasClass('agreement-tab')){
			$('#'+current_tab.attr('data-modal')).modal('show');
		}
		else{
			goToNextTab();
		}
	});
	$('#ucat-mcq #back').click(function(){
		goToPrevTab();
	});

	$('.go-next').click(function(){
		goToNextTab();
	})

	$('#ucat-mcq .tab-pane input').change(function(){
		// stopRunnerTimer_single(event);
	})

	$('#review-flagged').click(function(){
	    var tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
		var flaggedQues = $('[section='+tag_id+'-ques] [is-flagged=true]')
		if(flaggedQues.length > 0){
			$('[section='+tag_id+'-ques] [is-flagged=""]').parent().removeClass('active-tabs');
			$('[section='+tag_id+'-ques] [is-flagged=false]').parent().removeClass('active-tabs');
			$('#ucat-mcq .tab-pane.active.active-tabs').removeClass('active');
			$($('[section='+tag_id+'-ques] [is-flagged=true]')[0]).parent().addClass('active')
			resolve_calsses();
		}
		else{
			$('#flagged_modal').modal('show');
		}
	})

	$('#review-incomplete').click(function(){
		var tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
		var incompleteQues = $('[section='+tag_id+'-ques] [is-ans=false]')
		if(incompleteQues.length > 0){
			$('[section='+tag_id+'-ques] [is-ans="true"]').parent().removeClass('active-tabs');
			$('#ucat-mcq .tab-pane.active.active-tabs').removeClass('active');
			$($('[section='+tag_id+'-ques] [is-ans=false]')[0]).parent().addClass('active')
			resolve_calsses();
		}
		else{
			$('#incomplete_modal').modal('show');
		}
	})
	$('#review-all').click(function(){
		var tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
		$('#ucat-mcq .tab-pane.active.active-tabs').removeClass('active');
		$($('[section='+tag_id+'-ques]')[0]).addClass('active')
		resolve_calsses();
	})

	$('#end-review').click(function(){
		var is_last_tab = $('#ucat-mcq .tab-pane.active.active-tabs').nextAll('.tab-pane').length <= 0
		var tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
		var unans = $('[section='+tag_id+'-ques] [is-ans=false]')
		if(unans.length > 0){
			$('#last_end_review_modal #ques-warning').show();
			$('#last_end_review_modal #warning').hide();
			$('#last_end_review_modal #ques-warning span').text(unans.length );
		}
		else{
			$('#last_end_review_modal #ques-warning').hide();
			$('#last_end_review_modal #warning').show();
		}
		if(is_last_tab){
			$('#last_end_review_modal #review-go-next').removeAttr('onclick');
			$('#last_end_review_modal #review-go-next').click(function(){
				stopRunnerTimeSingle(event);
				$('#mcqa-form').submit();
			});
		}
		$('#last_end_review_modal').modal('show');
	})

	if($('#ucat-mcq .tab-pane.active.active-tabs').hasClass('review-tab')){
		$('.para_contant').addClass('faq_contant contant_scroll');
		add_review_text();
	}

	setReviewLinks();
	changeFlagged();
   	changeQueCount();
    onFlagChange();
    setClockQuesToggle();
})

function resolve_calsses(){
	if($('#ucat-mcq .tab-pane.active.active-tabs').hasClass('mcq-tab')){
		$('.uni_logo').hide();
		$('.main_contant').css('padding', '0px');
		$('.para_contant').css('padding', '0px');
		$('.para_contant').removeClass('faq_contant');
		$('.para_contant').removeClass('contant_scroll');
		// if(!$('#ucat-mcq .tab-pane.active.active-tabs').prev('.tab-pane').hasClass('mcq-tab'))
		changeHeaderMcq();
		$('#ucat-mcq .step_btn_wrap .review-btns').hide();
		$('#ucat-mcq #back').show();
		$('#ucat-mcq #continue').show();
		$('#ucat-mcq #submit-exam').show();
		$('#ucat-mcq #end-review').hide();
	}
	else{
		if($('#ucat-mcq .tab-pane.active.active-tabs').hasClass('review-tab')){
			renderQueList();
			$('.uni_logo').hide();
			$('.main_contant').css('padding', '0px');
			if(!$('.tab-content').hasClass('para_contant'))
				$('.tab-content').addClass('para_contant')
			$('.para_contant').css('padding', '18px 40px 0px 18px;');
			$('.para_contant').addClass('faq_contant');
			$('.para_contant').addClass('contant_scroll');
			changeHeaderReview();
			$('#ucat-mcq .step_btn_wrap .review-btns').show();
			$('#ucat-mcq #back').hide();
			$('#ucat-mcq #continue').hide();
			$('#ucat-mcq .tab-pane').addClass('active-tabs');
			$('#ucat-mcq #submit-exam').hide();
			$('#ucat-mcq #end-review').show();
			add_review_text();
		}
		else
		{
			$('.uni_logo').show();
			$('.main_contant').css('padding', '20px 0px 0px;');
			if(!$('.tab-content').hasClass('para_contant'))
				$('.tab-content').addClass('para_contant')
			$('.para_contant').css('padding', '18px 40px 0px 18px;');
			$('.para_contant').removeClass('faq_contant');
			$('.para_contant').removeClass('contant_scroll');
			// if($('#ucat-mcq .tab-pane.active.active-tabs').next('.tab-pane').hasClass('mcq-tab'))
			changeHeader();
			$('#ucat-mcq .step_btn_wrap .review-btns').hide();
			$('#ucat-mcq #back').hide();
			$('#ucat-mcq #continue').show();
			$('#ucat-mcq #submit-exam').show();
			$('#ucat-mcq #end-review').hide();
		}
	}
	changeFlagged();
	changeQueCount();
    
    var isMcqTab = $('#ucat-mcq .tab-pane.active.active-tabs').hasClass('mcq-tab')
    var selectedAttempt;
    var tag_id;
    if(isMcqTab){
       selectedAttempt = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('mcq-attempt-id');
       tag_id = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('tag-id');
    }
    else{
       selectedAttempt = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id')
       tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
    }
   	var exercise_id = $('#mcq-stem-timer').attr('exercise-id');
    $.ajax({
        url: '/mcq_attempts/update_selected_attempt',
        type: 'POST',
        dataType:"json",
        data: {selected_attempt: selectedAttempt, exercise_id: exercise_id, tag_id: tag_id},
        success: function(data) {
          
        }
    })

}	

function goToNextTab(){
	var current_tab = $('#ucat-mcq .tab-pane.active.active-tabs');
	// if(mcq_answered(current_tab)){
		stopRunnerTimer_single(event)
		updateYesNoAns(current_tab);
		$(current_tab.nextAll('.tab-pane.active-tabs')[0]).addClass('active');
		current_tab.removeClass('active');
		resolve_calsses();
		$('#'+current_tab.attr('data-modal')).modal('hide');
	// }
}

function goToPrevTab(){
	var current_tab = $('#ucat-mcq .tab-pane.active.active-tabs')
	// if(mcq_answered(current_tab)){
		stopRunnerTimer_single(event);
		updateYesNoAns(current_tab);
		$(current_tab.prevAll('.tab-pane.active-tabs')[0]).addClass('active');
	  	current_tab.removeClass('active');
	  	resolve_calsses();
	// }
}

function updateYesNoAns(current_tab){
	if(current_tab.find('.question').hasClass('yes_no')){
		var data = []
		var mcq_attempt_id = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('mcq-attempt-id');
		var mcq_stem = current_tab.find('#mcq-stem-timer')
		$(current_tab).find('.mcq-drag-list').each(function(){
			inner_data = {}
			var ans_id = $(this).attr('id').split('-')[0]
			var text = $('.drag_box .droppable#'+ans_id+'-droppable').text();
			if(text != ''){
				var new_text = (text == 'yes') ? 'true' : ((text == 'no') ? 'false' : '')
				if(new_text != ''){
					inner_data['mcq_answer_id'] = ans_id
					inner_data['value'] = new_text
					data.push(inner_data);
				}
			}
		})
		$.ajax({
			url: '/mcq_attempts/'+mcq_attempt_id+'/update_attempt_answer',
	        type: 'POST',
	        dataType:"json",
	        data: {mcq_attempt_answeres: data},
	        success: function(data) {
	        	mcq_stem.attr('is-ans', data);
	        }
		})
	}
}

// function mcq_answered(current_tab){
// 	mcq_checked = current_tab.find('input:checked')
// 	if (mcq_checked.length > 0){
// 		return true
// 	}
// 	else{
// 		$('#answer-warning').modal('show');
//		return false
// 	}

// }

function onFlagChange(){
	$('#mcq-flag').click(function(){
      var mcq_attempt_id = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('mcq-attempt-id');
      var flagged = $('#'+mcq_attempt_id+'-flagged').attr('is-flagged')
      $.ajax({
        url: '/mcq_attempts/'+mcq_attempt_id+'/update_flagged',
        type: 'POST',
        dataType:"json",
        data: {flagged: flagged == undefined ? true : flagged},
        success: function(data) {
          $('#'+mcq_attempt_id+'-flagged').attr('is-flagged',data.flagged)
          if(data.flagged)
            $('#mcq-flag').css('color', '#ffff00');
          else
            $('#mcq-flag').css('color', '#fff');
        }
      })
    })  
}

function changeQueCount(){
	var queCount = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('que-count');
    var totalCount = $('#ucat-mcq .tab-pane.active.active-tabs #mcq-stem-timer').attr('total-count');
    $('#que-count').text(queCount + ' of ' + totalCount );
}

function changeFlagged(){
	var flagged = $('#ucat-mcq .tab-pane.active.active-tabs .flagged').attr('is-flagged')
	if(flagged == 'true')
		$('#mcq-flag').css('color', '#ffff00');
	else
		$('#mcq-flag').css('color', '#fff');
}

function add_review_text(){
	var tag_id = $('#ucat-mcq .tab-pane.active.active-tabs').attr('id').split('-')[0]
	var unans = $('[section='+tag_id+'-ques] [is-ans=false]')
	if(unans.length > 0){
		$('#incomplete-text-'+tag_id).text(unans.length+' Unseen/Incomplete')
	}
	else{
		$('#incomplete-text-'+tag_id).text('')
	}
}

function setReviewLinks(){
	$('#ucat-mcq .card-body a').click(function(){
		var id = $(this).attr('id').split('-')[0]
		$('#ucat-mcq .tab-pane.active.active-tabs').removeClass('active');
		$('#ucat-mcq .tab-pane.active-tabs#'+id).addClass('active');
		resolve_calsses();
	})
}

function setClockQuesToggle(){

     $('#all_ques').click(function(){
      $('.number').toggleClass('none');
     
      });
 $('#clock').click(function(){
      $('.time').toggleClass('none');
     
      });
      
}