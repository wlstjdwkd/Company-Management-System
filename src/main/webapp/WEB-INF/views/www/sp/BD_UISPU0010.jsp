<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<ap:globalConst />
<c:set var="svcUrl" value="${requestScope[SVC_URL_NAME]}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery, form,validate" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, msg,util, sp" />

<script type="text/javascript">
	$(document).ready(function() {
		
		$(".s_cont03_0_1").click(function(){
			$(".s_cont03_02").hide();
			$(".s_cont03_03").hide();
			$(".s_cont03_01").show();
		})
		
		$(".s_cont03_0_2").click(function(){
			$(".s_cont03_01").hide();
			$(".s_cont03_03").hide();
			$(".s_cont03_02").show();
		})
		
		$(".s_cont03_0_3").click(function(){
			$(".s_cont03_01").hide();
			$(".s_cont03_02").hide();
			$(".s_cont03_03").show();
		})
	});
	
	// 첨부파일 다운로드
	function downAttFile(fileSeq){
		jsFiledownload("/PGCM0040.do","df_method_nm=updateFileDownBySeq&seq="+fileSeq);
	}
	
	function fileDown(){
	    window.open("down.jsp","down","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrolling=no,width=1,height=1,top=0,left=0");
	}
	
	
	/* function openTab(val) {
		$(".tabwrap > .tab > ul > li").removeClass('on');
		$(".tabwrap > div.tabcon").hide();

		$(".tabwrap > .tab > ul > li").each(function(){
			if (jQuery(this).index() == (val-1)) jQuery(this).addClass("on");
		});
		$(".tabwrap > div.tabcon").each(function(){
			if (jQuery(this).index() == val) jQuery(this).show();
		});

	} */
	
	
	
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		
<input type="hidden" id="df_method_nm" name="df_method_nm" value="" />
		
