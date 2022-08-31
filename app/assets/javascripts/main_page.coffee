$(document).on 'ready page:load', ->
  $('.essential_cont .arr_hde').show();
  $('.show_detail').hide();

  $('.essential_cont .arr_hde').click ->
    event.preventDefault();
    $('.essential_cont .arr_hde').fadeOut();
    $('.show_detail').fadeIn();

  $('.intrview_rdy_detail').click ->
    event.preventDefault();
    $('.essential_cont .arr_hde').fadeIn();
    $('.show_detail').fadeOut();

  $('.learn_btn_course.pckg_tbl_vce').click ->
    event.preventDefault();
    $('.vce.main-page.hover').fadeIn();

  $('.learn_btn_course.compare_tbl_vce').click ->
    event.preventDefault();
    $('.vce-provider.main-page.hover').fadeIn();

  $('.close-btn-vce').click ->
    event.preventDefault();
    $('.vce.main-page.hover').fadeOut();

  $('.close-btn-vce-provider').click ->
    event.preventDefault();
    $('.vce-provider.main-page.hover').fadeOut();

  $('.learn_btn_course.pckg_tbl_hsc').click ->
    event.preventDefault();
    $('.hsc.main-page.hover').fadeIn();

  $('.learn_btn_course.compare_tbl_hsc').click ->
    event.preventDefault();
    $('.hsc-provider.main-page.hover').fadeIn();

  $('.close-btn-hsc').click ->
    event.preventDefault();
    $('.hsc.main-page.hover').fadeOut();

  $('.close-btn-hsc-provider').click ->
    event.preventDefault();
    $('.hsc-provider.main-page.hover').fadeOut();

  $('.learn_btn_course.pckg_tbl_umat').click ->
    event.preventDefault();
    $('.umat.main-page.hover').fadeIn();

  $('.learn_btn_course.compare_tbl_umat').click ->
    event.preventDefault();
    $('.umat-provider.main-page.hover').fadeIn();

  $('.close-btn-umat').click ->
    event.preventDefault();
    $('.umat.main-page.hover').fadeOut();

  $('.close-btn-umat-provider').click ->
    event.preventDefault();
    $('.umat-provider.main-page.hover').fadeOut();

  $('.learn_btn_course.pckg_tbl_gamsat').click ->
    event.preventDefault();
    $('.gamsat.main-page.hover').fadeIn();

  $('.learn_btn_course.compare_tbl_gamsat').click ->
    event.preventDefault();
    $('.gamsat-provider.main-page.hover').fadeIn();

  $('.learn_link_course.compare_tbl_gamsat').click ->
    event.preventDefault();
    $('.gamsat-provider.main-page.hover').fadeIn();

  $('.learn_link_course.compare_tbl_umat').click ->
    event.preventDefault();
    $('.umat-provider.main-page.hover').fadeIn();

  $('.learn_link_course.compare_tbl_vce').click ->
    event.preventDefault();
    $('.vce-provider.main-page.hover').fadeIn();

  $('.learn_link_course.compare_tbl_hsc').click ->
    event.preventDefault();
    $('.hsc-provider.main-page.hover').fadeIn();


  $('.close-btn-gamsat').click ->
    event.preventDefault();
    $('.gamsat.main-page.hover').fadeOut();

  $('.close-btn-gamsat-provider').click ->
    event.preventDefault();
    $('.gamsat-provider.main-page.hover').fadeOut();
