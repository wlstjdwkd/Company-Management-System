<!-- 필요한 class import -->
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="org.apache.catalina.Context"%>
<%@page import="com.comm.user.UserService"%>
<%@page import="com.comm.user.UserVO"%>
<%@page import="com.comm.user.EntUserVO"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="tradesign.crypto.provider.*"%>
<%@ page import="tradesign.pki.pkix.X509Certificate"%>
<%@ page import="tradesign.pki.pkix.X509CRL"%>
<%@ page import="tradesign.pki.pkix.Login"%>
<%@ page import="tradesign.pki.util.*" %>
<%@ page import="tradesign.test.*" %>
<%@ page import="java.io.*, java.security.*, java.util.*, java.lang.*" %>

<html>
<!-- <link rel="stylesheet" href="../../tradesign2.css" type="text/css"> -->
<body>
<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Connection conn = null;
	try{

		//로컬
		JeTS.installProvider("C:/aframe/workspace/aframe/src/main/webapp/WEB-INF/bizrnoCert/tradesign3280.properties");
		//개발/운영
		//JeTS.installProvider("/usr/local/bizrnoCert/tradesign3280.properties");

		String message = new String(request.getParameter("loginData").getBytes("ISO-8859-1"), "utf-8");
	
		// 클라이언트에서 보내온 로그인메시지를 base64디코딩하여 login_request에 저장한다.
		byte[] login_request = tradesign.pki.util.JetsUtil.base64ToBytes(message);
		
		// Login객체 생성
		Login login1 = new Login(login_request);

		login1.setupCipher(JeTS.getServerkmCert(0), JeTS.getServerkmPriKey(0), JeTS.getServerKmKeyPassword(0));
		// 방화벽 작업 완료시 true로 전환해야됨
		login1.parseLoginData(false);
		// login1.parseLoginData(true);
		
		// 클라이언트에서 보내온 로그인메시지에서 사용자데이터영역을 userdata에 저장한다.	
		String userdata = new String(login1.getUserData());	
		String ssnumber = new String(login1.getSsn());

		// 클라이언트에서 보내온 로그인메시지에서 로그인을 시도한 사용자의 인증서를 읽는다.
		X509Certificate[] certs = login1.getSignerCerts();

		String SubjectDNStr[] = null; 
		String NotBeforeStr[] = null;
		String NotAfterStr[] = null; 
		String SerialNumber[] = null;
		String IssuerDNStr[] = null; 
		String SignatureAlgorithm[] = null;
		
		if (certs != null)
		{		
			SubjectDNStr  = new String[certs.length];
			NotBeforeStr  = new String[certs.length];
			NotAfterStr  = new String[certs.length];
			SerialNumber  = new String[certs.length];
			IssuerDNStr  = new String[certs.length];
			SignatureAlgorithm  = new String[certs.length];						
			
			for (int i = 0; i < certs.length; i++)
			{
				SubjectDNStr[i] = certs[i].getSubjectDNStr();
				NotBeforeStr[i] = certs[i].getNotBefore().toString();
				NotAfterStr[i] = certs[i].getNotAfter().toString();
				SerialNumber[i] = certs[i].getSerialNumber().toString();
				IssuerDNStr[i] = certs[i].getIssuerDNStr();
				SignatureAlgorithm[i] = certs[i].getSignatureAlgorithm().toString();
			}
		}

		X509Certificate cert = certs[0];
		boolean ret = cert.VerifyIDN(ssnumber, login1.getRandom());
		
		String idconfirm="";
		if (ret)
			idconfirm="신원확인 성공";
		else
			idconfirm="신원확인 실패";
		
		String strUserData ="", strRandom = "", strSessionId = "";
			
		strUserData = new String(login1.getUserData());
		
		strRandom = JetsUtil.toBase64String(login1.getRandom());
		strSessionId = new String(login1.gettid());	

		//////////////////////////////// 추가 ////////////////////////////
		
		String reslt = null;
		String reslt2 = null;
		String aduserno = null;
		int rslt = 0;

		if(ret){ // 신원확인 성공일때 처리
			String pageType = new String(request.getParameter("page_type"));
			if(request.getParameter("ad_user_no") != null)
				aduserno = new String(request.getParameter("ad_user_no"));
	
			InitialContext ic = new InitialContext();
			DataSource ds = (DataSource) ic.lookup("java:/comp/env/jdbc/DS_AFRAME");
			conn = ds.getConnection();
			String sql = null;
			String userno = null;
			String certchk = null;
			String dn = null;
			String adssn = null;
			String bizrnoo = null;
			int cnt = 0;

////////////if문으로 페이지마다 다르게 로직 처리해야함

			if(pageType.equals("0")){ // 로그인 화면일때
				adssn = new String(request.getParameter("ad_ssn"));
	 			// userno 검색
				sql = "SELECT * FROM tb_userinfo WHERE login_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, strSessionId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					userno = rs.getString("user_no");
				}

				if(userno != null){ // 회원이 존재할 시
					// 기업회원인지 검색
					sql = "SELECT count(*) FROM tb_entrprsuser WHERE user_no=? and bizrno=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, userno);
					pstmt.setString(2, adssn);
					rs = pstmt.executeQuery();
					while(rs.next()){
						cnt = rs.getInt(1);
						if(cnt != 0)
							reslt = "N";
					}
					
					// 사업자 인증한 회원인지 검사
					String y = "Y";
					sql = "SELECT count(*) FROM tb_entrprsuser WHERE user_no=? and bizrno=? and bizrno_dn=? and bizrno_cert_chk=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, userno);
					pstmt.setString(2, adssn);
					pstmt.setString(3, SubjectDNStr[0]);
					pstmt.setString(4, y);
					rs = pstmt.executeQuery();
					while(rs.next()){
						cnt = rs.getInt(1);
						if(cnt != 0)
							reslt2 = "N";
					}
				}
			}

			if(pageType.equals("1")){ // 수정 화면일때
				// 사용자가 이전에 등록한 사업자 정보와 같은지 확인
				sql = "SELECT count(*) FROM tb_entrprsuser WHERE bizrno_dn=? and user_no=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, SubjectDNStr[0]);
				pstmt.setString(2, aduserno);
				rs = pstmt.executeQuery();
				while(rs.next()){
					cnt = rs.getInt(1);
					if(cnt != 0)
						reslt2 = "N";
				}
				
				// 중복된 사업자번호가 있는지 확인
				sql = "SELECT count(*) FROM tb_entrprsuser WHERE bizrno_dn=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, SubjectDNStr[0]);
				rs = pstmt.executeQuery();
				while(rs.next()){
					cnt = rs.getInt(1);
					if(cnt != 0)
						reslt = "N";
				}
			}

	 		if(pageType.equals("2")){ // 가입 화면일때
				// 중복된 사업자번호가 있는지 확인
				sql = "SELECT count(*) FROM tb_entrprsuser WHERE bizrno_dn=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, SubjectDNStr[0]);
				rs = pstmt.executeQuery();
				while(rs.next()){
					cnt = rs.getInt(1);
					if(cnt != 0)
						reslt = "N";
				}
			}
	 		
	 		if(pageType.equals("3")){ // 로그인화면에서 사업자인증 팝업
	 			adssn = new String(request.getParameter("ad_ssn"));
	 			// userno 검색
				sql = "SELECT * FROM tb_userinfo WHERE login_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, strSessionId);
				rs = pstmt.executeQuery();
				while(rs.next()){
					userno = rs.getString("user_no");
				}

				if(userno != null){ // 회원이 존재할 시
					// 기업회원인지 검색
					sql = "SELECT count(*) FROM tb_entrprsuser WHERE user_no=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, userno);
					rs = pstmt.executeQuery();
					while(rs.next()){
						cnt = rs.getInt(1);
						if(cnt != 0)
							reslt = "N";
					}

					// 중복된 사업자번호가 있는지 확인
					sql = "SELECT count(*) FROM tb_entrprsuser WHERE bizrno_dn=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, SubjectDNStr[0]);
					rs = pstmt.executeQuery();
					while(rs.next()){
						cnt = rs.getInt(1);
						if(cnt != 0)
							reslt2 = "N";
					}

					// DB 업데이트
					if(reslt != null && reslt2 == null && !adssn.substring(3, 5).equals("85")){
						sql = "UPDATE tb_entrprsuser SET bizrno_dn=?, bizrno_cert_chk=?, bizrno=? WHERE user_no=?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, SubjectDNStr[0]);
						pstmt.setString(2, "Y");
						pstmt.setString(3, adssn);
						pstmt.setString(4, userno);
						rslt = pstmt.executeUpdate();
					} 
				}
			}
		}
