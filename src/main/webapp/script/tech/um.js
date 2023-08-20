//메인_비쥬얼
var mainVisual = {};
mainVisual.changeType = function(ttype)
{
	//$("#container .contents").addClass("animate");
	
	$("#container .contents").data("targettype", ttype);
	$("#container .contents").data("running", "Y");
	$("#container .text01").removeClass("on").addClass("off");
	//$("#container .text01 .btnType").css("display", "none");	
	if(ttype!="01")
	{
		var xtype=(parseInt(ttype,10)-1);
		//$("#container .main0"+xtype+" .text01 .btnType").css("display", "block");
		
	}
	if(mainVisual.transpfx!="")
	{
		$("#container .contents").get(0).className = "contents animate type"+ttype;
	}
	else
	{
		//$("#container .text01 .btnType").stop();
		//$("#container .text01 .btnType").css("left", "-300px");
		
 		var dur = 500;
 		
 		switch(ttype)
		{
		case "01":
			$("#container .contents .main01,.main02,.main03").stop().animate({width:340}, dur, function(){
				$("#container .contents").get(0).className = "contents type01";
				mainVisual.onChangeTypeEnd();
			});
			$("#container .main01 .visual01").stop().animate({'background-position-x':"-280px"}, dur);
			$("#container .main01 .object01").stop().animate({'background-position-x':"90px"}, dur);
			$("#container .main02 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main02 .object01").stop().animate({'background-position-x':"80px"}, dur);
			$("#container .main03 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main03 .object01").stop().animate({'background-position-x':"-90px"}, dur);
			$("#container .objBgBox").css("display", "none");
			
			
			break;
		case "02":
			$("#container .main01").stop().animate({width:510}, dur, function(){
				$("#container .contents").get(0).className = "contents type02";
				mainVisual.onChangeTypeEnd();
			});
			$("#container .main02,.main03").stop().animate({width:255}, dur);
			$("#container .main01 .visual01").stop().animate({'background-position-x':"-380px"}, dur);
			$("#container .main01 .object01").stop().animate({'background-position-x':"210px"}, dur);
			$("#container .main02 .visual01").stop().animate({'background-position-x':"-100px"}, dur);
			$("#container .main02 .object01").stop().animate({'background-position-x':"20px"}, dur);
			$("#container .main03 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main03 .object01").stop().animate({'background-position-x':"-90px"}, dur);
			$("#container .objBgBox").css("display", "block");
			$("#container .main01 .objBgBox").css("display", "none");
			break;
		case "03":
			$("#container .main02").stop().animate({width:510}, dur, function(){
				$("#container .contents").get(0).className = "contents type03";
				mainVisual.onChangeTypeEnd();
			});
			$("#container .main01,.main03").stop().animate({width:255}, dur);	
			$("#container .main01 .visual01").stop().animate({'background-position-x':"-280px"}, dur);
			$("#container .main01 .object01").stop().animate({'background-position-x':"50px"}, dur);
			$("#container .main02 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main02 .object01").stop().animate({'background-position-x':"170px"}, dur);
			$("#container .main03 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main03 .object01").stop().animate({'background-position-x':"-130px"}, dur);
			$("#container .objBgBox").css("display", "block");
			$("#container .main02 .objBgBox").css("display", "none");
			break;
		case "04":
			
			$("#container .main03").stop().animate({width:510}, dur, function(){
				$("#container .contents").get(0).className = "contents type04";
				mainVisual.onChangeTypeEnd();
			});
			$("#container .main01,.main02").stop().animate({width:255}, dur);
			$("#container .main01 .visual01").stop().animate({'background-position-x':"-280px"}, dur);
			$("#container .main01 .object01").stop().animate({'background-position-x':"50px"}, dur);
			$("#container .main02 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main02 .object01").stop().animate({'background-position-x':"20px"}, dur);
			$("#container .main03 .visual01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .main03 .object01").stop().animate({'background-position-x':"0px"}, dur);
			$("#container .objBgBox").css("display", "block");
			$("#container .main03 .objBgBox").css("display", "none");
			break;
		}
	}
};
mainVisual.onBtnShowEnd = function()
{
	
	//$("#container .contents .btnType").removeClass("animate5");
	
};
mainVisual.onChangeTypeEnd = function()
{
	var curtype="";
	var dur = 500;
	if($("#container .contents").data("running")!="Y")
		return;
	
	curtype=$("#container .contents").data("targettype");
	
	
	//$("#container .contents .btnType").css("display", "block");
	$("#container .contents").data("running", "N");
	if(curtype!="")
	{
		//console.debug(curtype);
		if(curtype!="01")
		{
			var xtype=(parseInt(curtype,10)-1);
			$("#container .contents .main0"+xtype+" .text01").removeClass("off").addClass("on");
			if(mainVisual.transpfx != "")
			{
				//console.debug("#container .contents .main0"+xtype+" .btnType");
				//$("#container .contents .btnType").removeClass("animatebtn");
				
				//$("#container .contents .main0"+xtype+" .btnType").addClass("animatebtn");
				
			}
			else
			{
				//$("#container .contents .main0"+xtype+" .btnType").animate({left:0}, dur);
			}
		}
	}
};
mainVisual.init = function () {
	mainVisual.transpfx = "";
	var obj = document.createElement('div');
	var props = ['perspectiveProperty', 'WebkitPerspective', 'MozPerspective', 'OPerspective', 'msPerspective'];
	for (var i in props) {
		if ( !(typeof obj.style[ props[i] ]=="undefined" || obj.style[ props[i] ]==null) ) {
		  mainVisual.transpfx = props[i].replace('Perspective','').toLowerCase();
		  break;
		}
	}
	//transpfx = "";
	
	$("#container .contents").mouseleave(function () {
		mainVisual.changeType('01');
	});
	$("#container .contents td").mouseenter(function () {
		mainVisual.changeType("0"+(parseInt(this.className.replace("main", ""),10)+1));
	});
	if(mainVisual.transpfx!="")
	{
		$("#container .contents").bind("mozTransitionEnd webkitTransitionEnd transitionend", mainVisual.onChangeTypeEnd);
		//$("#container .contents .btnType").bind("mozTransitionEnd webkitTransitionEnd transitionend", mainVisual.onBtnShowEnd);
	}
};


