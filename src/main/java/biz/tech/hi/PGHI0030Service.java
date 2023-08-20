package biz.tech.hi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.comm.page.Pager;
import com.infra.system.GlobalConst;

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
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * 기업소개
 * @author JGS
 *
 */
@Service("PGHI0030")
public class PGHI0030Service extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(PGHI0030Service.class);
	
	/**
	 * 관련법령
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView("/www/hi/BD_UIHIU0030");
		
		int cpgNm = MapUtils.getIntValue(rqstMap, "df_curr_page",0);
		int crpNm = MapUtils.getIntValue(rqstMap, "df_row_per_page",10);
		
		HttpClient httpClient = HttpClientBuilder.create().build();
		BasicResponseHandler basicRespHandler = new BasicResponseHandler();
		
		StringBuffer url = new StringBuffer();
		url.append(GlobalConst.LAW_INFOLIST_URL);
		url.append("?");
		url.append("q=%22%EC%A4%91%EA%B2%AC%EA%B8%B0%EC%97%85%22");
		url.append("&");
		url.append("outmax=");
		url.append(crpNm);		
		url.append("&");
		url.append("p4=1");
		url.append("&");
		url.append("pg=");
		url.append(cpgNm);		
		url.append("&section=joBody&lsiSeq=0&p9=2,4#AJAX");
				
		String urlStr = url.toString();
		
		logger.debug("국가법령사이이트 요청 정보 :"+urlStr);
		
	    HttpGet httpget = new HttpGet(urlStr);
	    
		
		String html = httpClient.execute(httpget, basicRespHandler);
		
	    Pager pager = null;
	    
	    Map<String,Object> resultMap = getCodeMapList(html);
	    
		logger.debug("국가법령사이이트 응답 데이터 :"+html);
	    
	    if(!MapUtils.getBooleanValue(resultMap, "result", false)) {
			 // 페이저 빌드        
			    pager = new Pager.Builder().pageNo( cpgNm).rowSize(crpNm).totalRowCount(0).build();
			 	pager.makePaging();
	    }
	    else
	    {
		 // 페이저 빌드        
		    pager = new Pager.Builder().pageNo( cpgNm).rowSize(crpNm).totalRowCount(Integer.parseInt((String) resultMap.get("cntNm"))).build();
		 	pager.makePaging();
	    }

	    mv.addObject("lawInfoList", resultMap);
	 	mv.addObject("pager", pager);
	 	
		return mv;
	}
	
	
	/**
	 * 공시시스템코드 HTMLParser
	 * 
	 * @param rqstMap
	 *            request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	private Map<String,Object> getCodeMapList(String html){
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		List codeMapList = new ArrayList<Map>();
		
		Document doc = Jsoup.parse(html);
		Elements trs = doc.select("div.tbl_type table tbody tr");

		if(trs.isEmpty())
			return null;
		
		for (Element tr : trs) {
        	Elements tds = tr.getElementsByTag("td");
        	Map<String,String> codeMap = new HashMap<String,String>();
        	
        	if(tds.size()<=1) {
        		resultMap.put("result", false);
        		return resultMap;
        	}
        	
        	for(int i=0;i<tds.size();i++) {
        		Element td = tds.get(i);
        		
        		switch(i) {
        		case 0:        			
        			// 번호
        			String seqNm = td.text();
        			codeMap.put("seqNm", seqNm);
        			break;
        		case 1:
        			// 법령명
        			String lawNm = td.html();
        			String lawNmT = td.text();
        			codeMap.put("lawNm", lawNm.replace("<div class=\"tbl_tx_type2\">", "<br/>").replace("</div>", "").replace("/LSW/images","http://www.law.go.kr/LSW/images"));
        			if( lawNmT.indexOf('[') != -1)
        			{
        				int idx =  lawNmT.indexOf('[');
        				codeMap.put("lawNmT",lawNmT.substring(0, idx) +"<br/>" +lawNmT.substring(idx) );
        			}
        			else
        			{
        				codeMap.put("lawNmT",lawNmT );
        			}
        			
        			break;
        		case 2:
        			// 조문명
        			String itemNm = td.html();
        			codeMap.put("itemNm", itemNm);
        			break;
        		case 3:
        			// 항호목
        			String itemNm2 = td.html();
        			codeMap.put("itemNm2", itemNm2);
        			break;
        		default:
        			break;
        		}
        	}
        	if(codeMap.size()>0) {
        		codeMapList.add(codeMap);
        	}
        }
		
		Elements cntNm = doc.select("#readNumDiv strong");
		
		Elements pcntNm = doc.select("#pageSize");
		
		resultMap.put("result", true);
		resultMap.put("value", codeMapList);
		resultMap.put("cntNm", cntNm.text());
		resultMap.put("pcntNm", pcntNm.val());
		
		return resultMap;	
	}
	
	
}
