<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" >
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,jBox" />
<%-- <ap:jsTag type="tech" items="msg,util" /> --%>
<ap:globalConst />
<c:set var="fnnrHTML" value="${sessionScope[SESSION_FNNRHTML_NAME]}" />
<style type="text/css">
body { font-size: 12px; }
body, div, dl, dt, dd, ul, li {	
	margin:0; 
	padding:0; 
	vertical-align: text-top; 
}
ul { margin:0px; }
ul li { 
	list-style:none; 
	border-bottom:1px dotted #777;
	vertical-align:middle;
	padding:8px;	
}
a:link {
	color:black;
	text-decoration:none;
	border-bottom:none;
}
a:visited {
	color:black;
	text-decoration:none;
	border-bottom:none;
}
</style>
<script type="text/javascript">

var layerTable = 	"<ul style='width:120px;'>"+
					"<li><a href='#none' class='ltb' onclick='setAmount(\"selng_am\");'>매출액</a></li>"+
					"<li><a href='#none' class='ltb' onclick='setAmount(\"capl\");'>자본금</a></li>"+
					"<li><a href='#none' class='ltb' onclick='setAmount(\"clpl\");'>자본잉여금</a></li>"+
					"<li><a href='#none' class='ltb' onclick='setAmount(\"capl_sm\");'>자본총계</a></li>"+
					"<li><a href='#none' class='ltb' onclick='setAmount(\"assets_totamt\");'>자산총액</a></li>"+
					"</ul>";					

$(document).ready(function(){
	myBox =	new jBox('Modal', {
		width: 150,
		title: '재무정보',
		overlay: false,
		createOnInit: true,
		content: layerTable,
		repositionOnOpen: false,
		repositionOnContent: false,
		reposition: true,
		position: {
			x: 'left',
			y: 'top'
		},
		blockScroll:false,
		fixed: false
		
	});

	$(".amount").on("click",function(){
		myBox.open();
		myBox.position({target: $(this)});
	});
	
});

function setAmount(type){
	var id = "${param.id}";
	var yr = "${param.yr}";
	
	var taget = myBox.target;
	var amount = taget.text();
	// 콤마 제거
	amount = amount.replace(/,/g, "");
	// 음수 처리
	if(amount.indexOf("(")!=-1||amount.indexOf(")")!=-1){
		amount = amount.replace(/\(/, "");
		amount = amount.replace(/\)/, "");
		amount = "-"+amount;
	}
	/* 
	if(id=="ho"){
		amount = amount.substr(0,amount.length-3);
	}else{
		amount = amount.substr(0,amount.length-6);
	}
	 */
	var $doc= $(window.opener.document);
	var elem = "ad_"+type+"_"+id+"_"+yr;
	
	var $el = $doc.find("#"+elem);
	$el.val(amount);
	
	window.opener.evalSelingAmRelateSumAvg(elem);
	
	//$( "#foo" ).trigger( "click" );
	
	myBox.close();
}
</script>
</head>
<body>

${fnnrHTML}

</body>
</html>