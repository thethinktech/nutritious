$(function () {
        // Remove Search if user Resets Form or hits Escape!
		$('body, .navbar-collapse form[role="search"] button[type="reset"]').on('click keyup', function(event) {
			if (event.which == 27 && $('.navbar-collapse form[role="search"]').hasClass('active') ||
				$(event.currentTarget).attr('type') == 'reset') {
				closeSearch();
			}
		});

		function closeSearch() {
            var $form = $('.navbar-collapse form[role="search"].active')
    		$form.find('input').val('');
			$form.removeClass('active');
			$('.search-button').removeClass('displayNone');
		}

		// Show Search if form is not active // event.preventDefault() is important, this prevents the form from submitting
		$(document).on('click', '.navbar-collapse form[role="search"]:not(.active) button[type="submit"]', function(event) {
			event.preventDefault();
			var $form = $(this).closest('form'),
				$input = $form.find('input');
			$form.addClass('active');
			$('.search-button').addClass('displayNone');
			$input.focus();

		});
		// ONLY FOR DEMO // Please use $('form').submit(function(event)) to track from submission
		// if your form is ajax remember to call `closeSearch()` to close the search container
		$(document).on('click', '.navbar-collapse form[role="search"].active button[type="submit"]', function(event) {
			event.preventDefault();
			var $form = $(this).closest('form'),
				$input = $form.find('input');
			$('#showSearchTerm').text($input.val());
            closeSearch()
		});
    });
	
	/********************** fliter product *********************/
	$(function() {
            $( "#slider-range" ).slider({
              range: true,
              min: 0,
              max: 500,
              values: [ 100, 300 ],
              slide: function( event, ui ) {
                $( "#amount" ).html( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
                $( "#amount1" ).val(ui.values[ 0 ]);
                $( "#amount2" ).val(ui.values[ 1 ]);
              }
            });
            $( "#amount" ).html( "$" + $( "#slider-range" ).slider( "values", 0 ) +
             " - $" + $( "#slider-range" ).slider( "values", 1 ) );
          });
	/*************** item select **********************************************/
	$(document).ready(function () {
    $('.accordion-toggle').on('click', function(event){
    	event.preventDefault();
    	// create accordion variables
    	var accordion = $(this);
    	var accordionContent = accordion.next('.accordion-content');
    	var accordionToggleIcon = $(this).children('.toggle-icon');
    	var accordionToggleFlower = $(this).children('.item_list_flower');
    	
    	// toggle accordion link open class
    	accordion.toggleClass("open");
    	// toggle accordion content
    	accordionContent.slideToggle(250);
    	
    	// change plus/minus icon
    	if (accordion.hasClass("open")) {
    		accordionToggleIcon.html("<img src='images/item_list_minus.png'>");
    		accordionToggleFlower.html("<img src='images/active_list_flower.png'>");
            
    	} else {
    		accordionToggleIcon.html("<img src='images/item_list_plus.png'>");
    		accordionToggleFlower.html("<img src='images/none_active_list_flower.png'>");
    	}
    });
});
$(window).load(function(){
	$('div.description').each(function(){
		$(this).css('opacity', 0);
		$(this).css('width', $(this).siblings('img').width());
		$(this).parent().css('width', $(this).siblings('img').width());
		$(this).css('display', 'block');
	});
	
	$('div.yummy-recipes-slidBox').hover(function(){
		$(this).children('.description').stop().fadeTo(500, 0.7);
	},function(){
		$(this).children('.description').stop().fadeTo(500, 0);
	});
	
});