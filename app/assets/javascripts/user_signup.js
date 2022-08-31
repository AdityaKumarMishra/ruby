$(document).ready( function () {
  displayStaffFields();
  circleImageClick();
  deletePhoto();

  // TODO make work for manager as well
  function displayStaffFields() {
    if( ($('#user_role').val() == 'tutor') || ($('#user_role').val() == 'manager')) {
      $("#staff_attributes").show();
      $("#staff_attributes .remove input[type=hidden]").val(0);
    }
    else {
      $("#staff_attributes .remove input[type=hidden]").val(1);
      $("#staff_attributes").hide();
    }
    $('#user_role').on('change', function() {
      if ( (this.value == 'tutor') || (this.value == 'manager'))
      {
        $("#staff_attributes").show();
        $("#staff_attributes .remove input[type=hidden]").val(0);
      }
      else
      {
        $("#staff_attributes .remove input[type=hidden]").val(1);
        $("#staff_attributes").hide();
      }
    });
  }

  function circleImageClick () {
    $('.deleteImage').hide();
    $('.imagePreview').click(function() {
        $(this).attr('disabled', 'true');
        $('#uploadImage').trigger('click');
    });
    $('#user_photo').on('change', function(){
        $('.imagePreview').removeAttr('disabled');
        readURL(this);
    });
  }

  function readURL(input) {
      if (input.files && input.files[0]) {
          var reader = new FileReader();
          var img = new Image(200,200);

          reader.onload = function (e) {
              img.src = e.target.result;
              $('.imagePreview').css('background', 'url(' + img.src + ')');
              $('.imagePreview').css('background-size', '200px');
              $('.imagePreview').css('background-repeat', 'no-repeat');
              $('.imageUpload, .uploadClick').hide();
          }
          $('.deleteImage').show();

          reader.readAsDataURL(input.files[0]);
      }
  }
  function deletePhoto () {
      $('.deleteImage').click(function() {
          $('.deleteImage').hide();
          $('#uploadImage').val('');
          $('.imagePreview').css('background', '');
          $('.imageUpload, .uploadClick').show();
      });
  }

});



