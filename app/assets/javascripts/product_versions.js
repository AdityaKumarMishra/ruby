$(function() {
  updateAddMasterFeatureBlockIds();

  $('.is_default_feature_cbx').on('change', function(event){
    $(this).parents('.feature-group').find('.product_version_features_price').slideToggle();
  });

  $(document).on('nested:fieldAdded', function(event) {
    $('.chosen-select').chosen();
    chooseFeature();
  });

  function chooseFeature() {
    $('.master-fetaure-drop-list').on('change', function() {
      master_id = $(this).attr("id");
      var feature = $("#"+master_id).find('option:selected').text();
      if(feature == "Gamsat Essay Feature" || feature == "Gamsat Private Tutoring Feature") {
        $(this).closest('.master_feature').find('.master-qty').fadeIn();
      } else {
        $(this).closest('.master_feature').find('.master-qty').fadeOut();
      }
    });
  }

  $('.CourseTypeMasterFeature').on('change', function(){
    var course_type = $(this).val();
    var product_line_id = getParameterByName('product_line_id')
    $.ajax({
      url: "/admin/product_versions/new.js",
      method: "GET",
      data: { product_line_id: product_line_id, course_type: course_type }
    });
  });

  function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }

  function updateAddMasterFeatureBlockIds() {
    $('.add_master_feature_block').each(function(i) {
      $(this).prop('id', 'add_master_feature_block_' + i);
    });
  };

  chooseFeature();

  $(document).on('nested:fieldAdded', function(event){
    updateAddMasterFeatureBlockIds();
  });

  $(document.body).on('change', '.master-fetaure-drop-list' ,function(){
    var form_block = $(this).closest('.add_master_feature_block');
    var block_id = form_block.prop('id');
    var mf_id = $(this).val();

    getMasterFeatureTags(mf_id, block_id);
  });

  function getMasterFeatureTags(mf_id, block_id) {
    $.ajax('/master_features/master_feature_tags', {
      type: 'POST',
      data: {
        id: mf_id
      },
      success: function(data, textStatus, xhr){
        updateTagsSelect(data.tags, block_id);
      },
      error: function(response){
        console.log(response);
      }
    });
  };

  function createSelectOption(label, value) {
    return $('<option value=' + value + '>' + label + '</option>');
  };

  function updateTagsSelect(tags_array, block_id) {
    var tags_select = findTagSelect(block_id);
    $(tags_select).empty();

    $.each(tags_array, function(index, el){
      var tag_html = createSelectOption(el.name, el.id);
      $(tags_select).append(tag_html);
    });

    $(tags_select).trigger('chosen:updated');
  };

  function findTagSelect(block_id) {
    return $('#' + block_id).find('select.tag-list');
  };

});

function takeCourseScript(pv_id, pv_slug){
  $.ajax({
    url: "/courses/list_cities",
    type: "json",
    method: "GET",
    data: { product_id: pv_id },
    success: function(data){
      var options = data.map(function(city){
        return '<option>' + city + '</option>'
      }).join('\n');
      $('#city').html(options);
      $('#city').trigger('change');
    }
  });

  $('#city').on('change',function(){
    $('.take-course-btn').hide();

    var mock;
    $('.custom-pvpf-checkbox:checked').each(function() {
      feature_name = $(this).parent().text();
      if (feature_name.indexOf('Mock Exam Day') != -1){
        mock = true;
      }
    });
    $.ajax({
      url: "/courses/list_courses_by_city.json",
      type: "json",
      method: "GET",
      data: {city: $('#city').val(), product_id: pv_id, mock: mock },
      success: function(responseData) {
        var options = responseData.map(function(course){
           return "<option value=" + course.id  + ">" + course.name + "</option>";
        }).join('\n');
        $("#course").html(options);
        if($('.custom-course-city-selection').hasClass('hide')){
          $("div.mCustomScrollbar").hide();
        }else{
          $('#course').trigger('change');
        }
      }
    });
  });

  if($('#course').length <=0){
    $("div.mCustomScrollbar").hide();
  }

  $('#course').on('change',function(){
    $('#custom-course-purchase-form').attr('action', '/courses/' + $(this).val() + '/enrolments/custom_enrol');
    $('.course-enrol-button').attr('href', '/courses/' + $(this).val() + '/enrolments/enrol');
    var course_id = $(this).val();

    if(course_id){
      $.ajax({
        url: "/courses/list_course_lessons.json",
        type: "json",
        method: "GET",
        data: {course_id:  course_id},
        success: function(obj) {
          if(obj=='failure') {
          }
          else {
            var lessons = obj.lessons;
            $('#enrolment_dates').text(obj["enrolment_end_date"]);
            if (lessons.length > 0 ){
              var content = '';
              for(var i=0;i<lessons.length;i++)
              {
                var tr="<tr>";
                var td1="<td>"+lessons[i]["date"]+"</td>";
                var td2="<td>"+lessons[i]["location"]+"</td>";
                var td3="<td>"+lessons[i]["start_time"]+"</td>";
                var td4="<td>"+lessons[i]["end_time"]+"</td>";
                var td5="<td>"+lessons[i]["item_covered"]+"</td></tr>";
                content += tr + td1 +td2 + td3+ td4+ td5;
              }
              if(obj.course_type == 'custom'){
                var mock_exam = false;
                $('.custom-pvpf-checkbox:checked').each(function() {
                  feature_name = $(this).parent().text();
                  if (feature_name.indexOf('Mock Exam Day') != -1){
                    mock_exam = true
                  }
                });
                if(mock_exam){
                  $("div.mCustomScrollbar").show();
                  $(".course-dates-table .table tbody").html(content);
                }else{
                  $("div.mCustomScrollbar").hide();
                }
              }else{
                $("div.mCustomScrollbar").show();
                $(".course-dates-table .table tbody").html(content);
              }
            }else{
              $("div.mCustomScrollbar").hide();
            }
          };
        }
      });

      var isTrial = pv_slug == 'free_trial'
      if(isTrial) {
        $('.trial-btn').hide();
      }

      $.ajax({
        url: "/courses/" + $(this).val() + "/trial_enabled.json",
        type: "json",
        method: "GET",
        data: {},
        success: function(obj) {
          if(obj=='failure') {
          }
          else {
            if(obj["trial_enabled"] == true){
              $('.take-course-btn').show();

            }else
            {
              $('.take-course-btn').show();
            }
          };
        }
      });
    }else{
      $("div.mCustomScrollbar").hide();
      $('.course_present_view').hide();
      $('.course_reopen').removeClass('hide');
    }
  });

  $('.trial-btn').click(function() {
    $(this).attr("href", this.href + "?trial=true");
  });

  $('.custom-pvpf-checkbox').click(function(){
    var mock_exam = false;
    $('.custom-pvpf-checkbox:checked').each(function() {
      feature_name = $(this).parent().text();
      if (feature_name.indexOf('Mock Exam Day') != -1){
        mock_exam = true
      }
    });
    if(mock_exam){
      $('.custom-course-city-selection').removeClass('hide');
      $('#city').trigger('change');
    }else{
      $('.custom-course-city-selection').addClass('hide');
      $("div.mCustomScrollbar").hide();
      $('#city').trigger('change');
    }
  })
}

