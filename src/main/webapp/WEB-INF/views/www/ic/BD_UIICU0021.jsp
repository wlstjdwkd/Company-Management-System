<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.tech.kr/jsp/jstl" prefix="ap"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>기업 종합정보시스템</title>
<ap:jsTag type="web" items="jquery,form,validate,selectbox" />
<ap:jsTag type="tech" items="msg,util,cmn, mainn, subb, font,ic" />
<script type="text/javascript">
	$(document).ready(function() {
		// 약관동의
		$("#btn_agree_terms").click(function() {
			if(document.getElementById("chk_terms01").checked && document.getElementById("chk_terms02").checked && document.getElementById("chk_terms03").checked ) {
			   // alert("모두체크 ");
			   }else{
			    alert(Message.msg.agreeAllTerms);
			    return false;
			   }
			$("#dataForm").submit();
		});

		// 약관동의안함
		$("#btn_disagree_terms").click(function() {
			alert(Message.msg.disagreeTrems02);
		});

		// 유효성 검사
		$("#dataForm").validate({
			/* 	rules : {
				chk_terms01 : {
					required : true,
				},
				chk_terms02 : {
					required : true,
				},
				chk_terms03 : {
					required : true,
				},
			}, */
			showErrors : function(errorMap, errorList) {
				if (this.numberOfInvalids()) {
					alert(Message.msg.agreeAllTerms02);
				}
			},
			onkeyup : false,
			onclick : false,
			onfocusout : false,
			submitHandler : function(form) {
				form.submit();
			}
		});
	});
	
	function popPrivacy() {
		window.open("/popup/privacyPolicyRev.html","privacyPolicyRev","width=500,height=560, left=20, top=24, scrollbars=yes, resizable=no");
	}
</script>
</head>
<body>
<form name="dataForm" id="dataForm" method="post" action="PGIC0022.do">
    <ap:include page="param/defaultParam.jsp" />
    <ap:include page="param/dispParam.jsp" />
    <input type="hidden" name="ad_entrprs_nm" value="${param.ad_entrprs_nm}" />
    <input type="hidden"
			name="ad_bizrno_first" value="${param.ad_bizrno_first}" />
    <input type="hidden"
			name="ad_bizrno_middle" value="${param.ad_bizrno_middle}" />
    <input type="hidden"
			name="ad_bizrno_last" value="${param.ad_bizrno_last}" />
    <input type="hidden"
			name="ad_confm_target_yy" value="${param.ad_confm_target_yy}" />
    <input type="hidden"
			name="ad_jdgmnt_reqst_year" value="${param.ad_jdgmnt_reqst_year}" />
    <input type="hidden"
			name="ad_stacnt_mt_ho" value="${param.ad_stacnt_mt_ho}" />
	<input type="hidden"
			name="ad_excpt_trget_at" value="${param.ad_excpt_trget_at}" />
    <!--//content-->
    <div id="wrap">
        <div class="s_cont" id="s_cont">
		<div class="s_tit s_tit02">
			<h1>기업확인</h1>
		</div>
		<div class="s_wrap">
			<div class="l_menu">
				<h2 class="tit tit2">기업확인</h2>
				<ul>
				</ul>
			</div>
			<div class="r_sec">
				<div class="r_top">
					<ap:trail menuNo="${param.df_menu_no}" />
				</div>
				<div class="r_cont s_cont02_04">
					<div class="step_sec" style="margin-bottom: 40px;">
						<ul>
							<li>1.기본확인</li><!--공백제거
							--><li class="arr"> </li><!--공백제거
							--><li class="on">2.약관동의</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>3.신청서작성</li><!--공백제거
							--><li class="arr"></li><!--공백제거
							--><li>4.신청완료</li>
						</ul>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">확인서 신청에 대한 안내</h4>
						<div class="clause_sec">
							<div class="scroll_sec">
						<p>기업임이 확인 될 경우 기업명, 법인등록번호, 확인서 발급번호 공개에 동의합니다.</p>
						<p>기업확인서 신청 시 신청기업 정보 및 자가진단서 등을 허위로 작성하여 확인서를 발급받아 책임은 신청기업에게 있으며 <br/>이에 이의가 없음을 확인합니다. </p>
						<p>사실과 다른 내용 또는 허위자료를 제출 (동 시슷템 화면에 직접 입력한 사항 포함)하여 기업이 아닌 자가 기업 시책에 참여한 경우<br/>「기업 성장촉진 및 경쟁력 강화에 관한 특별법」 제 31조 및 동법 시행령 16조에 따라 500만 원 이하의 과태료가 부과되며,<br/>기존에 지원 받은 사항은 무료 또는 취소, 회수 될 수 있습니다. </p>
						</div>
						<ul class="check_sy">
							<li>
								<input type="checkbox" id="chk_terms01" name="chk_terms01">
								<label for="chk_terms01"></label>
								<label for="chk_terms01">위 정보 공개에 동의합니다.</label>
							</li>
						</ul>
						</div>
						</div>