//메인_롤링베너
var rollzoneWhich = 1;
var rollzoneTimer;
var totalSize =3;

function forwardrollzone(){
    for (var i=1;i<=totalSize;i++) {
        var fldbtn = document.getElementById("rollzone-h"+(i));
        fldbtn.className = (i == rollzoneWhich) ? 'on' : '';
        var fld = document.getElementById("rollzone-c"+(i));
        fld.style.display = (i == rollzoneWhich) ? 'block' : 'none';
    }
    rollzoneWhich++;
    if (rollzoneWhich > totalSize) rollzoneWhich = 1;
}
function forwardrollzoneDirect(no){
    Stoprollzone();
    for (var i=1;i<=totalSize;i++) {
        var fldbtn = document.getElementById("rollzone-h"+(i));
        fldbtn.className = (i == no) ? 'on' : '';
        var fld = document.getElementById("rollzone-c"+(i));
        fld.style.display = (i == no) ? 'block' : 'none';
    }
    rollzoneWhich = no+1;
    if (rollzoneWhich > totalSize) rollzoneWhich = 1;
}
function Stoprollzone() {
    clearInterval(rollzoneTimer);
    $("#rbn_play").attr("src","../../images/ma/rollbn_next.png");
    $("#rbn_stop").attr("src","../../images/ma/rollbn_stop_on.png");
}
function Startrollzone() {
    Stoprollzone();
    rollzoneTimer = setInterval('forwardrollzone()',3000);
    $("#rbn_play").attr("src","../../images/ma/rollbn_next_on.png");
    $("#rbn_stop").attr("src","../../images/ma/rollbn_stop.png");
}
