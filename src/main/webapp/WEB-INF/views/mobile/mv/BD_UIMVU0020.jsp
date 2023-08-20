<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>기업소개</title>
<ap:jsTag type="web" items="jquery,tools,ui" />
<ap:jsTag type="tech" items="util,mv" />
</head>
<body>
	<!--//내용영역-->
	<section class="roll_zone">
		<div class="year">
			<div class="prod">2011</div>
			<div class="prod">2012~2014</div>
			<!-- <div class="prod">2013</div>
			<div class="prod">2014</div> -->
			<div class="prod active">2015~현재</div>
		</div>
		<a href="#" class="pleft" style="left:25%;"><img src="../../images/hi/btn_pre.png" at="이전년도가기" /></a> <a href="#"
			class="pright" style="left:72%;"><img src="../../images/hi/btn_next.png" at="다음년도가기" /></a>

		<div class="sub_con">
			<!--//2011-->
			<div class="year_con">
				<div class="tabwrap">
					<div class="tab">
						<ul><li class="on"><span>기업기준</span></li><li><span>규모기준</span></li><li><span>상한기준</span></li><li><span>독립성기준</span></li></ul>
					</div>

					<div class="tabcon">
						<!--//2011-기업기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img1.png" style="width: 100%" ; alt=""
									title="규모기준/독립성기준/상한기준" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>규모기준</dt><dd>업종별로 상이</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자본금</dd><dd>- 매출액</dd><dd>유예기간 부여(3년)</dd><dd>- 반복적용</dd></dl>
							<dl><dt>독립성기</dt><dd>업종구분 없음</dd><dd>유예기간 미부여</dd><dd>판단지표 : 지분율, 계열사, 상시근로자, 매출액, 자본금, 자산총계, 자기자본</dd></dl>
							<dl><dt>상한기준</dt><dd>업종구분 없음</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자산총계</dd><dd>- 자기자본</dd><dd>유예기간 미부여</dd></dl>
						</div>
						<!--2011-기업기준//-->
					</div>
					<div class="tabcon y2011_2" style="display: none;">
						<!--//2011-규모기준-->
						<div class="tbl_view">
							<table cellspacing="0" border="0" summary="기본게시판 목록으로 규모기준, 해당업종 정보를 제공합니다.">
								<caption>2011년 규모기준 게시판</caption>
								<colgroup>
									<col width="45%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">규모기준</th>
										<th scope="col">해당업종</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>상시근로자 300명 이상<br />자본금 80억 초과
										</td>
										<td>
											<p>• 제조업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상<br />자본금 30억 초과
										</td>
										<td>
											<p>• 광업</p>
											<p>• 건설업</p>
											<p>• 운수업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />매출액 300억 초과
										</td>
										<td>
											<p>• 출판, 영상, 방송통신 및 정보서비스업</p>
											<p>• 사업시설관리 및 사업지원 서비스업</p>
											<p>• 보건 및 사회복지 서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 200명 이상 <br />매출액 200억 초과
										</td>
										<td>
											<p>• 농업, 임업 및 어업</p>
											<p>• 전기, 가스, 증기 및 수도사업</p>
											<p>• 도매 및 소매업</p>
											<p>• 숙박 및 음식점업</p>
											<p class="txt_line">• 금융 및 보험업</p>
											<p>• 전문, 과학 및 기술 서비스업</p>
											<p>• 예술, 스포츠 및 여가관련 산업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 100명 이상 <br />매출액 100억 초과
										</td>
										<td>
											<p>• 하수처리, 폐기물 처리 및 환경복원업</p>
											<p>• 교육서비스업</p>
											<p>• 수리및 기타서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 50명 이상<br />매출액 50억 초과
										</td>
										<td>
											<p>• 부동산업 및 임대업</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="ft_txt">
							<p>
								중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하기 위하여 <strong>3년간 중소기업과 동등한 지원</strong>을 받을
								수 있도록 준비기간 부여
							</p>
						</div>
						<!--2011-규모기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2011-상한기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img2.png" style="width: 100%" ; alt="" title="상시근로자/자산총계" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>상시근로자</dt><dd>1,000명 이상</dd></dl>
							<dl><dt>자산총계</dt><dd>5,000억원이상</dd></dl>
						</div>
						<div class="ft_txt">
							<p>
								<strong>업종에 관계없이</strong> 해당 기준을 만족하면 기업에 진입
							</p>
							<p>
								- 상한기준은 <strong>유예기간을 부여하지 않음</strong>
							</p>
						</div>
						<!--2011-상한기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2011-독립성기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img3.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>자산총액 5,000억원 이상 법인이 30% 이상 출자한 기업</dt></dl>
							<dl><dt>A기업 자산 5,000억원 모회사</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사 (유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>B기업 모회사</dt></dl>
						</div>
						<div class="ft_txt">
							<p>
								자산총액 <strong>5,000억원</strong> 이상인 법인이 주식 등을 <strong>30%이상 직접적</strong>으로 소유하고, <strong>최다출자자</strong>인
								경우 업종에 상관없이 기업에 진입
							</p>
						</div>
						<div>
							<h4>관계기업 제도</h4>
							<div class="mtb20">
								<p>• 개별 기업의 크기로 보면 중소기업이지만 계열사와 규모를 합하면 기업에 속하는 경우</p>
								<p>• 관계기업은 기업간의 지배,종속의 관계가 성립하는 기업들의 집단</p>
								<p>• 지배기업이 종속기업의 의결권 있는 주식 등을 30%이상 소유하면서 최다출자자인 경우 하나의 기업으로 간주</p>
								<p>• 출자비율에 따라 상시근로자, 자본금, 매출액, 자기자본, 자산총액 등을 합산하여 기업규모 산정</p>
								<p>• 지배기업의 특수관계자 또는 자회사가 종속기업의 주식 등을 우회적으로 소유하고 있는 경우에도 이를 모두 합산하여 최다출자자 판단</p>
							</div>
						</div>
						<div class="ft_txt">
							<p>지배기업은 「주식회사의 외부감사에 관한 법률」 제2조에 따른 외부감사대상기업</p>
						</div>
						<h5>관계기업 제도 적용 예제 1</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img4.png" style="width: 100%" ; alt=""
									title="A기업이 특수관계자(갑 및 갑의 친족)와 합산하여 B기업의 주식 등을 30%이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 2</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자  관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 3</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2011_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사 및 특수관계자와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<!--2011-독립성기준//-->
					</div>
				</div>
			</div>

			<!--//2012-->
			<div class="year_con">
				<div class="tabwrap">
					<div class="tab">
						<ul><li class="on"><span>기업기준</span></li><li><span>규모기준</span></li><li><span>상한기준</span></li><li><span>독립성기준</span></li></ul>
					</div>

					<div class="tabcon">
						<!--//2012-기업기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img1.png" style="width: 100%" ; alt=""
									title="규모기준/독립성기준/상한기준" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>규모기준</dt><dd>업종별로 상이</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자본금</dd><dd>- 매출액</dd><dd>유예기간 부여(3년)</dd><dd>- 반복적용</dd></dl>
							<dl><dt>독립성기</dt><dd>업종구분 없음</dd><dd>유예기간 미부여</dd><dd>판단지표 : 지분율, 계열사, 상시근로자, 매출액, 자본금, 자산총계, 자기자본</dd></dl>
							<dl><dt>상한기준</dt><dd>업종구분 없음</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자산총계</dd><dd>- 자기자본</dd><dd>- 매출액</dd><dd>유예기간 미부여</dd></dl>
						</div>
						<!--2012-기업기준//-->
					</div>
					<div class="tabcon y2012_2" style="display: none;">
						<!--//2012-규모기준-->
						<div class="tbl_view">
							<table cellspacing="0" border="0" summary="기본게시판 목록으로 규모기준, 해당업종 정보를 제공합니다.">
								<caption>2012년 규모기준 게시판</caption>
								<colgroup>
									<col width="45%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">규모기준</th>
										<th scope="col">해당업종</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 80억 초과
										</td>
										<td>
											<p>• 제조업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 30억 초과
										</td>
										<td>
											<p>• 광업</p>
											<p>• 건설업</p>
											<p>• 운수업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />매출액 300억 초과
										</td>
										<td>
											<p>• 출판, 영상, 방송통신 및 정보서비스업</p>
											<p>• 사업시설관리 및 사업지원 서비스업</p>
											<p>• 전문, 과학 및 기술 서비스업</p>
											<p>• 보건 및 사회복지 서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 200명 이상 <br />매출액 200억 초과
										</td>
										<td>
											<p>• 농업, 임업 및 어업</p>
											<p>• 전기, 가스, 증기 및 수도사업</p>
											<p>• 도매 및 소매업</p>
											<p>• 숙박 및 음식점업</p>
											<p>• 예술, 스포츠 및 여가관련 산업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 100명 이상 <br />매출액 100억 초과
										</td>
										<td>
											<p>• 하수처리, 폐기물 처리 및 환경복원업</p>
											<p>• 교육서비스업</p>
											<p>• 수리및 기타서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 50명 이상<br />매출액 50억 초과
										</td>
										<td>
											<p>• 부동산업 및 임대업</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="ft_txt">
							<p>중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하기 위하여 3년간 중소기업과 동등한 지원을 받을 수 있도록 준비기간
								부여</p>
						</div>
						<!--2012-규모기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2012-상한기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img2.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>상시근로자</dt><dd>1,000명 이상</dd></dl>
							<dl><dt>자산총계</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>자기자본(자기자본 = 자산총액 – 부채총액)</dt><dd>1,000억원이상</dd></dl>
							<dl><dt>매출액(3년 평균)</dt><dd>3년 평균1,500억원이상</dd></dl>
						</div>
						<div class="ft_txt">
							<p>
								<strong>업종에 관계없이</strong> 해당 기준을 만족하면 기업에 진입
							</p>
							<p>
								- 상한기준은 <strong>유예기간을 부여하지 않음</strong>
							</p>
						</div>
						<!--2012-상한기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2012-독립성기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img3.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>자산총액 5,000억원 이상 법인이 30% 이상 출자한 기업</dt></dl>
							<dl><dt>A기업 자산 5,000억원 모회사</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사 (유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>B기업 모회사</dt></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사(유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>A기업 자산→간접적소유관계→C기업 손자회사</dt></dl>
						</div>
						<div class="ft_txt">
							<p>
								자산총액 <strong>5,000억원</strong> 이상인 법인이 주식 등을 <strong>30%이상 직∙간접적</strong>으로 소유하고, <strong>최다출자자</strong>인
								경우 업종에 상관없이 기업에 진입
							</p>
						</div>
						<div>
							<h4>관계기업 제도</h4>
							<div class="mtb20">
								<p>• 개별 기업의 크기로 보면 중소기업이지만 계열사와 규모를 합하면 기업에 속하는 경우</p>
								<p>• 관계기업은 기업간의 지배,종속의 관계가 성립하는 기업들의 집단</p>
								<p>• 지배기업이 종속기업의 의결권 있는 주식 등을 30%이상 소유하면서 최다출자자인 경우 하나의 기업으로 간주</p>
								<p>• 출자비율에 따라 상시근로자, 자본금, 매출액, 자기자본, 자산총액 등을 합산하여 기업규모 산정</p>
								<p>• 지배기업의 특수관계자 또는 자회사가 종속기업의 주식 등을 우회적으로 소유하고 있는 경우에도 이를 모두 합산하여 최다출자자 판단</p>
							</div>
						</div>
						<div class="ft_txt">
							<p>지배기업은 「주식회사의 외부감사에 관한 법률」 제2조에 따른 외부감사대상기업</p>
						</div>
						<h5>관계기업 제도 적용 예제 1</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img4.png" style="width: 100%" ; alt=""
									title="A기업이 특수관계자(갑 및 갑의 친족)와 합산하여 B기업의 주식 등을 30%이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 2</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자  관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 3</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2012_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사 및 특수관계자와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<!--2012-독립성기준//-->
					</div>
				</div>
			</div>

			<!--//2013-->
			<!-- <div class="year_con">
				<div class="tabwrap">
					<div class="tab">
						<ul><li class="on"><span>기업기준</span></li><li><span>규모기준</span></li><li><span>상한기준</span></li><li><span>독립성기준</span></li></ul>
					</div>

					<div class="tabcon">
						//2013-기업기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img1.png" style="width: 100%" ; alt=""
									title="규모기준/독립성기준/상한기준" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>규모기준</dt><dd>업종별로 상이</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자본금</dd><dd>- 매출액</dd><dd>유예기간 부여(3년)</dd><dd>- 반복적용</dd></dl>
							<dl><dt>독립성기</dt><dd>업종구분 없음</dd><dd>유예기간 미부여</dd><dd>판단지표 : 지분율, 계열사, 상시근로자, 매출액, 자본금, 자산총계, 자기자본</dd></dl>
							<dl><dt>상한기준</dt><dd>업종구분 없음</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자산총계</dd><dd>- 자기자본</dd><dd>- 매출액</dd><dd>유예기간 미부여</dd></dl>
						</div>
						2013-기업기준//
					</div>
					<div class="tabcon y2013_2" style="display: none;">
						//2013-규모기준
						<div class="tbl_view">
							<table cellspacing="0" border="0" summary="기본게시판 목록으로 규모기준, 해당업종 정보를 제공합니다.">
								<caption>2013년 규모기준 게시판</caption>
								<colgroup>
									<col width="45%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">규모기준</th>
										<th scope="col">해당업종</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 80억 초과
										</td>
										<td>
											<p>• 제조업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 30억 초과
										</td>
										<td>
											<p>• 광업</p>
											<p>• 건설업</p>
											<p>• 운수업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />매출액 300억 초과
										</td>
										<td>
											<p>• 출판, 영상, 방송통신 및 정보서비스업</p>
											<p>• 사업시설관리 및 사업지원 서비스업</p>
											<p>• 전문, 과학 및 기술 서비스업</p>
											<p>• 보건 및 사회복지 서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 200명 이상 <br />매출액 200억 초과
										</td>
										<td>
											<p>• 농업, 임업 및 어업</p>
											<p>• 전기, 가스, 증기 및 수도사업</p>
											<p>• 도매 및 소매업</p>
											<p>• 숙박 및 음식점업</p>
											<p>• 예술, 스포츠 및 여가관련 산업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 100명 이상 <br />매출액 100억 초과
										</td>
										<td>
											<p>• 하수처리, 폐기물 처리 및 환경복원업</p>
											<p>• 교육서비스업</p>
											<p>• 수리및 기타서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 50명 이상<br />매출액 50억 초과
										</td>
										<td>
											<p>• 부동산업 및 임대업</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="ft_txt">
							<p>중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하기 위하여 3년간 중소기업과 동등한 지원을 받을 수 있도록 준비기간
								부여</p>
						</div>
						2013-규모기준//
					</div>
					<div class="tabcon" style="display: none;">
						//2013-상한기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img2.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>상시근로자</dt><dd>1,000명 이상</dd></dl>
							<dl><dt>자산총계</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>자기자본(자기자본 = 자산총액 – 부채총액)</dt><dd>1,000억원이상</dd></dl>
							<dl><dt>매출액(3년 평균)</dt><dd>3년 평균1,500억원이상</dd></dl>
						</div>
						<div class="ft_txt">
							<p>
								<strong>업종에 관계없이</strong> 해당 기준을 만족하면 기업에 진입
							</p>
							<p>
								- 상한기준은 <strong>유예기간을 부여하지 않음</strong>
							</p>
						</div>
						2013-상한기준//
					</div>
					<div class="tabcon" style="display: none;">
						//2013-독립성기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img3.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>자산총액 5,000억원 이상 법인이 30% 이상 출자한 기업</dt></dl>
							<dl><dt>A기업 자산 5,000억원 모회사</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사 (유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>B기업 모회사</dt></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사(유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>A기업 자산→간접적소유관계→C기업 손자회사</dt></dl>
						</div>
						<div class="ft_txt">
							<p>
								자산총액 <strong>5,000억원</strong> 이상인 법인이 주식 등을 <strong>30%이상 직∙간접적</strong>으로 소유하고, <strong>최다출자자</strong>인
								경우 업종에 상관없이 기업에 진입
							</p>
						</div>
						<div>
							<h4>관계기업 제도</h4>
							<div class="mtb20">
								<p>• 개별 기업의 크기로 보면 중소기업이지만 계열사와 규모를 합하면 기업에 속하는 경우</p>
								<p>• 관계기업은 기업간의 지배,종속의 관계가 성립하는 기업들의 집단</p>
								<p>• 지배기업이 종속기업의 의결권 있는 주식 등을 30%이상 소유하면서 최다출자자인 경우 하나의 기업으로 간주</p>
								<p>• 출자비율에 따라 상시근로자, 자본금, 매출액, 자기자본, 자산총액 등을 합산하여 기업규모 산정</p>
								<p>• 지배기업의 특수관계자 또는 자회사가 종속기업의 주식 등을 우회적으로 소유하고 있는 경우에도 이를 모두 합산하여 최다출자자 판단</p>
							</div>
						</div>
						<div class="ft_txt">
							<p>지배기업은 「주식회사의 외부감사에 관한 법률」 제2조에 따른 외부감사대상기업</p>
						</div>
						<h5>관계기업 제도 적용 예제 1</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img4.png" style="width: 100%" ; alt=""
									title="A기업이 특수관계자(갑 및 갑의 친족)와 합산하여 B기업의 주식 등을 30%이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 2</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자  관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 3</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2013_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사 및 특수관계자와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						2013-독립성기준//
					</div>
				</div>
			</div> -->

			<!--//2014-->
			<!-- <div class="year_con">
				<div class="tabwrap">
					<div class="tab">
						<ul><li class="on"><span>기업기준</span></li><li><span>규모기준</span></li><li><span>상한기준</span></li><li><span>독립성기준</span></li></ul>
					</div>

					<div class="tabcon">
						//2014-기업기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img1.png" style="width: 100%" ; alt=""
									title="규모기준/독립성기준/상한기준" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>규모기준</dt><dd>업종별로 상이</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자본금</dd><dd>- 매출액</dd><dd>유예기간 부여(3년)</dd><dd>- 반복적용</dd></dl>
							<dl><dt>독립성기</dt><dd>업종구분 없음</dd><dd>유예기간 미부여</dd><dd>판단지표 : 지분율, 계열사, 상시근로자, 매출액, 자본금, 자산총계, 자기자본</dd></dl>
							<dl><dt>상한기준</dt><dd>업종구분 없음</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자산총계</dd><dd>- 자기자본</dd><dd>- 매출액</dd><dd>유예기간 미부여</dd></dl>
						</div>
						2014-기업기준//
					</div>
					<div class="tabcon y2014_2" style="display: none;">
						//2014-규모기준
						<div class="tbl_view">
							<table cellspacing="0" border="0" summary="기본게시판 목록으로 규모기준, 해당업종 정보를 제공합니다.">
								<caption>2014년 규모기준 게시판</caption>
								<colgroup>
									<col width="45%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">규모기준</th>
										<th scope="col">해당업종</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 80억 초과
										</td>
										<td>
											<p>• 제조업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />자본금 30억 초과
										</td>
										<td>
											<p>• 광업</p>
											<p>• 건설업</p>
											<p>• 운수업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 300명 이상 <br />매출액 300억 초과
										</td>
										<td>
											<p>• 출판, 영상, 방송통신 및 정보서비스업</p>
											<p>• 사업시설관리 및 사업지원 서비스업</p>
											<p>• 전문, 과학 및 기술 서비스업</p>
											<p>• 보건 및 사회복지 서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 200명 이상 <br />매출액 200억 초과
										</td>
										<td>
											<p>• 농업, 임업 및 어업</p>
											<p>• 전기, 가스, 증기 및 수도사업</p>
											<p>• 도매 및 소매업</p>
											<p>• 숙박 및 음식점업</p>
											<p>• 예술, 스포츠 및 여가관련 산업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 100명 이상 <br />매출액 100억 초과
										</td>
										<td>
											<p>• 하수처리, 폐기물 처리 및 환경복원업</p>
											<p>• 교육서비스업</p>
											<p>• 수리및 기타서비스업</p>
										</td>
									</tr>
									<tr>
										<td>상시근로자 50명 이상<br />매출액 50억 초과
										</td>
										<td>
											<p>• 부동산업 및 임대업</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="ft_txt">
							<p>중소기업 지원혜택의 갑작스런 중단으로 경영상의 어려움을 겪을 가능성이 있어 이를 대비하기 위하여 3년간 중소기업과 동등한 지원을 받을 수 있도록 준비기간
								부여</p>
						</div>
						2014-규모기준//
					</div>
					<div class="tabcon" style="display: none;">
						//2014-상한기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img2.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>상시근로자</dt><dd>1,000명 이상</dd></dl><dl><dt>자산총계</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>자기자본(자기자본 = 자산총액 – 부채총액)</dt><dd>1,000억원이상</dd></dl>
							<dl><dt>매출액(3년 평균)</dt><dd>3년 평균1,500억원이상</dd></dl>
						</div>
						<div class="ft_txt">
							<p>
								<strong>업종에 관계없이</strong> 해당 기준을 만족하면 기업에 진입
							</p>
							<p>
								- 상한기준은 <strong>유예기간을 부여하지 않음</strong>
							</p>
						</div>
						2014-상한기준//
					</div>
					<div class="tabcon" style="display: none;">
						//2014-독립성기준
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img3.png" style="width: 100%" ; alt=""
									title="상시근로자/자산총계/자기자본/매출액" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>자산총액 5,000억원 이상 법인이 30% 이상 출자한 기업</dt></dl>
							<dl><dt>A기업 자산 5,000억원 모회사</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사 (유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>B기업 모회사</dt></dl>
							<dl><dt>30% 이상 →</dt><dd>직접적소유관계 상법상 모든 회사(유한회사, 합자회사 등) →</dd></dl>
							<dl><dt>A기업 자산→간접적소유관계→C기업 손자회사</dt></dl>
						</div>
						<div class="ft_txt">
							<p>
								자산총액 <strong>5,000억원</strong> 이상인 법인이 주식 등을 <strong>30%이상 직∙간접적</strong>으로 소유하고, <strong>최다출자자</strong>인
								경우 업종에 상관없이 기업에 진입
							</p>
						</div>
						<div>
							<h4>관계기업 제도</h4>
							<div class="mtb20">
								<p>• 개별 기업의 크기로 보면 중소기업이지만 계열사와 규모를 합하면 기업에 속하는 경우</p>
								<p>• 관계기업은 기업간의 지배,종속의 관계가 성립하는 기업들의 집단</p>
								<p>• 지배기업이 종속기업의 의결권 있는 주식 등을 30%이상 소유하면서 최다출자자인 경우 하나의 기업으로 간주</p>
								<p>• 출자비율에 따라 상시근로자, 자본금, 매출액, 자기자본, 자산총액 등을 합산하여 기업규모 산정</p>
								<p>• 지배기업의 특수관계자 또는 자회사가 종속기업의 주식 등을 우회적으로 소유하고 있는 경우에도 이를 모두 합산하여 최다출자자 판단</p>
							</div>
						</div>
						<div class="ft_txt">
							<p>지배기업은 「주식회사의 외부감사에 관한 법률」 제2조에 따른 외부감사대상기업</p>
						</div>
						<h5>관계기업 제도 적용 예제 1</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img4.png" style="width: 100%" ; alt=""
									title="A기업이 특수관계자(갑 및 갑의 친족)와 합산하여 B기업의 주식 등을 30%이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 2</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자  관계기업 성립" />
							</div>
						</div>
						<h5>관계기업 제도 적용 예제 3</h5>
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2014_img5.png" style="width: 100%" ; alt=""
									title="A기업이 자회사 및 특수관계자와 합산하여 B기업의 주식 등을 30% 이상 소유하면서 최다출자자 관계기업 성립" />
							</div>
						</div>
						2014-독립성기준//
					</div>
				</div>
			</div> -->

			<!--//2015-->
			<div class="year_con active">
				<div class="tabwrap">
					<div class="tab">
						<ul><li class="on"><span>기업기준</span></li><li><span>규모기준</span></li><li><span>상한기준</span></li><li><span>독립성기준</span></li></ul>
					</div>

					<div class="tabcon">
						<!--//2015-기업기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2015_img1.png" style="width: 100%" ; alt=""
									title="규모기준/독립성기준/상한기준" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>규모기준</dt><dd>업종별로 상이</dd><dd>판단지표</dd><dd>- 상시근로자</dd><dd>- 자본금</dd><dd>- 매출액</dd><dd>유예기간 부여(3년)</dd><dd>- 최소1회적용</dd></dl>
							<dl><dt>독립성기준</dt><dd>업종구분 없음</dd><dd>유예기간 미부여</dd><dd>판단지표 : 지분율, 계열사, 3년평균매출액</dd></dl>
							<dl><dd>상한기준</dd><dd>판단지표</dd><dd>- 자산총계</dd><dd>유예기간 미부여</dd></dl>
						</div>
						<!--2015-기업기준//-->
					</div>
					<div class="tabcon y2015_2" style="display: none;">
						<!--//2015-규모기준-->
						<div class="tbl_view">
							<table cellspacing="0" border="0" summary="기본게시판 목록으로 규모기준, 해당업종 정보를 제공합니다.">
								<caption>2015년 규모기준 게시판</caption>
								<colgroup>
									<col width="45%" />
									<col width="*" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">규모기준</th>
										<th scope="col">해당업종</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>3년평균 매출액 1,500억원 초과</td>
										<td>
											<p>• 의복, 의복액세서리 및 모피제품 제조업</p>
											<p>• 가죽, 가방 및 신발 제조업</p>
											<p>• 펄프, 종이 및 종이제품 제조업</p>
											<p>• 1차 금속 제조업</p>
											<p>• 전기장비 제조업</p>
											<p>• 가구제조업</p>
										</td>
									</tr>
									<tr>
										<td>3년평균 매출액 1,000억원 초과</td>
										<td>
											<p>• 농업, 임업 및 어업</p>
											<p>• 광업</p>
											<p>• 식료품 제조업</p>
											<p>• 담배 제조업</p>
											<p>• 섬유제품 제조업 ; 의복 제외</p>
											<p>• 목재 및 나무제품 제조업 ; 가구 제외</p>
											<p>• 코크스, 연탄 및 석유정제품 제조업</p>
											<p>• 화학물질 및 화학제품 제조업; 의약품 제외</p>
											<p>• 고무제품 및 플라스틱 제품 제조업</p>
											<p>• 금속가공제품 제조업 ; 기계 및 가구 제외</p>
											<p>• 전자부품, 컴퓨터, 영상, 음향 및 통신장비 제조업</p>
											<p>• 기타 기계 및 장비 제조업</p>
											<p>• 자동차 및 트레일러 제조업</p>
											<p>• 기타 운송장비 제조업</p>
											<p>• 전기, 가스, 증기 및 수도사업</p>
											<p>• 건설업</p>
											<p>• 도매 및 소매업</p>
										</td>
									</tr>
									<tr>
										<td>3년평균 매출액 800억원 초과</td>
										<td>
											<p>• 음료 제조업</p>
											<p>• 인쇄 및 기록매체 복제업</p>
											<p>• 의료용 물질 및 의약품 제조업</p>
											<p>• 비금속 광물제품 제조업</p>
											<p>• 의료, 정밀, 광학기기 및 시계 제조업</p>
											<p>• 기타 제품 제조업</p>
											<p>• 하수 ·폐기물 처리, 원료재생 및 환경복원업</p>
											<p>• 운수업</p>
											<p>• 출판, 영상, 방송통신 및 정보서비스업</p>
										</td>
									</tr>
									<tr>
										<td>3년평균 매출액 600억원 초과</td>
										<td>
											<p>• 전문· 과학 및 기술 서비스업</p>
											<p>• 사업시설관리 및 사업지원 서비스업</p>
											<p>• 보건업 및 사회복지 서비스업</p>
											<p>• 예술, 스포츠 및 여가관련 서비스업</p>
											<p>• 협회 및 단체, 수리 및 기타 개인 서비스업</p>
										</td>
									</tr>
									<tr>
										<td>3년평균 매출액 400억원 초과</td>
										<td>
											<p>• 숙박 및 음식점업</p>
											<p>• 부동산업 및 임대업</p>
											<p>• 교육 서비스업</p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!--//하단 정보-->
						<div class="ft_txt">
							<p>
								※ 중소기업 <strong>졸업유예(3년)은 중복 불가 / 최초 1회에 한정</strong>
							</p>
						</div>
						<!--하단 정보//-->
						<!--2015-규모기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2015-상한기준-->
						<div class="img_zone">
							<div class="img_size">
								<img src="../../images/mv/2015_img2.png" style="width: 100%" ; alt=""
									title="자산총계 5,000억원 이상" />
							</div>
						</div>
						<div class="hidden">
							<dl><dt>상시근로자 - 삭제</dt><dd>1,000명 이상 - 삭제</dd></dl>
							<dl><dt>자산총계</dt><dd>5,000억원이상</dd></dl>
							<dl><dt>자기자본(자기자본 = 자산총액 – 부채총액) - 삭제</dt><dd>1,000억원이상 - 삭제</dd></dl>
							<dl><dt>매출액(3년 평균) - 삭제</dt><dd>3년 평균1,500억원이상 - 삭제</dd></dl>
						</div>
						<!--2015-상한기준//-->
					</div>
					<div class="tabcon" style="display: none;">
						<!--//2015-독립성기준-->
						<h4>관계기업제도의 판정지표 산정</h4>
						<div class="mtb20">
							<p>• 지배·종속의 관계가 설립하여 관계기업이 되더라도 모두 기업이 되는 것은 아닙니다.</p>
							<p>• 관계기업 간에 “3년 평균 매출액”을 주식 등의 소유 비율만큼 합산하여 규모기준을 만족할 경우 기업으로 인정됩니다.</p>
							<p>• “3년 평균 매출액” 산정 시 기업이 보유하고 있는 주식비율 만큼 합산하여 평가합니다.</p>
						</div>
						<div class="ft_txt">
							<p>
								모든 관계기업이 기업으로 판정되는 것은 아니며, 관계기업 중 <strong>주식 등의 소유 비율</strong>만큼 <strong>상시근로자 등</strong>을
								산정하여 <strong>규모기준 및 상한기준 만족 시</strong> 기업
							</p>
						</div>
						<!--2015-독립성기준//-->
					</div>
				</div>
			</div>
		</div>
	</section>
	<!--내용영역//-->
</body>
</html>