<!-- 					<div class="agree_st cust01">
						<p class="list_noraml cust02">기업임이 확인 될 경우 기업명, 법인등록번호, 확인서 발급번호 공개에 동의합니다.</p>
						<p class="list_noraml cust02">기업확인서 신청 시 신청기업 정보 및 자가진단서 등을 허위로 작성하여 확인서를 발급받아 책임은 신청기업에게 있으며 <br/>이에 이의가 없음을 확인합니다. </p>
						<p class="list_noraml cust02">사실과 다른 내용 또는 허위자료를 제출 (동 시슷템 화면에 직접 입력한 사항 포함)하여 기업이 아닌 자가 기업 시책에 참여한 경우<br/>「기업 성장촉진 및 경쟁력 강화에 관한 특별법」 제 31조 및 동법 시행령 16조에 따라 500만 원 이하의 과태료가 부과되며,<br/>기존에 지원 받은 사항은 무료 또는 취소, 회수 될 수 있습니다. </p>
					</div>
 -->					<div class="list_bl">
						<h4 class="fram_bl">개인정보 수집 및 이용에 대한 안내</h4>
						<div class="clause_sec">
							<div class="scroll_sec">
								<p class="tit">개인정보처리방침</p>
								<p>산업통상자원부가 취급하는 모든 개인정보는 개인정보 보호법 및 산업통상자원부 개인정보 보호지침 등 관련 법령상의 개인정보 보호 규정을 준수하여 수집&middot;보유&middot;처리되고 있습니다. 산업통상자원부는 개인정보 보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다. 산업통상자원부는 개인정보 처리방침을 변경하는 경우에는 시행의 시기, 변경된 내용을 정보주체가 쉽게 확인할 수 있도록 변경 전•후를 비교하여 공개하도록 할 예정입니다. <br/><br/></p>
								<p class="tit">【기업 정보 홈페이지 이용자의 개인정보 보호】</p>
								<p>본 홈페이지는 기업 정보 웹사이트입니다. 우리 부의 기업 정보 이용에 대해 감사 드리며, 기업 정보에서의 개인 정보보호방침에 대하여 설명을 드리겠습니다. 이는 현행 『개인정보 보호법』및 『표준 개인정보 보호지침』에 근거를 두고 있습니다. 이 방침은 별도의 설명이 없는 한 우리 부에서 운용하는 모든 웹사이트에 적용됨을 알려드립니다.<br/></p>
								<ul>
									<li>기업 정보 홈페이지 :https://www.mme.or.kr<br/><br/></li>
								</ul>
								<p class="tit">자동적으로 수집&middot;저장되는 개인정보</p>
								<p>이용자가 우리 부의 기업 정보 홈페이지를 이용할 경우 다음의 정보는 자동적으로 수집•저장됩니다.<br/></p>
								<ul>
									<li>이름, 휴대전화번호, 이메일주소 등 개인정보</li>
									<li>각 사업자의 기업정보와 신청정보 등</li>
									<li>이용자의 인터넷서버 도메인과 우리 홈페이지를 방문할 때 거친 웹사이트의 주소</li>
									<li>이용자의 브라우져 종류 및 OS, IP</li>
									<li>방문일시 등<br/><br/></li>
								</ul>
								<p>위와 같이 자동 수집&middot;저장되는 정보는 이용자에게 보다 나은 서비스를 제공하기 위해 홈페이지의 개선과 보완을 위한 통계분석, 이용자와 웹사이트간의 원활한 의사소통 등을 위해 이용될 것입니다. 다만, 법령의 규정에 따라 이러한 정보를 제출하게 되어 있을 경우도 있다는 것을 유념하시기 바랍니다.<br/><br/></p>
								<p class="tit">이메일 및 웹 서식 등을 통한 수집정보</p>
								<ul>
									<li>이용자가 홈페이지에 기재한 사항은 다른 사람들이 조회 또는 열람할 수도 있습니다.이용자가 기재한 사항은 관련 법규에 근거하여 필요한 다른 사람과 공유될 수 있으며, 관련법령의 시행과 정책개발의 자료로도 사용될 수 있습니다. 또한, 이러한 정보는 타 부처와 공유되거나, 필요에 의하여 제공될 수도 있습니다. 홈페이지 보안을 위해 관리적&middot;기술적 노력을 하고 있으나, 만약의 침해사고 시 문제가 될 수 있는 민감한 정보의 기재는 피하여 주시기 바랍니다.<br/><br/></li>
								</ul>
								<p class="tit">개인정보의 수집&middot;이용목적</p>
								<p>기업 정보 사이트에서 기업 상세정보를 제공하기 위하여 사용자등록이 필요합니다. 또한, 산업통상자원부에서는 이용자들에게 메일링서비스, SMS를 비롯한 보다 더 향상된 양질의 서비스를 제공하기 위하여 이용자 개인의 정보를 수집, 이용하고 있습니다.<br/><br/></p>
								<p class="tit">개인정보의 열람&middot;정정</p>
								<p>기업 정보의 회원으로 가입하신 분께서는 언제든지 개인정보를 열람하거나 정정하실 수 있습니다. 개인정보를 열람 또는 정정하고자 하실 때에는 내정보관리를 클릭하여 직접 열람 또는 정정을 하시거나, 담당자에게 전화 또는 E-Mail로 연락하시면 지체 없이 조치해 드리겠습니다. 이용자께서 개인정보의 오류에 대한 정정을 요청하신 경우, 정정을 완료하기 전까지 개인정보를 이용하거나 제공하지 않습니다.<br/><br/></p>
								<p class="tit">웹사이트에서 운영하는 보안조치</p>
								<p>홈페이지 보안 또는 지속적인 서비스를 위해, 우리 부는 네트워크 트래픽의 통제(Monitor)는 물론 불법적으로 정보를 변경 시도를 탐지하기 위해 여러 가지 프로그램을 운영하고 있습니다.</p>
								<ul>
									<li>이용자가 홈페이지에 기재한 사항은 다른 사람들이 조회 또는 열람 할 수도 있습니다. 이용자가 홈페이지에 기재한 내용 중 개인정보가 포함되어 있는 경우 개인정보를 삭제 조치 후 게시하여야 합니다.<br/><br/></li>
								</ul>
								<p>※ "개인정보"라 함은 생존하는 개인에 관한 정보로서 당해 정보에 포함되어있는 성명, 주민등록번호 및 화상 등의 사항에 의하여 당해 개인을 식별 할 수 있는 정보(당해 정보만으로는 특정개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함한다)를 말한다.<br/><br/></p>
								<p class="tit">링크 사이트&middot;웹 페이지</p>
								<p>산업통상자원부에서 운영하는 여러 웹페이지에 포함된 링크 또는 배너를 클릭하여 다른 사이트 또는 웹페이지로 옮겨갈 경우 개인정보처리방침은 그 사이트 운영기관이 게시한 방침이 적용되므로 새로 방문한 사이트의 방침을 확인하시기 바랍니다.<br/><br/></p>
								<p class="tit">웹사이트 이용 중 다른 사람의 개인정보 취득</p>
								<p>산업통상자원부에서 운영하는 웹사이트에서 이메일 주소 등 식별할 수 있는 개인정보를 취득하여서는 안 됩니다. 허위, 기타 부정한 방법으로 이러한 개인정보를 열람 또는 제공받은 자는 관계 법규(「개인정보 보호법」 제9장 벌칙)에 의하여 처벌을 받을 수 있습니다.<br/><br/></p>
								<p class="tit">【컴퓨터에 의해 처리되는 개인정보에 대한 취급 및 보호방침】</p>
								<p class="tit">개인정보의 수집 및 보유</p>
								<p>산업통상자원부는 법령의 규정과 정보주체의 동의에 의해서만 개인정보를 수집&middot;보유합니다.</p>
								<ul>
									<li>화일명 : 기업 정보 고객정보</li>
									<li>보유목적 : 기업 정보 회원관리 및 조회이력 관리</li>
									<li>수집방법 : 온라인 수집(홈페이지 회원가입)</li>
									<li>대상범위 : 기업 정보 회원</li>
									<li>열람청구부서 및 주소 : 세종특별자치시 한누리대로 402 12동, 13동 산업통상자원부 정보보호담당관실</li>
									<li>열람제한항목 : 없음</li>
									<li>기록항목 : 성명, 전화번호, 이메일, 주소, 회사명 등<br/><br/></li>
								</ul>
								<p>산업통상자원부는 보유하고 있는 국민 이용자의 개인정보를 관계법령에 따라 적법하고 적정하게 처리하여, 권익이 침해 받지 않도록 노력할 것입니다.<br/><br/></p>
								<p class="tit">개인정보의 이용 및 제3자 제공의 제한</p>
								<p>산업통상자원부는 수집•보유하고 있는 개인정보는 일반 행정정보와 달리 이용 및 제공에 엄격한 제한이 있는 정보입니다. 『개인정보 보호법』 제18조 (개인정보의 이용•제공 제한)는 다음에 경우 개인정보를 목적 외의 용도로 이용하거나 제3자에게 제공할 수 있도록 규정하고 있습니다.</p>
								<p>- 정보주체로부터 별도의 동의를 받은 경우</p>
								<p>- 다른 법률에 특별한 규정이 있는 경우</p>
								<p>- 정보주체 또는 그 법정대리인이 의사표시를 할 수 없는 상태에 있거나 주소불명 등으로 사전 동의를 받을 수 없는 경우로서 명백히 정보주체 또는 제3자의 급박한 생명, 신체, 재산의 이익을 위하여 필요하다고 인정되는 경우</p>
								<p>- 통계작성 및 학술연구 등의 목적을 위하여 필요한 경우로서 특정 개인을 알아볼 수 없는 형태로 개인정보를 제공하는 경우</p>
								<p>- 개인정보를 목적 외의 용도로 이용하거나 이를 제3자에게 제공하지 아니하면 다른 법률에서 정하는 소관 업무를 수행할 수 없는 경우로서 개인정보보호위원회의 심의·의결을 거친 경우</p>
								<p>- 조약, 그 밖의 국제협정의 이행을 위하여 외국정부 또는 국제기구에 제공하기 위하여 필요한 경우</p>
								<p>- 범죄의 수사와 공소의 제기 및 유지를 위하여 필요한 경우</p>
								<p>- 법원의 재판업무 수행을 위하여 필요한 경우</p>
								<p>- 형(刑) 및 감호, 보호처분의 집행을 위하여 필요한 경우<br/><br/></p>
								<ul>
									<li>산업통상자원부에서 제공하는 개인정보를 제공받은 기관은 우리 부의 동의 없이 타 기관에 제공할 수 없습니다.</li>
									<li>산업통상자원부는 개인정보의 이용 및 제공에 있어 관계법령을 엄수하여 부당하게 이용되지 않도록 노력하겠습니다.</li>
									<li>산업통상자원부가 위 법령 및 기타 개별법에 근거하여 통상적으로 다른 기관에 제공하는 개인정보 현황은 다음과 같습니다.<br/></br></li>
								</ul>
								<table>
									<tbody>
										<tr>
											<th>개인정보파일</th>
											<th>정보제공처</th>
											<th>이용목적</th>
											<th>제공항목</th>
											<th>보유 및 이용기간</th>
										</tr>
										<tr>
											<th>-</th>
											<th>-</th>
											<th>-</th>
											<th>-</th>
											<th>-</th>
										</tr>
									</tbody>
								</table>
								<p><br/><br/></p>
								<p class="tit">개인정보의 위탁관리</p>
								<p>산업통상자원부 기업 정보은 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다. 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
								<ul>
									<li>위탁처리 기관</li>
								</ul>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 수탁업체명 : 연합회</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 주소 : 서울특별시 영등포구 양평로 21길26 (양평로5가 선유도역 1차 아이에스비즈타워)607호</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 전화 : 02-761-7701</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 근무시간 : 09:00 - 18:00</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 위탁내용 : 시스템 운영 및 유지보수, 데이터 추출 및 가공, SMS등의 발송대행 등</p>
								<ul>
									<li>위탁업무 수행 목적 외 개인정보의 처리 금지에 관한 사항, 개인정보의 관리적·기술적 보호조치에 관한 사항, 개인정보의 안전관리에 관한 사항 위탁업무의 목적 및 범위, 재위탁 제한에 관한 사항, 개인정보 안전성 확보 조치에 관한 사항, 위탁업무와 관련하여 보유하고 있는 개인정보의 관리현황점검 등 감독에 관한 사항, 수탁자가 준수하여야할 의무를 위반한 경우의 손해배상책임에 관한 사항 또한, 위탁하는 업무의 내용과 개인정보 처리업무를 위탁받아 처리하는 자(“수탁자”)에 대하여 해당 홈페이지에 공개하고 있습니다.</li>
								</ul>
								<p><br/></p>
								<p class="tit">정보주체의 권리&middot;의무 및 그 행사 방법</p>
								<p>정보주체는 아래와 같은 권리를 행사 할 수 있으며, 만14세 미만 아동의 법정대리인은 그 아동의 개인정보에 대한 열람, 정정·삭제, 처리정지를 요구할 수 있습니다</p>
								<ul>
									<li><strong>개인정보 열람 요구</strong><br/>산업통상자원부에서 보유하고 있는 개인정보파일은 「개인정보 보호법」 제35조(개인정보의 열람)에 따라 자신의 개인정보에 대한 열람을 요구할 수 있습니다. 다만, 개인정보 열람 요구는 법 제35조 5항에 의하여 아래와 같이 제한될 수 있습니다.</li>
								</ul>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 정보주체로부터 별도의 동의를 받는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 다른 사람의 생명·신체를 해할 우려가 있거나 다른 사람의 재산과 그 밖의 이익을 부당하게 침해할 우려가 있는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 공공기관이 아래 각 목의 어느 하나에 해당하는 업무를 수행할 때 중대한 지장을 초래하는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;가. 조세의 부과·징수 또는 환급에 관한 업무</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;나. 학력·기능 및 채용에 관한 시험, 자격 심사에 관한 업무</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;다. 보상금·급부금 산정 등에 대하여 진행 중인 평가 또는 판단에 관한 업무</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;라. 다른 법률에 따라 진행 중인 감사 및 조사에 관한 업무</p>
								<ul>
									<li><strong>개인정보 정정&middot;삭제 요구</strong><br/>산업통상자원부에서 보유하고 있는 개인정보파일은 「개인정보 보호법」 제36조(개인정보의 정정·삭제)에 따라 정정·삭제를 요구할 수 있습니다. 다만, 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.</li>
								</ul>
								<ul>
									<li><strong>개인정보 처리정지 요구</strong><br/>산업통상자원부에서 보유하고 있는 개인정보파일은 「개인정보보호법」 제37조(개인정보의 처리정지 등)에 따라 처리정지를 요구할 수 있습니다. 다만, 개인정보 처리정지 요구는 법 제37조 2항에 의하여 거절될 수 있습니다.</li>
								</ul>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 정보주체로부터 별도의 동의를 받은 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 다른 법률에 특별한 규정이 있는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 정보주체 또는 그 법정대리인이 의사표시를 할 수 없는 상태에 있거나 주소불명 등으로 사전 동의를 받을 수 없는 경우로서 명백히 정보주체 또는 
