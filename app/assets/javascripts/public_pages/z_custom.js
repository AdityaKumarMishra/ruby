$("#testimonial_slider").carousel({interval: false})

$("#tutors_slide").carousel({interval: false})

incrementalNumber = function() {var e = {item: ".incrementalNumber",value: "data-value",bigNumber: "big-number",setText: "set-text",setTime: "set-time"}
    numberTimers = []
    numberStarts = []
    autoincrementNumber = function(a, r, n) {
        var t = r.attr(e.setTime)
        t != "" && t !== undefined ? numberTime = parseInt(t) / n : numberTime = 1e3 / n
        var o = r.attr(e.bigNumber)
        o != "" && o !== undefined ? numberStarts[a] = parseInt(o) : typeof o !== typeof undefined && o !== false ? numberStarts[a] = Math.round(n - n / 10) : numberStarts[a] = 0
        var l = r.attr(e.setText)
        numberTimers[a] = setInterval(function() {
            numberStarts[a]++
                numberStarts[a] <= n ? r.html(l !== undefined ? numberStarts[a] + l : numberStarts[a]) : clearInterval(numberTimers[a])
        }, numberTime)
    }
    $.each($(e.item), function(a, r) {
        data = $(this).attr(e.value)
        autoincrementNumber(numberTimers.length, $(this), data)
    })
}

var intervalId;
var shakeCount = 0;

function loopy() {
    var e = $(".content")
    var a = e.length
    e.each(function(r, n) {

        if ($(n).hasClass("shake")) {
      shakeCount++;
            $(n).removeClass("shake-constant")
            $(n).removeClass("shake")
            if (r < a - 1) {
                $(e[r + 1]).addClass("shake")
                $(e[r + 1]).addClass("shake-constant")
            } else {
                $(e[0]).addClass("shake")
                $(e[0]).addClass("shake-constant")
            }
            return false
        }
    })
  if(shakeCount == 3) {
    hideCF1()
  }
}

function CF1() {
    intervalId = setInterval(function() {
      loopy()
    }, 5000)
}
$(".content").mouseenter(function() {
    clearInterval(intervalId)

 //    $(".shake").removeClass("shake-constant")
 //    $(".shake").removeClass("shake")
    $(this).addClass("color")
     $(this).animate({
                    opacity: 1
                }, 500).addClass("color")
}).mouseleave(function() {
         $(".color").removeClass("color")
  //   $(this).addClass("shake-constant")
 //   $(this).addClass("shake")
     $(this).animate({
                    opacity: 1
                }, 500).removeClass("color")
    //CF1()
})

function hideCF1() {
  clearInterval(intervalId)
  $('.fixed_social_icon').addClass("hide_icon");
}

setTimeout(function() {
    $('.fixed_social_icon').addClass('hide_icon');
},30000);



