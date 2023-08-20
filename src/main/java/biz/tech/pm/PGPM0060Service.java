package biz.tech.pm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0060Mapper;

/**
 * 세율관리
 * 
 * 급여 계산시 모든 직원에게 일괄 적용되는 급여 항목 관리
 * 
 * 조회 / 등록 / 수정 / 삭제
 * 
 */
@Service("PGPM0060")
public class PGPM0060Service {

	private static final Logger logger = LoggerFactory.getLogger(PGPM0060Service.class);

	@Autowired
	PGPM0060Mapper pgpm0060Mapper;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	/**
	 * 세율 항목 이동
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/BD_UIPMA0060");

		return mv;
	}
	
	/**
	 * 세율 등록화면 이동
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getTaxItemRegist(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/BD_UIPMA0061");
		
		return mv;
	}
	
	/**
	 * 세율 항목 등록/수정
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processTaxItem(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();

		String payItmCd = MapUtils.getString(rqstMap, "ad_itmCd");				// 급여항목코드
		String payItmNm = MapUtils.getString(rqstMap, "ad_itmNm");				// 급여항목명
		String refItmCd = MapUtils.getString(rqstMap, "ad_refItmCd");			// 참고항목코드
		String refItmNm = MapUtils.getString(rqstMap, "ad_refItmNm");			// 참고항목명
		String taxRate	= MapUtils.getString(rqstMap, "ad_taxRate");			// 세율
		String rmrk		= MapUtils.getString(rqstMap, "ad_rmrk");				// 비고
		String insert_update = MapUtils.getString(rqstMap, "ad_insert_update"); // 등록/수정 체크

		//급여항목 등록정보
		param.put("payItmCd", payItmCd);
		param.put("refItmCd", refItmCd);
		param.put("taxRate", taxRate);
		param.put("rmrk", rmrk);

		ModelAndView mv = index(new HashMap());
		
		// 결과메시지
		if ("INSERT".equals(insert_update.toUpperCase())) {			//등록했다면
			pgpm0060Mapper.insertTaxItm(param);
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.insert", new String[] { "메뉴" },
							Locale.getDefault()));
		}
		else if ("UPDATE".equals(insert_update.toUpperCase())) {	//수정했다면
			pgpm0060Mapper.updateTaxItm(param);
			mv.addObject(
					"resultMsg",
					messageSource.getMessage("success.common.update", new String[] { "메뉴" },
							Locale.getDefault()));
		}

		return mv;
	}
	
	/**
	 * 세율 삭제
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView deleteTaxItem(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();

		String payItmCd = MapUtils.getString(rqstMap, "ad_itmCd");	// 급여항목코드
		param.put("payItmCd", payItmCd);
		
		pgpm0060Mapper.deleteTaxItm(param);		// 테이블에서 해당 세율 계산 삭제
		
		//결과 메시지
		ModelAndView mv = index(new HashMap());
		mv.addObject("resultMsg",
				messageSource.getMessage("success.common.delete",
						new String[] { "급여항목" }, Locale.getDefault()));
		
		return mv;
	}
	
	/**
	 * 세율 조회
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getTaxItemList(Map<?, ?> rqstMap) throws Exception {
		List<Map> payItmList = pgpm0060Mapper.findTaxItmList(new HashMap());	//급여 항목 목록
		String jsData;	//js Array로 변환된 data

		jsData = GridCodi.MaptoJson(payItmList);	//트리뷰로 사용할 JSON 변환
		
		ModelAndView mv = new ModelAndView("");
		
		return ResponseUtil.responseText(mv, jsData);
	}
	
	/**
	 * 세율 수정화면 이동
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getTaxItemModify(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		Map taxInfo;	//조회한 세율 정보

		String codeNo = MapUtils.getString(rqstMap, "ad_codeNo");	// 급여항목 코드
		param.put("payItmCd", codeNo);
		
		taxInfo = pgpm0060Mapper.findTaxItm(param);					// 조회할 세율 계간 정보
				
		mv.addObject("taxInfo", taxInfo);
		mv.setViewName("/admin/pm/BD_UIPMA0062");
		
		return mv;
	}
	
	/**
	 * 참고 급여항목 찾기 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goRefItemList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0063");
		
		return mv;
	}
}
