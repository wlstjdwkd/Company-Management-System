package biz.tech.pm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0020Mapper;
import biz.tech.mapif.pm.PGPM0030Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 개인별월급여항목
 * 
 * 선택한 사원의 개인별월급여항목 테이블(TB_PAY_ITM_MST)에서 사용 중인 항목 관리
 * '급여계산'에서 계산할 때 여기서 작성된 각 항목 금액들이 입력된다   
 *  
 * 등록 / 수정
 * 
 */
@Service("PGPM0030")
public class PGPM0030Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGPM0030Service.class);

	@Autowired
	PGPM0020Mapper pgpm0020Mapper;

	@Autowired
	PGPM0030Mapper pgpm0030Mapper;

	/**
	 * 메인 화면 이동
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/BD_UIPMA0030");

		return mv;
	}
	
	/**
	 * 사용여부가 Y인 급여 항목 리스트
	 * (개인급여항목관리 첫 조회 용)
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getUsePayItemList(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		param.put("chkUseYn", "Y");
		List<Map> codeList = pgpm0020Mapper.findPayItmMstList(param);
		String jsData;
		jsData = GridCodi.MaptoTreeJson(codeList , "payItmCd", "upItmCd");
		
		//logger.debug("jsData: " + jsData);
		
		ModelAndView mv = new ModelAndView("");
		
		return ResponseUtil.responseText(mv, jsData);
	}

	/**
	 * 사원 목록 팝업 띄우기
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView goEmpList(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/pm/PD_UIPMA0032");

		return mv;
	}

	/**
	 * 팝업용 사원 목록
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getEmpList(Map<?, ?> rqstMap) throws Exception {
		List<Map> codeList = pgpm0030Mapper.findEmpList(new HashMap());
		String jsData = GridCodi.MaptoJson(codeList);

		ModelAndView mv = new ModelAndView("");

		return ResponseUtil.responseText(mv, jsData);
	}
	
	/**
	 * 특정 직원조회 (공제세율 용)
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getDcRt(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		param.put("empNo", (String) rqstMap.get("empNo"));
		List<Map> codeList = pgpm0030Mapper.findEmpList(param);
		String jsData = GridCodi.MaptoJson(codeList);

		ModelAndView mv = new ModelAndView("");

		return ResponseUtil.responseText(mv, jsData);
	}

	// 매개변수로 받은 String을 json구조로 가독성 좋게 변환
	// @SuppressWarnings("deprecation")
	static private String prettyPring(String jsonStr) {
		//logger.debug("string[" + jsonStr + "]");
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonParser jp = new JsonParser();
		JsonElement je = jp.parse(jsonStr);
		String prettyJsonString = gson.toJson(je);
		logger.debug("string[" + prettyJsonString + "]");

		return prettyJsonString;
	}

	/**
	 * 개인별 급여 항목 수정
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView updateEmpPay(Map<String, Object> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("");
		HashMap param = new HashMap();
		JSONArray jArray = new JSONArray(); // 받은 전체 json Data
		JSONObject jsonData = null;			// 제어할 json Data
		String extracedJsonStr;				// &quot;(쌍따옴표) 변환이 끝난 문자열

		// jsonParse
		try {
			jArray = convertStrToJArr(MapUtils.getString(rqstMap, "sendData"));

			// 화면단에서 수정된 data만 전달받아 update
			for (int i = 0; i < jArray.size(); i++) {
				jsonData = (JSONObject) jArray.get(i);			// 제어할 json Data 가져오기
				param.clear(); 									// query 매개변수 초기화
				param.put("payItmCd", jsonData.get("payItmCd").toString()); 		// 급여항목
				param.put("empNo", jsonData.get("empNo").toString()); 				// 사원번호
				if (jsonData.containsKey("itmBasAmt")) {		// 해당 항목이 null이면 아애 json에 없는 경우가 존재
					param.put("itmBasAmt", jsonData.get("itmBasAmt").toString());	//항목기본금액
				}
				else {											// 항목기본금액 비었다면
					param.put("itmBasAmt", 0);					// 기본값으로 0 지정
				}
				param.put("useYN", jsonData.get("useYN").toString()); 				// 사용여부
				if (jsonData.containsKey("rmk")) {				// 해당 항목이 null이면 아애 json에 없는 경우가 존재
					param.put("rmrk", jsonData.get("rmk").toString());				// 비고
				}

				pgpm0030Mapper.updateEmpPay(param);				// table 수정
			}

			param.clear(); 
			param.put("ad_employee_code", jsonData.get("empNo").toString());
			mv = processEmpPayTree(param);
		}
		catch (ParseException e) {
			String errMsg = "cannot parsing input data";
			logger.error("Error message" + errMsg);
			throw new ParseException(ParseException.ERROR_UNEXPECTED_EXCEPTION, "cannot parsing input data");
		}

		return mv;
	}

	/**
	 * 개인별월급여항목 조회
	 * 
	 * 선택한 사원의 개인별월급여항목의 정보를 화면단으로 넘긴다
	 * 만약, 해당 사원의 개인별월급여항목이 생성된적 없다면 자동으로 생성한다
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView processEmpPayTree(Map<?, ?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		List<Map> codeList;		// 개인별 급여 항목
		String empNo;			// 사원번호
		String jsData;			// return할 Json 데이터

		empNo = (String) MapUtils.getString(rqstMap, "ad_employee_code");	// 해당 사원번호 받기
		if(rqstMap.containsKey("insertChk")) {	// 요청이 있을때만 작동
			insertChk(empNo);					// 사전검사
		}

		param.put("empNo", empNo);
		param.put("upItmCd", 0);
		codeList = pgpm0030Mapper.findEmpPayList(param);
		 
		jsData = GridCodi.MaptoTreeJson(codeList, "payItmCd", "upItmCd");

		ModelAndView mv = new ModelAndView("");

		return ResponseUtil.responseText(mv, jsData);
	}

	/**
	 * 사전검사
	 * 
	 * 사원코드를 받아 해당 사원코드를 가진 개인별 항목코드에서 모든 급여항목이 있는지 검사
	 * 있다면 no action 
	 * 없다면 default 값으로 insert
	 * 
	 * @param empNo
	 * @return
	 * @throws Exception
	 */
	private void insertChk(String empNo) throws Exception {
		List<String> codeList = new ArrayList<>();	// 모든 급여 항목 코드
		List<Map> chkPayItmList;					// 개별 급여 항목
		HashMap param = new HashMap();				// 쿼리 매개변수
		String itmBasAmtDefault = "0";				// 항목금액 기본
		String useYnDefault = "Y";					// 사용여부 기본

		// 모든 급여항목 코드 받기
		param.put("chkUseYn", "Y");
		List<Map> itemList = pgpm0020Mapper.findPayItmMstList(param);
		for (Map item : itemList) {
			codeList.add(MapUtils.getString(item, "payItmCd"));
		}

		// TB_PAY_ITM_LST에서 급여항목 다 있는지 검사
		for (String code : codeList) {
			param.clear();
			param.put("empNo", empNo);
			param.put("payItmCd", code);

			// 쿼리 호출해 급여항목 있으면 pass
			// 없다면 insert 호출
			chkPayItmList = pgpm0030Mapper.chkPayItm(param);
			if (chkPayItmList.isEmpty()) {
				param.put("itmBasAmt", itmBasAmtDefault);
				param.put("useYn", useYnDefault);
				pgpm0030Mapper.insertPayItm(param);
			}
		}
	}
	
	/**
	 * 변동 내역 저장
	 * 
	 * 개인별월급여항목의 금액변동을 기록
	 * 이때 수정된 항목만 화면단에서 받게된다
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView insertPayItmLog(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("");
		HashMap param = new HashMap();
		JSONArray jArray = new JSONArray(); // 받은 전체 json Data
		JSONObject jsonData = null;			// 제어할 json Data
		String empNo;
		
		// jsonParse
		try {
			empNo = MapUtils.getString(rqstMap, "empNo");		// 사원번호
			jArray = convertStrToJArr(MapUtils.getString(rqstMap, "updatedLog"));

			//화면단에서 수정된 data만 전달받아 update
			for (int i = 0; i < jArray.size(); i++) {
				jsonData = (JSONObject) jArray.get(i);			// 제어할 json Data 가져오기
				param.clear(); 									// query 매개변수 초기화
				param.put("payItmCd", jsonData.get("payItmCd").toString()); 		// 급여항목
				param.put("empNo", empNo); 											// 사원번호
				param.put("postItmAmt", jsonData.get("postItmAmt").toString());		// 수정된 항목기본금액
				param.put("prevItmAmt", jsonData.get("prevItmAmt").toString());		// 기존 항목기본금액
				if (jsonData.containsKey("rmk")) {				// 해당 항목이 null이면 아애 json에 없는 경우가 존재
					param.put("rmrk", jsonData.get("rmk").toString());				// 비고
				}

				pgpm0030Mapper.insertPayItmLog(param);			// 변동기록 삽입
			}

			// 화면 refresh
			param.clear(); 
			param.put("ad_employee_code", empNo);
			mv = processEmpPayTree(param);
		}
		catch (ParseException e) {
			String errMsg = "cannot parsing input data";
			logger.error("Error message" + errMsg);
			throw new ParseException(ParseException.ERROR_UNEXPECTED_EXCEPTION, "cannot parsing input data");
		}
		
		return ResponseUtil.responseText(mv, null);
	}
	
	/**
	 * 문자열 -> JSON Array 변환
	 * 
	 * 매개변수 Map에서 key이름으로 된 String을 JSONArray로 변환한다
	 * 
	 * @param rqstMap, keyName
	 * @return JSONArray
	 * @throws ParseException
	 */
	static public JSONArray convertStrToJArr(String jsonDataString) throws ParseException {
		JSONArray jArray;
		String extracedJsonStr;				// &quot;(쌍따옴표) 변환이 끝난 문자열
			
		// String -> Json으로 type 변환
		extracedJsonStr = (jsonDataString).replaceAll("&quot;", "\""); // 쌍따옴표 변환
		JSONParser jsonParse = new JSONParser();
		extracedJsonStr = prettyPring(extracedJsonStr);
		JSONObject jsonObj = (JSONObject) jsonParse.parse(extracedJsonStr);

		// rows 명으로 String을 받아 JSON Array에 저장
		String jData = (String) jsonObj.get("jsonRows").toString(); 
		jArray = (JSONArray) jsonParse.parse(jData);

		return jArray;
	}
}