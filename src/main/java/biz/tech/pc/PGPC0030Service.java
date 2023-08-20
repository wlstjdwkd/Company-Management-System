package biz.tech.pc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.AllUserVO;
import com.comm.user.EntUserVO;
import com.comm.user.UserService;
import com.comm.user.UserVO;
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

import biz.tech.mapif.pc.PGPC0030Mapper;
import egovframework.board.admin.BoardDao;
import egovframework.board.admin.BoardVO;
import egovframework.board.config.BoardConfVO;


/**
 * 기업통계
 * 
 * 
 */
@Service("PGPC0030")
public class PGPC0030Service {
	private static final Logger logger = LoggerFactory.getLogger(PGPC0030Service.class);
	
	@Resource(name="PGPC0030Mapper")
	PGPC0030Mapper PGPC0030DAO;
	
	@Autowired
	UserService userService;

	@Resource
    private BoardDao boardDao;
	
	/**
	 * 기업통계
	 */
	public ModelAndView index (Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		HashMap userInfo = new HashMap();
		ModelAndView mv = new ModelAndView();
		List<Map> mainPointList = new ArrayList();
		List<Map> yMlfscPointList = new ArrayList();
		List<Map> nMlfscPointList = new ArrayList();
		
		int latelyYear = PGPC0030DAO.findMaxStdyy();
		
		mv.addObject("latelyYear", latelyYear);
		// 기업 주요 통계 지표
		for(int i = latelyYear - 4; i <= latelyYear; i++) {
			param.put("stdyyDo", i);
			mainPointList.add(PGPC0030DAO.findMainPoint(param));
		}
		
		// 제조업 통계 지표
		param.put("productAt", "YY");
		for(int i = latelyYear - 4; i <= latelyYear; i++) {
			param.put("stdyyDo", i);
			yMlfscPointList.add(PGPC0030DAO.findMlfscPoint(param));
		}
		
		// 비제조업 통계 지표
		param.put("productAt", "NN");
		for(int i = latelyYear - 4; i <= latelyYear; i++) {
			param.put("stdyyDo", i);
			nMlfscPointList.add(PGPC0030DAO.findMlfscPoint(param));
		}
		mv.addObject("userInfo",userInfo);
		mv.addObject("yMlfscPointList", yMlfscPointList);
		mv.addObject("nMlfscPointList", nMlfscPointList);
		mv.addObject("mainPointList",mainPointList);
		mv.addObject("stdyy", PGPC0030DAO.selectMaxJdgmntYear(param));
		
		mv.setViewName("/www/pc/BD_UIPCU0030");
		return mv;
	}
	
