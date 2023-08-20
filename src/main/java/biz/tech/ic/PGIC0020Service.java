package biz.tech.ic;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 기업확인>기업확인신청
 * 
 * @author JGS
 * 
 */
@Service("PGIC0020")
public class PGIC0020Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGIC0020Service.class);

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Autowired
	UserService userService;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;

	/**
	 * 기본확인
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/ic/BD_UIICU0020");
		
		EntUserVO entUserVo = SessionUtil.getEntUserInfo();		
		if(Validate.isEmpty(entUserVo)) {
			throw processException("fail.common.select", new String[] {"기업정보"});			
		}
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("JURIRNO", entUserVo.getJurirno());
		Map<String,String> applyMap = hpeCnfirmReqstMapper.selectTempApplyMaster(param);
		
		Calendar cal1 = Calendar.getInstance( );
		mv.addObject("ad_stacnt_mt_yy", cal1.get(Calendar.YEAR));		//현재년도
		
		// 임시저장 유무 확인
		String existedTempData ="N";
		if(!Validate.isEmpty(applyMap)) {		
			mv.addObject("loadRceptNo", applyMap.get("RCEPT_NO"));
			mv.addObject("tempTargetYear", applyMap.get("CONFM_TARGET_YY"));
			existedTempData ="Y";
		}
		
		mv.addObject("existedTempData", existedTempData);		
		
		return mv;
	}
	
	/**
	 * 확인서 신청년도 조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getIssuYears(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map valueMap = new HashMap<String, Object>();
				
		int sacntYear = MapUtils.getIntValue(rqstMap, "ad_stacnt_mt_yy");
		int sacntMonth = MapUtils.getIntValue(rqstMap, "ad_stacnt_mt_ho");
		// int lastStdyy = calcLastIssuYear(sacntYear, sacntMonth);
		int lastStdyy = sacntYear+1;
		
		valueMap.put("start_issu_year", 2010);
		valueMap.put("last_issu_year", lastStdyy);
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE, valueMap, "");
	}
	
	/**
	 * 확인서 신청 가능여부(상호출자제한, 중소기업확인)
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView pblictePossibleAt (Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map valueMap = new HashMap<String, Object>();
		
		EntUserVO entUserVo = SessionUtil.getEntUserInfo();
		if(Validate.isEmpty(entUserVo)) {
			throw processException("fail.common.select", new String[] {"기업정보"});			
		}
				
		param.put("JURIRNO", entUserVo.getJurirno());
		
		int sacntYear = MapUtils.getIntValue(rqstMap, "ad_stacnt_mt_yy");		// 직전년도
		int sacntMonth = MapUtils.getIntValue(rqstMap, "ad_stacnt_mt_ho");		// 결산월
		int issuYear = MapUtils.getIntValue(rqstMap, "ad_issu_year");			// 확인신청년도
		
		int lastStdyy = calcLastIssuYear(sacntYear, sacntMonth);
		
		Calendar cal = Calendar.getInstance( );
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String stdDate = "";
		//boolean isLastYear = issuYear == lastStdyy;		// true or false
		boolean isLastYear = true;
		
		valueMap.put("last_year_at", isLastYear);
		
		
		List<Map> dataList = null;
		
		/** 상호출자제한기업 확인 */
		// 최종년도
		if(isLastYear) {
			// 현재일 기준 지난달 1일
			cal.add(Calendar.MONTH, -1);
			cal.set(Calendar.DATE, 1);			
		
			stdDate = sdf.format(cal.getTime());
			
			param.put("STD_DE", stdDate);
			
			dataList = hpeCnfirmReqstMapper.selectMutualInvestLimit(param);
			if(Validate.isNotEmpty(dataList)) {
				valueMap.put("mutual_invest_limit_at", "Y");
			}else {
				valueMap.put("mutual_invest_limit_at", "N");
			}
			
		// 과거년도	
		}/*else {
			// 신청년도 기준 지난해 12월 1일
			cal.set(Calendar.YEAR, issuYear-1);
			cal.set(Calendar.MONTH, 12);
			cal.set(Calendar.DATE, 1);			
		}*/				
		
		/** 중소기업확인서발급내역 확인 */
		if(isLastYear) {
			cal = Calendar.getInstance();
			sdf = new SimpleDateFormat("yyyyMMdd");
			
			param.put("TODAY", sdf.format(cal.getTime()));
			dataList = hpeCnfirmReqstMapper.selectSmbaList(param);
			
			if(Validate.isNotEmpty(dataList)) {
				valueMap.put("smba_at", "Y");
				valueMap.put("process_de_fmt", StringUtil.toDateFormat(MapUtils.getString(dataList.get(0), "PROCESS_DE")));
			}else {
				valueMap.put("smba_at", "N");
			}
		}else{
			valueMap.put("smba_at", "N");
		}
		
		/** 대상년도 발급 신청건 조회 */
		param.put("JDGMNT_REQST_YEAR", issuYear);
		Map applyData = hpeCnfirmReqstMapper.selectApplyMasterReqstYear(param);
		
		if(Validate.isNotEmpty(applyData)) {
			valueMap.put("applyData_at", "Y");
		}else {
			valueMap.put("applyData_at", "N");
		}
		
		return ResponseUtil.responseJson(mv, Boolean.TRUE, valueMap, "");
	}
	
	/**
	 * 확인서 신청년도 계산
	 * @param sacntMonth
	 * @return
	 */
	public int calcLastIssuYear(int sacntYear, int sacntMonth) {
		logger.info("sacntYear:" + sacntYear);
		logger.info("sacntMonth:" + sacntMonth);
		
		int lastStdyy;		
		
		Calendar cal1 = Calendar.getInstance( );
		Calendar cal2 = Calendar.getInstance( );
		
		lastStdyy = cal1.get(Calendar.YEAR);		//현재년도
		
		cal1.set(Calendar.DATE, 1);
		cal2.set(Calendar.DATE, 1);
		
		cal2.set(Calendar.YEAR, sacntYear);
		cal2.set(Calendar.MONTH, sacntMonth);
		cal2.add(Calendar.MONTH, 4);		// 11+3 = 2
		
		lastStdyy = cal2.get(Calendar.YEAR);
		
		/*
		if((sacntMonth + 3) <= 12) {
			logger.info("--------------------(sacntMonth + 3) <= 12 일때------------------");
			logger.info("--------> Calendar.MONTH: " + cal2.get(Calendar.MONTH));
			cal2.set(Calendar.MONTH, sacntMonth-1);
			logger.info("--------> Calendar.MONTH에 sacntMonth-1 를 set: " + cal2.get(Calendar.MONTH));
			cal2.add(Calendar.MONTH, 3);
			logger.info("--------> Calendar.MONTH + 3: " + cal2.get(Calendar.MONTH));
			
			logger.info("--------> cal1:" + cal1.toString());
			logger.info("--------> cal2:" + cal2.toString());
			
			if(cal1.before(cal2)) {
				lastStdyy = lastStdyy - 1;
			}
			
		}else {
			logger.info("--------------------(sacntMonth + 3) <= 12 가 아닐때------------------");
			logger.info("--------> Calendar.YEAR:" + cal2.get(Calendar.YEAR));		// 2016
			logger.info("--------> Calendar.MONTH: " + cal2.get(Calendar.MONTH));		// 1
			
			cal2.add(Calendar.YEAR, -1);
			logger.info("--------> Calendar.YEAR - 1: " + cal2.get(Calendar.YEAR));		// 2015		
			
			cal2.set(Calendar.MONTH, sacntMonth-1);		// 12-1
			logger.info("--------> Calendar.MONTH에 sacntMonth-1 를 set: " + cal2.get(Calendar.MONTH));		// 11
			
			cal2.add(Calendar.MONTH, 3);		// 11+3 = 2
			logger.info("--------> +3개월 적용 후 YEAR: " + cal2.get(Calendar.YEAR));		// 2016
			logger.info("--------> Calendar.MONTH + 3: " + cal2.get(Calendar.MONTH));	// 2
			
			logger.info("--------------------2222------------------");
			logger.info("--------> cal1:" + cal1.toString());
			logger.info("--------> cal2:" + cal2.toString());
						
//			if(cal1.before(cal2)) {
//				lastStdyy = lastStdyy - 2;
//			}else {
				lastStdyy = cal2.get(Calendar.YEAR);
//			}
			
			logger.info("--------> lastStdyy:" + lastStdyy);
		}
		*/
		
		return lastStdyy;
	}
}
