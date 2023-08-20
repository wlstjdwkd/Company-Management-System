package com.comm.logio;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.user.AllUserVO;
import com.comm.user.UserService;
import com.infra.system.GlobalConst;
import com.infra.util.RandomNumber;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 비밀번호찾기
 * 
 * @author KMY
 *
 */
@Service("PGCMLOGIO0030")
public class PGCMLOGIO0030Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMLOGIO0030Service.class);
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Autowired
	UserService userService;
	
	/**
	 * 비밀번호찾기 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		//mv.setViewName("/www/mb/BD_UIMBU0030");
		mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0030");
		return mv;
	}
	
	/**
	 * 비밀번호찾기 성공/실패
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findUserPwdForm(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap userInfo = new HashMap();
		
		String userId = MapUtils.getString(rqstMap, "ad_user_id");
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		
		param.put("userId", userId);
		param.put("userNm", userNm);
		param.put("email", email);
		userInfo.put("userId", userId);
		userInfo.put("userNm", userNm);
		userInfo.put("userEmail", email);
		
		Map findUserPwd = userService.findUserPwd(param);
		
		if(Validate.isEmpty(findUserPwd)) {
			// 비밀번호찾기 실패
			//mv.setViewName("/www/mb/BD_UIMBU0031");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0031");
		}
		else {
			// 비밀번호찾기 성공
			int userNo= (Integer) findUserPwd.get("userNo");
			userInfo.put("userNo", userNo);
			
			Map mbtlNum = StringUtil.telNumFormat((String) findUserPwd.get("mbtlNum"));
			mbtlNum.put("last", "****");
			
			String userEmail = (String) findUserPwd.get("email");
			String[] userEmailArray = userEmail.split("@");
			
			int cnt = (userEmailArray[0].length()) -3;
			String star="";
			for(int i=0; i<cnt; i++)
				star += "*";
			
			userEmail = userEmailArray[0].substring(0, 3) + star + "@" + userEmailArray[1];
			
			
			mv.addObject("userInfo", userInfo);
			mv.addObject("mbtlNum", mbtlNum);
			mv.addObject("userEmail", userEmail);
			//mv.setViewName("/www/mb/BD_UIMBU0032");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0032");
		}
		
		return mv;
	}
	
	/**
	 * 이메일 발송
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertEmail(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap pwdParam = new HashMap();
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		String userId = MapUtils.getString(rqstMap, "ad_user_id");
		
		param.put("userNm", userNm);
		param.put("email", email);
		param.put("userId", userId);
		
		Map findUserPwd = userService.findUserPwd(param);
		pwdParam = (HashMap) updateInitializePwd(findUserPwd);

		param.put("PRPOS", "T");
		param.put("EMAIL_SJ", "[기업 정보] 임시비밀번호안내입니다.");
		param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_USERPWD.html");
		param.put("TMPLAT_USE_AT", "Y");
		param.put("SNDR_NM", "기업정보");
		param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
		param.put("RCVER_NM", userNm);
		param.put("RCVER_EMAIL_ADRES", findUserPwd.get("email"));
		param.put("SUBST_INFO1", "userPwd::" + pwdParam.get("newkey"));
		param.put("SUBST_INFO8", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
		param.put("SNDNG_STTUS", "R");
		
		int resCnt = userService.insertEmail(param);
		if(resCnt == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
	}
	
	/**
	 * SMS 전송
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertMbtlNum(Map<?, ?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap pwdParam = new HashMap();
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		String userId = MapUtils.getString(rqstMap, "ad_user_id");
		
		param.put("userNm", userNm);
		param.put("email", email);
		param.put("userId", userId);
		
		Map findUserPwd = userService.findUserPwd(param);
		pwdParam = (HashMap) updateInitializePwd(findUserPwd);
		
		param.put("MT_REFKEY", findUserPwd.get("userNo"));
		param.put("CONTENT", "회원님의 임시비밀번호는 " + pwdParam.get("newkey") + "입니다.");
		param.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
		param.put("RECIPIENT_NUM", findUserPwd.get("mbtlNum"));
		param.put("SERVICE_TYPE", 0);
		
		int resCnt = userService.insertSms(param);
		if(resCnt == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
	}
	
	/**
	 * 비밀번호 초기화
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public Map updateInitializePwd (Map<?, ?> rqstMap) throws Exception
	{
		boolean result = Boolean.FALSE;
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();		
		String userNo = MapUtils.getString(rqstMap, "userNo");		
		
		param.put("USER_NO", userNo);
		param.put("limitFrom", 0);
		param.put("limitTo", 1);
		
		List<AllUserVO> user = userService.findAllUser(param);
		if(Validate.isNotEmpty(user)) {
			//새로운 비밀번호 생성
            int alplen = 2;
            int numlen = 7;
            String newkey = tempKey2(alplen, numlen);
            
            //새로생성한 비밀번호 암호화 후 업데이트
            byte pszDigest[] = new byte[32];		
    		Crypto cry = CryptoFactory.getInstance("SHA256");
    		pszDigest =cry.encryptTobyte(newkey);
			
    		param.put("PASSWORD", pszDigest);
    		param.put("UPDUSR", userNo);
    		
    		int resCnt = userService.updateInitializePwd(param);
    		param.put("newkey", newkey);
    		
    		if(resCnt == StringUtil.ONE) {
    			//TODO email 발송 추가해야 할 부분
    			result = Boolean.TRUE;
    		
    			//TODO 확인용 추후 삭제
    			param.put("ORI", newkey);
    		}			
		}
		
		return param;
	}
	
	
	/**
	 * 임시 비밀번호 생성
	 * EX : AA1234567
	 * 8자리로 구성하며 앞 두자리는 임의의 영문자 나머지는 숫자로 구성
	 */
   private String tempKey2(int alplen, int numlen)
   {
       String alp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
       String num = "0123456789";
       String newkey = "";
       int max = alplen + numlen;
       int n = 0;

       int a_len = alp.length();
       int n_len = num.length();

       for(int i = 0 ; i < max; i++) {
           if(i < alplen) {
               n = RandomNumber.getInt(a_len);
               newkey = newkey + alp.charAt(n);
           }
           else {
               n = RandomNumber.getInt(n_len);
               newkey = newkey + num.charAt(n);
           }
       }
       
       return newkey;
   }
}
