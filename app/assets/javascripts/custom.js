$( document ).ready(function() {
  var site_url = $(location).attr("href");
  split_url = site_url.split('#')
  if(split_url[1]){
    split_url = '#' + split_url[1]
    $('html, body').animate({
      scrollTop: $(split_url).offset().top - 60
    }, 1500);
  }
  $('.modal-input-edit').on('shown.bs.modal', function() {
    $(document).off('focusin.modal');
  });
})

function QuestionsFontResize(){
  $('.btn_plus').click(function(){
    $('.mcq_stem_description').css({'font-size': '+=2'});
    $('.btn_plus').addClass('zoom_active');
    $('.btn_reset').removeClass('zoom_active');
    $('.btn_minus').removeClass('zoom_active');
  })

  $('.btn_minus').click(function(){
    $('.mcq_stem_description').css({'font-size': '-=2'});
    $('.btn_minus').addClass('zoom_active');
    $('.btn_reset').removeClass('zoom_active');
    $('.btn_plus').removeClass('zoom_active');
  })

  $('.btn_reset').click(function(){
    $('.mcq_stem_description').css({'font-size': '14px'});
    $('.btn_reset').addClass('zoom_active');
    $('.btn_minus').removeClass('zoom_active');
    $('.btn_plus').removeClass('zoom_active');
  })
}

  function timer_state(t){
    if(t == 'Pause' || t == ''){
      $("#exam_total_time_remaining").runner('start');
    }
    else {
      $("#exam_total_time_remaining").runner('stop');
    }
  }
