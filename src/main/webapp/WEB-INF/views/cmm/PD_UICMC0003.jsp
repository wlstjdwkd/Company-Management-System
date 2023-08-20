<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<!-- <script type="text/javascript" src="/script/java/deployJava.js"></script> -->
<!-- <script src="https://www.java.com/js/deployJava.js"></script> -->
</head>

<body>

<div id="pop_sys_code">

<script type="text/javascript">

// alert('aaa');
// var attributes = {
//         code:'EmbeddedViewerApplet.class', codebase:'/CertIssue', width:850, height:710,
//         archive:'CertIssue.jar,jasperreports-applet-5.6.1.jar,commons-logging-1.2.jar,commons-collections-3.2.1.jar'} ; 
        
// alert('aaa');        
// var parameters = {	
//     							jnlp_href: 'CertIssue_applet.jnlp',
//     							serviceName:'${inparam.serviceNm}',
//     							taskname:'${inparam.methodNm}',
//     							taskparam:'${inparam.issueNo}',
//     							jsessionid:'${pageContext.session.id}',
//     							} ; 
// alert('aaa');
// deployJava.runApplet(attributes, parameters, '1.4'); 

// function isFamilyVersionSupported() {
//     try {
//         return (new ActiveXObject("JavaPlugin.FamilyVersionSupport") != null);
//     } catch (exception) {
//         return false;
//     }
// }

// if( isFamilyVersionSupported() )
// { 
	document.write('<OBJECT ');
	document.write(' classid = "clsid:CAFEEFAC-0017-0000-FFFF-ABCDEFFEDCBA"');
	document.write(' codebase = "http://java.sun.com/update/1.7.0/jinstall-7u75-windows-i586.cab"');
	document.write(' WIDTH = "900" HEIGHT = "710" >');
	document.write(' <PARAM NAME = "CODE" VALUE = "EmbeddedViewerApplet.class" >');
	document.write(' <PARAM NAME = "CODEBASE" VALUE = "/CertIssue" >');
	document.write(' <PARAM NAME = "ARCHIVE" VALUE = "CertIssue.jar,jasperreports-applet-5.6.1.jar,commons-logging-1.2.jar,commons-collections-3.2.1.jar" >');
	document.write(' <PARAM NAME = "type" VALUE = "application/x-java-applet;jpi-version=1.7.0_75">');
	document.write(' <PARAM NAME = "scriptable" VALUE = "false">');
	document.write(' <PARAM NAME = "serviceName" VALUE ="${inparam.serviceNm}">');
	document.write(' <PARAM NAME = "taskname" VALUE ="${inparam.methodNm}">');
	document.write(' <PARAM NAME = "taskparam" VALUE ="${inparam.issueNo}">');
	document.write(' <PARAM NAME = "jsessionid" VALUE ="${pageContext.session.id}">');
	document.write(' <COMMENT>');
	document.write(' <EMBED type="application/x-java-applet" java_version="1.7.0_75" CODE="EmbeddedViewerApplet.class" CODEBASE="/CertIssue"  ARCHIVE = "CertIssue.jar,jasperreports-applet-5.6.1.jar,commons-logging-1.2.jar,commons-collections-3.2.1.jar"  WIDTH = "900"  HEIGHT = "710"  serviceName="${inparam.serviceNm}"  taskname="${inparam.methodNm}"   taskparam="${inparam.issueNo}"  jsessionid="${pageContext.session.id}" scriptable=true pluginspage="http://javadl.sun.com/webapps/download/GetFile/1.7.0_75-b13/windows-i586/xpiinstall.exe">');
	document.write(' <NOEMBED>');
	document.write(' </NOEMBED>');
	document.write(' </EMBED>');
	document.write(' </COMMENT>');
	document.write('</OBJECT>');
// }
// else
// {
	
// }

</script>

</div>

</body>
</html>