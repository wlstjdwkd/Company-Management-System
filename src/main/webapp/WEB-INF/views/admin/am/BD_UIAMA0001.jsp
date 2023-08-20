<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>정보</title>
<ap:jsTag type="web" items="jquery,toos,ui,form,validate,notice,msgBoxAdmin,colorboxAdmin" />
<ap:jsTag type="tech" items="msg,util,acm,am" />
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function fn_board_ask() {
		$("#menuForm").append('<input type="hidden" id="ad_board_bbsCd"  name="ad_board_bbsCd"  value="1005" />' );
		jsMoveMenu('32','64','PGMS0080', 'index', 'menuForm');
	}
	
	function fn_board_ask_2() {
		$("#menuForm").append('<input type="hidden" id="ad_board_bbsCd"  name="ad_board_bbsCd"  value="1005" />' );
		$("#menuForm").append('<input type="hidden" id="ad_board_filter"  name="ad_board_filter"  value="Y" />' );
		jsMoveMenu('32','64','PGMS0080', 'index', 'menuForm');
	}
	
	function fn_board_data() {
		$("#menuForm").append('<input type="hidden" id="ad_board_bbsCd"  name="ad_board_bbsCd"  value="1006" />' );
		jsMoveMenu('32','64','PGMS0080', 'index', 'menuForm');
	}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <input type="hidden" id="no_lnb" value="true" />
    <!--//content-->
    <div id="wrap">
        <div class="wrap_inn">
            <div class="contents_main">
                <!--// 타이틀 영역 -->
                <h2 class="menu_title_line">정보 <span class="name">관리자</span></h2>
                <!-- 타이틀 영역 //-->
                <!--// 첫번째 단락 -->
                <div class="main_block">
                    <ul>
                        <li class="left">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#none" onclick="jsMoveMenu('28','113','PGIM0010')">확인서신청 처리현황</a></h3>
                                <table>
                                    <caption>
                                    확인서신청 처리현황 리스트
                                    </caption>
                                    <colgroup>
                                    <col style="width:20%">
                                    <col style="width:20%">
                                    <col style="width:20%">
                                    <col style="width:20%">
                                    <col style="width:*">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">접수(발급신청)</th>
                                            <th scope="col">접수(내용변경)</th>
                                            <th scope="col">보완접수</th>
                                            <th scope="col">검토중</th>
                                            <th scope="col">보완검토중</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><fmt:formatNumber value = "${cntConfirmReceive1}" pattern = "#,##0"/></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntConfirmReceive2}" pattern = "#,##0"/></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntConfirmSupplement}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntConfirmReview1}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntConfirmReview2}" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                        <li class="right">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#none" onclick = "jsMoveMenu('31', '102', 'PGSO0100')">기업시책(RSS) 처리현황</a></h3>
                                <table>
                                    <caption>
                                    기업시책(RSS) 처리현황 리스트
                                    </caption>
                                    <colgroup>
                                     <col style="width:50%">
                                     <col style="width:50%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">사업공고</th>
                                            <th scope="col">신규</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><fmt:formatNumber value = "${cntSuportList}" pattern = "#,##0"/></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntFinishRss}" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                    </ul>
                </div>
                <!--// 두번째 단락 -->
                <div class="main_block">
                    <ul>
                        <li class="left">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#" onclick ="fn_board_ask();">묻고답하기 처리현황</a></h3>
                                <table>
                                    <caption>
                                    묻고답하기 처리현황 리스트
                                    </caption>
                                    <colgroup>
                                     <col style="width:33%">
                                     <col style="width:33%">
                                   <col style="width:*">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">접수(미답변)</th>
                                            <th scope="col">답변중</th>
                                            <th scope="col">완료</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><a href="#" onclick ="fn_board_ask_2();"><fmt:formatNumber value = "${cntQaReceive}" pattern = "#,##0"/></a></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntQaOngoing}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntQaFinish}" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                        <li class="right">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#none" onclick ="fn_board_data();">자료요청 처리현황</a></h3>
                                <table>
                                    <caption>
                                    자료요청 처리현황 리스트
                                    </caption>
                                    <colgroup>
                                    <col style="width:33%" />
                                    <col style="width:33%" />
                                    <col style="width:33%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">접수(미답변)</th>
                                            <th scope="col">답변중</th>
                                            <th scope="col">완료</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><fmt:formatNumber value = "${cntRequestReceive}" pattern = "#,##0"/></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntRequestOngoing}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntRequestFinish}" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                    </ul>
                </div>
                <!--// 세번째 단락 -->
					<div class="main_block">
						<ul>
							<li class="left">
								<!--// 리스트 -->
								<div class="list_zone">
									<h3>
										<a href="#none" onclick="jsMoveMenu('28', '116', 'PGIM0040')">위변조 신고내역</a>
									</h3>
									<table>
										<caption>위변조 신고내역 리스트</caption>
										<colgroup>
											<col style="width: 50%">
											<col style="width: 50%">
										</colgroup>
										<thead>
											<tr>
												<th scope="col">최근 1주일</th>
												<th scope="col">누적</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td><fmt:formatNumber value="${cntDocReportLately }" pattern="#,##0" /></td>
												<td class="tac"><fmt:formatNumber value="${cntDocReport}" pattern="#,##0" /></td>
											</tr>
										</tbody>
									</table>
								</div> <!-- 리스트// -->
							</li>

							<!--//네번째 단락 -->

							<li class="right">
								<div class="list_zone">
									<h3>
										<a href="#none"
											onclick="jsMoveMenuURL('32', '121', 'PGCMMON0140', 'PGCMMON0140.do?df_method_nm=processVisitStats')">방문현황</a>
									</h3>
									<table>
										<caption>방문현황 리스트</caption>
										<colgroup>
											<col style="width: 33%" />
											<col style="width: 33%" />
											<col style="width: 34%" />
										</colgroup>
										<thead>
											<tr>
												<th scope="col">전일</th>
												<th scope="col">금월</th>
												<th scope="col">총누적</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td><fmt:formatNumber value="${cntYesterVisit}" pattern="#,##0" /></td>
												<td class="tac"><fmt:formatNumber value="${cntTodayVisit}" pattern="#,##0" /></td>
												<td><fmt:formatNumber value="${cntVisit}" pattern="#,##0" /></td>
											</tr>
										</tbody>
									</table>
								</div>
						</ul>
					</div>
					<!-- 리스트// -->
					</li>
                  <div class="main_block">
                     <ul>
                         <li class="left">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#none" onclick ="jsMoveMenu('32','48','PGCMUSER0010')">회원가입현황</a></h3>
                                <table>
                                    <caption>
                                    회원가입현황 리스트
                                    </caption>
                                    <colgroup>
                                    <col style="width:25%">
                                    <col style="width:25%">
                                    <col style="width:25%">
                                    <col style="width:25%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">회원구분</th>
                                            <th scope="col">최근일주일</th>
                                            <th scope="col">한달</th>
                                            <th scope="col">누적</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>개인회원</td>
                                            <td class="tac"><fmt:formatNumber value = "${cntGnWeekUser}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntGnMonUser}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntGnUser}" pattern = "#,##0"/></td>
                                        </tr>
                                        <tr>
                                            <td>기업회원</td>
                                            <td class="tac"><fmt:formatNumber value = "${cntEpWeekUser}" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntEpMonUser }" pattern = "#,##0"/></td>
                                            <td><fmt:formatNumber value = "${cntEpUser }" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                        <li class="right">
                            <!--// 리스트 -->
                            <div class="list_zone">
                                <h3><a href="#none" onclick="jsMoveMenu('32', '145', 'PGCMUSER0100')">정보변경신청</a></h3>
                                <table>
                                    <caption>
                                    정보변경신청
                                    </caption>
                                    <colgroup>
                                    <col style="width:50%">
                                    <col style="width:50%">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">접수</th>
                                            <th scope="col">완료</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="tac"><fmt:formatNumber value = "${cntNewChanger}" pattern = "#,##0"/></td>
                                            <td class="tac"><fmt:formatNumber value = "${cntChanger}" pattern = "#,##0"/></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- 리스트// -->
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--content//-->
</form>
</body>
</html>