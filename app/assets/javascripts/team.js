$(function() {
  $('#team-selection ul li').on('click', function(){
    var category = $(this).data('category')
    $(this).addClass('active')
    $(this).siblings().removeClass('active')
    if(category == "all"){
      $("#team-images a").removeClass('filterImage');
    }else{
      $("#team-images a:not([data-category=" + category + "])").addClass('filterImage');
      $("#team-images a[data-category=" + category + "]").removeClass('filterImage');
    }
  })
});