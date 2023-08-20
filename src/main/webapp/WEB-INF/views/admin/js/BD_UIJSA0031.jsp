<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ap" uri="http://www.tech.kr/jsp/jstl" %>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>확정판정상세보기</title>
<ap:jsTag type="web" items="jquery,tools,ui,validate,form,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="acm,msg,util" />

<script type="text/javascript">
	// 검색
	function fn_search() {
		$("#df_method_nm").val("selectEntprsInfoList");
		$("#df_curr_page").val("1");
		$("#dataForm").submit();
	}
	
	// 확정판정 사유등록
	function popDcsnJdgmntResn(hpeCd) {
	    $.colorbox({
	        title : "확정판정보기 및 등록",
	        href : "${svcUrl}?df_method_nm=selectDcsnJdgmntResn&ad_hpe_cd="+hpeCd+"&ad_stdyy="+$("#ad_stdyy").val(),
	        width : "550",
	        height : "430",
	        overlayClose : false,
	        escKey : false,
	        iframe : true
	    });
	}
</script>

</head>
<body>
    <div id="wrap">
        <div class="wrap_inn">
    		<!--//content-->
            <div class="contents">
                <!--// 타이틀 영역 -->
                <h2>확정판정상세보기</h2>
                <!-- 타이틀 영역 //-->
                
                <form name="dataForm" id="dataForm" action="<c:url value='${svcUrl}'/>" method="post">
				<ap:include page="param/defaultParam.jsp" />
				<ap:include page="param/dispParam.jsp" />
				<ap:include page="param/pagingParam.jsp" />
				
				<input type="hidden" name="ad_stdyy" id="ad_stdyy" value="${param.ad_stdyy }" />
				
                <div class="search_top">
                    <table cellpadding="0" cellspacing="0" class="table_search" summary="조회 조건">
                        <caption>
                        조회 조건
                        </caption>
                        <colgroup>
                        <col width="15%" />
                        <col width="*" />
                        <col width="15%" />
                        <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">검색어</th>
                                <td>
                                    <select name="ad_searchCondition" title="검색조건" id="ad_searchCondition" style="width:100px">
                                        <option <c:if test="${param.ad_searchCondition eq 'entrprsNm' }">selected="selected"</c:if> value="entrprsNm">업체명</option>
                                        <option <c:if test="${param.ad_searchCondition eq 'jurirno' }">selected="selected"</c:if> value="jurirno">법인등록번호</option>
                                        <option <c:if test="${param.ad_searchCondition eq 'bizrno' }">selected="selected"</c:if> value="bizrno">사업자번호</option>
                                    </select>
                                    <input name="ad_searchKeyword" type="text" class="text" id="ad_searchKeyword" style="width:150px;" title="검색어" placeholder="검색어를 입력하세요" value="${param.ad_searchKeyword }" />
                                </td>
                            </tr>
                            <tr>
                              <th scope="row">시스템판정구분</th>
                              <td><input type="radio" name="ad_searchGubun" id="ad_searchGubun_A" value="A"<c:if test="${param.ad_searchGubun eq 'A' }"> checked</c:if> />
                                  <label for="ad_searchGubun_A">전체</label>
                                   <input type="radio" name="ad_searchGubun" id="ad_searchGubun_S" value="S" class="mgl50"<c:if test="${param.ad_searchGubun eq 'S' }"> checked</c:if> />
                                  <label for="ad_searchGubun_S">시스템판정</label>
                                  <input type="radio" name="ad_searchGubun" id="ad_searchGubun_M" value="M" class="mgl50"<c:if test="${param.ad_searchGubun eq 'M' }"> checked</c:if> />
                                  <label for="ad_searchGubun_M">확정판정</label>
                                  <p class="btn_src_zone"><a href="#none" class="btn_search" onclick="fn_search();">조회</a></p>
                                  </td>
                          </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                
                <div class="block">
					<ap:pagerParam addJsRowParam="null,'selectEntprsInfoList'"/>	
                    <!--// 리스트 -->
                    <div class="list_zone">
                        <table cellspacing="0" border="0" summary="시스템 판정 리스트" class="list">
                            <caption>
                            시스템 판정 리스트
                            </caption>
                            <colgroup>
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            <col width="*" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기준년도</th>
                                    <th scope="col">법인번호</th>
                                    <th scope="col">사업자번호</th>
                                    <th scope="col">업체명</th>
                                    <th scope="col">시스템판정</th>
                                    <th scope="col">확정판정</th>
                                    <th scope="col">시스템판정사유</th>
                                    <th scope="col">확정판정사유</th>
                                    <th scope="col">확정판정 및 사유등록</th>
                                </tr>
                            </thead>
                            <tbody>
							<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
							<c:if test="${fn:length(entprsList) == 0}">
								<tr>
									<td colspan="8"><spring:message code="info.nodata.msg" /></td>
								</tr>
							</c:if>
							<%-- 데이터를 화면에 출력해준다 --%>				
                            <c:forEach items="${entprsList}" var="info" varStatus="status">
                                <tr>
                                    <td>${info.stdyy }</td>
                                    <td>${info.jurirno }</td>
                                    <td>${info.bizrno }</td>
                                    <td class="tal"><c:out value="${info.entrprsNm }" /></td>
                                    <td>${info.sysHpeAtNm }</td>
                                    <td>${info.dcsnHpeAtNm }</td>
                                    <td><c:out value="${info.sysResnNm }" /></td>
                                    <td><c:out value="${info.mResnNm }" /></td>
                                    <td><div class="btn_inner"><a href="#none" class="btn_in_gray" id="btn_resn_${info.hpeCd }" onclick="popDcsnJdgmntResn('${info.hpeCd }');"><span>보기/등록</span></a></div></td>
                                </tr>
							</c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 리스트// -->
                    <div class="mgt10"></div>
                    <ap:pager pager="${pager}" addJsParam="'selectEntprsInfoList'" />
                </div>
                <!--리스트영역 //-->
            </div>
        </div>
        <!--content//-->
    </div>
</body>
</html>