$(document).ready(function () {
  'use strict';
  $('.hoverDiagram map area').each(function () {
    var title = $(this).attr('href');
    $(this).qtip({
      content: {
        text: $('div' + title).html()
      },
      position: {
        my: 'bottom center',
        at: 'top center'
      }
    });
  });
  var defaultTooltip = $('#default').qtip('api');
  if (defaultTooltip) {
    defaultTooltip.toggle(true);
  }
  var firstView = true;
  $('.hoverDiagram').mouseenter(function() {
    if (firstView) {
      defaultTooltip.toggle(false);
    }
    firstView = false;
  });
});
