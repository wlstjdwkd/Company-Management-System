package com.comm.logio;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.user.UserService;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 아이디찾기
 * 
 * @author KMY
 *
 */
@Service("PGCMLOGIO0020")
public class PGCMLOGIO0020Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCMLOGIO0020Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Autowired
	UserService userService;
	
	/**
	 * 아이디찾기 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		//mv.setViewName("/www/mb/BD_UIMBU0020");
		mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0020");
		return mv;
	}
	
	/**
	 * 아이디찾기 성공/실패
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findUserIdForm(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap userInfo = new HashMap();
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		
		param.put("userNm", userNm);
		param.put("email", email);
		userInfo.put("userNm", userNm);
		userInfo.put("email", email);
		
		List<Map> findUserId = userService.findUserId(param);
		String userId = null;
		
		if(Validate.isEmpty(findUserId)) {
			// 아이디찾기 실패
			//mv.setViewName("/www/mb/BD_UIMBU0022");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0022");
		}
		else {
			for(int i=0; i< findUserId.size(); i++) {
				userId = (String) findUserId.get(i).get("loginId");
				int idCnt = (userId.length())-3;
				String idStar = "";
				
				for(int j=0; j<idCnt; j++) {
					idStar += "*";
				}
				findUserId.get(i).put("loginId", userId.substring(0, 3) + idStar);
			}
			
			
			// 아이디찾기 성공
			mv.addObject("userInfo", userInfo);
			mv.addObject("findUserId",findUserId);
			//mv.setViewName("/www/mb/BD_UIMBU0021");
			mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0021");
			
		}
		return mv;
	}
	
	/**
	 * 전체아이디찾기 화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView findUserIdAllForm(Map<?,?> rqstMap) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		HashMap userInfo = new HashMap();
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		param.put("userNm", userNm);
		param.put("email", email);
		userInfo.put("userNm", userNm);
		userInfo.put("email", email);
		
		List<Map> findUserId = userService.findUserId(param);
		
		if(findUserId.size() < 2) {
			Map mbtlNum = StringUtil.telNumFormat((String) findUserId.get(0).get("mbtlNum"));
			mbtlNum.put("last", "****");
			
			findUserId.get(0).put("mbtlNum", mbtlNum);
			
			String userEmail = (String) findUserId.get(0).get("email");
			String[] userEmailArray = userEmail.split("@");
			
			int cnt = (userEmailArray[0].length())-3;
			String star="";
			for(int i=0; i<cnt; i++)
				star += "*";
			
			userEmail = userEmailArray[0].substring(0, 3) + star + "@" + userEmailArray[1];
			findUserId.get(0).put("email", userEmail);
		}
		else {
			for( int i=0; i< findUserId.size(); i++) {
				Map mbtlNum = StringUtil.telNumFormat((String) findUserId.get(i).get("mbtlNum"));
				mbtlNum.put("last", "****");
				
				findUserId.get(i).put("mbtlNum", mbtlNum);
				
				String userEmail = (String) findUserId.get(i).get("email");
				String[] userEmailArray = userEmail.split("@");
				
				int cnt = (userEmailArray[0].length())-3;
				
				String star="";
				for(int j=0; j<cnt; j++)
					star += "*";
				
				userEmail = userEmailArray[0].substring(0, 3) + star + "@" + userEmailArray[1];
				findUserId.get(i).put("email", userEmail);
			}
		}
		
		mv.addObject("userInfo", userInfo);
		mv.addObject("findUserId",findUserId);
		//mv.setViewName("/www/mb/BD_UIMBU0023");
		mv.setViewName("/www/comm/logio/BD_UICMLOGIOU0023");
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
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		
		param.put("userNm", userNm);
		param.put("email", email);
		
		List<Map> findUserId = userService.findUserId(param);
		
		int resCnt = 0;
		
		if(findUserId.size() < 2) {
			param.put("PRPOS", "T");
			param.put("EMAIL_SJ", "[기업 정보] 요청하신 아이디 안내입니다.");
			param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_USERID.html");
			param.put("TMPLAT_USE_AT", "Y");
			param.put("SNDR_NM", "기업정보");
			param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
			param.put("RCVER_NM", userNm);
			param.put("RCVER_EMAIL_ADRES", findUserId.get(0).get("email"));
			param.put("SUBST_INFO1", "userId::" + findUserId.get(0).get("loginId"));
			param.put("SUBST_INFO8", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
			param.put("SNDNG_STTUS", "R");
			
			resCnt = userService.insertEmail(param);
			
		}
		else {
			for(int i=0; i<findUserId.size(); i++) {
				param.put("PRPOS", "T");
				param.put("EMAIL_SJ", "[기업 정보] 요청하신 아이디 안내입니다.");
				param.put("TMPLAT_FILE_COURS", "TMPL_EMAIL_USERID.html");
				param.put("TMPLAT_USE_AT", "Y");
				param.put("SNDR_NM", "기업정보");
				param.put("SNDR_EMAIL_ADRES", GlobalConst.MASTER_EMAIL_ADDR);
				param.put("RCVER_NM", userNm);
				param.put("RCVER_EMAIL_ADRES", findUserId.get(i).get("email"));
				param.put("SUBST_INFO1", "userId::" + findUserId.get(i).get("loginId"));
				param.put("SUBST_INFO8", "MASTER_EMAIL_ADDR::" + GlobalConst.MASTER_EMAIL_ADDR);
				param.put("SNDNG_STTUS", "R");
				
				resCnt = userService.insertEmail(param);
			}
		}
		
		
		
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
		
		String userNm = MapUtils.getString(rqstMap, "ad_user_nm");
		String email = MapUtils.getString(rqstMap, "ad_user_email");
		
		param.put("userNm", userNm);
		param.put("email", email);
		
		List<Map> findUserId = userService.findUserId(param);
		int resCnt = 0;
		
		if(findUserId.size() < 2) {
			param.put("MT_REFKEY", findUserId.get(0).get("userNo"));
			param.put("CONTENT", "회원님의 아이디는 " + findUserId.get(0).get("loginId") + "입니다.");
			param.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
			param.put("RECIPIENT_NUM", findUserId.get(0).get("mbtlNum"));
			param.put("SERVICE_TYPE", 0);
			resCnt = userService.insertSms(param);
		}
		else {
			for(int i=0; i < findUserId.size(); i++) {
				param.put("MT_REFKEY", findUserId.get(i).get("userNo"));
				param.put("CONTENT", "회원님의 아이디는 " + findUserId.get(i).get("loginId") + "입니다.");
				param.put("CALLBACK", GlobalConst.CSTMR_PHONE_NUM);
				param.put("RECIPIENT_NUM", findUserId.get(i).get("mbtlNum"));
				param.put("SERVICE_TYPE", 0);
				resCnt = userService.insertSms(param);
			}
		}
		
		if(resCnt == StringUtil.ONE) {
			return ResponseUtil.responseJson(mv, true);
		}
		
		return ResponseUtil.responseJson(mv, false);
	}
	
}
