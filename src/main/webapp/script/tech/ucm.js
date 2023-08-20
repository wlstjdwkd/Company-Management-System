// gnb
function gnb_menu(){
	$('.gnb_menu').hide(); //로딩후 서브메뉴숨김

	$('.gnb').mouseenter(function() { // 메뉴열림		
		$('.gnb_menu').stop(true,false).slideDown(300);
	});
	
	$('.gnb_menu').mouseleave(function(){ // 메뉴닫힘
		$('.gnb_menu').slideUp(300);
	});
	$('.quick').mouseenter(function() { // 메뉴닫힘
		$('.gnb_menu').slideUp(300);
	});
	$('#header').mouseleave(function() { // 메뉴닫힘
		$('.gnb_menu').stop(true,false).slideUp(300);
	});
}

//서브좌측메뉴_lnb
function lnb(){
	$(".lnb li").click(function(){	
		var $this = jQuery(this);
      	$this.parent("ul").children("li").removeClass("on");
      	$this.addClass("on");
		if($("+.lnb_menu2",this).css("display")=="none"){
			$(".lnb_menu2").slideUp("slow");
			$("+.lnb_menu2",this).slideDown("slow");
		}
		$(this).parent('ul').siblings('li').removeClass('on');
	});
	
	var $lnb_zone = jQuery(".lnb_zone");
	$(".lnb_menu2").css("display","none");
	
	//var cMenuNo = $('#df_menu_no').val();
	var cMenuNo = $('#disp_menu_no').val();	
	
	var dt = $('ul.lnb>li').filter('#'+cMenuNo);
	if(!Util.isEmpty(dt[0])){
		dt.addClass('on');
		dt.next('dd.lnb_menu2').css("display","block");
		return;
	}	
	
	var dts = $('ul.lnb>li');
	for(var i=0;i<dts.length;i++){
		var dt = $(dts[i]);
		var dd = dt.next();
		var li = dd.find('ul>li').filter('#'+cMenuNo);
		if(!Util.isEmpty(li[0])){
			dt.addClass('on');
			dt.next('dd.lnb_menu2').css("display","block");
			return;
		}
	}
	
	var dt = $('ul.lnb>li:first');
	dt.addClass('on');
	dt.next('li.lnb_menu2').css("display","block");

}


//Tab
function tabwrap(){
	var $tabwrap = jQuery(".tabwrap");
	$tabwrap.children('.tab').children('ul').children('li').click(function(){
		//alert(1)
		  var jQthis = jQuery(this);
		  var myindex = jQthis.index();
		  jQthis.parent('ul').children('li').removeClass('on');
		  jQthis.addClass('on');
		  jQthis.parent('ul').parent('.tab').parent('.tabwrap').children('div.tabcon').hide();
		  jQthis.parent('ul').parent('.tab').parent('.tabwrap').children('div.tabcon').eq(myindex).show();
		});
}

//고객지원:FAQ
function tbl_faq() {	
var faqlist = jQuery(".tbl_faq tr");
var faqindex = faqlist.index();
	faqlist.click(function(e){
	    var jQthis = jQuery(this);
		if(!jQthis.next('.viewtd').hasClass('active')){
			jQthis.next('.viewtd').addClass('active').show();
			jQthis.next('.viewtd').children().children('.listshow').show();
			//alert(1)
			jQthis.addClass('over');
		}
		else if(jQthis.next('.viewtd').hasClass('active')){
			jQthis.next('.viewtd').removeClass('active');
			jQthis.next('.viewtd').children().children('.listshow').hide();
			jQthis.removeClass('over');
		}
		e.preventDefault();
	});
}

//Tip
function tiptoggle() {
	$("dd.tip").css("display", "none");
	
	$("dt.tip").click(function(){
		if( $(this).next().css("display") == "none" ) {
			$(this).next().slideDown("fast");
			$(this).children(".openTip").hide();
			$(this).children(".closeTip").show();
		} else {
			$(this).next().slideUp("fast");
			$(this).children(".openTip").show();
			$(this).children(".closeTip").hide();
		}
	});
}

$(document).ready(function () {
	// gnb
	gnb_menu();
	
	var nolnb = document.getElementById('no_lnb');
	if(Util.isEmpty(nolnb)){
		// lnb
		lnb();
	}
});