<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>	
<ap:jsTag type="web" items="jquery, form" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util, hi" />

<script type="text/javascript">
$(document).ready(function(){
	
	$(".s_cont01_0_1").click(function(){
		$(".s_cont01_02").show()
		$(".s_cont01_03").hide();
		$(".s_cont01_04").hide();
	});

	$(".s_cont01_0_2").click(function(){
		$(".s_cont01_02").hide();
		$(".s_cont01_03").show()
		$(".s_cont01_04").hide();
	});

	$(".s_cont01_0_3").click(function(){
		$(".s_cont01_02").hide();
		$(".s_cont01_03").hide();
		$(".s_cont01_04").show()
	});
});

function openTab(val) {
	$(".tabwrap > .tab > ul > li").removeClass('on');
	$(".tabwrap > div.tabcon").hide();

	$(".tabwrap > .tab > ul > li").each(function(){
		if (jQuery(this).index() == (val-1)) jQuery(this).addClass("on");
	});
	$(".tabwrap > div.tabcon").each(function(){
		if (jQuery(this).index() == val) jQuery(this).show();
	});

}


</script>
</head>

<body>
<form name="dataForm" id="dataForm" method="post">
<ap:include page="param/defaultParam.jsp" />
<ap:include page="param/dispParam.jsp" />

