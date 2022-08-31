$(document).ready(function() {
  var product_to_color = {"gamsat": "green", "umat": "blue", "vce":"purple", "hsc":"red"};

  // Declare functions to alternate colors
  function alternateColors(product_line, prev_color) {
    var all_icons = ['heart', 'rocket', 'crosshairs', 'share', 'comment'];

    var title = document.getElementById('title');
    var text = document.getElementsByClassName('text');
    // Switch title color
    title.className -= " u-text-" + prev_color;
    title.className += " u-text-" + product_to_color[product_line];

    for (var i = 0; i < all_icons.length; i++) {
      var icon = document.getElementById(all_icons[i] + '-icon');
      removeClass(icon, prev_color);
      icon.className += ' ' + product_to_color[product_line];
    }
    prev_color = product_to_color[product_line];
  }

  // Declared function to remove class from element
  function removeClass(el, className) {
    if (el.classList)
      el.classList.remove(className)
    else if (hasClass(el, className)) {
      var reg = new RegExp('(\\s|^)' + className + '(\\s|$)')
      el.className=el.className.replace(reg, ' ')
    }
  }

  $('#aboutCarousel').carousel();
  $('.item1').click(function() {
    $('#aboutCarousel').carousel(0);
  });
  $('.item2').click(function() {
    $('#aboutCarousel').carousel(2);
  });
  $('.item3').click(function() {
    $('#aboutCarousel').carousel(3);
  });
  $('.item4').click(function() {
    $('#aboutCarousel').carousel(1);
  });

  var prev_color = null;
  var products = ['gamsat', 'umat', 'vce', 'hsc'];
  // Adjust colors based on active items
  if ( $('li.item1').hasClass('active') ) {
    alternateColors(products[0], prev_color);
    prev_color = 'green';
  }
  else if ( $('li.item2').hasClass('active') ) {
    alternateColors(products[1], prev_color);
    prev_color = 'blue';
  }
  else if ( $('li.item3').hasClass('active') ) {
    alternateColors(products[2], prev_color);
    prev_color = 'purple';
  }
  else if ( $('li.item4').hasClass('active') ) {
    alternateColors(products[3], prev_color);
    prev_color = 'red';
  }

  // Left right buttons
  $('.left').click(function() {
    $('#aboutCarousel').carousel('prev');
  });
  $('.right').click(function() {
    $('#aboutCarousel').carousel('next');
  });
});