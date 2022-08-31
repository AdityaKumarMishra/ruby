$(document).ready(function(){
    $("#autoemail-form").validate({
        rules: {
            "autoemail[title]": {required:true},
            "autoemail[subject]": {required:true},
            "autoemail[content]": {required: true},
            "autoemail[greeting]": {required: true}
        },
        messages: {
        }
    });

  jQuery.validator.addMethod("notUpdated", function(value, element) {
    // var mcqStem = $('#mcq_stem_id');
    // var mcqStemId;
    // if(mcqStem.length > 0){
    //     mcqStemId = mcqStem.val();
    // }
    // if (mcqStemId != undefined) {
        return value != 'not_started'
    // }
    // else
    // {
    //     return true
    // }
  }, "Update the work status value");
})