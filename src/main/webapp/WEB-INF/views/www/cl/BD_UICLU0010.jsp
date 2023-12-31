<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<TITLE>기업 정보</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width, height=device-height" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"/>

<!-- 
<script src="../../js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="../../js/ucm.js" type="text/javascript"></script> 
-->

<ap:jsTag type="web" items="jquery,form,validate" />
<ap:jsTag type="tech" items="cmn, mainn, subb, font, util" />

<script type="text/javascript">
	$(document).ready(function() {

	});
</script>
</head>
<body>
	<form name="dataForm" id="dataForm" method="post">
		<ap:include page="param/defaultParam.jsp" />
		<ap:include page="param/dispParam.jsp" />
		<!--//content-->
		  <div id="wrap">
			<div class="s_cont" id="s_cont">
				<div class="s_tit s_tit08">
					<h1>약관</h1>
				</div>
				<div class="s_wrap">
					<div class="l_menu">
						<h2 class="tit tit8">약관</h2>
						<ul>
						</ul>
					</div>
					<div class="r_sec">
						<div class="r_top">
							<ap:trail menuNo="${param.df_menu_no}" />
						</div>
						<div class="r_cont">
							<div class="terms_wrap">
								<div>
									<h2>제1장 총칙</h2>
									<h3>제1조 (목적)</h3>
									<p>이 이용약관은 “기업 정보 (이하 "당 사이트")”에서 제공하는 인터넷 서비스(이하 '서비스')의 가입조건, 당 사이트와 이용자의 권리, 의무, 책임사항과 기타 필요한 사항을 규정함을 목적으로 합니다.</p>
								</div>
								<div>
									<h3>제2조 (용어의 정의)</h3>
									<ol class="terms_depth1">
										<li>"이용자"라 함은 당 사이트에 접속하여 이 약관에 따라 당 사이트가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.</li>
										<li>"기업 정보"이라 함은 기업 통계 및 확인서 발급, 기업 채용공고, 기업 지원 사업 등을 제공하는 서비스를 말합니다.</li>
										<li>"회원"이라 함은 서비스를 이용하기 위하여 당 사이트에 개인정보를 제공하여 아이디(ID)와 비밀번호를 부여 받은 자를 말합니다.</li>
										<li>“비회원”이하 함은 회원으로 가입하지 않고 " 기업 정보"에서 제공하는 서비스를 이용하는 자를 말합니다.</li>
										<li>"회원 아이디(ID)"라 함은 회원의 식별 및 서비스 이용을 위하여 자신이 선정한 문자 및 숫자의 조합을 말합니다.</li>
										<li>"비밀번호"라 함은 회원이 자신의 개인정보 및 직접 작성한 비공개 콘텐트의 보호를 위하여 선정한 문자, 숫자 및 특수문자의 조합을 말합니다.</li>
									</ol>
								</div>
								<div>
									<h3>제3조 (이용약관의 효력 및 변경)</h3>
									<ol class="terms_depth1">
										<li>당 사이트는 이 약관의 내용을 회원이 알 수 있도록 당 사이트의 초기 서비스화면에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 <br/>     볼 수 있도록 할 수 있습니다.</li>
										<li>당 사이트는 이 약관을 개정할 경우에 적용일자 및 개정사유를 명시하여 현행 약관과 함께 당 사이트의 초기화면 또는 초기화면과의 연결화면에 <br/>그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 회원에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 <br/>유예기간을 두고 공지합니다. 이 경우 당 사이트는 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.</li>
										<li>당 사이트가 전항에 따라 개정약관을 공지하면서 “개정일자 적용 이전까지 회원이 명시적으로 거부의 의사표시를 하지 않는 경우 회원이 <br/>개정약관에 동의한 것으로 봅니다.”라는 취지를 명확하게 공지하였음에도 회원이 명시적으로 거부의 의사표시를 하지 않은 경우에는 개정약관에 <br/>동의한 것으로 봅니다. 회원이 개정약관에 동의하지 않는 경우 당 사이트 이용계약을 해지할 수 있습니다.</li>
									</ol>
								</div>
								<div>
									<h3>제4조 (약관 외 준칙)</h3>
									<ol class="terms_depth1">
										<li>이 약관은 당 사이트가 제공하는 서비스에 관한 이용안내와 함께 적용됩니다.</li>
										<li>이 약관에 명시되지 아니한 사항은 관계법령의 규정이 적용됩니다.</li>
									</ol>
								</div>
							</div>
							<div class="terms_wrap">
								<div>
									<h2>제2장 이용제약의 체결</h2>
									<h3>제5조 (이용계약의 성립 등)</h3>
									<p>이용계약은 이용고객이 당 사이트가 정한 약관에 「동의합니다」를 선택하고, 당 사이트가 정한 회원가입양식을 작성하여 서비스 이용을 신청한 후, 당 사이트가 이를 승낙함으로써 성립합니다.</p>
								</div>
								<div>
									<h3>제6조 (회원가입)</h3>
									<p>서비스를 이용하고자 하는 고객은 당 사이트에서 정한 회원가입양식에 개인정보를 기재하여 가입을 하여야 합니다.</p>
								</div>
								<div>
									<h3>제7조 (개인정보의 보호 및 사용)</h3>
									<p>당 사이트는 관계법령이 정하는 바에 따라 회원 등록정보를 포함한 회원의 개인정보를 보호하기 위해 노력합니다. 회원 개인정보의 보호 및 사용에 대해서는 관련법령 및 당 사이트의 개인정보 보호정책이 적용됩니다. 다만, 당 사이트 이외에 링크된 사이트에서는 당 사이트의 개인정보 보호정책이 적용되지 않습니다.</p>
								</div>
								<div>
									<h3>제8조 (이용 신청의 승낙과 제한)</h3>
									<ol class="terms_depth1">
										<li>당 사이트는 제6조의 규정에 의한 이용신청고객에 대하여 약관에 정하는 바에 따라 서비스 이용을 승낙합니다.</li>
										<li>
											당 사이트는 아래사항에 해당하는 경우에 대해서 회원가입을 승낙하지 아니하거나 이후 사전 통보 없이 취소할 수 있습니다.
											<ul class="terms_depth2">
												<li>- 회원가입 신청 시 내용을 허위로 기재한 경우</li>
												<li>- 기타 규정한 제반사항을 위반하며 신청하는 경우</li>
												<li>- 다른 사람의 당 사이트 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 경우</li>
												<li>- 당 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우</li>
											</ul>
										</li>
									</ol>
								</div>
								<div>
									<h3>제9조 (회원 아이디 부여 및 변경 등)</h3>
									<ol class="terms_depth1">
										<li>당 사이트는 이용고객에 대하여 약관에 정하는 바에 따라 자신이 선정한 회원 아이디를 부여합니다.</li>
										<li>회원 아이디는 원칙적으로 변경이 불가하며 부득이한 사유로 인하여 변경 하고자 하는 경우에는 해당 아이디를 해지하고 재가입해야 합니다.</li>
										<li>회원은 회원가입 시 기재한 개인정보가 변경되었을 경우 온라인으로 직접 수정할 수 있습니다. 이때 변경하지 않은 정보로 인해 발생되는 문제에 <br/>     대한 책임은 회원에게 있습니다.</li>
									</ol>
								</div>
							</div>
							<div class="terms_wrap">
								<div>
									<h2>제3장 계약 당사자의 의무</h2>
									<h3>제10조 ("기업 정보"의 의무)</h3>
									<ol class="terms_depth1">
										<li>당 사이트는 이용고객이 희망한 서비스 제공 개시일에 특별한 사정이 없는 한 서비스를 이용할 수 있도록 하여야 합니다.</li>
										<li>당 사이트는 개인정보 보호를 위해 보안시스템을 구축하며 개인정보 보호정책을 공시하고 준수합니다.</li>
										<li>당 사이트는 회원으로부터 제기되는 의견이 합당하다고 판단될 경우에는, 적절한 조치를 취하여야 합니다.</li>
										<li>당 사이트는 전시, 사변, 천재지변, 비상사태, 현재의 기술로는 해결이 불가능한 기술적 결함 기타 불가항력적 사유 및 이용자의 귀책사유로 <br/>인하여 발생한 이용자의 손해, 손실, 기타 모든 불이익에 대하여 어떠한 책임도 지지 않습니다.</li>
									</ol>
								</div>
								<div>
									<h3>제11조 (회원의 의무)</h3>
									<ol class="terms_depth1">
										<li>이용자는 회원가입 신청 또는 회원정보 변경 시 실명으로 모든 사항을 사실에 근거하여 작성하여야 하며, 허위 또는 타인의 정보를 등록할 경우 <br/>일체의 권리를 주장할 수 없습니다.</li>
										<li>당 사이트가 관계법령 및 개인정보 보호정책에 의거하여 그 책임을 지는 경우를 제외하고, 회원에게 부여된 아이디의 비밀번호 관리소홀, <br/>부정사용 등에 의하여 발생하는 모든 결과에 대한 책임은 회원에게 있습니다.</li>
										<li>회원은 당 사이트 및 제 3자의 지식재산권을 침해해서는 안 됩니다.</li>
										<li>이용자는 당 사이트의 운영자, 직원, 기타 관계자를 사칭하는 행위를 하여서는 안 됩니다.</li>
										<li>이용자는 바이러스, 악성코드 등을 제작, 배포, 이용하여서는 아니 되고, 당 사이트의 승인 없이 광고하는 행위를 하여서는 안 됩니다.</li>
										<li>이용자는 당 사이트 및 제 3자의 명예를 훼손하거나 업무를 방해하거나, 외설적이거나, 폭력적이거나 기타 공서양속에 반하는 게시물, 쪽지, 메일 <br/>등을 게시, 전송, 배포하여서는 안 됩니다.</li>
									</ol>
								</div>
							</div>
							<div class="terms_wrap">
								<div>
									<h2>제4장 서비스의 이용</h2>
									<h3>제12조 (서비스 이용 시간)</h3>
									<ol class="terms_depth1">
										<li>회원의 이용신청을 승낙한 때부터 서비스를 개시합니다. 단, 일부 서비스의 경우에는 지정된 일자부터 서비스를 개시합니다.</li>
										<li>업무상 또는 기술상의 장애로 인하여 서비스를 개시하지 못하는 경우에는 사이트에 공시하거나 회원에게 이를 통지합니다.</li>
										<li>서비스의 이용은 연중무휴, 1일 24시간을 원칙으로 하며, 서비스 응대 및 처리 시간은 법정 근무일 근무시간(09:00~18:00, 법정공휴일 및 주말 <br/>제외)으로 합니다. 다만, 당 사이트의 업무상 또는 기술상의 이유로 서비스가 일시 중지 될 수 있습니다. 이러한 경우 당 사이트는 사전 또는 <br/>사후에 이를 공지합니다.</li>
										<li>회원으로 가입한 이후라도 일부 서비스 이용 시 서비스 제공자의 요구에 따라 특정회원에게만 서비스를 제공할 수 있습니다.</li>
										<li>서비스를 일정범위로 분할하여 각 범위별로 이용가능 시간을 별도로 정할 수 있습니다. 이 경우 그 내용을 사전에 공개합니다.</li>
									</ol>
								</div>
								<div>
									<h3>제13조 (홈페이지 저작권)</h3>
									<ol class="terms_depth1">
										<li>당 사이트가 게시한 본 홈페이지의 모든 콘텐트에 대한 저작권은 당 사이트에 있습니다. 다만, 게시물의 원저작자가 별도로 있는 경우 그 출처를 <br/>     명시하며 해당 게시물의 저작권은 원저작자에게 있습니다.</li>
										<li>회원이 직접 게시한 저작물의 저작권은 회원에게 있습니다. 다만, 회원은 당 사이트에 무료로 이용할 수 있는 권리를 허락한 것으로 봅니다.</li>
										<li>당 사이트 소유의 콘텐트에 대하여 제3자가 허락 없이 다른 홈페이지에 사용 또는 인용하는 것을 금지합니다.</li>
									</ol>
								</div>
								<div>
									<h3>제14조 (서비스의 변경, 중단)</h3>
									<ol class="terms_depth1">
										<li>당 사이트는 기술상•운영상의 필요에 의해 제공하는 서비스의 일부 또는 전부를 변경하거나 중단할 수 있습니다. 당 사이트의 서비스를 <br/>중단하는 경우에는 30일 전에 홈페이지에 이를 공지하되, 다만 사전에 통지할 수 없는 부득이한 사정이 있는 경우는 사후에 통지를 할 수 <br/>있습니다.</li>
										<li>제1항의 경우에 당 사이트가 제공하는 서비스의 이용과 관련하여, 당 사이트는 이용자에게 발생한 어떠한 손해에 대해서도 책임을 지지 <br/>않습니다. 다만 당 사이트의 고의 또는 중대한 과실로 인하여 발생한 손해의 경우는 제외합니다.</li>
									</ol>
								</div>
							</div>
							<div class="terms_wrap">
								<div>
									<h2>제5장 계약 해지 및 이용 제한</h2>
									<h3>제15조 (계약 해지)</h3>
									<ol class="terms_depth1">
										<li>회원은 언제든지 마이페이지 메뉴 등을 통하여 이용계약 해지 신청을 할 수 있으며, 당 사이트는 관련법 등이 정하는 바에 따라 이를 즉시 <br/>처리하여야 합니다.</li>
										<li>회원이 계약을 해지할 경우, 관련법령 및 개인정보처리방침에 따라 당 사이트가 회원정보를 보유하는 경우를 제외하고는 해지 즉시 회원의 모든 <br/>데이터는 소멸됩니다.</li>
										<li>회원이 계약을 해지하는 경우, 회원이 작성한 게시물(묻고 답하기 질문, 확인서 신청내역)은 삭제되지 아니합니다.</li>
									</ol>
								</div>
								<div>
									<h3>제16조 (서비스 이용제한)</h3>
									<ol class="terms_depth1">
										<li>
											당 사이트는 회원이 서비스 이용에 있어서 본 약관 및 관련 법령을 위반하거나, 다음 각 호에 해당하는 경우 서비스 이용을 제한할 수 있습니다.
											<ul class="terms_depth2">
												<li>- 2년 이상 서비스를 이용한 적이 없는 경우</li>
												<li>- 기타 정상적인 서비스 운영에 방해가 될 경우</li>
											</ul>
										</li>
										<li>상기 이용제한 규정에 따라 서비스를 이용하는 회원에게 사전 통지 후 서비스 이용을 일시정지 등 제한하거나 이용계약을 해지 할 수 있습니다. <br/>단, 불가피한 사유로 사전 통지가 불가능한 경우에는 그러하지 아니합니다.</li>
									</ol>
								</div>
							</div>
							<div class="terms_wrap">
								<div>
									<h2>제6장 손해배상 및 기타사항</h2>
									<h3>제17조 (손해배상)</h3>
									<p>당 사이트는 무료로 제공되는 서비스와 관련하여 회원에게 어떠한 손해가 발생하더라도 당 사이트가 고의 또는 과실로 인한 손해발생을 제외하고는 이에 대하여 책임을 부담하지 아니합니다.</p>
								</div>
								<div>
									<h3>제18조 (관할 법원)</h3>
									<p>서비스 이용으로 발생한 분쟁에 대해 소송이 제기되는 경우 민사 소송법상의 관할 법원에 제기합니다.</p>
								</div>
								<div>
									<h3>제19조 (서비스별 이용자 사전 동의 사항과 의무)</h3>
									<p>당 사이트에 ‘기술정보를 제공하는 이용자는 자신의 기술정보에 대한 권리(특허권, 실용신안권, 디자인권, 상표권 등)를 법적으로 보호받기 위해서 필요한 조치를 스스로 취하여야 합니다. 당 사이트는 이용자의 권리 보장이나 취득 등을 위한 어떠한 명목의 의무나 책임도 부담하지 않고, 이를 보장하지 않으며, 이용자 개인의 행위(당 사이트의 서비스 이용 행위 일체를 포함)로 인한 어떠한 분쟁이나 어떠한 명목의 손실, 손해에 대해서도 법적 책임을 지지 아니합니다.</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		
		
			<!--<div class="top_btn">
				<button>맨위로이동</button>
			</div>-->
		  </div>
	</form>
</body>
</html>