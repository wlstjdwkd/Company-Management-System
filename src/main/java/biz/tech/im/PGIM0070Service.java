package biz.tech.im;

import java.util.ArrayList;
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
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import biz.tech.mapif.im.PGIM0070Mapper;

@Service("PGIM0070")
public class PGIM0070Service extends EgovAbstractServiceImpl{
	
	@Resource(name = "PGIM0070Mapper")
	private PGIM0070Mapper pgim0070Mapper;
	
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception {
		
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		
		// 기업직간접소유현황정보수집관리 목록
		@SuppressWarnings("rawtypes")
		List<Map> stockMgrList = pgim0070Mapper.findrelPossessionMgrList(param);
			
		ModelAndView mv = new ModelAndView();

		mv.addObject("relPossessionMgrList", stockMgrList);
		
		mv.setViewName("/admin/im/BD_UIIMA0070");
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	public ModelAndView findrelPossessionList(Map<?, ?> rqstMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String tarket_year = "2021";
		String selectCondType = MapUtils.getString(rqstMap, "selectCondType","all");
		String searchkeyword = MapUtils.getString(rqstMap, "searchKeyword");
		
		if( Validate.isEmpty(tarket_year) )
			throw processException("errors.required", new String[] {"발표일자"});
		
		param.put("stdYy", tarket_year);
		param.put("selectCondType", selectCondType);
		param.put("searchKeyword", searchkeyword);

		// 총 프로그램 갯수
		int totalRowCnt = pgim0070Mapper.findrelPossessionListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 기업직간접소유현황정보수집 목록
		@SuppressWarnings("rawtypes")
		List<Map> miLimitList = pgim0070Mapper.findrelPossessionList(param);
		
		@SuppressWarnings("rawtypes")
		Map numMap = new HashMap();
		String num = null;
		
		for(int i=0; i<miLimitList.size(); i++) {
			// 사업자번호
			numMap = StringUtil.toBizrnoFormat((String) miLimitList.get(i).get("bizrNo"));
			num = numMap.get("first") + "-" + numMap.get("middle") + "-" + numMap.get("last");
			miLimitList.get(i).put("bizrNo", num);
			// 법인등록번호
			numMap = StringUtil.toJurirnoFormat((String) miLimitList.get(i).get("jurirNo"));
			num = numMap.get("first") + "-" + numMap.get("last") ;
			miLimitList.get(i).put("jurirNo", num);
			// 직접_법인번호
			if(Validate.isNull(miLimitList.get(i).get("drposjurirNo"))) {
				num="";
			} else {
				numMap = StringUtil.toJurirnoFormat((String) miLimitList.get(i).get("drposjurirNo"));
				if(Validate.isNull(numMap.get("first"))) {
					num = "";
				} else {
					num = numMap.get("first") + "-" + numMap.get("last") ;
				}
				miLimitList.get(i).put("drposjurirNo", num);
			}
			// 간접_법인번호1
			if(Validate.isNull(miLimitList.get(i).get("ndrposjurirNo1"))) {
				num="";
			} else {
				numMap = StringUtil.toJurirnoFormat((String) miLimitList.get(i).get("ndrposjurirNo1"));
				if(Validate.isNull(numMap.get("first"))) {
					num = "";
				} else {
					num = numMap.get("first") + "-" + numMap.get("last") ;
				}
				miLimitList.get(i).put("ndrposjurirNo1", num);
			}
			// 간접_법인번호2
			if(Validate.isNull(miLimitList.get(i).get("ndrposjurirNo2"))) {
				num="";
			} else {
				numMap = StringUtil.toJurirnoFormat((String) miLimitList.get(i).get("ndrposjurirNo2"));
				if(Validate.isNull(numMap.get("first"))) {
					num = "";
				} else {
					num = numMap.get("first") + "-" + numMap.get("last") ;
				}
				miLimitList.get(i).put("ndrposjurirNo2", num);
			}
		}
		
		mv.addObject("findrelPossessionList", miLimitList);
		mv.addObject("inparam",param);
		mv.addObject("pager", pager);

		mv.setViewName("/admin/im/PD_UIIMA0070");
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	public ModelAndView findErrMsg(Map<?, ?> rqstMap) throws Exception {
		
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		String  ErrMsg = null;
		
		String tarket_year = "2021";
		
		if( Validate.isEmpty(tarket_year) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!\"}");
		
		param.put("stdYy", tarket_year);

		// 기업직간접소유현황정보수집 목록
		ErrMsg = pgim0070Mapper.findErrMsg(param);
		
		return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\""+ErrMsg+"\"}");
	}

	@SuppressWarnings("unchecked")
	public ModelAndView deleterelPossessionlist(Map<?, ?> rqstMap) throws Exception {
		
		@SuppressWarnings("rawtypes")
		HashMap param = new HashMap();
		@SuppressWarnings("rawtypes")
		HashMap jsonMap = new HashMap();
		ModelAndView mv = new ModelAndView();
		int StockMgrCnt = 0;
		int StockListCnt = 0;
		
		String tarket_year = "2021";
		
		if( Validate.isEmpty(tarket_year) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
			
		param.put("stdYy", tarket_year);

		// 기업직간접소유현황정보수집 목록
		StockListCnt = pgim0070Mapper.deletrelPossessionList(param);
		StockMgrCnt = pgim0070Mapper.deletrelPossessionMgr(param);
	

		jsonMap.put("listCnt", StockListCnt);
		jsonMap.put("mgrCnt", StockMgrCnt); // 발급일자
		return ResponseUtil.responseText(mv, "{\"result\":true,\"value\":null,\"message\":\"정상처리되었습니다.\"}");
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ModelAndView updaterelPossession(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		Map<String,Object> paramdata = null;
		ModelAndView mv = new ModelAndView();
		List<Map<String,Object>> resultList = null;
		
		String[] columNames = 
			{
				"기준년도","법인번호","사업자번호","업체명","비고","직접소유법인번호","직접소유 기업명","직접소유지분율","직접소유비고",
				"간접소유법인번호1","간접소유 기업명1","간접소유지분율1","간접소유비고1",
				"간접소유 법인번호2","간접소유 기업명2","간접소유지분율2","간접소유비고2"
		};
		
		String[] columparam = 
			{
				"stdYy","jurirNo","bizrNo","entrprsNm","Rm","drposjurirNo","drposentrprsNm","drposqotaRt","drposRm",
				"ndrposjurirNo1","ndrposentrprsNm1","ndrposqotaRt1","ndrposRm1",
				"ndrposjurirNo2","ndrposentrprsNm2","ndrposqotaRt2","ndrposRm2"
		};
		
		Date startTime = new Date ( );
		
		String tarket_year = "2021";
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest)rqstMap.get(GlobalConst.RQST_MULTIPART);
		
		if( Validate.isEmpty(tarket_year) || Validate.isEmpty(mptRequest) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file_relPossession");
		
		if(Validate.isEmpty(multipartFiles))
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		if(multipartFiles.get(0).isEmpty())
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		
		fileList = UploadHelper.upload(multipartFiles, "relpossessiontemp");
		
		System.out.println(fileList.get(0).getFileByteSize());
		
		if(fileList.size() != 1)
			 return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다!\"}");
		
		resultList = BizUtil.paserExcelFile(columNames,columparam,fileList.get(0).getFile(),0);
		
		param.put("stdYy", tarket_year);
		
		// 기업직간접소유현황정보수집 목록
		pgim0070Mapper.deletrelPossessionMgr(param);
		pgim0070Mapper.deletrelPossessionList(param);
		
		Date endTime = new Date ( );
		
		param.put("rowCnt", resultList.size());
		param.put("startDate", startTime);
		param.put("endDate", endTime);
		pgim0070Mapper.insertrelPossessionMgr(param);
		
		for( int i = 0; i < resultList.size() ; i++ ) {
			paramdata = resultList.get(i);
			pgim0070Mapper.intsertrelPossession((HashMap)paramdata);
		}
		
		return ResponseUtil.responseText(mv, "{\"result\":true,\"value\":null,\"message\":\"기업직간접소유현황 등록이 정상처리되었습니다.\"}");
	}
}