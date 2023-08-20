package biz.tech.mv;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.infra.util.Converter;
import com.infra.util.ResponseUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import egovframework.board.admin.BoardDao;
import egovframework.board.admin.BoardVO;
import egovframework.board.config.BoardCacheService;
import egovframework.board.config.BoardConfVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 고객지원 > 공지사항
 * 
 * @author KMY
 *
 */
@Service("PGMV0070")
public class PGMV0070Service extends EgovAbstractServiceImpl{
	
	private static final Logger logger = LoggerFactory.getLogger(PGMV0070Service.class);
	
	@Autowired
    private BoardCacheService boardCacheService;
	
	@Autowired
    private BoardDao boardDAO;
	
	/**
	 * 공지사항 리스트화면
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(Map<?,?> rqstMap) throws Exception {
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		BoardVO boardVo = new BoardVO();
		
		String moreList = MapUtils.getString(rqstMap, "ad_moreList");		
				
		Integer bbsCd = 1001;		// 공지사항
		
		boardVo.setBbsCd(bbsCd);
		
		// 공지글 전체 수
		boardVo.setNoticeYn("Y");
		int noticeCnt = boardDAO.boardListCount(boardVo);
		
		boardVo.setNoticeYn("N");
		// 게시글 전체 수
		int dataCnt = boardDAO.boardListCount(boardVo);
		
		param.put("cnt", noticeCnt+dataCnt);
		
		// 첫화면 리스트
		if(Validate.isEmpty(moreList)) {
			// 공지글이 10개 이상일 경우
			if(noticeCnt > 10) {
				boardVo.setLimitFrom(0);
				boardVo.setLimitTo(10);
				
				// 공지글 조회
		        List<BoardVO> noticeList = boardDAO.noticeList(boardVo, "");
		        param.put("noticeFrom", boardVo.getLimitTo());
		        
		        mv.addObject("inparam", param);
		        mv.addObject("noticeList", noticeList);
		        mv.setViewName("/mobile/mv/BD_UIMVU0070");
		        return mv;
		        
			}
			// 공지글이 10개 이하일경우
			else {
				boardVo.setLimitFrom(0);
				boardVo.setLimitTo(noticeCnt);
				
				// 공지글 조회
		        List<BoardVO> noticeList = boardDAO.noticeList(boardVo, "");
		        
		        boardVo.setLimitTo(10-noticeCnt);
		     // 공지글이 아닌 게시글 조회
		        List<BoardVO> boardList = boardDAO.boardList(boardVo, ""); 
		        param.put("boardFrom", boardVo.getLimitTo());
		        mv.addObject("inparam", param);
		        mv.addObject("boardList", boardList);
		        mv.addObject("noticeList", noticeList);
		        mv.setViewName("/mobile/mv/BD_UIMVU0070");
		        return mv;
		        
			}
		}
		else {
			String ad_ajax = MapUtils.getString(rqstMap, "ad_ajax");

			// 더보기 버튼을 눌렀을 때
			if(Validate.isNotEmpty(ad_ajax)) {
				
				// 공지글이 더 있으면
				if(noticeCnt > 10) {
					int limitFrom = MapUtils.getIntValue(rqstMap, "ad_noticeFrom");
					boardVo.setLimitFrom(limitFrom);
					boardVo.setLimitTo(noticeCnt);
					
					// 공지글 조회
			        List<BoardVO> noticeList = boardDAO.noticeList(boardVo, ""); 
			        
			        boardVo.setLimitFrom(0);
			        boardVo.setLimitTo(dataCnt);
			        
			        // 공지글이 아닌 게시글 조회
			        List<BoardVO> boardList = boardDAO.boardList(boardVo, "");
			        
			        ArrayList<List<BoardVO>> list = new ArrayList<List<BoardVO>>();
			        
			        list.add(noticeList);
			        list.add(boardList);
			        
			        return ResponseUtil.responseJson(mv,true, list);
				}
				else {
					// 공지글이 없으면
					int boardFrom = MapUtils.getIntValue(rqstMap, "ad_boardFrom");
					boardVo.setLimitFrom(boardFrom);
			        boardVo.setLimitTo(dataCnt);
			        
			        // 공지글이 아닌 게시글 조회
			        List<BoardVO> boardList = boardDAO.boardList(boardVo, "");   
			        return ResponseUtil.responseJson(mv,true, boardList);
				}
			}
		}
        
		mv.setViewName("/mobile/mv/BD_UIMVU0070");
		return mv;
	}
	
	
	/**
	 * 공지사항 상세조회
	 * @param rqstMap
	 * @return
	 * @throws Exception
	 */
	public ModelAndView noticeForm(Map<?,?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		BoardVO boardVo = new BoardVO();
		
		Integer bbsCd = 1001;		// 공지사항
		BoardConfVO boardConfVO = boardCacheService.findBoardConfig(bbsCd);
		
		String seq = MapUtils.getString(rqstMap, "ad_listSeq");
		System.out.println(seq);
		
		boardVo.setBbsCd(bbsCd);
		boardVo.setSeq(seq);
		
		// 공지글 조회
        BoardVO noticeList = boardDAO.boardView(boardVo, boardConfVO);
        
        // 에디터사용이 N일 때 \n이 있으면 <br/> 태그로 전환
        if("N".equals(boardConfVO.getMgrEditorYn())) {
        	noticeList.setContents(Converter.translateBR(noticeList.getContents()));
        }

        mv.addObject("noticeList", noticeList);
		mv.setViewName("/mobile/mv/BD_UIMVU0071");
		return mv;
		
	}
}