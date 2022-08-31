$("#filterrific_with_tutor").empty()
  .append("<%= escape_javascript(render(:partial => @tutors)) %>")