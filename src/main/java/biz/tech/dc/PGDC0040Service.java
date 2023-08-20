package biz.tech.dc;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.page.Pager;
import com.comm.user.UserVO;
import com.infra.system.GlobalConst;
import com.infra.util.DateUtil;
import com.infra.util.ResponseUtil;
import com.infra.util.SessionUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.dc.PGDC0040Mapper;
import egovframework.com.sym.bat.service.BatchOpert;
import egovframework.com.sym.bat.service.BatchSchdul;
import egovframework.com.sym.bat.service.BatchScheduler;
import egovframework.com.sym.bat.service.EgovBatchOpertService;

/**
 * 주가정보수집관리
 * @author DST
 *
 */
@Service("PGDC0040")
public class PGDC0040Service {

	private static final Logger logger = LoggerFactory.getLogger(PGDC0040Service.class);
	
	@Resource(name = "PGDC0040Mapper")
	private PGDC0040Mapper pgdc0040Mapper;
	
	/** egovBatchOpertService */
	@Resource(name = "egovBatchOpertService")
	private EgovBatchOpertService egovBatchOpertService;
	
	/** 배치스케줄러 서비스 */
	@Resource(name = "batchScheduler")
	private BatchScheduler batchScheduler;
	
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		Calendar today = Calendar.getInstance();
		
		String from_year = MapUtils.getString(rqstMap, "from_year");
		String to_year = MapUtils.getString(rqstMap, "to_year");
		
		if( Validate.isEmpty(from_year) )
		{
			param.put("fromstdYy", String.valueOf(today.get(Calendar.YEAR)-1));
			param.put("tostdYy", String.valueOf(today.get(Calendar.YEAR)));
		}
		else
		{
			param.put("fromstdYy", from_year);
			param.put("tostdYy", to_year);
		}

		// 주가정보수집 목록
		List<Map> fxerMgrList = pgdc0040Mapper.findfxerMgrList(param);
	
		ModelAndView mv = new ModelAndView();

		mv.addObject("fxerMgrList", fxerMgrList);
		
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		param.put("before_year", String.valueOf(today.get(Calendar.YEAR)-1));
		mv.addObject("inparam",param);

		mv.setViewName("/admin/dc/BD_UIDCA0040");
		
