package biz.tech.ps;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.BizUtilTest;
import com.infra.util.FileUtil;
import com.infra.util.JsonUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import biz.tech.mapif.ps.PGPS0080Mapper;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("PGPS0080")
public class PGPS0080Service extends EgovAbstractServiceImpl {
	private static final Logger logger = LoggerFactory.getLogger(PGPS0080Service.class);

	@Resource(name="messageSource")
	private MessageSource messageSource;
	
	@Resource(name="PGPS0080Mapper")
	private PGPS0080Mapper pgps0080Mapper;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year", "");
		
		if(!Validate.isEmpty(tarket_year)) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("tarket_year", tarket_year);
			List<Map> result = pgps0080Mapper.List(param);
			mv.addObject("resultList", result);
			mv.addObject("Key", tarket_year);
		}

		HashMap param = new HashMap();
		Calendar today = Calendar.getInstance();
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		mv.addObject("inparam",param);
		
		mv.setViewName("/admin/ps/BD_UIPSA0080");
		return mv;
	}
	
	
	/**
	 *  업로드되는 파을을 검증한다.
	 *  
	 *  1. 입력파라미터를 검증한다.
	 *  2. 업로드 파일에 대한 검증을 수행한다.
	 *  3. 업로드 데이터를 검증한다.
	 */
	public ModelAndView updaterelPossession(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> paramdata = null;
		String selectstdYy = MapUtils.getString(rqstMap, "selectstdYy");	// 기준년도
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		MultipartHttpServletRequest mptRequest = (MultipartHttpServletRequest) rqstMap.get(GlobalConst.RQST_MULTIPART);
		
		// 입력 파라미터를 검증한다. 
		// 기준년도 검증
		if(Validate.isEmpty(selectstdYy))
			return ResponseUtil.responseText(mv,"{\"result\":false,\"value\":null,\"message\":\"기준년도를 선택해주세요.\"}" );
		
		// 파일업로드 검증
		if(Validate.isEmpty(mptRequest))
			return ResponseUtil.responseText(mv,"{\"result\":false,\"value\":null,\"message\":\"파일을 업로드 해주세요.\"}");
		
		List<MultipartFile> multipartFiles = mptRequest.getFiles("file_relPossession");		
		
		if (Validate.isEmpty(multipartFiles))
			return ResponseUtil.responseText(mv,"{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		if (multipartFiles.get(0).isEmpty())
			return ResponseUtil.responseText(mv,"{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		// 파일 확장자명 검증 ( xls, xlsx, csv )
		for(int i=0; i<multipartFiles.size(); i++ ){
			String filename = multipartFiles.get(i).getOriginalFilename();
			String fileext = FileUtil.getExtension(filename);
			
			if(fileext == null || (!fileext.equals("xls") && !fileext.equals("csv") &&  !fileext.equals("xlsx"))){
				return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"파일 확장자명을 확인 해 주세요!.\"}");
			}
		}
		
		List<FileVO> fileList = new ArrayList<FileVO>();
		fileList = UploadHelper.upload(multipartFiles, "relpossessiontemp");
		
		if(fileList.size() != 1){
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"Upload 파일에 에러가 있습니다.\"}");
		}
			
		param.put("stdYy", selectstdYy);
		param.put("FDelimiter", "comma"); // 인뱅에서는 화면에서 선택, csv 구분자
		param.put("FEncoding", "UTF-8"); // 인뱅에서는 화면에서 선택, csv 인코딩

		String[] columparam = { "stdYy", "jurirNo", "bizrNo", "entrprsNm",
				"Rm", "drposjurirNo", "drposentrprsNm", "drposqotaRt",
				"drposRm", "ndrposjurirNo1", "ndrposentrprsNm1",
				"ndrposqotaRt1", "ndrposRm1" };

		// 업로드 데이터 검증
		Map<String,Object> map1 = BizUtilTest.checkFile(param, columparam, fileList);
		List<Map<String, Object>> errorList = (List<Map<String, Object>>) map1.get("errorList");
		List<Map<String, Object>> resultList = (List<Map<String, Object>>) map1.get("resultList");
		
		/*
		 * 타입을 체크해서 하나라도 하나라도 다르면 return
		 *  errorList가 null이 아닐 때
		 * */
		if(errorList != null && errorList.size() > 0){
			 String	name = errorList.get(0).get("name").toString();
			
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\""+name+ "의 타입을 확인 해 주세요!\"}");
		}
		
		/* 
		 * 임시 테이블에 저장
		 */
		Date startTime = new Date();
		
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("stdYy", selectstdYy);

		// 기업직간접소유현황정보수집 목록
		pgps0080Mapper.deletrelPossessionList(params);
		pgps0080Mapper.deletrelPossessionMgr(params);

		Date endTime = new Date();
		params.put("rowCnt", resultList.size());
		params.put("startDate", startTime);
		params.put("endDate", endTime);
		pgps0080Mapper.insertrelPossessionMgr(param);

		for (int i = 0; i < resultList.size(); i++) {
			paramdata = resultList.get(i);
			pgps0080Mapper.intsertrelPossession((HashMap) paramdata);
		}

		String message = "엑셀 등록이 정상처리되었습니다.";
		Map<String, Object> returnObj = new HashMap<String, Object>();
		returnObj.put("message", message);
		returnObj.put("result", true);
		returnObj.put("value", null);
		returnObj.put("Key", "2021");	
		
		return ResponseUtil.responseText(mv, JsonUtil.toJson(returnObj));
	}
	

	/**
	 * 업로드 파일 정보 최종 저장 
	 */
	public ModelAndView updateData(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		String[] stdYy = (String[]) rqstMap.get("stdYy");
		String[] jurirNo = (String[]) rqstMap.get("jurirNo");
		String[] bizrNo = (String[]) rqstMap.get("bizrNo");
		String[] entrprsNm = (String[]) rqstMap.get("entrprsNm");
		String[] drposjurirNo = (String[]) rqstMap.get("drposjurirNo");
		String[] drposentrprsNm = (String[]) rqstMap.get("drposentrprsNm");
		String[] drposqotaRt = (String[]) rqstMap.get("drposqotaRt");
		String[] ndrposjurirNo1 = (String[]) rqstMap.get("ndrposjurirNo1");
		String[] ndrposentrprsNm1 = (String[]) rqstMap.get("ndrposentrprsNm1");
		String[] ndrposqotaRt1 = (String[]) rqstMap.get("ndrposqotaRt1");
		String selectstdYy = MapUtils.getString(rqstMap, "selectstdYy");	//기준년도
		
		param.put("stdYy", selectstdYy);	//기준년도 

		/*
		 * 실제 테이블로 insert 
		 */
		
		// 기업직간접소유현황정보수집 목록
		pgps0080Mapper.deletrelPossessionList(param);
		pgps0080Mapper.deletrelPossessionMgr(param);

		Date startTime = new Date();
		Date endTime = new Date();
		param.put("rowCnt", stdYy.length); 	
		param.put("startDate", startTime);
		param.put("endDate", endTime);
		pgps0080Mapper.insertrelPossessionMgr(param);
		
		for(int i=0; i<stdYy.length; i++){ // 필수 입력 컬럼으로
			HashMap<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("stdYy", stdYy[i]);
			dataMap.put("jurirNo", jurirNo[i]);
			dataMap.put("bizrNo", bizrNo[i]);
			dataMap.put("entrprsNm", entrprsNm[i]);
			dataMap.put("drposjurirNo", drposjurirNo[i]);
			dataMap.put("drposentrprsNm", drposentrprsNm[i]);
			dataMap.put("drposqotaRt", drposqotaRt[i].equals("") ? null : drposqotaRt[i]);
			dataMap.put("ndrposjurirNo1", ndrposjurirNo1[i]);
			dataMap.put("ndrposentrprsNm1", ndrposentrprsNm1[i]);
			dataMap.put("ndrposqotaRt1", ndrposqotaRt1[i].equals("") ? null : ndrposqotaRt1[i]);

			pgps0080Mapper.intsertrelPossession(dataMap);
		};
		
		HashMap inparam = new HashMap();
		Calendar today = Calendar.getInstance();
		inparam.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		mv.addObject("inparam",inparam);
		
		mv.setViewName("/admin/ps/BD_UIPSA0080");

		return mv;
	}
}
