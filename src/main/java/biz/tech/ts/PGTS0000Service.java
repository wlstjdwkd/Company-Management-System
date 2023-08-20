package biz.tech.ts;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.bind.Validator;

import com.comm.issue.CertIssueVo;
import com.comm.menu.MenuService;
import com.comm.page.Pager;
import com.infra.file.FileDAO;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.test.TestMapper;

@Service("PGTS0000")
public class PGTS0000Service {
private static final Logger logger = LoggerFactory.getLogger(PGTS0000Service.class);
	

	/**
	 * 파일업로드 인덱스
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView test(Map<?, ?> rqstMap) throws Exception {		
		
		ModelAndView modelAndView = new ModelAndView();		
		
		Map<String,Object> parameterMap = new HashMap<String,Object>();
		
		System.out.println("aaaa");
		
		List<CertIssueVo> CertIssueList = new ArrayList<CertIssueVo>();
		CertIssueVo user1 = new CertIssueVo();
		user1.setDocNo("5158-8010-6768-9203");
		user1.setIssueNo("2014-0835");
		user1.setCorpNm("게임빌엔");
		user1.setCeoNm("송재준");
		user1.setJuriNo("110111-5099018");
		user1.setCorpRegNo("264-81-13433,264-99-11111,231-82-12345)");
		user1.setAddress("서울특별시 서초구 서초중앙로 4 게임빌빌딩 5층");
		user1.setExpireDe("2014-04-01 ~ 2015-03-31");
		user1.setPrintDe("2014 년 11월 14일");
		
		CertIssueList.add(user1);
		
//		User user2 = new User();
//		user2.setId("abc");
//		user2.setUserName("ANANAN");
//		usersList.add(user2);
		 
        JRDataSource JRdataSource = new JRBeanCollectionDataSource(CertIssueList);
 
        parameterMap.put("datasource", JRdataSource);
        parameterMap.put("url", "classpath:/env/report/CertIssue.jasper");
 
        //pdfReport bean has ben declared in the jasper-views.xml file
        modelAndView = new ModelAndView("pdfReport", parameterMap);
        
 
        return modelAndView;
	}
	
	
public ModelAndView test3(Map<?, ?> rqstMap) throws Exception {		
		
		ModelAndView modelAndView = new ModelAndView();		
		
		Map<String,Object> parameterMap = new HashMap<String,Object>();
		
		System.out.println("aaaa");
		
		List<CertIssueVo> CertIssueList = new ArrayList<CertIssueVo>();
		CertIssueVo user1 = new CertIssueVo();
		user1.setDocNo("5158-8010-6768-9203");
		user1.setIssueNo("2014-0835");
		user1.setCorpNm("게임빌엔");
		user1.setCeoNm("송재준");
		user1.setJuriNo("110111-5099018");
		user1.setCorpRegNo("264-81-13433,264-99-11111,231-82-12345)");
		user1.setAddress("서울특별시 서초구 서초중앙로 4 게임빌빌딩 5층");
		user1.setExpireDe("2014-04-01 ~ 2015-03-31");
		user1.setPrintDe("2014 년 11월 14일");
		
		CertIssueList.add(user1);
		
//		User user2 = new User();
//		user2.setId("abc");
//		user2.setUserName("ANANAN");
//		usersList.add(user2);
		 
 //		user2.setId("abc");
//		user2.setUserName("ANANAN");
//		usersList.add(user2);
		 
        JRDataSource JRdataSource = new JRBeanCollectionDataSource(CertIssueList);
 
        parameterMap.put("datasource", JRdataSource);
        parameterMap.put("url", "classpath:/env/report/CertIssue.jasper");
 
        //pdfReport bean has ben declared in the jasper-views.xml file
        modelAndView = new ModelAndView("testReport", parameterMap);
 
        return modelAndView;
	}
}
