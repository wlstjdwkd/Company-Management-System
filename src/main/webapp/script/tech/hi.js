//기업범위
function roll(){
    var itemBody = jQuery('.roll_zone'),
	//active = itemBody.find('.prod:first'),
    item = itemBody.find('.prod'),
	//itemSize=itemBody.find('.prod').size(),
	ayear=itemBody.find('.year_con:first'),
	year=itemBody.find('.year_con'),
	pleft=itemBody.find('.pleft'),
	pright=itemBody.find('.pright');
	//active.addClass('active');

	pright.click(function(e){
		//alert(8);
			active = itemBody.find('.prod.active').next();
		    item.removeClass('active');
       	    active.addClass('active');
       	    ayear = itemBody.find('.year_con.active').next();
       	    year.removeClass('active');
       	    ayear.addClass('active');
			if ( active.length === 0) {
				active = itemBody.find('.prod:first');
				active.addClass('active');
				ayear = itemBody.find('.year_con:first');
				ayear.addClass('active');
			}
			e.preventDefault();
		});
	pleft.click(function(e){
			active = itemBody.find('.prod.active').prev();
		    item.removeClass('active');
       	    active.addClass('active');
       	    ayear = itemBody.find('.year_con.active').prev();
       	    year.removeClass('active');
       	    ayear.addClass('active');
			if ( active.length === 0) {
				active = itemBody.find('.prod:last');
				active.addClass('active');
				ayear = itemBody.find('.year_con:last');
				ayear.addClass('active');
			}
			e.preventDefault();
		});
}
