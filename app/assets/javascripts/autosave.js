// Handle auto saving (for registration) on local storage temporarily

$(document).ready(function() {

  pathArr = window.location.pathname.split( '/' );
  requestAction = pathArr[1];
  var user_form = $("#new_user").length;
  // Check for LocalStorage support.
  if (localStorage && ((requestAction == '' && user_form > 0) || requestAction == 'register')) {
    // Define all fields needed to be save from auth/signup page
    var base_fields = [
      'email', 'phone_number', 'first_name', 'last_name'
    ]

    var address_fields = [
      'line_one', 'line_two', 'suburb', 'post_code', 'state', 'country'
    ]

    var question_fields = [
      'student_level', 'university_id', 'degree_id', 'year',
      'current_highschool', 'target_uni_course',
      'last_source'
    ]

    // Fields for checklist and radiobuttons
    var source_fields = [
      'googlesearch', 'word_of_mouth', 'facebook', 'posterslarge_a3_sheets_posted_on_wall', 'postersa4_sheets_posted_on_wall',
      'flyerssmaller_a5_handouts', 'brochures', 'in_class',
      'through_student_society', 'workshop', 'other'
    ]

    var other_fields = [
      'umat_high_school_true', 'umat_high_school_false', 'umat_uni_true', 'umat_uni_false',
      'highschool_year_level_year_10', 'highschool_year_level_year_11', 'highschool_year_level_year_12'
    ]

    // Retrieve all values if local storage has values saved
    loop_list(base_fields, '', false);
    loop_list(address_fields, 'user_address_attributes_', false);
    loop_list(question_fields, 'user_questionnaire_attributes_', false);
    check_checklist(source_fields, 'user_questionnaire_attributes_source_', false);
    check_checklist(other_fields, 'user_questionnaire_attributes_', false);

    // Add an event listener for form submissions
    document.getElementById('new_user').addEventListener('submit', function() {
      // Save the fields in localStorage.
      loop_list(base_fields, 'user_', true);
      loop_list(address_fields, 'user_address_attributes_', true);
      loop_list(question_fields, 'user_questionnaire_attributes_', true);
      check_checklist(source_fields, 'user_questionnaire_attributes_source_', true);
      check_checklist(other_fields, 'user_questionnaire_attributes_', true);
    });
  }
  else {
    // Resort to alternative (Don't do anything right now)
    localStorage.clear();
  };

  // Loop through specified list and store/retrieve values
  function loop_list(list, str_to_append, store) {
    if (typeof store === "undefined")
      store = true;

    for (var i=0; i < list.length; i++) {
      var key_name = str_to_append + list[i];

      // Store values
      if (store) {
        if (document.getElementById(key_name).value == null) {
          continue;
        }
        var value_name = document.getElementById(key_name).value;
        localStorage.setItem(key_name, value_name);
      }
      // Retrieve values
      else {
        var stored_val = localStorage.getItem(key_name);

        if (stored_val != null) {
          document.getElementById(key_name).value = stored_val;
        }
      }
    }
  };

  function check_checklist(list, str_to_append, store) {
    if (typeof store === "undefined")
      store = true;

    for (var i=0; i < list.length; i++) {
      var id_name = str_to_append + list[i];
      if (store) {
        var val = document.getElementById(id_name).checked;
        // only save if it's checked to avoid redundancy
        if (val == true) {
          localStorage.setItem(id_name, val);
        }
        else{
          localStorage.removeItem(id_name)
        }
      }
      else {
        var val = localStorage.getItem(id_name);
        if (val != null) {
          document.getElementById(id_name).checked = val;
        }
      }
    }
    if($("#user_questionnaire_attributes_student_level").length > 0){
      check($("#user_questionnaire_attributes_student_level").val());
    }
  }

});