<!--//content-->
<div id="wrap">
	<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit01">
			<h1>기업현황</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit">기업현황</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont01_02">
					<div class="s_tabMenu">
						<ul>
							<li class="on"><a href="#none" class="s_cont01_0_1" alt="업종별 규모기준">업종별 규모기준</a></li>
							<li><a href="#none" class="s_cont01_0_2" alt="자산총액 기준">자산총액 기준</a></li>
							<li><a href="#none" class="s_cont01_0_3" alt="독립성기준">독립성기준</a></li>
						</ul>
					</div>
					<table class="table_bl">
						<colgroup>
							<col width="414px">
							<col width="128px">
							<col width="175px">
							<col width="170px">
						</colgroup>
						<div class="list_bl bg_gray">
						<div class="left">
							<h3>공통안내</h3>
						</div>
						<div class="right">
							<p><span style=color:#2763ba;><strong>※ 주된 업종의 판단</strong></span>
							<p>&emsp;하나의 기업(법인)이 2개 이상의 업종을 영위하는 경우에는 손익계산서의 매출액 비중이 가장 큰 업종을 해당 기업의<br/> &emsp;주된 업종으로 하며,
							     관계기업 제도 적용에 있어서는 지배기업과 종속기업 중에서 매출액이 큰 기업의 주된 업종을 <br/>&emsp;지배기업과 종속기업의 주된 업종으로 간주합니다. </p><br/>
							<p> * 주된 업종 판단은 매출액이 가장 큰 업종을 기준으로 하나, 업종별 규모기준(3년평균매출액등)을 적용할 때는
							      주된 업종만의 <br/> &nbsp;&nbsp;&nbsp;매출액이 아닌 전체 매출액이 주된 업종의 규모기준을 충족하는지 판단해야 합니다.</p><br/>
							<p><span style=color:#2763ba;><strong>※ 한국표준산업분류상 주된업종 분류기호(코드) 확인 방법</strong></span></p>
							<p>&emsp;가. 통계분류포털(https://kssc.kostat.go.kr:8443) 접속</p>
							<p>&emsp;나. 경제부문 - 한국표준산업분류(KSIC) 선택</p>
							<p>&emsp;다. 검색 - 분류내용보기(해설서) 선택</p>
							<p>&emsp;라. 팝업창에서 검색어(키워드) 입력</p>
							<p>&emsp;마. 결과의 분류코드(5자리) 中 앞 2자리로 판단</p>
							<p>&emsp;(예) 분류코드가 28302인 경우, 앞 2자리는 28에 해당<br/>&emsp;&emsp;28은 C제조업(10~34)에 해당하므로, C28이 주된업종에 해당</p><br/>
							<p><span style="color:#2763ba;"> <span style="font-weight:bold;">※ 기업 확인서는 기업이 제출한 서류를 바탕으로 판단하며, 아래 '가,나' 조건을 모두 충족할 경우에 발급됩니다.</span></<br/>
							<p>&emsp;가. 기업 범위 충족 (기업 제외대상은 기업 확인서 발급 불가)</p>
							<p>&emsp;나. 기업 기준 충족 (업종별 규모기준, 상한기준, 독립성기준 중 1가지 이상 충족)</span></p>
						</div>
				</div>
						
						<thead>
							<tr>
								<th rowspan="2">해당 기업의 주된 업종</th>
								<th rowspan="2">분류기호</th>
								<th colspan="2" style="padding: 9px;">규모기준</th>
							</tr>
							<tr>
								<th style="padding: 9px;">
									기업<br/>
									<span style="font-size:13px; color:#2763ba;">(기업 확인서 발급 기준)</span>
								</th>
								<th style="padding: 9px;">
									기업 후보기업<br/>
									<span style="font-size:13px; color:#2763ba;">(중소기업 확인서 발급)</span>
									</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="t_left">1. 의복, 의복액세서리 및 모피제품 제조업 　</td>
								<td>C14</td>
								<td rowspan="6" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>1,500억원초과</td>
								<td rowspan="6" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>1,000억원이상</td>
							</tr>
							<tr>
								<td class="t_left">2. 가죽, 가방 및 신발 제조업</td>
								<td>C15</td>
							</tr>
							<tr>
								<td class="t_left">3. 펄프, 종이 및 종이제품 제조업</td>
								<td>C17</td>
							</tr>
							<tr>
								<td class="t_left">4. 1차 금속 제조업 </td>
								<td>C24</td>
							</tr>
							<tr>
								<td class="t_left">5. 전기장비 제조업</td>
								<td>C28</td>
							</tr>
							<tr>
								<td class="t_left">6. 가구 제조업 </td>
								<td>C32</td>
							</tr>
							<tr>
								<td class="t_left">7. 농업, 임업 및 어업 </td>
								<td>A</td>
								<td rowspan="18" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>1,000억원 초과</td>
								<td rowspan="18" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>700억원 이상</td>
							</tr>
							<tr>
								<td class="t_left">8. 광업 </td>
								<td>B</td>
							</tr>
							<tr>
								<td class="t_left">9. 식료품 제조업</td>
								<td>C10</td>
							</tr>
							<tr>
								<td class="t_left">10. 담배 제조업</td>
								<td>C12</td>
							</tr>
							<tr>
								<td class="t_left">11. 섬유제품 제조업(의복 제조업은 제외) </td>
								<td>C13</td>
							</tr>
							<tr>
								<td class="t_left">12. 목재 및 나무제품 제조업(가구 제조업은 제외) </td>
								<td>C16</td>
							</tr>
							<tr>
								<td class="t_left">13. 코크스, 연탄 및 석유정제품 제조업</td>
								<td>C19</td>
							</tr>
							<tr>
								<td class="t_left">14. 화학물질 및 화학제품 제조업(의약품 제조업은 제외)</td>
								<td>C20</td>
							</tr>
							<tr>
								<td class="t_left">15. 고무제품 및 플라스틱제품 제조업 </td>
								<td>C22</td>
							</tr>
							<tr>
								<td class="t_left">16. 금속가공제품 제조업(기계 및 가구 제조업은 제외) </td>
								<td>C25</td>
							</tr>
							<tr>
								<td class="t_left">17. 전자부품, 컴퓨터, 영상, 음향 및 통신장비 제조업</td>
								<td>C26</td>
							</tr>
							<tr>
								<td class="t_left">18. 그 밖의 기계 및 장비 제조업 </td>
								<td>C29</td>
							</tr>
							<tr>
								<td class="t_left">19. 자동차 및 트레일러 제조업 </td>
								<td>C30</td>
							</tr>
							<tr>
								<td class="t_left">20. 그 밖의 운송장비 제조업 </td>
								<td>C31</td>
							</tr>
							<tr>
								<td class="t_left">21. 전기, 가스, 증기 및 공기조절 공급업 </td>
								<td>D</td>
							</tr>
							<tr>
								<td class="t_left">22. 수도업</td>
								<td>E36</td>
							</tr>
							<tr>
								<td class="t_left">23. 건설업 </td>
								<td>F</td>
							</tr>
							<tr>
								<td class="t_left">24. 도매 및 소매업</td>
								<td>G</td>
							</tr>
							<tr>
								<td class="t_left">25. 음료 제조업 </td>
								<td>C11</td>
								<td rowspan="9" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>800억원 초과</td>
								<td rowspan="9" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>550억원 이상</td>
							</tr>
							<tr>
								<td class="t_left">26. 인쇄 및 기록매체 복제업</td>
								<td>C18</td>
							</tr>
							<tr>
								<td class="t_left">27. 의료용 물질 및 의약품 제조업 </td>
								<td>C21</td>
							</tr>
							<tr>
								<td class="t_left">28. 비금속 광물제품 제조업 </td>
								<td>C23</td>
							</tr>
							<tr>
								<td class="t_left">29. 의료, 정밀, 광학기기 및 시계 제조업</td>
								<td>C27</td>
							</tr>
							<tr>
								<td class="t_left">30. 그 밖의 제품 제조업</td>
								<td>C33</td>
							</tr>
							<tr>
								<td class="t_left">31. 수도, 하수 및 폐기물 처리, 원료재생업(수도업은 제외)</td>
								<td>E(E36 제외)</td>
							</tr>
							<tr>
								<td class="t_left">32. 운수 및 창고업</td>
								<td>H</td>
								<!-- <td rowspan="8" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>600억원 초과</td>
								<td rowspan="8" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>400억원 이상</td> -->
							</tr>
							<tr>
								<td class="t_left">33. 정보통신업</td>
								<td>J</td>
							</tr>
							<tr>
								<td class="t_left">34. 산업용 기계 및 장비 수리업</td>
								<td>C34</td>
								<td rowspan="6" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>600억원 초과</td>
								<td rowspan="6" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>400억원 이상</td>
							</tr>
							<tr>
								<td class="t_left">35. 전문, 과학 및 기술 서비스업 </td>
								<td>M</td>
							</tr>
							<tr>
								<td class="t_left">36. 사업시설관리, 사업지원 및 임대 서비스업(임대업은 제외) </td>
								<td>N(N76 제외)</td>
							</tr>
							<tr>
								<td class="t_left">37. 보건업 및 사회복지 서비스업 </td>
								<td>Q</td>
							</tr>
							<tr>
								<td class="t_left">38. 예술, 스포츠 및 여가 관련 서비스업 </td>
								<td>R</td>
							</tr>
							<tr>
								<td class="t_left">39. 수리(修理) 및 기타 개인 서비스업 </td>
								<td>S</td>
							</tr>
							<tr>
								<td class="t_left">40. 숙박 및 음식점업</td>
								<td>I</td>
								<td rowspan="5" style="line-height: 25px; padding-bottom: 33px;">3년평균매출액등<br/>400억원 초과</td>
								<td rowspan="5" style="line-height: 25px; padding-bottom: 33px;">매출액<br/>300억원 이상</td>
							</tr>
							<tr>
								<td class="t_left">41. 금융 및 보험업 </td>
								<td>K</td>
							</tr>
							<tr>
								<td class="t_left">42. 부동산업</td>
								<td>L</td>
							</tr>
							<tr>
								<td class="t_left">43. 임대업 </td>
								<td>N76</td>
							</tr>
							<tr>
								<td class="t_left">44. 교육 서비스업</td>
								<td>P</td>
							</tr>
						</tbody>
					</table>
					<table class="note">
						<colgroup>
							<col width="84">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>비고</th>
								<td>
									<ol>
										<li>해당 기업의 주된 업종의 분류 및 분류기호는 「통계법」 제22조에 따라 통계청장이 고시한 한국표준산업분류에 따른다.</li>
										<li>위 표 제19호 및 제20호에도 불구하고 자동차용 신품 의자 제조업(C30393), 철도 차량 부품 및 관련 장치물 제조업(C31202) 중 <br>철도 차량용 의자 제조업, 항공기용 부품 제조업(C31322) 중 항공기용 의자 제조업의 규모 기준은 평균매출액등 1,500억원 초과로 한다.</li>
									</ol>
								</td>
							</tr>
						</tbody>
					</table>
					<!-- <p class="list_noraml">중소기업에서 기업이 된 경우, 중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어<br> 이를 대비하고자 3년간 중소기업과 동등한 지원을 받을 수 있도록 유예기간 부여</p> -->
					
				</div>
				<div class="r_cont s_cont01_03" style="display:none;">
					<div class="s_tabMenu">
						<ul>
							<li><a href="#none" class="s_cont01_0_1" alt="업종별 규모기준">업종별 규모기준</a></li>
							<li class="on"><a href="#none" class="s_cont01_0_2" alt="자산총액 기준">자산총액 기준</a></li>
							<li><a href="#none" class="s_cont01_0_3" alt="독립성기준">독립성기준</a></li>
						</ul>
					</div>
					<p class="list_noraml">해당기업의 자산총액 5천억원 이상인 경우 기업 기준 충족</p>
					<table class="table_bl">
						<colgroup>
							<col width="50%">
							<col width="50%">
						</colgroup>
						<tbody>
							<tr>
								<th>직전사업연도가 있는 기업 </th>
								<td>직전 사업연도 말 재무상태표 상의 자산총계</td>
							</tr>
							<tr>
								<th>해당 사업연도에 창업 · 분할 · 합병한 기업</th>
								<td>창업 · 분할 · 합병 당시 현재의 자산총액</td>
							</tr>
						</tbody>
					</table>
					<!-- <p class="list_noraml">중소기업에서 기업이 된 경우, 중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어<br/> 이를 대비하고자 3년간 중소기업과 동등한 지원을 받을 수 있도록 유예기간 부여</p> -->
					<!-- <div class="list_bl bg_gray">
						<div class="left">
							<h3>공통안내</h3>
						</div>
						<div class="right">
							<p><strong>* 중소기업 유예기간</strong></p>
							<p>중소기업에서 기업이 된 경우, 중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하고자 3년간 중소기업과 동등한 지원을 받을 수 있도록 유예기간 부여</p>
						</div>
					</div> -->
				</div>
				<div class="r_cont s_cont01_04" style="display:none;">
					<div class="s_tabMenu">
						<ul>
							<li><a href="#none" class="s_cont01_0_1" alt="업종별 규모기준">업종별 규모기준</a></li>
							<li><a href="#none" class="s_cont01_0_2" alt="자산총액 기준">자산총액 기준</a></li>
							<li class="on"><a href="#none" class="s_cont01_0_3" alt="독립성기준">독립성기준</a></li>
						</ul>
					</div>
				<!-- <div class="list_bl bg_gray">
						<div class="left">
							<h3>공통안내</h3>
						</div>
						<div class="right">
							<p><strong>* 중소기업 유예기간</strong></p>
							<p>중소기업에서 기업이 된 경우, 중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하고자 3년간 중소기업과 동등한 지원을 받을 수 있도록 유예기간 부여</p>
						</div>
				</div> -->
					<p class="bg_txt">5,000억 원이상//자산총액 5,000억원 이상 법인이 30% 이상 출자한 기업//간접적소유관계//30% 이상//직접적소유관계//30% 이상//직접적소유관계</p>
					<p class="list_noraml">자산총액 5천억원 이상 10조원 미만인 법인이 주식등을 직∙간접적으로 30%이상 소유하면서 최다출자 자인 경우 업종에 상관없이<br> 기업 기준 충족</p>
					<p class="list_noraml">관계기업에 속하는 기업의 경우 출자 비율에 해당하는 3년 평균매출액을 합산하여 기업 업종별 규모기준을 초과하는 경우<br> 기업 기준 충족 <br/>(지배기업은 「주식회사의 외부감사에 관한 법률」 제2조에 따른 외부감사대상기업)</p>
					<p class="bg_txt">관계기업 제도 적용 예제1//A기업(외감기업)//B기업//10%//갑(개인)//갑의 친족//30% & 최다출자자//A기업이 특수관계자(갑 및 갑의 친족과 환산하여 B기업의 주식 등을 30%이상 소유하면서 최대 출자자 관계기업 성립</p>
					<p class="bg_txt">관계기업 제도 적용 예제2//A기업(외감기업)//자회사 50%//기업 5%, 25%//30% & 최다출자자//A기업이 자회사와 합산하여 B회사의 주식 등을 30% 이상 소유하면서 최다출자자 관계기업 성립</p>
					<p class="bg_txt">관계기업 제도 적용 예제3//A기업(외감기업)10%//자회사 50%//갑(개인)//갑의 친족//B기업 10%, 10%, 5%, 5%//30% & 최다출자자//A기업이 자회사 및 특수관계자와 합산하여 B기업의 주식 등을 30%이상 소유하면서 최다 출자자 관계기업 성립</p>
				
				</div>
				
			</div>
		</div>
	</div>
</div>
<!--content//-->
</form>
</body>
</html>