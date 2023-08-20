package biz.tech.ev;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.file.FileDAO;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;
import com.infra.web.GridCodi;

import biz.tech.mapif.ev.PGEV0100Mapper;
import egovframework.rte.fdl.property.EgovPropertyService;

@Service("PGEV0100")
public class PGEV0100Service {
	private static final Logger logger = LoggerFactory.getLogger(PGEV0100Service.class);

	private Locale locale = Locale.getDefault();

	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "filesDAO")
	private FileDAO fileDao;

	@Autowired
	PGEV0100Mapper PGEV0100Mapper;

	// 초기 실행(목록 조회)
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;
		String initSearchYn = MapUtils.getString(rqstMap, "init_search_yn");

		List<Map> memberList = null;
		if (Validate.isNotEmpty(initSearchYn)) {
			memberList = PGEV0100Mapper.findMember(param);
		}

		mv.addObject("memberList", memberList);
		mv.setViewName("/admin/ev/BD_UIEVA0100");

		return mv;
	}

	// 개별 조회 창 띄우기
	public ModelAndView programEvaluation(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();

		String ad_PK = MapUtils.getString(rqstMap, "ad_PK");
		param.put("ad_PK", ad_PK);

		List<Map> evaList = null;
		if (Validate.isNotEmpty(ad_PK)) {
			evaList = PGEV0100Mapper.findEvaList(param);
		}

		mv.addObject("member", MapUtils.getObject(rqstMap, "member"));
		mv.addObject("evaList", evaList);
		mv.setViewName("/admin/ev/BD_UIEVA0101");
		return mv;
	}

	// 검색

	// 등록
	public ModelAndView insertEVA(Map<?, ?> rqstMap) throws Exception {
		HashMap expinfoTOP = new HashMap();

		String ad_PK = MapUtils.getString(rqstMap, "ad_PK");
		String ad_target_id = MapUtils.getString(rqstMap, "ad_target_id");
		String ad_score = MapUtils.getString(rqstMap, "ad_score");
		String ad_comment = MapUtils.getString(rqstMap, "ad_comment");
		String ad_eva_id = MapUtils.getString(rqstMap, "ad_eva_id");
		String ad_eva_date = MapUtils.getString(rqstMap, "ad_eva_date");

		expinfoTOP.put("ad_PK", ad_PK);
		expinfoTOP.put("ad_target_id", ad_target_id);
		expinfoTOP.put("ad_score", ad_score);
		expinfoTOP.put("ad_comment", ad_comment);
		expinfoTOP.put("ad_eva_id", ad_eva_id);
		expinfoTOP.put("ad_eva_date", ad_eva_date);
		try {
			PGEV0100Mapper.insertEVA(expinfoTOP);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		ModelAndView mv = index(rqstMap);
		return mv;

	}

	// 리얼그리드로 DB 불러오기
	public ModelAndView countSess(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map param = new HashMap<>();
		param = (Map<?, ?>) rqstMap;

		String ad_search_word = MapUtils.getString(rqstMap, "ad_search_word");

		param.put("ad_search_word", ad_search_word);

		logger.debug("========================= ad_search_word : " + ad_search_word);

		List<Map> userList = PGEV0100Mapper.findMember(param);
		String count = GridCodi.MaptoJson(userList);
		logger.debug("============================== userList : " + userList);

		return ResponseUtil.responseText(mv, count);
	}

}
