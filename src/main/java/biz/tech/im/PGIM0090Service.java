package biz.tech.im;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import com.infra.util.JsonUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;
import biz.tech.mapif.ps.PGPS0020Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 확인서발급현황 > 신청기준집계
 */

@Service("PGIM0090")
public class PGIM0090Service extends EgovAbstractServiceImpl{
	
	@Resource(name = "PGPS0020Mapper")
	private PGPS0020Mapper pgps0020Dao;
	
	/**
	 * 지역 코드
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map<? , ?> rqstMap) throws Exception 
	{
		
		ModelAndView mv = new ModelAndView();
		HashMap<Object, Object> param = new HashMap<Object, Object>();
		List areaCity = new ArrayList();
		List areaSelect = new ArrayList();
		List javaMessage = new ArrayList();
		List sqlMessage = new ArrayList();
		
		areaCity = pgps0020Dao.findCodesCity(param);
		areaSelect = pgps0020Dao.findAreaSelect(param);
		
		javaMessage.add("areaCity = pgps0020Dao.findCodesCity(param); -> // 지역코드 조회(시도별)");
		javaMessage.add("areaSelect = pgps0020Dao.findAreaSelect(param); -> //지역(본사기준) - 구/군 ");
		
		// 지역코드 조회(시도별) 쿼리
		sqlMessage.add("SELECT 	/* ProgramID=com.comm.mapif.CodeMapper.findCodesCity */ "
				+ " AREA_CODE"
				+ " , UPPER_CODE"
				+ " , `DIV`"
				+ " , AREA_NM"
				+ " , ABRV" 
				+ " ,from TB_AREA_DIV"
				+ " ,where `DIV` = 2"
				+ " ,and AREA_CODE != 'D99'");
		
		// 지역(본사기준) - 구/군 쿼리
		sqlMessage.add("select /* ProgramID=biz.tech.mapif.ps.PGPS0020Mapper.findAreaSelect */ "
				+ " AREA_CODE"
				+ " , UPPER_CODE "
				+ " , `DIV`"
				+ " , AREA_NM"
				+ " , ABRV"
				+ " from TB_AREA_DIV"
				+ " where `DIV` = 3");

		
		mv.addObject("areaCity", areaCity);
		mv.addObject("areaSelect", JsonUtil.toJson(areaSelect));
		mv.addObject("javaMessage", javaMessage);
		mv.addObject("sqlMessage", sqlMessage);
		mv.setViewName("/admin/im/BD_UIIMA0090");
		
		return mv;
	}
	
	
}