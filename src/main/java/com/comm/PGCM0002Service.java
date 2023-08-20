package com.comm;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import com.infra.system.GlobalConst;
import com.infra.util.BizUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.SystemUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.HttpClientBuilder;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 공시시스템코드조회
 * 
 * @author JGS
 * 
 */
@Service("PGCM0002")
public class PGCM0002Service extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGCM0002Service.class);
	private Locale locale = Locale.getDefault();

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	/**
	 * 공시시스템코드조회 화면 출력
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/cmm/PD_UICMC0002");
		String crpNm = MapUtils.getString(rqstMap, "crp_nm", "").replace("주식회사", "");
		logger.debug("-------------------------------------------------- crpNm : " + crpNm);

		HttpClient httpClient = HttpClientBuilder.create().build();
		BasicResponseHandler basicRespHandler = new BasicResponseHandler();

		StringBuffer url = new StringBuffer();
		url.append(GlobalConst.DATR_ENTLIST_URL);
		url.append("?");
		url.append("textCrpNm=");
		url.append(URLEncoder.encode(crpNm, GlobalConst.ENCODING));

		String urlStr = url.toString();
		HttpGet httpget = new HttpGet(urlStr);

		String html = httpClient.execute(httpget, basicRespHandler);

		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 공시시스템코드조회: " + html);
		Map<String, Object> resultMap = getCodeMapList(html);
		mv.addObject("codeMapList", resultMap);

		return mv;
	}

	/**
	 * 기업개황API 호출
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getEntInfo(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		String crpCd = MapUtils.getString(rqstMap, "crp_cd", "");
		// String crpCd = MapUtils.getString(rqstMap, "crp_cd", "00126380");

		HttpClient httpClient = HttpClientBuilder.create().build();
		BasicResponseHandler basicRespHandler = new BasicResponseHandler();

		StringBuffer url = new StringBuffer();
		url.append(GlobalConst.DATR_ENTINFO_URL);
		url.append("?");
		// url.append("auth=");
		// url.append(GlobalConst.DATR_OPENAPI_KEY);
		// url.append("&");
		// url.append("crp_cd=");
		// url.append(crpCd);
		// 수정
		url.append("crtfc_key=");
		url.append(GlobalConst.DATR_OPENAPI_KEY);
		url.append("&");
		url.append("corp_code=");
		url.append(crpCd);

		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ url: " + url);
		HttpGet httpget = new HttpGet(url.toString());

		String html = httpClient.execute(httpget, basicRespHandler);

		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 기업개황API 호출: " + html);

		HashMap<String, String> respons = JsonUtil.fromJson(html, new HashMap<String, String>().getClass());

		logger.debug("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 기업개황API 호출(respons): " + respons);

		int accMt = MapUtils.getIntValue(respons, "acc_mt");
		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ accMt : " + accMt);
		if (Validate.isEmpty(accMt)) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "0" }, locale));
		}

		String lastIssuYear = String.valueOf(BizUtil.getLastIssuYear(accMt));
		respons.put("last_issu_year", lastIssuYear);

		logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 기업개황API 호출(respons): " + respons);
		return ResponseUtil.responseJson(mv, true, respons);
		// return ResponseUtil.responseJson(mv, true, html); //에러
	}

	/**
	 * 기업상세검색(재무)API 호출
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView getEntFnnr(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		logger.debug("@@@getEntFnnr start@@@");
		
		String crp_cd = MapUtils.getString(rqstMap, "crp_cd", ""); // 공시대상회사 코드
		String start_dt = MapUtils.getString(rqstMap, "start_dt", ""); // 검색시작일자
		String end_dt = MapUtils.getString(rqstMap, "end_dt", ""); // 검색종료일자
		String bsn_tp = MapUtils.getString(rqstMap, "bsn_tp", ""); // 보고서유형
//		String crp_cls = MapUtils.getString(rqstMap, "crp_cls", ""); // 회사 유형
		String fin_rpt = "Y"; // 최종보고서만(최종정정만)
		
		//test
		logger.debug("1::crp_cd:: " + crp_cd);
		logger.debug("2::start_dt:: " + start_dt);
		logger.debug("3::end_dt:: " + end_dt);
		logger.debug("4::bsn_tp:: " + bsn_tp);
//		logger.debug("5-1::crp_cls:: " + crp_cls);
		logger.debug("6::fin_rpt:: " + fin_rpt);
		String err_code2 = MapUtils.getString(rqstMap, "err_code", "");
		String rcp_no2 = MapUtils.getString(rqstMap, "rcp_no", "");
		logger.debug("7::err_code2:: " + err_code2);
		logger.debug("8::rcp_no2:: " + rcp_no2);
		String crp_cls = MapUtils.getString(rqstMap, "corp_cls", ""); // 회사 유형
		String page_no = MapUtils.getString(rqstMap, "page_no", "");
		String page_count = MapUtils.getString(rqstMap, "page_count", "");
		logger.debug("5-2::corp_cls:: " + crp_cls);
		logger.debug("9::page_no:: " + page_no);
		logger.debug("10::page_count:: " + page_count);
		
		// 기업상세검색API
		StringBuffer urlEntDetail = new StringBuffer();
		urlEntDetail.append(GlobalConst.DATR_ENTDETAIL_URL);
		urlEntDetail.append("?");
		urlEntDetail.append("crtfc_key=");
		urlEntDetail.append(GlobalConst.DATR_OPENAPI_KEY);
		urlEntDetail.append("&");
		urlEntDetail.append("corp_code=");
		urlEntDetail.append(crp_cd);
		urlEntDetail.append("&");
		urlEntDetail.append("bgn_de=");
		urlEntDetail.append(start_dt);
		urlEntDetail.append("&");
		urlEntDetail.append("end_de=");
		urlEntDetail.append(end_dt);
	//	urlEntDetail.append("&");
	//	urlEntDetail.append("pblntf_detail_ty=");
	//	urlEntDetail.append("F001");

		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%% 기업상세검색API 요청: " + urlEntDetail.toString());

		String html = openURL(urlEntDetail.toString());
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%% 기업상세검색API 결과: " + html);

		HashMap<String, Object> result = JsonUtil.fromJson(html, new HashMap<String, Object>().getClass());
		
		logger.debug("status: " + MapUtils.getString(result, "status"));
		
//		if (!"000".equals(MapUtils.getString(result, "err_coe"))) {
		if (!"000".equals(MapUtils.getString(result, "status"))) {
			return ResponseUtil.responseJson(mv, false, MapUtils.getString(result, "err_msg"));
		}


		int totalCount = MapUtils.getIntValue(result, "total_count", 0);
		
		logger.debug("total_count: " + totalCount);
		
		if (totalCount <= 0) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "1" }, locale));
		}

		List dataList = (ArrayList) result.get("list");
		
		logger.debug("dataList: " + dataList);
		if (dataList.isEmpty()) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "2" }, locale));
		}
	//	dataList: [{corp_code=00129022, corp_name=삼호산업, stock_code=, corp_cls=E, report_nm=연결감사보고서 (2018.12), rcept_no=20190429000105, flr_nm=경일공인회계사감사반(제4호), rcept_dt=20190429, rm=}, 
	//	           {corp_code=00129022, corp_name=삼호산업, stock_code=, corp_cls=E, report_nm=감사보고서 (2018.12), rcept_no=20190410000917, flr_nm=경일공인회계사감사반(제4호), rcept_dt=20190410, rm=}]

		
		// 리포트 번호 추출
		Map<String, String> data = null;
		Map<String, String> tempData = null;
		
		// 연결재무재표 스킵
		for(int i = 0; i < totalCount; i++) {
			tempData = (HashMap<String, String>) dataList.get(i);
			String reportNm = MapUtils.getString(tempData, "report_nm").substring(0, 7);
			logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ reportNm: " + reportNm);
			if((reportNm.contains("사업보고서") || reportNm.contains("감사보고서")) && !reportNm.contains("연결") && !reportNm.contains("제출")) {
				data = tempData;
			}
		}
		
		if (data == null) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "2" }, locale));
		}
		
//		String rcpNo = MapUtils.getString(data, "rcp_no");
		String rcpNo = MapUtils.getString(data, "rcept_no");
		logger.debug("rcept_no::" +rcpNo);

		// 공시뷰어메인 URL 호출
		String resultHtml = openDisclosureViewer(rcpNo);
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%% 공시뷰어메인URL 호출: " + resultHtml);
//		//임시
//		resultHtml = "http://dart.fss.or.kr/dsaf001/main.do?rcpNo=20190530000687";
		
		
		// 스크립트 파싱
		crp_cls = MapUtils.getString(data, "corp_cls");
		logger.debug("crp_cls::" +crp_cls);
		Map<String, String> resultScriptParam = parseFnnrScriptHTML(resultHtml, crp_cls);
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%% 공시뷰어메인 스크립트 파싱: " + resultScriptParam.toString());

		if (resultScriptParam.isEmpty()) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "3" }, locale));
		}

		if (resultScriptParam.isEmpty()) {
			return ResponseUtil.responseJson(mv, false,
					messageSource.getMessage("info.searchdata.seq", new String[] { "4" }, locale));
		}

		// 공시뷰어상세
		StringBuffer urlViewer = new StringBuffer();
		urlViewer.append(GlobalConst.DATR_VIEWER_DETAIL_URL);
		urlViewer.append("?");
		urlViewer.append("rcpNo=");
		urlViewer.append(MapUtils.getString(resultScriptParam, "rcpNo"));
		urlViewer.append("&");
		urlViewer.append("dcmNo=");
		urlViewer.append(MapUtils.getString(resultScriptParam, "dcmNo"));
		urlViewer.append("&");
		urlViewer.append("eleId=");
		urlViewer.append(MapUtils.getString(resultScriptParam, "eleId"));
		urlViewer.append("&");
		urlViewer.append("offset=");
		urlViewer.append(MapUtils.getString(resultScriptParam, "offset"));
		urlViewer.append("&");
		urlViewer.append("length=");
		urlViewer.append(MapUtils.getString(resultScriptParam, "length"));
		logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%% 공시뷰어상세URL 호출: " + urlViewer.toString());

		String fnnrHTML = openURL(urlViewer.toString());
		String bodyHTML = getBodyHTML(fnnrHTML);

		// 재무상세 팝업에서 출력할 재무HTML 저장
		SessionUtil.setFnnrHTML(bodyHTML, propertiesService.getInt("session.timeout"));
		
		logger.debug("@@@getEntFnnr end@@@");

		return ResponseUtil.responseJson(mv, true);
	}

	/**
	 * 재무제표 화면 출력
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView fnnrHTML(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/cmm/PD_UICMC0005");
		return mv;
	}

	/**
	 * 제무제표를 보기 위한 공시뷰어화면 Script 파싱
	 * 
	 * @param String
	 *            html 공시뷰어화면 HTML
	 * @param String
	 *            entType 회사타입
	 * @return Map result 공시뷰어상세화면 URL 정보
	 * @throws Exception
	 */
	private Map<String, String> parseFnnrScriptHTML(String html, String entType) throws Exception {

		Map<String, String> result;

		if ("Y".equals(entType) || "K".equals(entType)) {
			// 유가, 코스닥
			result = parseFnnrScriptYK(html);
		} else {
			// 코넥스, 기타
			result = parseFnnrScript(html);
		}

		return result;
	}

	/**
	 * 재무제표 TreeScript Parsing 좌측 트리 메뉴의 제무제표URL을 재 호출해야함
	 * 
	 * @param String
	 *            html 공시뷰어에 출력된 HTML
	 * @return Map 재 호출할 공시뷰어상세 URL
	 * @throws Exception
	 */
	private Map<String, String> parseFnnrScript(String html) throws Exception {

		Document doc = Jsoup.parse(html);

		Elements scriptElements = doc.getElementsByTag("script");

		String scriptStr = "";
		for (Element scriptElement : scriptElements) {

			String scriptText = scriptElement.html();

			scriptText = scriptText.replaceAll("\\p{Z}", "");
			scriptText = scriptText.replaceAll("\\p{Space}", "");
			scriptText = scriptText.replace(SystemUtil.LINE_SEPARATOR, "");

			if (scriptText.indexOf("newTree.TreeNode") != -1) {
				scriptStr = scriptText;
				break;
			}
		}

		String regex = "(?i)newTree\\.TreeNode\\(\\{text:\".+재무제표등\",id:\"\\d+\",cls:\"text\",listeners:\\{click:function\\(\\)\\{viewDoc\\('(\\d+)','(\\d+)','(\\d+)','(\\d+)','(\\d+)','(.+\\.xsd)'\\);\\}\\}\\}\\)";

		Pattern pattern = Pattern.compile(regex);
		Matcher match = pattern.matcher(scriptStr);

		Map<String, String> result = new HashMap<String, String>();
		while (match.find()) {
			result.put("rcpNo", match.group(1));
			result.put("dcmNo", match.group(2));
			result.put("eleId", match.group(3));
			result.put("offset", match.group(4));
			result.put("length", match.group(5));
		}

		if (result.isEmpty()) {
			regex = "(?i)newTree\\.TreeNode\\(\\{text:\".+재무제표\",id:\"\\d+\",cls:\"text\",listeners:\\{click:function\\(\\)\\{viewDoc\\('(\\d+)','(\\d+)','(\\d+)','(\\d+)','(\\d+)','(.+\\.xsd)'\\);\\}\\}\\}\\)";
			pattern = Pattern.compile(regex);
			match = pattern.matcher(scriptStr);
			while (match.find()) {
				result.put("rcpNo", match.group(1));
				result.put("dcmNo", match.group(2));
				result.put("eleId", match.group(3));
				result.put("offset", match.group(4));
				result.put("length", match.group(5));
			}
		}

		return result;
	}

	/**
	 * 재무제표 SelectScript Parsing 유가, 코스닥일 경우 첨부파일문서 URL을 재 호출해야 함
	 * 
	 * @param String
	 *            html 공시뷰어에 출력된 HTML
	 * @return Map 재 호출할 공시뷰어 URL
	 * @throws Exception
	 */
	private Map<String, String> parseFnnrScriptYK(String html) throws Exception {
		Map<String, String> result = new HashMap<String, String>();

		Document doc = Jsoup.parse(html);

		Elements selectElements = doc.getElementsByTag("select");

		Element test = doc.getElementById("family");
		test.children().attr("selected", "selected");
		
		String param = selectElements.toString().substring(120, 140);
		
		
		if (selectElements.isEmpty()) {
			return result;
		}
		
		String reportParam = "";
		for (Element select : selectElements) {
			String onchange = select.attr("onchange");
			
			logger.debug("onchange::" +onchange);
			logger.debug(".equals(onchange)" +"changeAtt(this.value)::".equals(onchange));
			
//			if ("changeAtt(this.value)".equals(onchange)) {
//				Elements options = select.getElementsByTag("option");
//				for (Element option : options) {
//					String text = option.text();
//					
//					text = text.replaceAll("\\p{Z}", "");
//					text = text.replaceAll("\\p{Space}", "");
//					text = text.replace(SystemUtil.LINE_SEPARATOR, "");
//					String regex = "^\\d{4}\\.\\d{2}\\.\\d{2}(\\[정정\\]감사보고서|감사보고서)$";
//					logger.debug("@@@text::" + text);
//					logger.debug("@@@regex::" + regex);
//					
//					if (Pattern.matches(regex, text)) {
//						reportParam = option.attr("value");
//						break;
//					}
//
//				}
//			}
			
			Elements options2 = select.getElementsByTag("option:selected");
			String testa123 = options2.toString();
			
			for (Element option : options2) {
				Elements options3 = option.getElementsByTag("option:selected");
				
				for (Element option3 : options3) {
					String text = option3.text();
					text.split("rcpNo");
					logger.debug("text.split(rcpNo)::" +text.split("rcpNo"));
					reportParam = option3.attr("value");
					break;
				}
			}
		}
		
		reportParam = param;	
		if (Validate.isEmpty(reportParam)) {
			return result;
		}
		logger.debug("@@@here4@@@");
		// 공시뷰어의 첨부선택에 감사보고서 URL
		StringBuffer urlViewer = new StringBuffer();
		urlViewer.append(GlobalConst.DATR_VIEWER_MAIN_URL);
		urlViewer.append("?");
		urlViewer.append(reportParam);

		String urlViewerHTML = openURL(urlViewer.toString());

		result = parseFnnrScript(urlViewerHTML);

		return result;
	}

	/**
	 * 공시뷰어메인URL 호출
	 * 
	 * @param String
	 *            rcpNo 리포트번호
	 * @return String html 호출된 공시뷰어메인 HTML
	 * @throws Exception
	 */
	private String openDisclosureViewer(String rcpNo) throws Exception {

		HttpClient httpClient = HttpClientBuilder.create().build();
		BasicResponseHandler basicRespHandler = new BasicResponseHandler();

		StringBuffer url = new StringBuffer();
		url.append(GlobalConst.DATR_VIEWER_MAIN_URL);
		url.append("?");
		url.append("rcpNo=");
		url.append(rcpNo);

		HttpGet httpget = new HttpGet(url.toString());

		String html = httpClient.execute(httpget, basicRespHandler);

		return html;
	}

	/**
	 * 공시기업리스트 HTMLParser
	 * 
	 * @param String
	 *            html 공시기업리스트 HTML
	 * @return Map 화면에 출력할 공시기업리스트 정보
	 * @throws Exception
	 */
	private Map<String, Object> getCodeMapList(String html) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		List codeMapList = new ArrayList<Map>();

		Document doc = Jsoup.parse(html);
		Elements trs = doc.select("div.table_scroll table tbody tr");

		for (Element tr : trs) {
			Elements tds = tr.getElementsByTag("td");
			Map<String, String> codeMap = new HashMap<String, String>();

			if (tds.size() <= 1) {
				resultMap.put("result", false);
				return resultMap;
			}

			for (int i = 0; i < tds.size(); i++) {
				Element td = tds.get(i);

				switch (i) {
				case 0:
					// crp 코드, 기업명
					String cikCd = td.getElementsByAttributeValue("name", "hiddenCikCD1").get(0)
							.attr("value");
					String cikNm = td.getElementsByAttributeValue("name", "hiddenCikNM1").get(0)
							.attr("value");
					codeMap.put("cikCd", cikCd);
					codeMap.put("cikNm", cikNm);
					break;
				case 1:
					// 대표자
					String rprNm = td.text();
					codeMap.put("rprNm", rprNm);
					break;
				case 2:
					// 종목코드
					String itemCd = td.text();
					codeMap.put("itemCd", itemCd);
					break;
				case 3:
					// 업종명
					String indutyNm = td.text();
					codeMap.put("indutyNm", indutyNm);
					break;
				default:
					break;
				}
			}
			if (codeMap.size() > 0) {
				codeMapList.add(codeMap);
			}
		}
		resultMap.put("result", true);
		resultMap.put("value", codeMapList);

		return resultMap;
	}

	/**
	 * 지정 URL 호출
	 * 
	 * @param String
	 *            url 호출할 URL
	 * @return String html 호출된 URL의 HTML
	 * @throws Exception
	 */
	private String openURL(String url) throws Exception {
		HttpClient httpClient = HttpClientBuilder.create().build();
		BasicResponseHandler basicRespHandler = new BasicResponseHandler();

		HttpGet httpget = new HttpGet(url);

		String html = httpClient.execute(httpget, basicRespHandler);

		return html;
	}

	/**
	 * 공시뷰어에 출력된 HTML 중 Body 수정
	 * 
	 * @param String
	 *            html
	 * @return String bodyHTML
	 * @throws Exception
	 */
	private String getBodyHTML(String html) throws Exception {
		Document doc = Jsoup.parse(html);

		String bodyHTML = "";
		Elements elements = doc.getElementsByTag("body");

		if (!elements.isEmpty()) {
			Element bodyElement = elements.get(0);
			Elements tds = bodyElement.getElementsByTag("td");

			String regex = "\\d+";
			for (Element td : tds) {
				String orgVal = td.text();
				orgVal = orgVal.replaceAll("\\p{Z}", "");
				String repVal = td.text();
				repVal = repVal.replaceAll("\\p{Z}", "");
				repVal = repVal.replaceAll(",", "");
				repVal = repVal.replaceAll("\\(", "");
				repVal = repVal.replaceAll("\\)", "");
				if (Pattern.matches(regex, repVal)) {
					// td.attr("class", "amount");
					td.empty();
					td.appendElement("a").attr("href", "#none").attr("class", "amount").appendText(orgVal);
				}
			}
			bodyHTML = bodyElement.html();
		}

		return bodyHTML;
	}

}
