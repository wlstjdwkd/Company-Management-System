<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,notice,msgBoxAdmin" />
<ap:jsTag type="tech" items="msg,util,acm,im" />
<ap:globalConst />	
<script type="text/javascript">
$(document).ready(function(){

});

function savePartclrMatter(){
	var ad_rcept_no = $("#ad_rcept_no").val();
	var ad_partclr_matter = $("#ad_partclr_matter").val();
	$.ajax({
        url      : "PGIM0010.do",
        type     : "POST",
        dataType : "text",
        data     : { df_method_nm : "updatePartclrMatter", ad_rcept_no:ad_rcept_no, ad_partclr_matter:ad_partclr_matter },                
        async    : false,                
        success  : function(response) {
        	try {
        		if(eval(response)){
        			jsMsgBox(null,'info',Message.msg.successSave,function(){
        				parent.$.colorbox.close();
        			});
        		}else{
        			jsMsgBox(null,'info',Message.msg.failSave);
        		}
            } catch (e) {
                if(response != null) {
                	jsSysErrorBox(response);
                } else {
                    jsSysErrorBox(e);
                }
                return;
            }
        }
    });
}
</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post" action="/PGIM0010.do">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />
<ap:include page="param/pagingParam.jsp" />
<input type="hidden" id="no_lnb" value="true" />
<input type="hidden" id="ad_rcept_no" value="${partclrMatter.RCEPT_NO}" />

<div id="self_dgs">
<div class="pop_q_con">   
   
   <table cellpadding="0" cellspacing="0" class="table_basic" summary="신청담당자정보보기">
        <caption>
       신청담당자정보
        </caption>
        <colgroup>
        <col width="20%" />
        <col width="*" />
        </colgroup>
        <tbody>
            <tr>
                <th scope="row">접수서류<br />
                특이사항</th>
                <td class="right_line"><textarea name=ad_partclr_matter id="ad_partclr_matter" cols="85" rows="10" title="내용입력란"  style="width:95%;" placeholder="특이사항 입력">${partclrMatter.PARTCLR_MATTER}</textarea></td>
            </tr>
        </tbody>
    </table>
    <div class="btn_page_last"><a class="btn_page_admin" href="#none" onclick="savePartclrMatter()"><span>저장</span></a> </div> 
   
</div>
</div>
</form>
</body>
</html>