// Freelancer Theme JavaScript

(function($) {
    "use strict"; // Start of use strict

    hljs.initHighlightingOnLoad();
    
    // hljs
    $(document).ready(function() {
      $('pre code').each(function(i, block) {
        hljs.highlightBlock(block);
        $(this).parent().css("word-wrap", "normal");
        $(this).css("white-space", "pre");
      });
    });    

    // Highlight the top nav as scrolling occurs
    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 51
    });

    // Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function(){ 
            $('.navbar-toggle:visible').click();
    });
    
})(jQuery); // End of use strict