%>
<%--
 <table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">  Login 예제   </font></td></tr>
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 사용자에게 받은 로그인 요청 메시지(BASE64인코딩) ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">
  <tr>
    <td align="left">
      <textarea name="plainText" rows="6" cols="90" ><%= message %></textarea>
    </td>
</tr>
</table>
<br>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">== 사용자에게 받은 로그인 요청 메시지의 인증서 정보 ==</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0"> 
--%>
<%
	if (certs != null)
	{		
		for (int i = 0; i < certs.length; i++)
		{
			/* out.print("<tr><td align='left'><textarea name='signedData' rows='10' cols='90'>"+ 
			"[Subject DN]"+SubjectDNStr[i] + "\r\n" +
			"[유효기간시작일]"+NotBeforeStr[i] + "\r\n" +
			"[유효기간종료일]"+NotAfterStr[i] + "\r\n" +
			"[시리얼넘버]"+SerialNumber[i] + "\r\n" +
			"[발급자DN]"+IssuerDNStr[i] + "\r\n" +
			"[서명알고리즘]"+SignatureAlgorithm[i] + "\r\n" +
			"</textarea></td></tr>"); */
		}
		out.print("<span id='rest' >" + IssuerDNStr[0] + "</span>");
		if(reslt != null)
			out.print("<span id='jb' >" + reslt + "</span>");
		else
			out.print("<span id='jb' >" + "Y" + "</span>");
		if(reslt2 != null)
			out.print("<span id='jb2' >" + reslt2 + "</span>");
		else
			out.print("<span id='jb2' >" + "Y" + "</span>");
		out.print("<span id='jb3' >" + rslt + "</span>");

	}	
