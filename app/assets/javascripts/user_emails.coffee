$ ->
  checksendButton = ->
    if $('.user-id-checkbox:checked').length == 0
      $('#send-emails-button').prop 'disabled', true
    else
      $('#send-emails-button').prop 'disabled', false

  $('select#user-product-line-filter').change ->
    window.location = $(this).val()

  $('select#user-product-version-filter').change ->
    window.location = $(this).val()

  $('select#user-course-filter').change ->
    window.location = $(this).val()

  $('select#user-master-feature-filter').change ->
    window.location = $(this).val()

  $('select#user-enrolment-filter').change ->
    window.location = $(this).val()

  $('select#user-state-filter').change ->
    window.location = $(this).val()

  $(document).on 'click', '#select_all', ->
    status = $('#select_all').prop('checked')
    $('#select_all').parents('#user-mass-email-form').find(':checkbox.user-id-checkbox').prop 'checked', status
    checksendButton()

  $(document).on 'click', '.user-id-checkbox', ->
    if $('.user-id-checkbox:checked').length == $('.user-id-checkbox').length
      $('#select_all').prop 'checked', true
    else
      $('#select_all').prop 'checked', false

  $(document).on 'click', '.user-id-checkbox', ->
    checksendButton()
