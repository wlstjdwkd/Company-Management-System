//성장촉진기본계획 추진전략 서브tab
function tabwrap_sub(){
	var $tabwrap_sub = jQuery(".tabwrap_sub");
	$tabwrap_sub.children('.tab_sub').children('ul').children('li').click(function(){
		//alert(1)
		  var jQthis = jQuery(this);
		  var myindex = jQthis.index();
		  jQthis.parent('ul').children('li').removeClass('on');
		  jQthis.addClass('on');
		  jQthis.parent('ul').parent('.tab_sub').parent('.tabwrap_sub').children('div.tabcon_sub').hide();
		  jQthis.parent('ul').parent('.tab_sub').parent('.tabwrap_sub').children('div.tabcon_sub').eq(myindex).show();
		});
}