<input type="hidden" id="disp_pmenu_no" name="df_pmenu_no" value="9" />
<input type="hidden" id="disp_menu_no" name="df_menu_no" value="10" />
		<!--//content-->
		<div id="wrap">
			<div class="s_cont" id="s_cont">
		<div class="s_tit s_tit03">
			<h1>기업정책</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit3">기업정책</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont03_03">
					<div class="s_tabMenu s_3tabMenu">
						<ul>
							<li class="on"><a href="#none" class="s_cont03_0_3" alt="제2차 기업 성장촉진 시행계획">제2차 기업 성장촉진 시행계획 (2020.2)</a></li>
							<li><a href="#none" class="s_cont03_0_2" alt="2019년 기업 성장촉진 시행계획">2019년 기업 성장촉진 시행계획 (2019.2)</a></li>
							<li><a href="#none" class="s_cont03_0_1" alt="기업 비전 2280">기업 비전 2280 (2018.2)</a></li>
						</ul>
					</div>
					
					<div class="cont_sec01">
						<div class="blu_circle">
							<h1>VISION</h1>
							<h2>기업이 이끄는 <br/>혁신·포용성장 실현</h2>
						</div>
					</div>

					
					<div class="cont_sec02">
						<h3 class="title">목표</h3>
						<div class="cont">
							<table>
								<caption>기업 비전 2280 목표</caption>
								<colgroup>
									<col width="370px">
									<col width="21px">
									<col width="370px">
								</colgroup>
								<thead>
									<tr>
										<th>기업 수</th>
										<th class="gap"></th>
										<th>전체 기업 중 중견 매출액 비중</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><p>산업혁신을 선도하는 경쟁력 있는 기업 육성</p><span>*매출액 3천억원 이상 기업 : ('18) 4,635 → ('24) 6,000</span></td>
										<td class="gap"></td>
										<td><p>기업 주도 경제활력 제고</p><span>*기업 수출액(억불) : ('18) 982 → ('24) 1,200</span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
			
					<!-- <div class="cont_sec01">
						<h3 class="title">기본방향</h3>
						<div class="cont">
							<p>기업이 산업·지역 내 핵심주체로 역할하도록 뒷받침</p>
							<p>성장단계·유형별 맞춤형 지원을 통해 정책효과 극대화</p>
							<p>기업의 자발적인 투자와 혁신역량 제고 활동 유도</p>
							
						</div>
					</div> -->
					<div class="cont_sec03">
						<h3 class="title">기본방향</h3>
					</div>
					<div class="acc_sec acc_sec02">
						<div class="add_tit">
							<table>
								<tbody>
								
									<tr>
										<td>기본 방향</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="add_cont">
							<table>
								
								<tbody>
									<tr>
										<td>
											<ul>
												<li>기업이 <strong>산업·지역 내  핵심주체</strong>로 역할하도록 뒷받침</li>
												<li>성장단계·유형별 <strong>맞춤형 지원</strong>을 통해 정책효과 극대화</li>
												<li>기업의 <strong>자발적인 투자</strong>와 <strong>혁신역량 제고 활동 유도</strong></li>
											</ul>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div style="text-align: center;"><img src="/images2/sub/policy/sub02_img01.png"></div>
					<div class="cont_sec03">
						<h3 class="title">추진전략</h3>
						<div class="cont">
							<div>
								<div class="s_tit"><br/>
									<span>01</span>
									<h4>산업·지역·신시장 진출<br/>선도 역할 강화</h4>
								</div>
								<ul>
									<li>소재·부품·장비 글로벌 전문기업 육성</li>
									<li>신산업 및 주력산업 성장 주도</li>
									<li>지역대표 기업 육성</li>
									<li>신남방·신북방 등 신시장 진출 활성화</li>
								</ul>
							</div>
							<div>
								<div class="s_tit"><br/>
									<span>02</span>
									<h4>지속성장을 위한<br/>맞춤형 지원 확대</h4>
								</div>
								<ul>
									<li>혁신선도 기술역량 및 인재 확보</li>
									<li>신사업 및 사업재편 지원 강화</li>
									<li>기업 맞춤형 금융지원 확대</li>
									<li>후보 기업 성장 촉진</li>
								</ul>
							</div>
							<div>
								<div class="s_tit"><br/>
									<span>03</span>
									<h4>법·제도 등<br/>성장 인프라 확충</h4>
								</div>
								<ul>
									<li>성장걸림돌 규제·제도 개선</li>
									<li>성장 지원체계 정비</li>
								</ul>
							</div>
							
						</div>
					</div>
					<div class="list_bl m_b_0" style="margin-top: 67px;">
						<h4 class="fram_bl">세부 추진과제 전략</h4>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>01</span><h3>산업·지역·신시장 진출 선도 역할 강화</h3></div>
						<table class="table_wht">
							<caption>역할 강화</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>소재·부품·장비 <br/>글로벌 전문기업 육성</th>
									<td>
										소부장 6대 분야*를 중심으로 <span>50개 이상의 유망 기업을 발굴</span>하여 세계적 전문기업으로 육성<br/>
										&emsp;<span style="font-size:12px;">* 반도체, 디스플레이, 자동차, 전자전기, 기계금속, 기초화학</span><br/>
										<span>소부장 경쟁력위원회</span>등을 통해 <span>기업 중심의 수요-공급기업간 협력사업</span> 지속 발굴<br/>
									
									</td>
								</tr>
								<tr>
									<th>신산업 및 주력산업 성장 주도</th>
									<td>
										<span>(미래차)</span> 친환경·자율차 전환을 위한 <span>중견부품사 기술력 제고</span><br/>
										&emsp;<span style="font-size:12px;">* (전기차) '20 ~ '26, 약 4천억원 / (자율차) '21 ~ '27, 1.7조원(예타) 등</span><br/>
										<span>(시스템반도체)</span> 산업 생태계 성장을 위한 <span>수요연계 팹리스 기술개발, 중견 파운드리·패키징 시설투자 자금 </span>등 지원<br/>
										<span>(바이오헬스)</span> 신약·융복합의료기기 등 <span>차세대 유망기술 개발,</span>원부자재·장비 등 <span>생산시설 국산화</span> 지원<br/>
										<span>(기계 등 주력산업)</span> 미래시장 대비를 위한 <span>산업지능화 및 고부가치화 주도</span>
									</td>
								</tr>
								<tr>
									<th>지역대표 기업 육성</th>
									<td>
										지역경제를 견인할 <span>지역대표 기업</span>을 선정(100개, '21 ~ '25년), <span>상생협력R&D 및 수출·특허 등 패키지 지원</span><br/>
										&emsp;<span style="font-size:12px;">* 혁신R&D, 특허전략수립 등을 지원하는 예타사업 기획 추진('20)</span><br/>
									</td>
								</tr>
								<tr>
									<th>신남방·신북방 등 <br/>신시장 진출 활성화</th>
									<td>
										<span>(신남방·신북방 진출)</span> 신남방·신북방과의 <span>역량강화 지원사업</span><span style="font-size:12px;">(해외거점 등)</span> <span>참여</span> 및 RCEP 등 <span>FTA 적극 추진</span><br/>
										&emsp;<span style="font-size:12px;">* 한-베트남 TASK 센터, 필리핀 금형기술지원센터 등</span><br/>
										<span>(수출지원)</span> 무역보험<span style="font-size:12px;">('20년 20조원)</span> 등 <span>수출금융 확대,</span> 해외 영업·마케팅 등 <span>기업 수출역량 강화 지원*, 해외지식 재산센터 추가</span> 개소<span style="font-size:12px;">('20년 필리핀)</span> 및 <span>온라인 위조상품 유통대응 지역 확대</span><span style="font-size:12px;">('20년 중국→베트남, 인도네시아 등)</span><br/>
										<span style="font-size:12px;">* 기업 수출역량강화(글로벌지원)사업('20, 220억원)</span>
									</td>
								</tr>
								<tr>
									<th>산업정책-중견 연계 강화</th>
									<td>
										<span>(산업→중견) 산업별 정책수립시 </span>▴가치사슬 내 <span>중견역할, ▴중견 애로사항, ▴관련 지원시책을 별도 분석·검토</span><br/>
										<span>(중견→산업) 업종별 산업가치사슬 분석</span>을 통해 <span>취약 품목·기술</span>에 대해 <span>월드클래스+ 등 중견전용R&D</span> 우선 지원 <br/>추진
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>02</span><h3>지속성장을 위한 맞춤형 지원 확대</h3></div>
						<table class="table_wht">
							<caption>지원 확대</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>혁신선도 기술역량 및 <br/>인재 확보</th>
									<td>
										<span><img alt="·" src="/images2/sub/policy/policy_cont_sec02_list_dot.png"><u>글로벌 기술경쟁력 제고</u></span><br/>
										&nbsp;&nbsp;<span>(중견 전용 R&D지원) 월드클래스+, 우수 중견부설연구소 100개 육성</span> 등 혁신 잠재력이 높은 기업 성장 촉진<br/>
										&emsp;<span style="font-size:12px;">* 월드클래스+ : '21 ~ '33년, 9,135억원, 150개사</span><br/>
										&nbsp;&nbsp;<span>(공공연 협력) 차세대 도전기술 개발 공동기획, 출연연-기업 1:1 멘토링, 온라인 기술문제해결 플랫폼 구축</span><br/>
										&nbsp;&nbsp;<span>(글로벌 협력) 독일, 이스라엘</span> 등 세계적 기술·창업 강국애 <span>글로벌 협력거점</span> 설립 추진<span style="font-size:12px;">(한-독 기술협력센터 '20.<ruby>上</ruby> 개소)</span><br/>
										&nbsp;&nbsp;<span>(산업지능화 확산기반 마련)</span> 중견대상 AI·빅데이터 활용 <span>산업지능화 성공사례 창출·확산</span><br/>
										&nbsp;&nbsp;<span>(제도개선) 출연금·민간부담현금비율 합리화</span> 등 R&D제도 개선으로 중견의 자발적인 R&D투자 확대 유도<br/>
										<span><img alt="·" src="/images2/sub/policy/policy_cont_sec02_list_dot.png"><u>혁신선도형 인재 확보</u></span><br/>
										&nbsp;&nbsp;<span>(고급인력 양성) AI·빅데이터 관련 석박사 과정</span> 운영<br/>
										&emsp;<span style="font-size:12px;">* ('24년까지 10개 대학에 기업 채용조건형 과정 개설)</span><br/>
										&nbsp;&nbsp;<span>(퇴직인력 활용) 출연연 퇴직연구원</span>을 통한 애로기술 해결<br/>
									
									</td>
								</tr>
								<tr>
									<th>신사업 및 사업재편 지원 강화</th>
									<td>
										<span><u>신사업 발굴 시범사업(중견 Light House Project)</u></span><br/>
										<span>미래 신사업 발굴~사업화</span>까지 체계적인 <span>신사업 개발 지원</span><br/>
										업종별<span> 신사업 개발전략 컨설팅 및 IP·R&BD 등 연계 지원</span><br/>
										&emsp;<span style="font-size:12px;">* '20 년 시범추진하고 '21년 이후 시범결과 토대로 단계적 확대</span><br/>
										<span>(사업전환·재편 지원)</span> 중견련에 <span>사업전환지원센터</span> 설치, 규제 간소화 외 <span>중견전용 R&D, 금융 등 추가 지원</span><br/>
										<span>(사내벤처·M&A 활성화) 사내벤처 프로그램 내 기업의 참여를 촉진</span>하고, <span>중견전담 M&A 지원창구 설치</span> 등 추진<br/>
										<span>(협력기반 신사업)</span> 글로벌 경쟁력을 갖춘 중견이 <span>초기 중견·중소와 경험·역량을 공유</span>하는 <span>협력모델 발굴</span><span style="font-size:12px;">(~'24. 10개)</span><br/>
										&emsp;<span style="font-size:12px;">* 협력모델 예 : GVC 동반진출, 인프라(생산시설, 연구장비 등) 공유 등</span><br/>
									</td>
								</tr>
								<tr>
									<th>기업 맞춤형 <br/>금융지원 확대</th>
									<td>
										<span>(신사업 금융애로 해소)</span> 월드클래스+ 등 혁신형 중견 대상 대출한도 상향·금리인하 등 종합금융지원, <span>신규 설비 투자 금융지원 프로그램</span><span style="font-size:12px;">(4.5조원, 20년)</span> 신설<br/>
										- 기업정책위원회 산하 <span>금융애로해소위원회</span> 구성<br/>
										<span>(펀드 조성)</span> 벤처·초기중견 투자를 위한<span> 중견성장펀드</span>와 제조중견 등 R&D를 위한 <span>제조업 R&D펀드 조성</span><br/>
										&emsp;<span style="font-size:12px;">* 성장펀드 '20 ~ '24. 1,000억원('20. 300억원), R&D펀드 '20 ~ '22. 6,000억원</span><br/>
									</td>
								</tr>
								<tr>
									<th>후보 기업 성장 촉진</th>
									<td>
									<span>(퇴출·유예기업 관리)</span> 매출규모나 성격<span style="font-size:12px;">(일반·관계·피출자)</span>·유예별로 <span>퇴출원인 분석,</span> 재도약 <span>경영컨설팅 지원 추진</span><br/>
									<span>(예비중견 양성) 글로벌 강소기업</span><span style="font-size:12px;">('20 ~ '24년 1,000개)</span>대상 <span>맞춤형 수출지원, 지역 우수 중소기업 대상 R&D·성장 전략 컨설팅 지원</span> 등을 통해 기업 후보군 양성<br/>
									<span>(강소벤처형 중견 육성) 성장 유망 관계·피출자 </span>기업의 육성을 위해 <span>모기업 <ruby>先</ruby>투자</span>와 매칭하여 <span>R&D</span> 등 지원
									</td>
								</tr>
								
							</tbody>
						</table>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>03</span><h3>법·제도 등 성장 인프라 확충</h3></div>
						<table class="table_wht">
							<caption>인프라 확충</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>성장걸림돌 규제·제도 개선</th>
									<td>
										현행 법령 전수조사 → 업계, 관계부처 협의를 통해 <span>중장기성장걸림돌 개선 로드맵</span> 마련<span style="font-size:12px;">('20)</span>
									</td>
								</tr>
								<tr>
									<th>성장 지원체계 강화</th>
									<td>
										<span>(성장지원 전담조직)</span> 성장애로 상시 지원하는 <span>"기업 성장촉진 전담 Desk</span><span style="font-size:12px;">(가칭)</span>" 운영<br/>
										<span>(옴부즈만)</span> 중소 옴부즈만 지원단 내 <span>중견 전담 지원체계 마련으로</span> 규제 및 애로 상시 해소기반 마련<br/>
										<span>(기업법 개정) 기업법</span><span style="font-size:12px;">('24.7월) </span><span>상시법</span><span style="font-size:12px;">(중견기본법)</span><span>전환, </span>해외판로·기술보호 등 <span>특례확대 검토</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn_sec">
						<a href="/download/2차_기업_성장촉진_기본계획_붙임.pdf" target="_blank" >2차 기업 성장촉진 기본계획 바로가기</a>
					</div>
					<!--  -->
				</div>
				
				
				<div class="r_cont s_cont03_02" style="display:none;">
					<div class="s_tabMenu s_3tabMenu">
						<ul>
							<li><a href="#none" class="s_cont03_0_3" alt="제2차 기업 성장촉진 시행계획">제2차 기업 성장촉진 시행계획 (2020.2)</a></li>
							<li class="on"><a href="#none" class="s_cont03_0_2" alt="2019년 기업 성장촉진 시행계획">2019년 기업 성장촉진 시행계획 (2019.2)</a></li>
							<li><a href="#none" class="s_cont03_0_1" alt="기업 비전 2280">기업 비전 2280 (2018.2)</a></li>
						</ul>
					</div>
					<div class="list_bl m_b_0">
						<h4 class="fram_bl">추진목표</h4>
					</div>
					<div class="acc_sec acc_sec01">
						<div class="add_tit">
							<table>
								<tbody>
									<tr>
										<td>목표</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="add_cont">
							<table>
								<tbody>
									<tr>
										<td>
											<h4>‘19년 기업 수 4,800개 달성</h4>
											<p class="comment">* 기업 수(개) : (’17) 4,468 → (’18) 4,600(추정) → (’19) 4,800(목표)</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="bg_txt">
						중소기업//예비중소기업//기업//글로벌 챔프기업 수출비중 30% 상승, R&D집중도 3% 상승
					</div>
					<div style="text-align: center;"><img src="/images2/sub/policy/sub02_img01.png"></div>
					<div class="acc_sec acc_sec02">
						<div class="add_tit">
							<table>
								<tbody>
									<tr>
										<td>추진 전략</td>
									</tr>
									<tr>
										<td>정책 과제</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="add_cont">
							<table>
								<caption>2019년 기업 성장촉진 시행계획 추진목표</caption>
								<colgroup>
									<col width="33.3333%">
									<col width="33.3333%">
									<col width="33.3333%">
								</colgroup>
								<thead>
									<tr>
										<th><span>01</span> 글로벌 혁신역량 강화</th>
										<th><span>02</span> 지속성장 인프라 구축</th>
										<th><span>03</span> 포용적 산업생태계 조성</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>
											<ul>
												<li><strong>기술혁신 역량</strong> 제고</li>
												<li><strong>수출 경쟁력</strong> 강화</li>
												<li><strong>우수인재 확보</strong> 지원</li>
												<li><strong>정책자금</strong> 지원 확대</li>
											</ul>
										</td>
										<td>
											<ul>
												<li><strong>성장걸림돌 제도</strong> 개선</li>
												<li><strong>유관기관 협업</strong> 활성화</li>
												<li><strong>예비 기업</strong> 육성</li>
											</ul>
										</td>
										<td>
											<ul>
												<li><strong>기업 중심 상생협력</strong> 확산</li>
												<li><strong>공정거래 문화</strong> 조성</li>
												<li><strong>지역 거점기업</strong> 육성</li>
											</ul>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				
					<div class="list_bl m_b_0" style="margin-top: 67px;">
						<h4 class="fram_bl">추진 과제</h4>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>01</span><h3>글로벌 혁신역량 강화</h3></div>
						<table class="table_wht">
							<caption>글로벌 혁신역량 강화</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>기술혁신 역량 제고</th>
									<td><span>글로벌 CHAMP 300 사업을 추진</span>하고, <span>기업 상생혁신 R&D, 기술문제해결 플랫폼</span>을 구축하여 <br/>기업 <span>기술혁신 역량 강화</span></td>
								</tr>
								<tr>
									<th>수출 경쟁력 강화</th>
									<td>유망 <span>기업 맞춤형 해외진출 지원</span>을 통해 글로벌 기업 도약을 지원하고, <span>소비재·서비스 등 해외진출 <br/>지원을 통해 수출 기업화</span> 촉진</td>
								</tr>
								<tr>
									<th>우수인재 확보 지원</th>
									<td>우수 인력-기업간 미스매칭을 해소하고 청년인재 채용을 촉진하기 위해 <span>기업 전용 채용의 <ruby>場</ruby>을 활성<br/>화하고 청년인재 고용지원 강화</span></td>
								</tr>
								<tr>
									<th>정책자금 지원 확대</th>
									<td><span>기업 특별자금</span>(산은·우리은행), <span>기업 맞춤형 무역보험 상품 출시</span>(무보), <br/><span>성장지원펀드 조성</span>(산은) 등을 통해 자금애로 해소 지원</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>02</span><h3>지속성장 인프라 확충</h3></div>
						<table class="table_wht">
							<caption>지속성장 인프라 확충</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>성장걸림돌 제도 개선</th>
									<td>기업으로의 성장에 부담으로 작용하는 <span>성장걸림돌 규제·제도를 개선</span>하여 <span>성장 친화적 <br/>기업 생태계 조성</span></td>
								</tr>
								<tr>
									<th>유관기관 협업 활성화</th>
									<td>기업 관계부처·기관간 <span>협력 네트워크를 강화하고,「기업 주간」개최</span> 등을 통해 <br/>기업에 대한 인식 확산</td>
								</tr>
								<tr>
									<th>예비 기업 육성</th>
									<td>성장·혁신 잠재력을 갖춘 <span>유망 중소기업을 선정해 R&D·수출 등 집중 지원, 스마트공장 보급 확산</span> 등을 통해<br/><span>기업으로의 성장 촉진</span></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="table_wrap">
						<div class="tit"><span>03</span><h3>포용적 산업생태계 조성</h3></div>
						<table class="table_wht">
							<caption>포용적 산업생태계 조성</caption>
							<colgroup>
								<col width="203px">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>성장걸림돌 제도 개선</th>
									<td><span>산업 생태계와 가치사슬을 고려한 상생협력을 추진</span>하고, 기업 생태계 가교 역할을 수행하는 <span>기업<br/>중심의 상생협력</span> 활성화</td>
								</tr>
								<tr>
									<th>유관기관 협업 활성화</th>
									<td><span>사회적책임 우수기업 지원사업 우대, 표준하도급 계약 보급</span> 확산 및 <span>공정거래 제도 개선</span> 등을 통해<br/>불공정행위 근절</td>
								</tr>
								<tr>
									<th>예비 기업 육성</th>
									<td><span>지역 혁신을 주도할 지역 거점기업 육성</span> 및 <span>지방 기업 육성사업 발굴 및 애로해소</span>를 지원하기<br/>위해 <span>중앙-지방간 협의체 운영</span></td>
								</tr>
							</tbody>
						</table>
					</div>
						<div class="btn_sec">
					<!--  -->
						<a href="/download/2019년_기업_성장촉진_시행계획.pdf" target="_blank" >2019년 기업 성장촉진 시행계획 바로가기</a>
					<!--  -->
					</div>
				</div>
				<div class="r_cont s_cont03_01"  style="display:none;">
					<div class="s_tabMenu s_3tabMenu">
						<ul>
							<li><a href="#none" class="s_cont03_0_3" alt="제2차 기업 성장촉진 시행계획">제2차 기업 성장촉진 시행계획 (2020.2)</a></li>
							<li><a href="#none" class="s_cont03_0_2" alt="2019년 기업 성장촉진 시행계획">2019년 기업 성장촉진 시행계획 (2019.2)</a></li>
							<li class="on"><a href="#none" class="s_cont03_0_1" alt="기업 비전 2280">기업 비전 2280 (2018.2)</a></li>
						</ul>
					</div>
					<div class="cont_sec01">
						<div class="blu_circle">
							<h1>VISION 2280</h1>
							<h2>22년까지 월드챔프<br/>1조클럽 80개 육성</h2>
						</div>
						<h3>- 혁신성장과 좋은 일자리 창출 선도 -</h3>
						<p>* 월드챔프 1조클럽 : 매출액 1조원 이상이며 혁신역량이 우수한 기업<br/>(R&D 비중 3%↑ or 수출 비중 30%↑ or 매출액 성장률 15%↑)</p>
					</div>
					<div class="cont_sec02">
						<h3 class="title">목표</h3>
						<div class="cont">
							<table>
								<caption>기업 비전 2280 목표</caption>
								<colgroup>
									<col width="370px">
									<col width="21px">
									<col width="370px">
								</colgroup>
								<thead>
									<tr>
										<th>기업 수</th>
										<th class="gap"></th>
										<th>기업 고용인원</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td><p>중소에서 중견으로의 성장을 촉진</p></td>
										<td class="gap"></td>
										<td><p>혁신성장·상생협력을 통한 양질의 일자리 창출</p><span>(신규 13만 + 확대 23만)</span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="cont_sec03">
						<h3 class="title">추진전략</h3>
						<div class="cont">
							<div>
								<div class="s_tit">
									<span>01</span>
									<h4>글로벌 수출<br/>기업화 촉진</h4>
								</div>
								<ul>
									<li>글로벌 수출 역량 강화</li>
									<li>기술혁신 역량 확충</li>
									<li>신사업 창출 기반 조성</li>
								</ul>
							</div>
							<div>
								<div class="s_tit">
									<span>02</span>
									<h4>지역 혁신생태계<br/>구축</h4>
								</div>
								<ul>
									<li>지역거점 기업 육성</li>
									<li>전문인력 확보 지원</li>
								</ul>
							</div>
							<div>
								<div class="s_tit">
									<span>03</span>
									<h4>포용적 산업생태계<br/>조성</h4>
								</div>
								<ul>
									<li>기업 중심 상생협력 활성화</li>
									<li>업종별 특화 상생협력 추진</li>
									<li>자발적 공정거래 문화 확산</li>
								</ul>
							</div>
							<div>
								<div class="s_tit">
									<span>04</span>
									<h4>혁신성장<br/>인프라 확충</h4>
								</div>
								<ul>
									<li>성장디딤돌 강화</li>
									<li>기업 혁신 네트워크 구축</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="cont_sec04">
						<h3 class="title">정책방향</h3>
						<div class="cont">
							<h1>혁신형 기업 육성, 공정한 성장 생태계 조성</h1>
							<div>
								<h2>혁신성장 측면</h2>
								<div class="sys_cont">
									<div class="sys_l">
										<p>기업중심 분절적 지원</p>
									</div>
									<div class="sys_r">
										<p>산업정책 연계 통합 지원</p>
										<p>4차 산업혁명 대응, 산업별 밸류체인 강화를 위한<br/>업종별 기업 육성 정책</p>
									</div>
								</div>
								<div class="sys_cont">
									<div class="sys_l">
										<p>내수 중심</p>
									</div>
									<div class="sys_r">
										<p>글로벌 수출기업화 지원</p>
										<p>R&D·수출·인력 등 세계적 수준의 혁신 역량을<br/>갖춘 글로벌 기업</p>
									</div>
								</div>
							</div>
							<div style="padding-bottom: 53px;">
								<h2>공정생태계 측면</h2>
								<div class="sys_cont">
									<div class="sys_l">
										<p>대기업 의존형</p>
									</div>
									<div class="sys_r">
										<p>독립형 성장 생태계 조성</p>
										<p>대기업 의존없이 성장하고 강한 교섭력을 갖춘<br/>독립형 기업</p>
									</div>
								</div>
								<div class="sys_cont">
									<div class="sys_l">
										<p>수도권 중심</p>
									</div>
									<div class="sys_r">
										<p>지역거점 기업 육성</p>
										<p>지역 특성을 고려한 맞춤형 정책으로 함께 성장하는<br/>지역거점 기업</p>
									</div>
								</div>
								<div class="sys_cont">
									<div class="sys_l">
										<p>대기업 중심 상생·공정거래</p>
									</div>
									<div class="sys_r">
										<p>기업 중심 상생·공정거래</p>
										<p>원청·협력형 기업 중심 상생협력·공정거래 확산을 통한<br/>포용적 산업생태계</p>
									</div>
								</div>
							</div>
							<div style="padding-bottom:43px;">
								<h2>공정생태계 측면</h2>
								<table>
									<caption>공정생태계 측면</caption>
									<colgroup>
										<col width="113px">
										<col width="237px">
										<col width="361px">
									</colgroup>
									<thead>
										<tr>
											<th> </th>
											<th>특징</th>
											<th>주요 지원정책</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>초기형</th>
											<td>
												- 매출액 3천억원 미만<br/>
												- 혁신역량 취약
											</td>
											<td>
												<p>성장디딤돌 강화, 정책자금 확대</p>
												<p>맞춤형 R&D·마케팅·인력 지원</p>
											</td>
										</tr>
										<tr>
											<th>혁신형</th>
											<td>
												- R&D·수출 비중 증가<br/>
												- 고성장 잠재력 보유
											</td>
											<td>
												<p>M&A 활성화, 수출 등 패키지 지원</p>
												<p>지역거점 기업 육성</p>
											</td>
										</tr>
										<tr>
											<th>내수·전속형</th>
											<td>
												- 내수시장 중심<br/>
												- 대기업 의존적
											</td>
											<td>
												<p>신사업·신시장 진출 및 사업다각화 지원</p>
												<p>대·중견·중소 동반성장 촉진</p>
											</td>
										</tr>
										<tr>
											<th>글로벌형</th>
											<td>
												- 매출 1조원 이상<br/>
												- 글로벌 경쟁력 보유
											</td>
											<td>
												<p>현장애로·규제개선 지원</p>
												<p>사회적책임 경영문화 확산</p>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="btn_sec">
					<!--  -->
						<a href="/download/기업_비전_2280.pdf" target="_blank">기업 비전 2280 원문 바로가기</a>
						<!--  -->
					</div>
				</div>
				
			</div>
		</div>
	</div>
		</div>
		<!--content//-->
	</form>
</body>
</html>