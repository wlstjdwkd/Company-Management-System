<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap" %>
<ap:globalConst />
<!--////////////////////////////////////관계기업추가-삭제////////////////////////////////////-->
<div class="tbl_add">
	<input type="hidden" name="addRcpyId" value="${addRcpyId}" />
	<!--//삭제버튼-->
	<div class="btn_bl3">
		<a class="relay_comBtn" href="#none" onclick="delRcpy(this);"> <span>관계기업삭제</span></a>
	</div>
	<!--삭제버튼//-->
	<!--//1.기업정보-->
	<div class="request_tbl">
		<div class="write">
			<table class="table_form02">
				<caption>기업확인신청서작성입력게시판</caption>
				<colgroup>
					<col style="width: 172px" />
					<col style="width: 273px" />
					<col style="width: 173px" />
					<col style="width: 272px" />
				</colgroup>
				<tbody>
					<tr>
						<td colspan="4" class="pr0 tbl_tline">
							<div class="fr btn_inner">
							<a href="#none" id="btn_load_dart_ent_${addRcpyId}" class="btn_in_dart"	onclick="loadDartEntList('${addRcpyId}')"><span>Dart데이터 불러오기</span></a>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">
							<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />관계기업구분
							<a href="#none" class="btn_code rcpy_div_dec"><img src="<c:url value="/images2/sub/help_btn.png" />" alt="?" style="float: right; margin-right: 5px" /></a>
						</th>
						<td><ap:code id="ad_rcpy_div_${addRcpyId}" grpCd="49" type="select" defaultLabel="" /></td>
						<th scope="row">
							<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 지분율</th>
						<td>
							<input required name="ad_qota_tr_${addRcpyId}" type="text" id="ad_qota_tr_${addRcpyId}" class="text qota_rt max100" style="width: 85px;" title="지분율" />%
						</td>
					</tr>
					<tr>
						<th scope="row">
							<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 기업명
						</th>
						<td>
							<input required maxlength="255" name="ad_entrprs_nm_${addRcpyId}" type="text" id="ad_entrprs_nm_${addRcpyId}" class="text" style="width: 191px;" title="기업명" />
						</td>
						<th scope="row">
							<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />법인등록구분
							<img src="<c:url value="/images2/sub/help_btn.png" />" class="reqstRcpy_jurir_divide" alt="?"	style="float: right; margin-right: 5px" /></th>
						<td>
							<select required name="ad_cpr_regist_se_${addRcpyId}" class="select_box" id="ad_cpr_regist_se_${addRcpyId}" style="width: 80px;" onchange="changedCprSe('${addRcpyId}','${lastYear}');">
								<option value="">선택</option>
								<option value="L">국내</option>
								<option value="F">해외</option>
						</select>&nbsp;통화 <a href="#none" class="btn_code crncy_cod_dec">
							<img src="<c:url value="/images2/sub/help_btn.png" />" alt="?" align="absmiddle" style="margin-top: 2px;" /></a> 
							<select name="ad_crncy_code_${addRcpyId}" class="select_box" id="ad_crncy_code_${addRcpyId}" onchange="changedCrnCyCode('${addRcpyId}','${lastYear}');">
								<option value="">-선택-</option>
								<c:forEach items="${crncy_code}" var="item" varStatus="status">
									<option value="${item.code}">${item.codeNm }</option>
								</c:forEach>
						</select> <!-- <ap:code id="ad_crncy_code_${addRcpyId}" grpCd="48" type="select" defaultLabel="선택" onchange="changedCrnCyCode('${addRcpyId}','${lastYear}')" />
                        	--></td>
					</tr>
					<tr>
						<th scope="row"><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />대표자명</th>
						<td colspan="3"><input required maxlength="255" name="ad_r_rprsntv_nm_ho_${addRcpyId}"
							type="text" id="ad_r_rprsntv_nm_ho_${addRcpyId}" class="text" style="width: 100%;"
							title="대표자명" /></td>
					</tr>
					<tr>
						<th scope="row"><label>법인등록번호</label></th>
						<td><input name="ad_jurirno_first_${addRcpyId}" type="text"
							id="ad_jurirno_first_${addRcpyId}" class="text numeric6" style="width: 82px;"
							title="법인등록번호앞자리" /> - <input name="ad_jurirno_last_${addRcpyId}" type="text"
							id="ad_jurirno_last_${addRcpyId}" class="text numeric7" style="width: 82px;"
							title="법인등록번호뒷자리" /></td>
						<th scope="row">사업자등록번호</th>
						<td><input name="ad_bizrno_first_${addRcpyId}" type="text"
							id="ad_bizrno_first_${addRcpyId}" class="text numeric3" style="width: 61px;"
							title="사업자등록번호앞자리" /> - <input name="ad_bizrno_middle_${addRcpyId}" type="text"
							id="ad_bizrno_middle_${addRcpyId}" class="text numeric2" style="width: 40px;"
							title="사업자등록번호가운데자리" /> - <input name="ad_bizrno_last_${addRcpyId}" type="text"
							id="ad_bizrno_last_${addRcpyId}" class="text numeric5" style="width: 61px;"
							title="사업자등록번호뒷자리" /></td>
					</tr>
					<tr>
						<!-- 
                        <th scope="row">
                        	<img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" name="img_dnRequiredMark_${addRcpyId}" /> 표준산업분류코드
                            <a href="#none" class="induty_cod_dec"><img src="<c:url value="/images/ic/btn_code.png" />" alt="?" style="float:right; margin-right:5px" /></a>
                        </th>
                        <td>
                        	<input required maxlength="5" name="ad_mn_induty_code_${addRcpyId}" type="text" id="ad_mn_induty_code_${addRcpyId}" class="text" style="width:55px;" title="표준산업분류코드" />
                            <div class="btn_inner"><a href="#none" class="btn_in_gray btn_search_code"><span>분류코드조회</span></a></div>
                        </td>
                   -->
						<th scope="row"><label>주업종</label></th>
						<td colspan="3"><select name="largeGroup_${addRcpyId}" class="select_box"
							id="largeGroup_${addRcpyId}" style="width: 250px"
							onchange="changelargeGroupSelectId(this.value, '${addRcpyId}');">
								<option value="noSelect">-선택-</option>
								<c:forEach items="${largeGroup}" var="item" varStatus="status">
									<option value="${item.lclasCd }">${item.lclasCd}: ${item.koreanNm }</option>
								</c:forEach>
						</select> <select name="smallGroup_${addRcpyId}" class="select_box" id="smallGroup_${addRcpyId}"
							style="width: 250px">
						</select></td>
					</tr>
					<tr>
						<th scope="row"><label>결산월</label></th>
						<td><select required id="ad_stacnt_mt_${addRcpyId}" name="ad_stacnt_mt_${addRcpyId}"
							class="stacnt_mt select_box" style="width: 75px;">
								<c:forTokens items="${MONTHS_TOKEN}" delims="," var="month">
									<option value="${month}">${month}</option>
								</c:forTokens>
						</select> 월
						<th scope="row"><label><img src="<c:url value="/images/ucm/bul03.png" />"
								alt="필수입력요소" name="img_dnRequiredMark_${addRcpyId}" /> 설립년월</label></th>
						<td><input required type="text" name="ad_fond_de_${addRcpyId}"
							id="ad_fond_de_${addRcpyId}" class="fond_de yyyy-MM-dd" title="날짜선택" /></td>
					</tr>
					<tr>
						<th scope="row">특이사항</th>
						<td colspan="3"><input maxlength="200" name="ad_partclr_matter_${addRcpyId}" type="text"
							id="ad_partclr_matter_${addRcpyId}" class="text" style="width: 100%;" title="특이사항"
							placeholder="법인 신규설립이나 분할˙합병 등의 특이 사항을 입력해 주세요" /></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--1.기업정보//-->

	<!--//2.주주명부-->
	<div class="request_tbl">
		<div class="write">
			<table class="table_form02">
				<caption>기업확인신청서작성입력게시판</caption>
				<colgroup>
					<col style="width: 16%" />
					<col style="width: 14%" />
					<col style="width: 21%" />
					<col style="width: 17%" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th rowspan="3" scope="row">지분 소유비율<br /> (최대3개 입력) </th>
						<th scope="row">
							<label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 주주명</label>
						</th>
						<td>
							<input required maxlength="255" name="ad_shrholdr_nm1_${addRcpyId}" type="text" id="ad_shrholdr_nm1_${addRcpyId}" class="text" style="width: 98%;" title="주주명" />
						</td>
						<th scope="row">
							<label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" /> 지분소유비율</label>
						</th>
						<td>
							<input required name="ad_qota_rt1_${addRcpyId}" type="text" id="ad_qota_rt1_${addRcpyId}" class="text qota_rt max100" style="width: 100%;" title="지분소유비율" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label> 주주명</label></th>
						<td>
							<input maxlength="255" name="ad_shrholdr_nm2_${addRcpyId}" type="text" id="ad_shrholdr_nm2_${addRcpyId}" class="text" style="width: 98%;" title="주주명" />
						</td>
						<th scope="row">
							<label> 지분소유비율</label>
						</th>
						<td>
							<input name="ad_qota_rt2_${addRcpyId}" type="text" id="ad_qota_rt2_${addRcpyId}" class="text qota_rt max100" style="width: 100%;" title="지분소유비율" />
						</td>
					</tr>
					<tr>
						<th scope="row"><label> 주주명</label></th>
						<td><input maxlength="255" name="ad_shrholdr_nm3_${addRcpyId}" type="text"
							id="ad_shrholdr_nm3_${addRcpyId}" class="text" style="width: 98%;" title="주주명" /></td>
						<th scope="row"><label> 지분소유비율</label></th>
						<td><input name="ad_qota_rt3_${addRcpyId}" type="text" id="ad_qota_rt3_${addRcpyId}"
							class="text qota_rt max100" style="width: 100%;" title="지분소유비율" /></td>
					</tr>
					<tr>
						<th scope="row" colspan="2"><label> 제출서류</label> 1)</th>
						<td colspan="3">주주명부 1부 (법인에 한함)<br /> <input name="file_${addRcpyId}_rf2_${lastYear}"
							type="file" id="file_${addRcpyId}_rf2_${lastYear}" style="width: 100%;" title="파일첨부" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--2.주주명부//-->

	<!--//2.매출액
    <div class="request_tbl">
	<div class="write">
		<table cellpadding="0" cellspacing="0" class="table_basic table_type" summary="매출액/년도별/합계/3년평균" >
			<caption>
			매출액입력
			</caption>
			<colgroup>
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			<col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">매출액</th>
					
					<c:forEach var="n" begin="0" end="2">
					<c:set var="year" value="${lastYear-n}" />
					<th scope="row">
						<label> ${year}년</label>
						<a href="#none" class="btn_code" onclick="getEntFnnr('${addRcpyId}','${year}')" >
							<img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" />
						</a>
					</th>
					<td><input name="ad_selng_am_${addRcpyId}_${year}" type="text" id="ad_selng_am_${addRcpyId}_${year}" class="numeric16 selAmR" style="width:40px;" title="매출액입력" /></td>
					</c:forEach>                        
					
					<th scope="row"><label> 합계</label></th>
					<td>
						<strong id="y3sum_selng_am_${addRcpyId}"></strong>
						<input name="ad_y3sum_selng_am_${addRcpyId}" type="hidden" id="ad_y3sum_selng_am_${addRcpyId}" class="numeric16" style="width:50px;" title="합계" />
					</td>
					<th scope="row"><label> 3년 평균</label></th>
					<td>
						<strong id="y3avg_selng_am_${addRcpyId}"></strong>
						<input name="ad_y3avg_selng_am_${addRcpyId}" type="hidden" id="ad_y3avg_selng_am_${addRcpyId}" class="numeric16" style="width:50px;" title="3년평균매출액" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	</div>
 -->

	<!--//2.매출액-->
	<div class="request_tbl">
		<div class="table_hrz_add">
			<table class="table_form02 finance_table ">
				<%-- <caption>매출액입력</caption> --%>
				<colgroup>
					<col style="width: 100px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
				</colgroup>
				<tbody>
					<tr>
						<th rowspan="2" scope="row">매출액(원)
						<img src="<c:url value="/images2/sub/help_btn.png" />" class="reqstRcpy_amount_unit" alt="?" style="float: right; margin-right: 5px" /></th>
						<c:forEach var="n" begin="0" end="2">
							<c:set var="year" value="${lastYear-n}" />
							<th scope="row"><label> ${year}년</label> 
							<a href="#none" class="form_blBtn" onclick="getEntFnnr('${addRcpyId}','${year}')">Dart자료 
								<%-- <img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" /> --%> 
							</a>
								</th>
						</c:forEach>
						<th scope="row"><label> 합계</label></th>
						<th scope="row"><label> 3년 평균</label></th>
					</tr>
					<tr>
						<c:forEach var="n" begin="0" end="2">
							<c:set var="year" value="${lastYear-n}" />
							<td>
							<%-- <select name="ad_amount_unit_${addRcpyId}_${year}" id="ad_amount_unit_${addRcpyId}_${year}" style="width: 102px;" class="amount-unit-${addRcpyId} select_box">
									<option value="1">원</option>
									<option value="1000000">백만원</option>
							</select>  --%>
							<input name="ad_selng_am_${addRcpyId}_${year}" id="ad_selng_am_${addRcpyId}_${year}" type="text" numberOnly class="-numeric18 selAmR" style="width: 100px; margin-top: 3px" title="매출액입력" />
								</td>
						</c:forEach>

						<td>
							<strong id="y3sum_selng_am_${addRcpyId}"></strong> 
							<input name="ad_y3sum_selng_am_${addRcpyId}" type="hidden" id="ad_y3sum_selng_am_${addRcpyId}" class="-numeric18" style="width: 50px;" title="합계" />
						</td>
						<td>
							<strong id="y3avg_selng_am_${addRcpyId}"></strong> 
							<input name="ad_y3avg_selng_am_${addRcpyId}" type="hidden" id="ad_y3avg_selng_am_${addRcpyId}" class="-numeric18" style="width: 50px;" title="3년평균매출액" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--3.매출액//-->

	<!--//4.재무정보-->
	<div class="request_tbl">
		<div class="table_hrz_add">
			<!--//table1-->
			<table class="table_form02 finance_table ">
				<caption>재무정보년도별입력테이블</caption>
				<colgroup>
					<col style="width: 100px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
					<col style="width: 110px" />
				</colgroup>
				<thead>
					<th></th>
					<th class="tac">자본금 (원)</th>
					<th class="tac">자본잉여금 (원)</th>
					<th class="tac">자본총계 (원)</th>
					<th class="tac">자산총액 (원)</th>
					<th class="tac">상시근로자수</th>
				</thead>
				<tbody>
					<tr>
						<th scope="row"><label><img src="<c:url value="/images/ucm/bul03.png" />" alt="필수입력요소" />${lastYear} 
						<a href="#none" class="form_blBtn" onclick="getEntFnnr('${addRcpyId}','${lastYear}')"> Dart자료 
						<%-- <img src="<c:url value="/images/ic/btn_dart.png" />" alt="dart자료" /> --%> 
						</a>
						</label></th>
						<td>
							<input name="ad_capl_${addRcpyId}_${lastYear}" type="text" numberOnly id="ad_capl_${addRcpyId}_${lastYear}" class="-numeric18" style="width: 100px;" title="${lastYear}년자본금" /> 
							<span id="span_capl_${addRcpyId}_${lastYear}"></span>
						</td>
						<td>
							<input name="ad_clpl_${addRcpyId}_${lastYear}" type="text" numberOnly id="ad_clpl_${addRcpyId}_${lastYear}" class="-numeric18" style="width: 100px;" title="${lastYear}년자본잉여금" /> 
							<span id="span_clpl_${addRcpyId}_${lastYear}"></span>
						</td>
						<td>
							<input name="ad_capl_sm_${addRcpyId}_${lastYear}" type="text" numberOnly id="ad_capl_sm_${addRcpyId}_${lastYear}" class="-numeric18" style="width: 100px;" title="${lastYear}년자본총계" /> 
							<span id="span_capl_sm_${addRcpyId}_${lastYear}"></span>
						</td>
						<td>
						<input required name="ad_assets_totamt_${addRcpyId}_${lastYear}" type="text" numberOnly id="ad_assets_totamt_${addRcpyId}_${lastYear}" class="-numeric18" style="width: 100px;" title="${lastYear}년자산총액" /> 
							<span id="span_assets_totamt_${addRcpyId}_${lastYear}"></span>
						</td>
						<td><input <c:if test="${lastYear>2013}">disabled</c:if> name="ad_ordtm_labrr_co_${addRcpyId}_${lastYear}" type="text" numberOnly id="ad_ordtm_labrr_co_${addRcpyId}_${lastYear}" class="numeric10" style="width: 30px;" title="${lastYear}년상시근로자수" /> (명)</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div>
			<!--//table2-->
			<div class="mgt12">
				<table class="table_form02">
					<caption>년도별제출서류입력테이블</caption>
					<colgroup>
						<col style="width: 99px" />
						<col style="width: 95px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제출서류2)</th>
							<th>국내법인</th>
							<td>직전 3개 사업연도 감사보고서 원본1부<br /> (재무제표, 세법이 정하는 회계장부, 「주식회사의 외부감사에 관한 법률」제 8조에 따라 제출한 감사
								보고서 등) 직전 3개 사업연도 내에 감사가 진행되었던 년도의 보고서만 업로드 하시면 됩니다.
							</td>
						</tr>
						<c:forEach var="n" begin="0" end="3">
							<c:set var="year" value="${lastYear-n}" />
							<tr>
								<th scope="row" colspan="2"><label> ${year}년</label></th>
								<td><input name="file_${addRcpyId}_rf1_${year}" type="file"
									id="file_${addRcpyId}_rf1_${year}" style="width: 100%;" title="파일첨부" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!--4.재무정보//-->

	<c:if test="${lastYear <= 2013}">
		<!--//5.입력-->
		<div class="request_tbl" id="labrr_table_${addRcpyId}" style="display: none">
			<div class="table_hrz_add">
				<!--//table1-->
				<table class="table_form02">
					<caption>재무정보년도별입력테이블</caption>
					<colgroup>
						<col style="width: 80px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: 39px" />
						<col style="width: *" />
						<col style="width: 56px" />
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
					<tbody>
						<tr>
							<th scope="row"><label>${lastYear}</label></th>
							<td><input name="ad_ordtm_labrr_co1_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co1_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년1월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co2_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co2_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년2월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co3_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co3_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년3월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co4_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co4_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년4월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co5_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co5_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년5월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co6_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co6_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년6월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co7_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co7_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년7월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co8_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co8_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년8월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co9_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co9_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년9월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co10_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co10_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년10월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co11_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co11_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년11월상시근로자수" /></td>
							<td><input name="ad_ordtm_labrr_co12_${addRcpyId}_${lastYear}" type="text"
								id="ad_ordtm_labrr_co12_${addRcpyId}_${lastYear}" class="numeric10 labbr"
								style="width: 25px;" title="${lastYear}년12월상시근로자수" /></td>
							<td><strong id="ordtm_labrr_sum_${addRcpyId}_${lastYear}"></strong> <input type="hidden"
								name="ad_ordtm_labrr_sum_${addRcpyId}_${lastYear}"
								id="ad_ordtm_labrr_sum_${addRcpyId}_${lastYear}" /></td>
							<td><strong id="ordtm_labrr_avg_${addRcpyId}_${lastYear}"></strong> <input type="hidden"
								name="ad_ordtm_labrr_avg_${addRcpyId}_${lastYear}"
								id="ad_ordtm_labrr_avg_${addRcpyId}_${lastYear}" /></td>
						</tr>
						<tr>
							<th scope="row"><label for="add_t4_info2">제출서류3)</label></th>
							<td colspan="14" class="tal">월별 원천징수이행상황신고서 원본1부</td>
						</tr>
						<tr>
							<th scope="row"><label>${lastYear}년</label></th>
							<td colspan="14" class="tal"><input name="file_${addRcpyId}_rf0_${lastYear}" type="file"
								id="file_${addRcpyId}_rf0_${lastYear}" style="width: 100%;" title="파일첨부" /></td>
						</tr>
					</tbody>
				</table>
				<!-- 유의사항-->
				<h4 class="mgt30">[신청서 작성시 유의사항]</h4>
				<div class="care">
					<ul>
						<li>지분소유비율<br /> - 30%이상 지분을 갖는 주주만 입력합니다.
						</li>
						<li>서류작성<br /> 1.직전 사업연도 월별 원천징수이행상황신고서(매월 근로자 확인이 가능한 서류)<br /> - 사본은 세무사 등 적격자의 원본대조필
							확인<br /> 2.직전 3개 사업연도 감사보고서(재무제표 또는 세법이 정하는 회계장부 1부)<br /> - 사본은 세무사 등 적격자의 원본대조필 확인<br />
							3.주주명부 1부(법인에 한함)<br /> - 사본은 원본대조필 확인<br /> 4.첨부가능한 파일 확장자<br /> - hwp, doc, docx, pdf,
							jpg, jpge, zip
						</li>
					</ul>
				</div>
			</div>
			<!--//table2-->
			<div></div>
		</div>
		<!--5.입력//-->
	</c:if>
</div>
<!--////////////////////////////////////관계기업추가-삭제////////////////////////////////////-->