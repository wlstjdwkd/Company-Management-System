package biz.tech.pm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0020Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 급여 항목 관리
 * 
 * 지급할 모든 급여가 정의된 항목 관리
 * 
 * 조회 / 등록 / 수정 / 비활성(사용여부 = N)
 * 
 */
@Service("PGPM0020")
public class PGPM0020Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGPM0020Service.class);

	@Autowired
	PGPM0020Mapper pgpm0020Mapper;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	/**
	 * 급여 항목 조회
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/BD_UIPMA0020");

		return mv;
	}
	
	/**
	 * 급여 항목 등록화면 이동
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getPayItemRegist(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/BD_UIPMA0021");
		
		return mv;
	}
	
	/**
	 * 급여 항목 등록/수정
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processPayItem(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap<>();
		Boolean isFind = false;

		String payItmCd = "";													// 항목코드
		String payItmNm = MapUtils.getString(rqstMap, "ad_payItmNm");			// 급여항목명
		String upItmCd	= MapUtils.getString(rqstMap, "ad_itmCd");				// 상위항목코드
		String itmSeq	= MapUtils.getString(rqstMap, "ad_itmSeq");				// 항목순번
		String useYn	= MapUtils.getString(rqstMap, "ad_useYn");				// 사용여부
		String rmrk		= MapUtils.getString(rqstMap, "ad_rmrk");				// 비고
		String insert_update = MapUtils.getString(rqstMap, "ad_insert_update"); // 등록/수정 체크

		// 최상위 항목의 상위항목은 0으로 설정
		if (upItmCd == "" || upItmCd == null || upItmCd.isEmpty()) {	// 상위 항목 비었을 때
			upItmCd = Integer.toString(0);
		}
		
		// 급여항목 등록정보
		param.put("payItmNm", payItmNm);		// 급여항목명
		param.put("upItmCd", upItmCd);			// 
		param.put("rmrk", rmrk);

		ModelAndView mv = index(new HashMap());
		
		// 결과메시지
		if ("INSERT".equals(insert_update.toUpperCase())) {			// 등록했다면
			int itmLv;								// 항목레벨
			HashMap chkParam = new HashMap();
			Map codeMap = new HashMap();
			
			if (Integer.parseInt(upItmCd) == 0) {	// 최상위 항목이라면
				itmLv = 1;
				
				// 현재 DB에 없는 항목코드를 탐색
				for(int i=1; i < 10; i++) {
					payItmCd = i + "00000000";
					chkParam.put("payItmCd", payItmCd);
					codeMap = pgpm0020Mapper.findPayItmMst(chkParam);
					
					if (codeMap == null || codeMap.isEmpty()) {
						param.put("payItmCd", payItmCd);
						isFind = true;
						break;
					}
				}
			}
			else {
				// 항목 레벨 계산
				int cd = Integer.parseInt(upItmCd);
				if ((cd % 100) > 0) {				// 십 이하의 자리에도 수가 있을 때
					itmLv = 5;
				}
				else if ((cd % 10000) > 0) {		// 천 이하의 자리에도 수가 있을 때
					itmLv = 4;
				}
				else if ((cd % 1000000) > 0) {		// 십만 이하의 자리에도 수가 있을 때
					itmLv = 3;
				}
				else if ((cd % 100000000) > 0) {	// 천만 이하의 자리에도 수가 있을 때
					itmLv = 2;
				}
				else {	// 최상위 항목이라면
					itmLv = 1;
				}
				
				itmLv ++;
				
				// 현재 DB에 없는 항목코드를 탐색
				for(int i=1; i < 100; i++) {
					payItmCd = upItmCd.substring(0,(itmLv-1)*2 - 1);
					if(i < 10) {
						payItmCd += "0";
					}
					payItmCd += i;
					for(int j=0; j < 5 - itmLv; j++) {
						payItmCd += "00";
					}
					
					chkParam.put("payItmCd", payItmCd);
					codeMap = pgpm0020Mapper.findPayItmMst(chkParam);
					if (codeMap == null || codeMap.isEmpty()) {
						param.put("payItmCd", payItmCd);
						isFind = true;
						break;
					}
				}				
			}

			if(!isFind || itmLv > 5) {	// 더이상 항목을 추가할 수 없을때
				// 등록 불가하다는 문구 띄우기
				/*
				 * mv.addObject("resultMsg", messageSource.getMessage("success.common.insert",
				 * new String[] { "메뉴" }, Locale.getDefault()));
				 */
				
				return mv;
			}

			param.put("useYn", "Y");
			param.put("itmLv", itmLv);
			param.put("payItmCd", payItmCd);
			param.put("itmSeq", payItmCd);
			
			pgpm0020Mapper.insertPayItmMst(param);
			mv.addObject("resultMsg",
							messageSource.getMessage("success.common.insert", new String[] { "메뉴" },
							Locale.getDefault()));
		}
		else if ("UPDATE".equals(insert_update.toUpperCase())) {	// 수정했다면
			payItmCd = MapUtils.getString(rqstMap, "ad_payItmCd");
			param.put("payItmCd", payItmCd);
			param.put("useYn", useYn);
			param.put("itmSeq", itmSeq);
			
			pgpm0020Mapper.updatePayItemMst(param);
			mv.addObject("resultMsg",
							messageSource.getMessage("success.common.update", new String[] { "메뉴" },
							Locale.getDefault()));
		}

		return mv;
	}
	
	/**
	 * 급여항목 삭제
	 * 
	 * 해당 항목의 사용여부를 사용안함으로 변경
	 * 테이블에서 delete하지 않는다
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView deletePayItem(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();

		String payItmCd = MapUtils.getString(rqstMap, "ad_payItmCd");	// 급여항목코드
		param.put("payItmCd", payItmCd);
		
		pgpm0020Mapper.deletePayItemMst(param);	// 급여항목 삭제 (update useYn = N)
		
		// 결과 메시지
		ModelAndView mv = index(new HashMap());
		mv.addObject("resultMsg",
						messageSource.getMessage("success.common.delete",
						new String[] { "급여항목" }, Locale.getDefault()));
		
		return mv;
	}
	
	/**
	 * 상위 급여항목 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goPayItemList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0023");
		
		return mv;
	}
	/**
	 * 급여항목 조회
	 * 
	 * 급여항목 TB_PAY_ITM_MST에 있는 모든 data를 보여준다
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getPayItemList(Map<?, ?> rqstMap) throws Exception {
		List<Map> payItmList = pgpm0020Mapper.findPayItmMstList(new HashMap());	//급여 항목 목록
		String jsData;	//js Array로 변환된 data

		jsData = GridCodi.MaptoTreeJson(payItmList , "payItmCd", "upItmCd");	//트리뷰로 사용할 JSON 변환
		
		ModelAndView mv = new ModelAndView("");
		
		return ResponseUtil.responseText(mv, jsData);
	}
	
	/**
	 * 급여항목 수정화면 이동
	 * 
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getPayItemModify(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();				// 급여항목 검색용
		HashMap upParam = new HashMap();			// 상위항목 검색용
		ModelAndView mv = new ModelAndView();

		// 코드로 급여항목 찾기
		String codeNo = MapUtils.getString(rqstMap, "ad_codeNo");
		param.put("payItmCd", codeNo);
		Map payItemInfo = pgpm0020Mapper.findPayItmMst(param);
		
		// 최상위 항목이 아니라면 상위 급여항목명 찾기
		codeNo = (String)payItemInfo.get("upItmCd");
		if(Integer.parseInt(codeNo) != 0) {			// 최상위 항목이 아니라면
			upParam.put("payItmCd", codeNo);
			Map upItemInfo = pgpm0020Mapper.findPayItmMst(upParam);

			mv.addObject("upItemInfo", upItemInfo);
		}
		
		mv.addObject("payItemInfo", payItemInfo);
		mv.setViewName("/admin/pm/BD_UIPMA0022");
		
		return mv;
	}
}