%>
<%-- 
</table>
<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">신원확인 결과</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">

<tr>
	<td>신원확인정보(사업자번호/주민등록번호): <%=  new String(login1.getSsn()) %></td>
          <td>사용안할 경우 0</td>
</tr>

<tr>
	<td>신원확인식별자 검증 :<%=  idconfirm %> </td>
</tr>
</table>

<table border="2" width="670" cellpadding="3" cellspacing="0" bordercolor="#97A9BB" bgcolor="#A7B9CC">
  <tr><td align="center"><font color="#FFFFFF">로그인 요청 메시지내 사용자 정보</font></td></tr>
</table>
<table border="2" width="670" cellpadding="5" cellspacing="0" bordercolor="#E0E0E0" bgcolor="#F0F0F0">

<tr>
	<td>UserInfo : <%=  strUserData %></td>
       <td>사용안할 경우 0</td>
</tr>

<tr>
	<td>Random (Base64 인코딩 값):<%=  strRandom  %> </td>
</tr>

<tr>
	<td>SessionID :<%=  strSessionId %> </td>
          <td>사용안할 경우 0</td>
</tr>
  <tr>
    <td align="right">
      <INPUT TYPE="button" Value="이 전 으 로" onClick="location.href='DemoLogin.jsp'">
    </td>
  </tr>
</table> 
--%>

<%
} catch(Exception e) {
	e.printStackTrace();
	out.println("에러 발생:" + e.getMessage() + "<br>");
}
finally {
	if(rs != null)
		rs.close();
	if(pstmt != null)
		pstmt.close();
	if(conn != null)
		conn.close();
}
%>
  </body>
  </html>
