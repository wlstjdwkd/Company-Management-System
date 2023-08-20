package biz.tech.dc;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.BizUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import biz.tech.mapif.dc.PGDC0030Mapper;

/**
 * 상호출자제한기업관리
 * @author DST
 *
 */
@Service("PGDC0030")
public class PGDC0030Service  extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGDC0030Service.class);
	
	@Resource(name = "PGDC0030Mapper")
	private PGDC0030Mapper pgdc0030Mapper;
	
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		Calendar today = Calendar.getInstance();
		
		String search_year = MapUtils.getString(rqstMap, "search_year");
		
		if( Validate.isEmpty(search_year) )
		{
			param.put("stdYy", String.valueOf(today.get(Calendar.YEAR)));
		}
		else
		{
			param.put("stdYy", search_year);
		}

		// 주가정보수집 목록
		List<Map> stockMgrList = pgdc0030Mapper.findmiLimitMgrList(param);
	
		ModelAndView mv = new ModelAndView();

		mv.addObject("stockMgrList", stockMgrList);
		
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		mv.addObject("inparam",param);

		mv.setViewName("/admin/dc/BD_UIDCA0030");
		
		return mv;
	}

	public ModelAndView findmiLimitList(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String tarket_date = MapUtils.getString(rqstMap, "tarket_date");
		String selectCondType = MapUtils.getString(rqstMap, "selectCondType","all");
		String searchkeyword = MapUtils.getString(rqstMap, "searchKeyword");
		
		if( Validate.isEmpty(tarket_date) )
			throw processException("errors.required", new String[] {"발표일자"});		
		
		param.put("stdYy", StringUtil.remove(tarket_date,'-'));
		param.put("selectCondType", selectCondType);
		param.put("searchKeyword", searchkeyword);

		// 총 프로그램 갯수
		int totalRowCnt = pgdc0030Mapper.findmiLimitListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 주가정보수집 목록
		List<Map> miLimitList = pgdc0030Mapper.findmiLimitList(param);
	
		ModelAndView mv = new ModelAndView();

		mv.addObject("findmiLimitList", miLimitList);
		mv.addObject("inparam",param);
		mv.addObject("pager", pager);

		mv.setViewName("/admin/dc/PD_UIDCA0031");
		
		return mv;
	}


	public ModelAndView findErrMsg(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		//HashMap jsonMap = new HashMap();
		ModelAndView mv = new ModelAndView();
		String  ErrMsg = null;
		
		String tarket_date = MapUtils.getString(rqstMap, "tarket_date");
		
		if( Validate.isEmpty(tarket_date) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!\"}");
		
		param.put("stdYy", tarket_date);

		// 주가정보수집 목록
		ErrMsg = pgdc0030Mapper.findErrMsg(param);
	

		//jsonMap.put("errMsg", ErrMsg);		
		return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\""+ErrMsg+"\"}");
	}

	public ModelAndView deletemiLimitlist(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		ModelAndView mv = new ModelAndView();
		int StockMgrCnt = 0;
		int StockListCnt = 0;
		
		String tarket_date = MapUtils.getString(rqstMap, "tarket_date");
		
		if( Validate.isEmpty(tarket_date) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		param.put("stdYy", tarket_date);

		// 주가정보수집 목록
		StockMgrCnt = pgdc0030Mapper.deletmiLimitMgr(param);
		StockListCnt = pgdc0030Mapper.deletmiLimitList(param);
	

		jsonMap.put("mgrCnt", StockMgrCnt);		
		jsonMap.put("listCnt", StockListCnt);	// 발급일자
		return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\"정상처리되었습니다.\"}");
	}

	public ModelAndView updateMiLimit(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		Map<String,Object> paramdata = null;
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> resultList = null;
		
		 String[] columNames = 
	     {
				 "순위","기업집단","금융업여부","소속회사명","법인등록번호"
	     };
		 String[] columparam = 
		 {
		          "entRank","kmBnt","fncBiz","entNm","jurirNo"
		 };

		 Date startTime = new Date ( );
		 
		String tarket_date = MapUtils.getString(rqstMap, "tarket_date");
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
		
		if( Validate.isEmpty(tarket_date) || Validate.isEmpty(mptRequest) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");

		List<MultipartFile> multipartFiles = mptRequest.getFiles("file_miLimit");
		if(Validate.isEmpty(multipartFiles)) 
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		if(multipartFiles.get(0).isEmpty()) 
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "milimittemp");
		
		System.out.println(fileList.get(0).getFileByteSize());
		
		if(fileList.size() != 1)
		{
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다!\"}");
		}
		
		resultList = BizUtil.paserExcelFile(columNames,columparam,fileList.get(0).getFile(),3);
		
		param.put("stdYy", StringUtil.remove(tarket_date, '-'));

		// 주가정보수집 목록
		pgdc0030Mapper.deletmiLimitMgr(param);
		pgdc0030Mapper.deletmiLimitList(param);
		
		for( int i = 0; i < resultList.size() ; i++ ) {
			paramdata = resultList.get(i);
			paramdata.put("stdYy", param.get("stdYy"));
			
			paramdata.put("jurirNo", StringUtil.remove((String)paramdata.get("jurirNo"),'-'));
			
			if(paramdata.get("fncBiz").equals("금융") )
			{
				paramdata.put("fncBizYN","Y");
			}
			else
			{
				paramdata.put("fncBizYN","N");
			}
			
			pgdc0030Mapper.intsertLimit((HashMap)paramdata);
		}
		
		 Date endTime = new Date ( );
		 param.put("rowCnt", resultList.size());
		 param.put("startDate", startTime);
		 param.put("endDate", endTime);
		 pgdc0030Mapper.insertmiLimitMgr(param);
		
		// if(true)
		//	 throw new Exception();
		 return ResponseUtil.responseText(mv, "{\"result\":true,\"value\":null,\"message\":\"상호출자제한기업 등록이 정상처리되었습니다.\"}"); 
		//return ResponseUtil.responseJson(mv, true,"상호출자제한기업 등록이 정상처리되었습니다.");
	}
}
