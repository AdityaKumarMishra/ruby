# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.lesson-form').on 'cocoon:after-insert', (e, insertedItem) ->
    insertedItem.find('.course_lessons_date input').datepicker({"format": "yyyy-mm-dd", "autoclose": true})