<!--
  KOSIS OpenAPI를 이용하여 통계목록을 생성하는 예제입니다.
   이 소스는 KOSIS API를 사용하는데 참고가 되도록 제공하는 것으로
  사용자의 운영환경에 따라 수정작업이 필요합니다

  * 유의사항 : Ajax를 활용하여 개발을 진행하실 때에는 CrossDomain으로 인한
     통신문제가 발생 할 수 있습니다.
      JSON 방식으로 제공받으실 때에는 개발홈페이지에 임의의 jsp를 생성하여
     호출함으로써 CrossDomain에 대한 제약을 우회하실 수 있는 개발소스를 제공합니다.
-->
 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <%@ page contentType="text/html; charset=utf-8" %>

 <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
 <head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <title>통계청 - 공유서비스</title>

 <link type="text/css" rel="stylesheet" media="all" href="http://kosis.kr/openapi/ext/style/subCommon.css" />
 <link type="text/css" rel="stylesheet" media="all" href="http://kosis.kr/openapi/devGuide/devGuide01/css/openTmp.css" />

 <script type="text/javascript" language="JavaScript" src="http://kosis.kr/openapi/devGuide/devGuide01/js/dojo.js" ></script>
 <script type="text/javascript" language="JavaScript" src="http://kosis.kr/openapi/devGuide/devGuide01/js/json.js" ></script>
 <script type="text/javascript" language="JavaScript" src="http://kosis.kr/openapi/devGuide/devGuide01/js/ajax.js"></script>
 <script type="text/javascript" language="JavaScript">

 var mapData;

 // window onload 되었을때 실행 함수
dojo.addOnLoad ( function() { 

 // 통계목록 리스트를 조회하기위해 함수를 호출한다.
getSubList("MT_ZTITLE", 0, "K2_350");
 });

 /****************************************************
 * 통계목록 리스트 조회 함수
* parameter : vwcd - 서비스뷰 코드 (통계목록구분)
 * listLev - 목록 레벨
* parentId - 시작목록 Id
 ****************************************************/
 function getSubList(vwcd, listLev, parentId) {

 // ajax 통신을 위한 파라메터를 변수에 담는다.
var paraObj = {
 // 임의의 jsp 페이지를 호출함으로써 cross domain 제약을 우회할 수 있다. (devGuidePop.jsp 소스는 소스 하단에 제공)
url : "/PGTS0006.do?df_method_nm=testImport&method=getList&key=MzJjZDNmYTViNDk2NWQxOTA5Yzg0NTU0ZDdlM2FlMjk=&vwcd=" + vwcd + "&parentId=" + parentId + "&type=json",
 sync : true,
 load : function(resObj, a, b) { mapData = resObj; },
 error : function ( resObj, e ) { alert(dojo.toJson(resObj)); }
 }

 // ajax 통신 호출 함수
sendPost( paraObj );

 // 통계목록 리스트를 화면에 출력하기 위한 함수 
makeNode( Number(listLev) + 1 );
 } 

 /****************************************************
 * 통계목록 리스트를 화면에 출력하기 위한 함수
* parameter : listLev - 목록 레벨
****************************************************/
function makeNode(listLev) {

 var nodeInfo="";

 nodeInfo = nodeInfo+"<ul>";

 for(var cnt=0; cnt<mapData.length; cnt++) {
 nodeInfo = nodeInfo + "<li>";
 if ( mapData[cnt].TBL_ID != null ) {
 nodeInfo = nodeInfo + "<img src='http://kosis.kr/openapi/devGuide/devGuide01/image/stats.gif'> <a target='_balnk' href=\"http://kosis.kr/start.jsp?orgId="+mapData[cnt].ORG_ID+"&tblId="+mapData[cnt].TBL_ID+"&vw_cd="+mapData[cnt].VW_CD+"&up_id="+mapData[cnt].UP_ID+"\">"+mapData[cnt].TBL_NM+"</a>" ; 
 } else { 
 nodeInfo = nodeInfo + "<img src='http://kosis.kr/openapi/devGuide/devGuide01/image/folder.gif'> <a href=\"javascript:getSubList('"+mapData[cnt].VW_CD+"', '" + listLev + "', '"+mapData[cnt].LIST_ID+"');\">"+mapData[cnt].LIST_NM+"</a>" ;
 }
 nodeInfo = nodeInfo + "</li>"; 
 }
 nodeInfo = nodeInfo+"</ul>";

 var r_node = document.getElementById("content"); //
 var v_node = document.getElementById("depth"+listLev);
 if( (typeof(v_node)!="undefined") && v_node!=null) {
 v_node.innerHTML = nodeInfo;
 }
 else { 
 v_node = document.createElement("div");
 v_node.setAttribute("id", "depth"+listLev);
 v_node.className = "category0"+listLev;
 v_node.innerHTML = nodeInfo;
 r_node.appendChild(v_node);
 }

 var nodeCount = document.getElementsByTagName("div").length;

 for( var cnt=(Number(listLev)+1); cnt< nodeCount; cnt++) {
 if(document.getElementById("depth"+cnt)!=null) 
 r_node.removeChild(document.getElementById("depth"+cnt));
 }
 }
 </script>
 </head>
 <body>
 <div id="content" ></div>
 </body>
 </html>