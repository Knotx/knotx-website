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
});