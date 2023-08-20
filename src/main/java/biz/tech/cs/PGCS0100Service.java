package biz.tech.cs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;
import com.infra.file.FileDAO;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.my.ApplyMapper;
import biz.tech.mapif.my.EmpmnMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;


import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 * 고객지원 > 채용정보 목록 데이터 XML로 제공 
 * 
 * @author wjchoi
 *
 */
@Service("PGCS0100")
public class PGCS0100Service extends EgovAbstractServiceImpl
{
	private static final Logger logger = LoggerFactory.getLogger(PGCS0100Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="empmnMapper")
	private EmpmnMapper empmnDAO;
	
	@Resource(name="applyMapper")
	private ApplyMapper applyMapper;
	
	/**
	 * 채용정보 리스트 검색
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String,Object> param = new HashMap<String,Object>();
		List<Map> dataList = new ArrayList<Map>();
		Map result = new HashMap();
		
		int limitFrom = MapUtils.getIntValue(rqstMap, "limitFrom");
		int limitTo = MapUtils.getIntValue(rqstMap, "limitTo"); 
		
		param.put("limitFrom", limitFrom);
		param.put("limitTo", limitTo);
		
		// 필터에 저장된 항목들을 가져와 배열로 넘겨 NOT IN 처리한다.
		// 필터항목들 검색
		// 필터 검색
		String temp = null;
		param.put("ad_select", "a");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListA = temp.split(",");
			param.put("array_filterListA", array_filterListA);	// xml에서 사용될 배열
			param.put("tempA", temp);
		}
		param.put("ad_select", "b");
		result = applyMapper.findFilter(param);
		if( result != null) {
			temp = result.get("ATRB").toString();
			String[] array_filterListB = temp.split(",");
			param.put("array_filterListB", array_filterListB);	// xml에서 사용될 배열
			param.put("tempB", temp);
		}
		param.put("ad_select", "c");
		result = applyMapper.findFilter(param);
		if( result != null) {
			String stringfilterListC = result.get("ATRB").toString();
			param.put("stringfilterListC", stringfilterListC);	// xml에서 사용될 배열
		}
		
		int totalRowCnt = empmnDAO.findEmpmnPblancInfoCount(param);
		mv.addObject("totalRowCnt", totalRowCnt);
		
		// 채용공고 리스트 조회
		dataList = empmnDAO.findEmpmnPblancInfoList(param);

		//추천기업 리스트
		mv.addObject("dataList", dataList);
		mv.setViewName("/www/cs/BD_UICSU0100");
		return mv;		
	}
	
	private String id = "babobox";
	
	private String name = "홍길동";
	
	private String address="서울 특별시";
	
	private String contactNo="12345";
	
	public void setId(String id) {
        this.id = id;
    }
	
    public String getId() {
        return this.id;
    }
	
    public void setName(String name) {
        this.name = name;
    }
	
    public String getName() {
        return this.name;
    }
	
	public void setAddress(String address) {
        this.address = address;
    }
	
	public String getAddress() {
		return this.address;
	}
	
	public void setContactNo(String contactNo) {
		this.contactNo = contactNo;
	}
	
	public String getContactNo() {
		return this.contactNo;
	}




	// always verify the host - dont check for certificate
    final static HostnameVerifier DO_NOT_VERIFY = new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                    return true;
            }
    };
 
    /**
     * Trust every server - don't check for any certificate
     */
    private static void trustAllHosts() {
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return new java.security.cert.X509Certificate[] {};
            }
 
            @Override
            public void checkClientTrusted(X509Certificate[] chain,
                    String authType) throws CertificateException {
            }
 
            @Override
            public void checkServerTrusted(X509Certificate[] chain,
                    String authType) throws CertificateException {
            }
        }};
 
        // Install the all-trusting trust manager
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    public static HttpsURLConnection postHttps(String url, int connTimeout, int readTimeout) {
        trustAllHosts();
 
        HttpsURLConnection https = null;
        try {
            https = (HttpsURLConnection) new URL(url).openConnection();
            https.setHostnameVerifier(DO_NOT_VERIFY);
            https.setConnectTimeout(connTimeout);
            https.setReadTimeout(readTimeout);
        } 
        catch (MalformedURLException e) {
            e.printStackTrace();
            return null;
        } 
        catch (IOException e) {
            e.printStackTrace();
            return null;
        }
 
        return https;
    }
}
