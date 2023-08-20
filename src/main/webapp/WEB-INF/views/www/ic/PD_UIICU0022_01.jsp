<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<div class="con" id="div_fnnrinfo_con">
<div class="table_hrz">
    <!--//table1-->
    <table class="table_basic" >
        <caption> 
        재무정보년도별입력테이블
        </caption>
        <colgroup>
        <col style="width:*" />
        <col style="width:90px" />
        <col style="width:90px" />
        <col style="width:90px" />
        <col style="width:90px" />
        <col style="width:90px" />
        <col style="width:90px" />
        </colgroup>
        <thead>
        	<tr>
	       		<th>&nbsp;</th>
	            <th class="tac">매출액</th>
	            <th class="tac">자본금</th>
	            <th class="tac">자본잉여금</th>
	            <th class="tac">자본총계</th>
	            <th class="tac">자산총액</th>
	            <th class="tac">상시근로자수</th>
	         </tr>
         </thead>
            <tbody>
        	<c:forEach var="n" begin="0" end="3">
        		<c:set var="year" value="${lastYear-n}" />
        		<tr>
                <th scope="row">
                	<c:if test="${n eq 0}">
                	<label for="t3_info2"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />
                	</c:if>
                	${year}년 
                	<a href="#none" class="btn_code" onclick="getEntFnnr('ho','${year}')">
                		<img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" />
                	</a>
                	</label>
                </th>
                <td><input <c:if test="${n eq 0}">required </c:if> class="-numeric18" id="ad_selng_am_ho_${year}" name="ad_selng_am_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년매출액" /></td>
                <td><input <c:if test="${n eq 0}">required </c:if> class="-numeric18" id="ad_capl_ho_${year}" name="ad_capl_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년자본금" /></td>
                <td><input <c:if test="${n eq 0}">required </c:if> class="-numeric18" id="ad_clpl_ho_${year}" name="ad_clpl_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년자본잉여금" /></td>
                <td><input <c:if test="${n eq 0}">required </c:if> class="-numeric18" id="ad_capl_sm_ho_${year}" name="ad_capl_sm_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년자본총계" /></td>
                <td><input <c:if test="${n eq 0}">required </c:if> class="-numeric18" id="ad_assets_totamt_ho_${year}" name="ad_assets_totamt_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년자산총액" /></td>
                <td><input <c:if test="${n eq 0}">required </c:if> <c:if test="${year>2013}">disabled</c:if> class="numeric10" id="ad_ordtm_labrr_co_ho_${year}" name="ad_ordtm_labrr_co_ho_${year}" class="-numeric18" type="text" style="width:70px;" title="${year}년상시근로자수" /></td>
            </tr>
			</c:forEach>            
        </tbody>
    </table>
</div>

<div class="mgt12">
    <!--//table2-->
    <table class="table_basic table_type">
        <caption>
        년도별제출서류입력테이블
        </caption>
        <colgroup>        
        <col style="width:99px" />
        <col style="width:95px" />
        <col style="width:*" />
  		</colgroup>
        <tbody>
        <tr>
        <th scope="row">제출서류2)</th>
	        <th >국내법인</th>
	        <td>직전 3개 사업연도 감사보고서 원본1부<br />
								(재무제표, 세법이 정하는 회계장부, 「주식회사의 외부감사에 관한 법률」제 8조에 따라 제출한 감사 보고서 등)
								직전 3개 사업연도 내에 감사가 진행되었던 년도의 보고서만 업로드 하시면 됩니다.
			</td>
        </tr>
        <c:forEach var="n" begin="0" end="3">
        	<c:set var="year" value="${lastYear-n}" />
        	<tr>
		        <th scope="row"  colspan="2"><label for="add_t3_info3"> ${year}년</label></th>
		        <td>
		        	<input name="file_ho_rf1_${year}" type="file" id="file_ho_rf1_${year}" style="width:100%;" title="파일첨부" />
		        </td>
       		</tr>
		</c:forEach>
        </tbody>
    </table>
</div>
</div>