$(document).ready(function() {
  var site_url = $(location).attr("href");
  split_url = site_url.split('#')
  if(split_url[1]){
    split_url = '#' + split_url[1]
    $('html, body').animate({
      scrollTop: $(split_url).offset().top - 60
    }, 1500);
  }

  $(".review_tab_open").click(function() {
    $(".non_active_review").removeClass("active")
    $(".active_review").addClass("active")
    $("#features_col").removeClass("active")
    $("#reviews_col").addClass("active")
  })

  $('.custom-pvpf-checkbox').click(function(){
    var mock_exam = false;
    var attendence = false;
    var weekend = false;
    var online_exam_1 = false;
    var online_exam_2 = false;
    $('.custom-pvpf-checkbox:checked').each(function() {
      feature_name = $(this).parent().text();
      if (feature_name.indexOf('Mock Exam Day') != -1){
        mock_exam = true
      }
      if (feature_name.indexOf('Attendance Tutorials Feature') != -1){
        attendence = true
      }
      if(feature_name.indexOf('GAMSAT Weekend Course') != -1){
        weekend = true
      }
      if(feature_name.indexOf('Online Mock Exam 1') != -1){
        online_exam_1 = true
      }
      if(feature_name.indexOf('Online Mock Exam 2') != -1){
        online_exam_2 = true
      }
    });
    if(mock_exam || attendence || weekend || online_exam_1 || online_exam_2){
      $(".course_frm").removeClass("hide_box");
      $(".custom_mok_show").addClass("hide_box");
      $(".course_tbl").removeClass("hide_box");
      $('.weekend_course').removeClass("hide_box");
    }else{
      $(".course_frm").addClass("hide_box");
      $(".custom_mok_show").removeClass("hide_box");
      $(".course_tbl").addClass("hide_box");
      $('.weekend_course').addClass("hide_box");
    }

    if($('.custom-pvpf-checkbox:checked').length > 0 ){
      var main_price = 0;
      $('.custom_course_purchase').removeClass('hide');
      $('.custom_course_purchase_modal').addClass('hide');

      $('.custom-pvpf-checkbox:checked').each(function() {
        feature_name = $(this).parent().find('.custom_price_high').text();
        main_price = main_price + parseInt(feature_name);
      });
      var gst = Math.ceil(((10 * main_price) / 100));
      var gst_price = main_price + gst
      $(".early_bird_price").removeClass("hide_box");

      var gms_txt = main_price.toString() + "<span class='fnt_size small_size pv_price'>+ 10% GST = " + gst_price.toString() + "</span>" ;

      $(".early_bird_price").find('.gmsat_text').html(gms_txt);

      $(".discrpton").removeClass("hide_box");
    }else{
      $('.custom_course_purchase').addClass('hide');
      $('.custom_course_purchase_modal').removeClass('hide');

      $(".early_bird_price").addClass("hide_box");
      $(".discrpton").addClass("hide_box");
    }
  })

  $(".public_gamsat").hover(function() {
    $(".public_gamsat_green").removeClass("disable");
    $(".public_umat_blue").addClass("disable");
  });
  $(".public_umat").hover(function() {
    $(".public_gamsat_green").addClass("disable");
    $(".public_umat_blue").removeClass("disable");
  });


  incrementalNumber()
  CF1()
  $(".mobile_menu_icon").click(function() {
    $(".mobile_menu_wrapper").addClass("menu_show");
    $(".page_wrapper").addClass("page_slight");
    $("body").addClass("overflow_hidden");
  });

  $(".overlay_show").click(function() {
    $(".mobile_menu_wrapper").removeClass("menu_show");
    $("body").removeClass("overflow_hidden");
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
  $("#call_back_overlay").click(function() {
    $(".overlay_content").toggle();
  })

  $(".show_submenu").click(function() {
    $(this).siblings(".mobile_submenu_col").toggle();
  })

  $('#test13').click(function(){
    if($(this).is(":checked")) {
      $(".course_frm").removeClass("hide_box");
      $(".custom_mok_show").addClass("hide_box");
      $(".course_tbl").removeClass("hide_box");
    } else {
      $(".course_frm").addClass("hide_box");
      $(".custom_mok_show").removeClass("hide_box");
      $(".course_tbl").addClass("hide_box");
    }
  });

  if ($(window).width() < 1020) {
    $(".qa_query_form").addClass("hide_qa_query_form")
  } else {
    $(".qa_query_form").removeClass("hide_qa_query_form")
  }

  $(".second_level_col").hover(
    function () {
      $(".scond_levl_hover").addClass("float-shadow");
    },
    function () {
      $(".scond_levl_hover").removeClass("float-shadow");
    }
  );

  $(".online_second").hover(
    function () {
      $(".online_frst_pkg").addClass("hide_pkg");
      $(".second_pkg_visible").addClass("pkg_none");
    },
    function () {
      $(".online_frst_pkg").removeClass("hide_pkg");
      $(".second_pkg_visible").removeClass("pkg_none");
    }
  );
  $(".attendence_second").hover(
    function () {
      $(".attend_frst_pkg").addClass("hide_pkg");
      $(".second_pkg_visible").addClass("pkg_none");
    },
    function () {
      $(".attend_frst_pkg").removeClass("hide_pkg");
      $(".second_pkg_visible").removeClass("pkg_none");
    }
  );

  $(".third_level_col").hover(
    function () {
      $(".third_levl_hover").addClass("float-shadow");
      $(".attend_second_pkg").addClass("hide_pkg");
      $(".attend_frst_pkg").addClass("hide_pkg");
      $(".gst").addClass("mtop20");
    },
    function () {
      $(".third_levl_hover").removeClass("float-shadow");
      $(".attend_second_pkg").removeClass("hide_pkg");
      $(".attend_frst_pkg").removeClass("hide_pkg");
      $(".gst").removeClass("mtop20");
    }
  );

  $(".float-shadow").hover(
    function () {
      $(".first_pkg_visible").addClass("pkg_none");
    },
    function () {
      $(".first_pkg_visible").removeClass("pkg_none");
    }
  );
  $(".float-shadow").hover(
    function () {
      $(".first_pkg_visible").addClass("pkg_none");
    },
    function () {
      $(".first_pkg_visible").removeClass("pkg_none");
    }
  );

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
});


$(document).ready(function(){
  function resizeForm(){
    var width = (window.innerWidth > 0) ? window.innerWidth : document.documentElement.clientWidth;
    if(width > 1024){
      // window.setTimeout(function(){
      // $('.qa_query_form.home_support_tab').addClass("show_qa_query_form")
      // }, 10000);
      // $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
    } else {
      // window.setTimeout(function(){
      //   $('.qa_query_form.home_support_tab').addClass("show_qa_query_form");
      //   $(".qa_query_form").find('.qa_form_header h3').html("Got a Question?");
      // }, 10000000000);
      $(".different_course_col").click(function() {
        $(this).addClass("show_data")
        $(".body_overlay_home").addClass("body_show");
      });

      $(".body_overlay_home").click(function() {
        $(".body_overlay_home").removeClass("body_show");
        $(".different_course_col").removeClass("show_data")
        $(".features_content_section").removeClass("show_data");
      });
      $(".features_content_section").click(function() {
        $(this).addClass("show_data")
        $(".body_overlay_home").addClass("body_show");
      });
    }
  }
  window.onresize = resizeForm;
  resizeForm();
});

$(document).ready(function() {
  $(".more_links_popup ul li a").on("click", function( e ) {
    e.preventDefault();
    $("body, html").animate({
      scrollTop: $( $(this).attr('href') ).offset().top
    }, 600);
  });

  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/i)) {
    $('body').addClass('ios');
  };

  if (navigator.userAgent.indexOf('Safari') != -1 &&
    navigator.userAgent.indexOf('Chrome') == -1) {
        document.body.className += " safari_ios";
  }

  $(".more_links_popup ul li").click(function() {
    $(".more_links_popup").removeClass("show")
  })

  $(function () {
    var active = true;
    $('.show_all_faq').click(function () {
      if (active) {
        active = false;
        $('.panel-collapse.collapse').removeClass('in');
        $('.panel-title').attr('data-toggle', 'collapse');
        $('.fa.pull-right.fa-angle-up').removeClass('fa-angle-up');
        $('.fa.pull-right').addClass('fa-angle-down');
        $(this).text('Show All');
      }else {
        active = true;
        $('.panel-collapse.collapse').addClass('in');
        $('.panel-title').attr('data-toggle', '');
        $('.panel-collapse.collapse').removeAttr('style');
        $('.fa.pull-right.fa-angle-down').removeClass('fa-angle-down');
        $('.fa.pull-right').addClass('fa-angle-up');
        $(this).text('Hide All');
      }
    });

    $('#accordion').on('show.bs.collapse', function () {
      if (active) $('#accordion .in').collapse('hide');
    });
  });

  if(window.location.hash == "#call_back_overlay"){
    $(".overlay_content").css("display", "block");
  }

  $(".z_index").click(function() {
    $(".body_overlay_home").css("display", "block");
  });

  $(".body_overlay_home").click(function() {
    $(".body_overlay_home").css("display", "");
    $(".overlay_content").css("display", "");
  });
});





$( document ).ready(function() {

  $('#testimonial_slider_3d').carouselSlider({
          carouselOptions: {
            autoplay: true,
            autoplayInitialDelay: 1000,
            autoplayDuration: 5000,
            autoplayPauseOnHover: true,
            clickToFocus: true,
            btnPrev: '.prevArrow',
            btnNext: '.nextArrow',
            duration: 400,
            minScale: 0.4
          },
          arrowAutoHide: true, /* auto hide the arrow button or not */
          animateStyle: 'twirl',
          triggerBy: 'click',  /* hover | click */
          clickIcons: true
        });

        $("*[id^='icon']").click(function(){
          $('.cstm_colr').removeClass('cstm_colr');
          $(this).addClass("cstm_colr");

          var str=this.id;
          var str1 = str.replace('icon','');
          var selectedClass = 'div'+str1;
          $(".full_data").removeClass("current");
          $(".full_data").removeClass("active140");
          $(".full_data").addClass("current");
          $('.'+selectedClass).removeClass("current");
          $('.'+selectedClass).addClass("active140");
        });
});

$(window).load(function() {
  $('.cont_laoder').hide();
})
