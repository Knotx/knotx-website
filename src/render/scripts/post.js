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
})(jQuery); // End of use strict