	/**
	 * 데이터 요청 팝업화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getDataRequestPop(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		HashMap popParam = new HashMap();
		AllUserVO userVo = null;
		EntUserVO entUserVo = null;
		
		String userNo = MapUtils.getString(rqstMap, "userNo");
		String emplyrTy = MapUtils.getString(rqstMap, "emplyrTy");
		
		param.put("USER_NO", userNo);

		if("JB".equals(emplyrTy.toUpperCase())) {
			userVo = userService.findEmpUser(param);
			Map mbtlNum = StringUtil.telNumFormat(userVo.getMbtlnum());
			popParam.put("userNm", userVo.getUserNm());			// 작성자
			popParam.put("mbtlNum", mbtlNum);					// 연락처
			popParam.put("email", userVo.getEmail());			// 이메일
		} else if ("EP".equals(emplyrTy.toUpperCase())) {
			entUserVo = userService.findEntUser(param);
			Map mbtlNum = StringUtil.telNumFormat(entUserVo.getMbtlnum());
			popParam.put("userNm", entUserVo.getChargerNm());	// 작성자
			popParam.put("mbtlNum", mbtlNum);					// 연락처
			popParam.put("email", entUserVo.getEmail());		// 이메일
		} else if ("GN".equals(emplyrTy.toUpperCase())) {
			userVo = userService.findGnrUser(param);
			Map mbtlNum = StringUtil.telNumFormat(userVo.getMbtlnum());
			popParam.put("userNm", userVo.getUserNm());			// 작성자
			popParam.put("mbtlNum", mbtlNum);					// 연락처
			popParam.put("email", userVo.getEmail());			// 이메일
		}

		ModelAndView mv = new ModelAndView();
		mv.addObject("popParam",popParam);
		mv.setViewName("/www/pc/PD_UIPCU0031");
		return mv;
	}
	
	/**
	 * 데이터 요청 등록
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertDataRequest(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap jsonMap = new HashMap();
		BoardVO boardVO = new BoardVO();
		BoardConfVO boardConfVO = new BoardConfVO();
		UserVO userVO = SessionUtil.getUserInfo();
		
		String mbtlNum = MapUtils.getString(rqstMap, "ad_mbtlNum");
		String email = MapUtils.getString(rqstMap, "ad_email");
		String title = MapUtils.getString(rqstMap, "ad_title");
		String dataItem = MapUtils.getString(rqstMap, "ad_data_item");
		String dataContent = MapUtils.getString(rqstMap, "ad_data_content");
		
		boardVO.setBbsCd(1006);
		
	    boardVO.setTitle(title);
	    boardVO.setSummary(title);
	    boardVO.setContents(dataContent);
	    boardVO.setCellPhone(mbtlNum);
	    boardVO.setEmailAddr(email);
	    boardVO.setExtColumn2(dataItem);
		
	    if(!Validate.isEmpty(userVO)) {
	    	boardVO.setRegId(userVO.getLoginId());
    		boardVO.setRegNm(userVO.getUserNm());
    	}
	    
	    boardConfVO.setBbsCd(1006); 
	    boardConfVO.setListSkin("petition");
	    boardDao.boardInsert(boardVO, boardConfVO);
	    
		return ResponseUtil.responseJson(mv, true, jsonMap);
	}
	
	/**
	 * 기업 통계 포함기업 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView statsIncEntrprsSearch(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/pc/PD_UIPCU0031");
		HashMap param = new HashMap<String, Object>();
		
		// 검색조건 업종세분류목록 조회
		List<Map> indutyDtlclfcList = PGPC0030DAO.selectIndutyDtlclfcList();
		// 검색조건 지역코드 조회(시도별)
		List<Map> areaDivList = PGPC0030DAO.selectAreaDivList();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String stdyy = PGPC0030DAO.selectMaxJdgmntYear(param);
		String entrprsNm = MapUtils.getString(rqstMap, "ad_entrprs_nm");
		String lclasCd = MapUtils.getString(rqstMap, "ad_lclas_cd");
		String area1 = MapUtils.getString(rqstMap, "ad_area1");
		
		param.put("STDYY", stdyy);
		param.put("ENTRPRS_NM", entrprsNm);
		param.put("LCLAS_CD", lclasCd);
		param.put("AREA1", area1);
		
		int totalRowCnt = PGPC0030DAO.selectHpeAllFnnrCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		List<Map> dataList = PGPC0030DAO.selectHpeAllFnnr(param);
		
		String listEntNm = null;
		int entNmIdx1 = 0;
		int entNmIdx2 = 0;
		String midEntNm = null;
		String resultNm = null;
		for(int i=0; i<dataList.size(); i++) {
			listEntNm = (String) dataList.get(i).get("ENTRPRS_NM");
			logger.debug("ENTRPRS_NM >>> " + listEntNm);
			
			entNmIdx1 = listEntNm.indexOf("(주)");
			entNmIdx2 = listEntNm.indexOf("㈜");
			if(entNmIdx1 != -1) {
				if(entNmIdx1 == 0) {
					midEntNm = listEntNm.substring(entNmIdx1+3, listEntNm.length());
					if(midEntNm.length() == 1) {
						resultNm = "(주)" + "*";
					} else if(midEntNm.length() == 2) {
						resultNm = "(주)" + "*" + midEntNm.substring(1, midEntNm.length());
					} else {
						resultNm = "(주)" + "*" + midEntNm.substring(1, midEntNm.length()-1) + "*";
					}
					logger.debug("resultNm >>> " + resultNm);
				} else {
					midEntNm = listEntNm.substring(0, listEntNm.length()-3);
					if(midEntNm.length() == 1) {
						resultNm = "*" + "(주)";
					} else if(midEntNm.length() == 2) {
						resultNm = "*" + midEntNm.substring(1, midEntNm.length()) + "(주)";
					} else {
						resultNm = "*" + midEntNm.substring(1, midEntNm.length()-1) + "*" + "(주)";
					}
					logger.debug("resultNm >>> " + resultNm);
				}
			} else if(entNmIdx2 != -1) {
				if(entNmIdx2 == 0) {
					midEntNm = listEntNm.substring(entNmIdx2+1, listEntNm.length());
					if(midEntNm.length() == 1) {
						resultNm = "㈜" + "*";
					} else if(midEntNm.length() == 2) {
						resultNm = "㈜" + "*" + midEntNm.substring(1, midEntNm.length());
					} else {
						resultNm = "㈜" + "*" + midEntNm.substring(1, midEntNm.length()-1) + "*";
					}
					logger.debug("resultNm >>> " + resultNm);
				} else {
					midEntNm = listEntNm.substring(0, listEntNm.length()-1);
					if(midEntNm.length() == 1) {
						resultNm = "*" + "㈜";
					} else if(midEntNm.length() == 2) {
						resultNm = "*" + midEntNm.substring(1, midEntNm.length()) + "㈜";
					} else {
						resultNm = "*" + midEntNm.substring(1, midEntNm.length()-1) + "*" + "㈜";
					}
					logger.debug("resultNm >>> " + resultNm);
				}
			} else {
				if(listEntNm.length() == 1) {
					resultNm = "*";
				} else if(listEntNm.length() == 2) {
					resultNm = "*" + listEntNm.substring(1, listEntNm.length());
				} else {
					resultNm = "*" + listEntNm.substring(1, listEntNm.length()-1) + "*";
				}
				logger.debug("resultNm >>> " + resultNm);
			}
			
			dataList.get(i).put("ENTRPRS_NM", resultNm);
		}
		
		mv.addObject("indutyDtlclfcList", indutyDtlclfcList);
		mv.addObject("areaDivList", areaDivList);
		
		mv.addObject("pager", pager);
		mv.addObject("dataList", dataList);
		
		return mv;
	}
}

