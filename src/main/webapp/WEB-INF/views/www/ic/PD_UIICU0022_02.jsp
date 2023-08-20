<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>

<div class="con" id="div_rabrr_con">
    <div class="table_hrz">
        <p class="mb7">매월말일 기준의 상시근로자수를 입력해 주세요.<span class="fr">[단위 : 명]</span></p>
        <!--//table1-->
        <table cellpadding="0" cellspacing="0" class="table_basic" summary="상시근로자수" >
            <caption>
            상시근로자수년도별입력테이블
            </caption>
            <colgroup>
            <col style="width:*" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            <col style="width:39px" />
            </colgroup>
            <thead>
            <th></th>
                <th>1</th>
                <th>2</th>
                <th>3</th>
                <th>4</th>
                <th>5</th>
                <th>6</th>
                <th>7</th>
                <th>8</th>
                <th>9</th>
                <th>10</th>
                <th>11</th>
                <th>12</th>
                <th>합계</th>
                <th>연평균</th>
                </thead>
            <tbody>
            	<c:forEach var="n" begin="0" end="3">
        		<c:set var="year" value="${lastYear-n}" />
        		<c:if test="${year<=2013}" >
        		<tr>
                    <th scope="row"><label>${year}년</label></th>
					<td><input name="ad_ordtm_labrr_co1_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co1_ho_${year}" style="width:25px;" title="${year}년1월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co2_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co2_ho_${year}" style="width:30px;" title="${year}년2월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co3_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co3_ho_${year}" style="width:30px;" title="${year}년3월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co4_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co4_ho_${year}" style="width:30px;" title="${year}년4월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co5_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co5_ho_${year}" style="width:30px;" title="${year}년5월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co6_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co6_ho_${year}" style="width:30px;" title="${year}년6월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co7_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co7_ho_${year}" style="width:30px;" title="${year}년7월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co8_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co8_ho_${year}" style="width:30px;" title="${year}년8월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co9_ho_${year}"  class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co9_ho_${year}" style="width:30px;" title="${year}년9월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co10_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co10_ho_${year}" style="width:30px;" title="${year}년10월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co11_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co11_ho_${year}" style="width:30px;" title="${year}년11월상시근로자수" /></td>
					<td><input name="ad_ordtm_labrr_co12_ho_${year}" class="numeric10 labbr" type="text" id="ad_ordtm_labrr_co12_ho_${year}" style="width:30px;" title="${year}년12월상시근로자수" /></td>
                    <td>
                    	<strong id="ordtm_labrr_sum_ho_${year}"></strong>
						<input type="hidden" name="ad_ordtm_labrr_sum_ho_${year}" id="ad_ordtm_labrr_sum_ho_${year}" />
                    </td>
                    <td>
                    	<strong id="ordtm_labrr_avg_ho_${year}"></strong>
                    	<input type="hidden" name="ad_ordtm_labrr_avg_ho_${year}" id="ad_ordtm_labrr_avg_ho_${year}" />
                    </td>
                </tr>
                </c:if>
        		</c:forEach>                
            </tbody>
        </table>
    </div>
    
    <!--//table2-->
    <div class="mgt12">
        <table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="제출서류" >
            <caption>
            년도별제출서류입력테이블
            </caption>
            <colgroup>
            <col style="width:13%" />
            <col style="width:39px" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><label for="t4_info6">제출서류</label></th>
                    <td>월별 원천징수이행상황신고서 원본1부</td>
                </tr>
                <c:forEach var="n" begin="0" end="3">
        		<c:set var="year" value="${lastYear-n}" />
        		<c:if test="${year<=2013}" >
        		<tr>
                    <th scope="row"><label> ${year}년</label></th>
                    <td colspan="4">
                    	<input name="file_ho_rf0_${year}" type="file" id="file_ho_rf0_${year}" style="width:500px;" title="파일첨부" />
                    </td>
                </tr>
        		</c:if>
        		</c:forEach>
                                
            </tbody>
        </table>
    </div>
</div>