		return mv;
	}

	public ModelAndView findfxerList(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		Calendar today = Calendar.getInstance();
		
		int pageNo = MapUtils.getIntValue(rqstMap, "df_curr_page");
		int rowSize = MapUtils.getIntValue(rqstMap, "df_row_per_page");
		
		String from_year = MapUtils.getString(rqstMap, "from_year");
		String to_year = MapUtils.getString(rqstMap, "to_year");
		String crncyCd = MapUtils.getString(rqstMap, "crncycd");

		
		if( Validate.isEmpty(from_year) )
		{
			param.put("fromstdYy", String.valueOf(today.get(Calendar.YEAR)));
			param.put("tostdYy", String.valueOf(today.get(Calendar.YEAR)));
		}
		else
		{
			param.put("fromstdYy", from_year);
			param.put("tostdYy", to_year);
		}
		
		if( Validate.isEmpty(crncyCd) )
		{
			param.put("crncyCd", "all");
		}
		else
		{
			param.put("crncyCd", crncyCd);
		}
		
		// 총 프로그램 갯수
		int totalRowCnt = pgdc0040Mapper.findfxerListCnt(param);

		// 페이저 빌드
		Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).rowSize(rowSize).build();
		pager.makePaging();
		param.put("limitFrom", pager.getLimitFrom());
		param.put("limitTo", pager.getLimitTo());

		// 주가정보수집 목록
		List<Map> fxerList = pgdc0040Mapper.findfxerList(param);
		List<Map> findfxercrncyCdList = pgdc0040Mapper.findfxercrncyCdList();
	
		ModelAndView mv = new ModelAndView();

		mv.addObject("findfxerList", fxerList);
		mv.addObject("findfxercrncyCdList",findfxercrncyCdList);
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		mv.addObject("inparam",param);
		mv.addObject("pager", pager);

		mv.setViewName("/admin/dc/PD_UIDCA0041");
		
		return mv;
	}


	public ModelAndView findErrMsg(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		ModelAndView mv = new ModelAndView();
		String  ErrMsg = null;
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		String tarket_month = MapUtils.getString(rqstMap, "tarket_month");
		
		if( Validate.isEmpty(tarket_year) || Validate.isEmpty(tarket_month) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!\"}");
		
		param.put("stdYy", tarket_year);
		param.put("stdMt",  StringUtil.removeStart( tarket_month, "0"));

		// 주가정보수집 목록
		ErrMsg = pgdc0040Mapper.findErrMsg(param);
	

		//jsonMap.put("errMsg", ErrMsg);		
		return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\""+ErrMsg+"\"}");
	}

	public ModelAndView deletefxerlist(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		HashMap jsonMap = new HashMap();
		ModelAndView mv = new ModelAndView();
		int StockMgrCnt = 0;
		int StockListCnt = 0;
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		if( Validate.isEmpty(tarket_year) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		param.put("stdYy", tarket_year);

		// 주가정보수집 목록
		StockMgrCnt = pgdc0040Mapper.deletfxerMgr(param);
		StockListCnt = pgdc0040Mapper.deletfxerList(param);
	

		jsonMap.put("mgrCnt", StockMgrCnt);		
		jsonMap.put("listCnt", StockListCnt);	// 발급일자
		return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\"정상처리되었습니다.\"}");
	}

	public ModelAndView updatefxer(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		
		//로그인 객체 선언
    	UserVO userVo = SessionUtil.getUserInfo();
    	
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		if( Validate.isEmpty(tarket_year) )
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"필수입력 정보가 부족합니다!.\"}");
		
		param.put("stdYy", tarket_year);
		param.put("batchNm",GlobalConst.FXER_BATCH_JOB_NAME);
		param.put("param", tarket_year);

		// 주가정보수집 목록
		pgdc0040Mapper.deletfxerMgr(param);
		pgdc0040Mapper.deletfxerList(param);
		
		Map batch_info = pgdc0040Mapper.findBatchJobbyBatchNm(param);
		
		if(Validate.isEmpty(batch_info))
		{
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"배치작업 등록 정보가 없습니다!\"}");
			//return ResponseUtil.responseJson(mv, false, "배치작업 등록 정보가 없습니다!");
		}
		
		BatchOpert batchOpert = new BatchOpert();
		batchOpert.setBatchOpertId((String)batch_info.get("batchOpertId"));
		batchOpert.setBatchOpertNm((String)batch_info.get("batchOpertNm"));
		batchOpert.setBatchProgrm((String)batch_info.get("batchProgrm"));
		batchOpert.setParamtr((String)param.get("param"));
		batchOpert.setUpdusr(userVo.getUserNo());
		egovBatchOpertService.updateBatchOpert(batchOpert);
		
		logger.debug("배치 수동 실행");
		
		Date now = Calendar.getInstance().getTime();
		
		BatchSchdul batchSchdul = new BatchSchdul();
		batchSchdul.setBatchOpertId(batchOpert.getBatchOpertId());
		batchSchdul.setBatchSchdulId("MANUAL_ONCE");
		batchSchdul.setExecutSchdulDe(DateUtil.getDate(now));
		
		batchSchdul.setBatchProgrm(batchOpert.getBatchProgrm());
		batchSchdul.setParamtr(batchOpert.getParamtr());
		
		//아이디 설정
		batchSchdul.setUpdusr(userVo.getUserNo());
		batchSchdul.setRegister(userVo.getUserNo());

		try {
		// 배치스케줄러에 스케줄정보반영
			batchScheduler.insertBatchSchdul(batchSchdul);
		}catch (Exception e)
		{
			return ResponseUtil.responseText(mv, "{\"result\":false,\"value\":null,\"message\":\"배치작업 등록을 실패했습니다!\"}");
		}

		return ResponseUtil.responseText(mv, "{\"result\":true,\"value\":null,\"message\":\"배치처리가 정상적으로 수행되었습니다.\"}");
		//return ResponseUtil.responseJson(mv, true,"배치처리가 정상적으로 수행되었습니다.");
	}
	
}
