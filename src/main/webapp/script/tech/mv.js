//모바일 좌측메뉴
$(function() {
    /*menu*/
   // $("aside #menu").css("height", body_h);
    $(".btn_s_menu").click(function(e){
        $("#s_menu div.smenu_wrap").animate({ 'left':'0'},500);
        //'easeOutExpo'
        //$("#s_menu div.menu").show(); // 갤럭시S3 에서 백화현상이 발생하는 오류 있음
        $("#s_menu div.smenu_dimm").show();
        //$("aside #menu").css("height", h);
        //var aside_h =  h+158;
        $("#container").css('position','fixed');
        FuncPreventEvent(e);
        return false;
    });
    $("#s_menu .smenu_dimm .smenu_close").bind('touchstart', hideSideMenu, false);
    $("#s_menu .smenu_wrap .smenu_close").bind('dragstart', hideSideMenu, false);
    $("#s_menu .smenu_dimm, .smenu_close").bind('mousedown', hideSideMenu);

    $("#pageTitle").text(document.title);
    
    
    function hideSideMenu(e) {
        $("#s_menu div.smenu_wrap").animate({ 'left':'-100%'},500);
        //$("#s_menu div.menu").hide(); // 갤럭시S3 에서 백화현상이 발생하는 오류 있음
        $("#s_menu div.smenu_dimm").hide();
        $("#container").css('position','relative');
        FuncPreventEvent(e);
        return false;
    }
});

//기업범위
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
$(document).ready(function () { 
    tabwrap();
});

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
$(document).ready(function(){   
    roll();
});

function addBookmark() {
	if (window.sidebar && window.sidebar.addPanel) { // Mozilla Firefox Bookmark
		window.sidebar.addPanel(document.title,window.location.href,'');
	} else if(window.external && ('AddFavorite' in window.external)) { // IE Favorite
		window.external.AddFavorite(location.href,document.title); 
	} else if(window.opera && window.print) { // Opera Hotlist
		this.title=document.title;
		return true;
	} else { // webkit - safari/chrome
		alert('Press ' + (navigator.userAgent.toLowerCase().indexOf('mac') != - 1 ? 'Command/Cmd' : 'CTRL') + ' + D to bookmark this page.');
	}
}