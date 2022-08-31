# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.datepicker').datepicker({"format": "yyyy-mm-dd", "autoclose": true, orientation: 'bottom'});

$(document).on 'change', '#filterrific_subjects', (evt) ->
  $.ajax 'update_tutors_select',
    type: 'GET'
    dataType: 'script'
    data: {
      select_id: $("#filterrific_subjects option:selected").val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      console.log("Dynamic country select OK!")
