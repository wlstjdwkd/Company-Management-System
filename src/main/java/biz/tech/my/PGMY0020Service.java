package biz.tech.my;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 마이페이지 > 입사지원현황
 * 
 * @author dongwoo
 *
 */
@Service("PGMY0020")
public class PGMY0020Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGMY0020Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	/**
	 * 입사지원현황 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();		
		
		String userNo = SessionUtil.getUserInfo().getUserNo();		
		param.put("USER_NO", userNo);
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		int totalRowCnt = applyMapper.findApplyCount(param);
		
		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();		
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());
		
		dataList = applyMapper.findApplyList(param);
		
		mv.addObject("pager", pager);
		mv.addObject("applyList", dataList);
		mv.setViewName("/www/my/BD_UIMYU0020");
		return mv;
	}
	
	/**
	 * 입사지원정보 상세보기
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView applyInfoView(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> empmnMap = new HashMap<String,Object>();
		Map<String,Object> applyMap = new HashMap<String,Object>();
		
		String empmnNo = MapUtils.getString(rqstMap, "ad_empmn_manage_no");
		
		// session 사용자번호
		String userNo = SessionUtil.getUserInfo().getUserNo();		
		// parameter 사용자번호
		String pramUserNo = MapUtils.getString(rqstMap, "ad_user_no");
		
		// 채용공고 상세조회
		param.put("EMPMN_MANAGE_NO", empmnNo);
		empmnMap = empmnDAO.findEmpmnPblancInfo(param);
		
		if(Validate.isEmpty(empmnMap)) {
			throw processException("info.searchdata.seq", new String[] {"채용공고"});
		}
		
		// 입사지원정보 조회
		if(Validate.isNotEmpty(pramUserNo)) {
			param.put("USER_NO", pramUserNo);
			mv.addObject("PRINCIPAL", "N");
		}else {
			param.put("USER_NO", userNo);
			mv.addObject("PRINCIPAL", "Y");
		}
		
		applyMap = applyMapper.findCompApplyInfo(param);
		
		if(Validate.isNotEmpty(applyMap)) {
			String acdmcrAt = MapUtils.getString(empmnMap, "DETAIL_ACDMCR_INPUT_AT", "");				//상세학력입력여부			
			String elseLgtyAt = MapUtils.getString(empmnMap, "_ELSE_LGTY_INPUT_AT", "");				//외국어능력입력여부
			String edcComplAt = MapUtils.getString(empmnMap, "EDC_COMPL_INPUT_AT", "");					//교육이수입력여부
			String ovseaAdytrnAt = MapUtils.getString(empmnMap, "OVSEA_SDYTRN_INPUT_AT", "");			//해외연수입력여부
			String qualfAcqsAt = MapUtils.getString(empmnMap, "QUALF_ACQS_INPUT_AT", "");				//자격취득입력여부
			String wtrcDtlsAt = MapUtils.getString(empmnMap, "WTRC_DTLS_INPUT_AT", "");					//수상내역입력여부			
			
			if("Y".equals(acdmcrAt)) {
				// 학력사항 조회
				applyMap.put("ACDMCR", applyMapper.findCaAcdmcr(param));				
			}			
			if("Y".equals(elseLgtyAt)) {
				// 외국어능력 조회
				applyMap.put("FGGG", applyMapper.findCaFggg(param));
			}
			if("Y".equals(edcComplAt)) {
				// 교육이수내역 조회
				applyMap.put("EDC", applyMapper.findCaEdc(param));
			}
			if("Y".equals(ovseaAdytrnAt)) {
				// 해외연수경험 조회
				applyMap.put("SDYTRN", applyMapper.findCaSdytrn(param));
			}
			if("Y".equals(qualfAcqsAt)) {
				// 자격취득사항 조회
				applyMap.put("QUALF", applyMapper.findCaQualf(param));
			}
			if("Y".equals(wtrcDtlsAt)) {
				// 수상내역 조회
				applyMap.put("AQTC", applyMapper.findCaRwrpns(param));
			}
			// 경력사항 조회
			applyMap.put("CACAREER", applyMapper.findCaCareer(param));
			
			// 전화번호 파싱
			Map<String, String> fmtTelNum = StringUtil.telNumFormat(MapUtils.getString(applyMap, "TELNO", ""));		
			Map<String, String> fmtMbtlnum = StringUtil.telNumFormat(MapUtils.getString(applyMap, "MBTLNUM", ""));	
					
			//전화번호
			applyMap.put("TELNO1", MapUtils.getString(fmtTelNum, "first", ""));
			applyMap.put("TELNO2", MapUtils.getString(fmtTelNum, "middle", ""));
			applyMap.put("TELNO3", MapUtils.getString(fmtTelNum, "last", ""));	
			//팩스번호
			applyMap.put("MBTLNUM1", MapUtils.getString(fmtMbtlnum, "first", ""));
			applyMap.put("MBTLNUM2", MapUtils.getString(fmtMbtlnum, "middle", ""));
			applyMap.put("MBTLNUM3", MapUtils.getString(fmtMbtlnum, "last", ""));			
		}
		
		mv.addObject("applyMap", applyMap);
		mv.addObject("empmnMap", empmnMap);
		mv.setViewName("/www/my/PD_UIMYU0021");
		
		return mv;
	}
	
	/**
	 * 입사지원 취소
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateApplyCancel(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();		
		
		String empmnNo = MapUtils.getString(rqstMap, "empmnNo");
		String userNo = SessionUtil.getUserInfo().getUserNo();
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		param.put("RCEPT_AT", "N");
		
		// 접수여부 변경
		applyMapper.updateReceptAt(param);
		
		return ResponseUtil.responseText(mv);
	}
	
	/**
	 * 입사지원정보 삭제
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteApplyInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();		
		
		String empmnNo = MapUtils.getString(rqstMap, "empmnNo");
		String userNo = SessionUtil.getUserInfo().getUserNo();
		
		param.put("EMPMN_MANAGE_NO", empmnNo);
		param.put("USER_NO", userNo);
		
		// 입사지원 추가 항목리스트 삭제
		applyMapper.deleteCaAcdmcr(param);
		applyMapper.deleteCaEdc(param);
		applyMapper.deleteCaFggg(param);
		applyMapper.deleteCaSdytrn(param);
		applyMapper.deleteCaCareer(param);
		applyMapper.deleteCaQualf(param);
		applyMapper.deleteCaRwrpns(param);
		
		// 입사지원기본정보 삭제
		applyMapper.deleteApplyInfo(param);				
		
		return ResponseUtil.responseText(mv);
	}
}