function takeNewCourseScript(pv_id){
  $('.new_city_panel').on('change',function(){
    var city = $(this).val();
    // var active_li = $(this).parent().parent("ul").find("li.active")
    // if(active_li){
    //   active_li.removeClass('active');
    // }
    // $(this).parent("li").addClass('active');
    var mock = $("#cust-mock-exam").attr('value');
    $.ajax({
      url: "/courses/list_courses_by_city.json",
      type: "json",
      method: "GET",
      data: {city: city, product_id: pv_id, mock: mock},
      success: function(responseData) {
        var options = responseData.map(function(course){
           return "<option value=" + course.id  + ">" + course.name + "</option>";
        }).join('\n');
        $("#course").html(options);
        $('#course').trigger('change');
      }
    });
  });

   $('#course').on('change',function(){
    var course_id = $(this).val();
    if(course_id){
      $.ajax({
        url: "/courses/"+ course_id +"/update_course_id",
        method: "GET",
        data: {course_id:  course_id}
      });

      $.ajax({
        url: "/courses/list_course_lessons.json",
        type: "json",
        method: "GET",
        data: {course_id:  course_id},
        success: function(obj) {
          if(obj=='failure') {
          }
          else {
            var lessons = obj.lessons;
            $('#courseEnrolmentDate').text('Enrolment Closure date - ' + obj['enrolment_end_date']);
            $('#courseExpiryDate').html('<a href="/gamsat-preparation-courses/faq/enrolment-and-payment#contact_ten_id">Expiry date</a> - ' + obj['expiry_date']);
            if (lessons.length > 0 ){
              var content = '';
              var content1 = "<div class='box_header'>Course Schedule </div>";
              var content1 = content1 + "<div class='box_content cstm_panel_desc_content'>";

              for(var i=0;i<lessons.length;i++)
              {
                if (i==0){
                  var row = "<div class='course_row_lesson show'>";
                }else{
                  var row = "<div class='course_row_lesson'>";
                }
                var row = row + "<h4>"+lessons[i]["location"]+"</h4>";
                var row = row + "<p>"+lessons[i]["item_covered"]+"</p>";
                var row = row + "<div class='unvrsty_schedule'>";
                var row = row + "<h4>"+lessons[i]["date"]+"</h4>";
                var row = row + "<p>"+lessons[i]["start_time"] + " | " + lessons[i]["end_time"] +"</p>";
                var row = row + "</div>";
                var row = row + "</div>";
                content += row
              }
              var all_content = content1 + content;
              var all_content = all_content + "</div>";

              if(lessons.length > 1){
                all_content += "<a class='toggle_courses' href='javascript:void(0)'>" + obj.image_down + obj.image_up + "</a>" ;
              }
              $(".cstm_panel_desc").html(all_content);
              $(".cstm_panel_desc").removeClass('cstm_condition');
              $(".toggle_courses").click(function(){
                $(".cstm_panel_desc_content").toggleClass("more_feature_col", 'slow');
              });
              var islessondown=true;
              $(".toggle_courses").click(function(){
                if(islessondown){
                  $(".toggle_courses .up_sign").removeClass('hide');
                  $(".toggle_courses .down_sign").addClass('hide');
                  islessondown=false;
                }
                else{
                  $(".toggle_courses .up_sign").addClass('hide');
                  $(".toggle_courses .down_sign").removeClass('hide');
                  islessondown=true;
                }
              })
            }else{
              $(".cstm_panel_desc").html('');
              $(".cstm_panel_desc").addClass('cstm_condition');
            }
          };
        }
      });
    }else{
    }
  });
}
