package biz.tech.ps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.comm.code.CodeService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.ic.HpeCnfirmReqstMapper;
import biz.tech.mapif.ps.PGPS0090Mapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;


/**
 * Create Test Service
 * @author Tkim
 *
 */
@Service("PGPS0090")
public class PGPS0090Service extends EgovAbstractServiceImpl {
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(PGPS0090Service.class);
	
	@Autowired
	CodeService codeService;
	
	@Resource(name="PGPS0090Mapper")
	private PGPS0090Mapper pgps0090Dao;
	
	@Resource(name="egovQustnrManageIdGnrService")
	private EgovIdGnrService idgenService;
	
	@Autowired
	HpeCnfirmReqstMapper hpeCnfirmReqstMapper;
	
	/**
	 * 기본 값 (테스트 탭 1)
	 * @param rqstMap request parameters
	 * @return ModelAndView
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView index(Map rqstMap) throws Exception {
		List<Map> listQustnrTmplat = new ArrayList(); 
		List sqlMessage = new ArrayList();
		listQustnrTmplat = pgps0090Dao.selectQustnrTmplatManage();
		sqlMessage.add("SELECT "
						+ "QUSTNR_TMPLAT_ID "	
						+ ",QUSTNR_TMPLAT_TY "	
						+ "FROM	comtnqustnrtmplat "
						+ "라디오 값을 가지고오는 쿼리 (foreign key)");
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0090");
		mv.addObject("listQustnrTmplat", listQustnrTmplat);
		mv.addObject("sqlMessage", sqlMessage);
		return mv;
	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ModelAndView insertData(Map rqstMap) throws Exception {
		HashMap param = new HashMap();		
		param = (HashMap) rqstMap;
		List javaMessage = new ArrayList();
		List sqlMessage = new ArrayList();
		ModelAndView mv = new ModelAndView("/admin/ps/BD_UIPSA0090");
		String idMaker = idgenService.getNextStringId();
		param.put("qestnrId", idMaker);
		List<Map> listQustnrTmplat = new ArrayList(); 
		listQustnrTmplat = pgps0090Dao.selectQustnrTmplatManage();
		mv.addObject("listQustnrTmplat", listQustnrTmplat);
		pgps0090Dao.insertUserInfo(param);
		/*int inserter = pgps0090Dao.insertUserInfo(param);
		String notice = "";
		if(inserter == 1){
			notice = "등록 성공했습니다";
		}*/
		javaMessage.add("String idMaker = idgenService.getNextStringId();	-다음 아이디 값을 얻는 기능");
		sqlMessage.add("QESTNR_ID ,QUSTNR_TMPLAT_ID ,QUSTNR_SJ ,QUSTNR_PURPS ,QUSTNR_WRITNG_GUIDANCE_CN ,QUSTNR_TRGET,RGSDE,UPDDE) "
				+ "VALUES (#{qestnr_id},#{qustnr_tmplat_id},#{qustnr_sj},#{qustnr_purps},#{qustnr_writing_guidance_cn},#{qustnr_trget},CURRENT_TIMESTAMP,CURRENT_TIMESTAMP); "
				+ "- Insert 쿼리");
		mv.addObject("javaMessage", javaMessage);
		mv.addObject("sqlMessage", sqlMessage);
		//	mv.addObject("resultMsg", notice);
		
		return mv;
	}
	
	

    
    
}