제3자의 급박한 생명, 신체, 재산의 이익을 위하여 필요하다고 인정되는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 통계작성 및 학술연구 등의 목적을 위하여 필요한 경우로서 특정 개인을 알아볼 수 없는 형태로 개인정보를 제공하는 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 개인정보를 목적 외의 용도로 이용하거나 이를 제3자에게 제공하지 아니하면 다른 법률에서 정하는 소관 업무를 수행할 수 없는 경우로서 개인정보보호위원회의 심의·의결을 거친 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 조약, 그 밖의 국제협정의 이행을 위하여 외국정부 또는 국제기구에 제공하기 위하여 필요한 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 범죄의 수사와 공소의 제기 및 유지를 위하여 필요한 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 법원의 재판업무 수행을 위하여 필요한 경우</p>
								<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 형(刑) 및 감호, 보호처분의 집행을 위하여 필요한 경우</p>
								<p><br/></p>
								<p class="tit">개인정보 정정·삭제 요구</p>
								<p>산업통상자원부는 원칙적으로 개인정보 보존기간이 경과되거나, 개인정보 처리목적이 달성된 경우에는 지체 없이 파기합니다. 파기의 절차, 기한 및 방법은 아래와 같습니다.</p>
								<ul>
									<li><strong>파기 절차</strong><br/>개인정보는 목적 달성 후 즉시 또는 별도의 공간에 옮겨져 내부 방침 및 기타 관련법령에 따라 일정기간 저장된 후 파기됩니다. 별도의 공간으로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</li>
									<li><strong>파기 기한 및 파기 방법</strong><br/>보유기간이 만료되었거나 개인정보의 처리목적달성, 해당 업무의 폐지 등 그 개인정보가 불필요하게 되었을 때에는 지체없이 파기합니다. 전자적 파일형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.</li>
								</ul>
								<p><br/></p>
								<p class="tit">개인정보의 안전성 확보 조치</p>
								<p>산업통상자원부는 개인정보 보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적, 관리적, 물리적 조치를 하고 있습니다.</p>
								<ul>
									<li><strong>개인정보 취급직원의 최소화 및 교육 실시</strong><br/>개인정보를 취급하는 직원은 반드시 필요한 인원에 한하여 지정·관리하고 있으며 취급직원을 대상으로 안전한 관리를 위한 교육을 실시하고 있습니다.</li>
									<li><strong>개인정보에 대한 접근 제한</strong><br/>개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여·변경·말소를 통하여 개인정보에 대한 접근통제를 위한 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.</li>
									<li><strong>접속기록의 보관</strong><br/>개인정보처리시스템에 접속한 기록(웹 로그, 요약정보 등)을 최소 6개월 이상 보관·관리하고 있습니다.</li>
									<li><strong>개인정보의 암호화</strong><br/>개인정보는 암호화 등을 통해 안전하게 저장 및 관리되고 있습니다. 또한 중요한 데이터는 저장 및 전송 시 암호화하여 사용하는 등의 별도 보안기능을 사용하고 있습니다.</li>
									<li><strong>보안프로그램 설치 및 주기적 점검·갱신</strong><br/>해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적으로 갱신·점검하고 있습니다</li>
									<li><strong>비인가자에 대한 출입 통제</strong><br/>개인정보를 보관하고 있는 개인정보시스템의 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.</li>
									<li><strong>정기적인 자체 점검 실시</strong><br/>개인정보 취급 관련 안정성 확보를 위해 정기적으로 소속·산하기관을 포함하여 개인정보 보호관리 점검을 실시하고 있습니다.</li>
									<li><strong>내부관리계획의 수립 및 시행</strong><br/>개인정보의 안전한 처리를 위하여 내부관리계획을 수립하고 시행하고 있습니다.</li>
								</ul>
								<p><br/></p>
								<p class="tit">개인정보 보호책임자 및 담당자</p>
								<p>산업통상자원부는 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 개인정보 보호 책임자 및 담당자를 지정하고 있습니다.</p>
								<ul>
									<li>개인정보 보호책임관 : 정책기획관 윤갑석</li>
									<li>개인정보보호 담당자 : 정보보호담당관실 이봉교<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 연락처 : 044-203-5597 (Fax : 044-203-4796)</li>
									<li>개인정보보호 담당자 : 정보보호담당관실 서준혁<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 연락처 : 044-203-5596 (Fax : 044-203-4796)</li>
								</ul>
								<p><br/></p>
								<p class="tit">권익침해 구제방법</p>
								<p>개인정보주체 및 법정대리인은 개인정보침해로 인한 피해를 구제 받기 위하여 개인정보 분쟁조정위원회, 한국인터넷진흥원 개인정보 침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다.</p>
								<ul>
									<li>개인정보 분쟁조정위원회 : 2-2100-2499 (www.kopico.go.kr), (국번없이) 118 (privacy.kisa.or.kr)</li>
									<li>개인정보 침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)</li>
									<li>대검찰청 사이버범죄수사과 : 02-3480-3570 (cybercid.spo.go.kr)</li>
									<li>경찰청 사이버안전국 : 02-3150-2659 (cyberbureau.police.go.kr)</li>
								<ul>
								<p>또한, 개인정보의 열람, 정정·삭제, 처리정지 등에 대한 정보주체자의 요구에 대하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익을 침해 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.</p>
								<ul>
									<li>행정심판에 대한 자세한 사항은 국민권익위원회(www.acrc.go.kr) 홈페이지를 참고하시기 바랍니다.</li>
								</ul>
								<p><br/></p>
								<p>개인정보 처리방침 변경</p>
								<ul>
									<li>이 개인정보 처리방침은 2017. 9. 1.부터 적용됩니다.</li>
									<li>이전의 개인정보 처리방침은 아래에서 확인 하실 수 있습니다.<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 2015. 5. 15 – 2017. 8. 31. 적용방침 바로가기</li>
								<ul>
							</div>
							<ul class="check_sy">
								<li>
									<input type="checkbox" id="chk_terms02" name="chk_terms02">
									<label for="chk_terms02"></label>
									<label for="chk_terms02">개인정보처리방침에 동의합니다.</label>
								</li>
							</ul>
						</div>
					</div>
					<div class="list_bl">
						<h4 class="fram_bl">행정정보 공동이용에 대한 약관</h4>
						<div class="clause_sec">
							<div class="scroll_sec">
								<p>1. 공동이용의 목적(공동이용을 통하여 처리하는 사무) : 기업 확인서 발급 신청<br/><br/>
									2. 공동이용 대상 행정정보 : 2 종<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;- 법인등기부등본<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;- 사업자등록증사본<br/><br/>
									3. 이용기관의 명칭 : 연합회<br/>
									본인은 이 건 사무의 처리와 관련하여 「전자정부법」 제21조 제1항 또는 제22조의2 제1항에 따른 행정정보의 공동이용을 통하여 이용기관의 민원담당자가 전자적으로 귀하의 정보를 확인하는 것에 동의합니다.(위에 기재된 공동이용 대상 행정정보는 목적 외의 용도로 사용될 수 없으며, 만약 전자적 확인에 대하여 본인이 동의하지 아니하는 경우에는 본인의 선택에 따라 서류로 대신 제출할 수 있음)
								</p>
							</div>
							<ul class="check_sy">
								<li>
									<input type="checkbox" id="chk_terms03" name="chk_terms03">
									<label for="chk_terms03"></label>
									<label for="chk_terms03">개인정보처리방침에 동의합니다.</label>
								</li>
							</ul>
						</div>
					</div>
					<div class="btn_bl">
						<a href="#none" id="btn_agree_terms">동의함</a><!-- 공백제거
						--><a href="#none" id="btn_disagree_terms" class="wht">동의하지 않음</a>
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