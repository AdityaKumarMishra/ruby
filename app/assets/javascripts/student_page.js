//= require jquery.dd
//= require swiper.min
//= require chosen
//= require jquery-ui/widgets/datepicker
//= require bootstrap-datepicker
//= require bootstrap-datetimepicker
//= require profile_stats/highcharts.js
//= require profile_stats/drilldown.js
//= require public_pages/jquery.bplugin.min.js
//= require public_pages/jquery.countdown.min.js

$(document).ready(function() {

  $("#sample").msDropdown();

  $(function () {
    var active = false;
    $('.show_all_faq').click(function () {
        if (active) {
            active = false;
           $('.panel-collapse').collapse('hide');
            $('.panel-title').attr('data-toggle', 'collapse');
      $('.fa.pull-right.fa-angle-up').removeClass('fa-angle-up');
      $('.fa.pull-right').addClass('fa-angle-down');
            $(this).text('Show All');
        } else {
            active = true;

       $('.panel-collapse').collapse('show');
            $('.panel-title').attr('data-toggle', '');
      $('.fa.pull-right.fa-angle-down').removeClass('fa-angle-down');
      $('.fa.pull-right').addClass('fa-angle-up');
            $(this).text('Hide All');
        }
    });

    $('#accordion').on('show.bs.collapse', function () {
        if (active) $('#accordion .in').collapse('hide');
    });
  });

  $(".mobile_mousehover_tool").click(function(){
    $(".mobile_mousehover_tool").removeClass("acitve");
    $(this).addClass("acitve");
    $(".overlay_show").addClass("show_tool_wrapper");
  });

  $(".overlay_show").click(function(){
    $(".mobile_mousehover_tool").removeClass("acitve");
    $(".overlay_show").removeClass("show_tool_wrapper");
  });

  $(".overlay_show").click(function() {
    $(".mobile_menu_wrapper").removeClass("menu_show");
    $("body").removeClass("overflow_hidden");
    $(".faq_wrapper").removeClass("show_rht_side");
  });

  $(".ddTitleText").click(function(){
    $(".overlay_show").addClass("show_tool_wrapper");
  });


  $(".review_tab_open").click(function() {
      $(".non_active_review").removeClass("active")
    $(".active_review").addClass("active")
     $("#features_col").removeClass("active")
    $("#reviews_col").addClass("active")

  })

  $(".side_toggle").click(function() {
    $(".faq_wrapper").toggleClass("hide_sidebar")
    $(".course_tab").toggle();
  })

  $(".sideLeftQues").click(function() {
    $(".faq_wrapper").toggleClass("show_rht_side");
    if($(".faq_wrapper").hasClass('show_rht_side')){
      $(".overlay_show").addClass("show_tool_wrapper");
    }
  })

  $(".side_exam_ques li").click(function() {
    $(".faq_wrapper").removeClass("show_rht_side")
    $(".overlay_show").removeClass("show_tool_wrapper");
  });

  $('[data-toggle="tooltip"]').tooltip();

  $(".mobile_menu_icon").click(function() {
    $(".mobile_menu_wrapper").addClass("menu_show");
    $(".page_wrapper").addClass("page_slight");
    $("body").addClass("overflow_hidden");
  });

  $(".close_menu").click(function() {
    $(".mobile_menu_wrapper").removeClass("menu_show");
    $(".page_wrapper").removeClass("page_slight");
    $("body").removeClass("overflow_hidden");
  });

    $(".contact_support, .ask_ques_sec").click(function() {
    $(".qa_query_form").addClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
  })

  $(".email_query_icon").click(function() {
    $(".qa_query_form").addClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Email");
  })

  $("#qa_header_click").click(function() {
    $(".qa_query_form").removeClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
  })
  $("#call_back_btn").click(function() {
    $(".qa_query_form").addClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Sechdule a call back");
  })
  $("#close_call_form").click(function() {
    $(".qa_query_form").removeClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
  })
  $("#email_back_btn").click(function() {
    $(".qa_query_form").addClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Email");
  })
  $("#close_email_form").click(function() {
    $(".qa_query_form").removeClass("show_qa_query_form");
    $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
  })

  if ($('#back-to-top').length) {
    var scrollTrigger = 100, // px
    backToTop = function () {
      var scrollTop = $(window).scrollTop();
      if (scrollTop > scrollTrigger) {
        $('#back-to-top').addClass('show');
      } else {
        $('#back-to-top').removeClass('show');
      }
    };
    backToTop();
    $(window).on('scroll', function () {
      backToTop();
    });
    $('#back-to-top').on('click', function (e) {
      e.preventDefault();
      $('html,body').animate({
        scrollTop: 0
      }, 700);
    });
  }

  $(".show_submenu").click(function() {
    $(this).siblings(".mobile_submenu_col").toggle();
  })

  toastr.options.extendedTimeOut = 10000;
  toastr.options.timeOut = 15000;

});
