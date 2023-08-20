package biz.tech.dc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.dc.PGDC0060Mapper;

/**
 * 기타 지표 데이터
 * @author DST
 *
 */
@Service("PGDC0060")
public class PGDC0060Service {
	
	private static final Logger logger = LoggerFactory.getLogger(PGDC0060Service.class);
	
	@Resource(name="PGDC0060Mapper")
	PGDC0060Mapper PGDC0060DAO;
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		HashMap pointInfo = new HashMap();
		HashMap indexInfo = new HashMap();
		

		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		int today = PGDC0060DAO.findMaxStdyy();
		
		// 입력 값이 없으면
		if( Validate.isEmpty(tarket_year) )
		{
			// 최근 데이터 년도 입력
			pointInfo.put("stdYy", String.valueOf(today));
			indexInfo.put("stdYy", String.valueOf(today));
		}
		else
		{
			// 입력 받은 값 입력
			pointInfo.put("stdYy", tarket_year);
			indexInfo.put("stdYy", tarket_year);
		}

		ModelAndView mv = new ModelAndView();
		
		List<Map> hpePoint = new ArrayList();
		
		// 기업 지표 정보 가져오기
		for(int i=1; i<22; i++) {
			pointInfo.put("phaseIx", "PI" + i);
			hpePoint.add(PGDC0060DAO.findHpePoint(pointInfo));
		}
		
		mv.addObject("hpePoint",hpePoint);
		indexInfo.put("curr_year", String.valueOf(today));
		mv.addObject("indexInfo",indexInfo);
		mv.setViewName("/admin/dc/BD_UIDCA0060");
		
		return mv;
	}
	
	public ModelAndView insertPoint(Map<?,?> rqstMap) throws Exception {
		
		HashMap pointInfo = new HashMap();
		double smlpzPoint;								//  중소기업 지표
		double ltrsPoint;									// 대기업 지표
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		pointInfo.put("stdYy", tarket_year);
		for(int i = 0; i < 21; i ++) {
			
			// 빈칸 확인
			if (MapUtils.getDouble(rqstMap, "smlpzPoint"+i) != null) {
				smlpzPoint = MapUtils.getDouble(rqstMap, "smlpzPoint"+i);
				pointInfo.put("smlpz", smlpzPoint);
			}
			// 값이 없으면 0 입력
			else {
				smlpzPoint = 0;
				pointInfo.put("smlpz", smlpzPoint);
			}
			// 빈칸 확인
			if (MapUtils.getDouble(rqstMap, "ltrsPoint"+i) != null) {
				ltrsPoint = MapUtils.getDouble(rqstMap, "ltrsPoint"+i);
				pointInfo.put("ltrs", ltrsPoint);
			}
			// 값이 없으면 0 입력
			else {
				ltrsPoint = 0;
				pointInfo.put("ltrs", ltrsPoint);
			}
			pointInfo.put("phaseIx", "PI"+(i+1));
		
			PGDC0060DAO.updateHpePhase(pointInfo);
		}
		ModelAndView mv = new ModelAndView();
		
		mv = index(rqstMap);
		return mv;
		
	}
}
