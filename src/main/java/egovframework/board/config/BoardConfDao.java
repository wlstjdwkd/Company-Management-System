package egovframework.board.config;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.infra.system.XMLConfig;
import com.infra.util.DateFormatUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.springframework.stereotype.Repository;

import egovframework.board.config.BoardConfVO;
import egovframework.board.temp.BoardTempVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("boardConfDao")
public class BoardConfDao extends EgovAbstractMapper  {
	
	/**
     * 게시판 목록 조회
     */
    @SuppressWarnings("unchecked")
    public List<BoardConfVO> boardConfList(BoardConfVO boardConfVO) {
        /*if(boardConfVO.getSuperAdmYn() != null && !"".equals(boardConfVO.getSuperAdmYn())){
            boardConfVO.getDataMap().put("superAdmYn", boardConfVO.getSuperAdmYn());
        }
        if(boardConfVO.getPpAdmYn() != null && !"".equals(boardConfVO.getPpAdmYn())){
            boardConfVO.getDataMap().put("ppAdmYn", boardConfVO.getPpAdmYn());
        }
        List<BoardConfVO> dataList = list("_boardconf.boardConfList", boardConfVO.getDataMap());
        boardConfVO.setTotalNum((Integer) selectByPk("_boardconf.boardConfListCount", boardConfVO.getDataMap()));*/
    	
    	List<BoardConfVO> dataList = selectList("_boardconf.boardConfList", boardConfVO);

        return dataList;
    }
    
    public int boardConfListCount(BoardConfVO boardConfVO) {
    	return ((Integer) (selectOne("_boardconf.boardConfListCount", boardConfVO))).intValue();
    }
    
    /**
     * 게시판 템플릿 목록
     */
    public List<BoardTempVO> boardTemplateList(String type){
        @SuppressWarnings("unchecked")
        List<BoardTempVO> tempList = selectList("_boardconf.boardTemplateList", type);

        return tempList;
    }
    
    /**
     * 게시판 등록 액션
     */
    public Object insertAction(BoardConfVO boardConfVO) {

        insert("_boardconf.boardConfInsert", boardConfVO);
        Integer primaryKey = boardConfVO.getBbsCd();

        if(primaryKey != null) {
            boardConfVO.setBbsCd(primaryKey);

            update("_boardconf.boardConfGlobalInsert", boardConfVO);
            update("_boardconf.boardConfListInsert", boardConfVO);
            update("_boardconf.boardConfViewInsert", boardConfVO);
            update("_boardconf.boardConfFormInsert", boardConfVO);
            //update("_boardconf.boardConfAuthInsert", boardConfVO);

            Iterator<?> it = XMLConfig.getKeys("board.defaultColumn");

            String key = "";
            BoardExtensionVO bExtVO;

            while(it.hasNext()) {
                bExtVO = new BoardExtensionVO();

                key = String.valueOf(it.next());
                key = key.replaceAll("board.defaultColumn", "board.defaultConfig");

                bExtVO.setBbsCd(primaryKey);
                bExtVO.setColumnId(XMLConfig.getString(key + "[@columnId]"));
                bExtVO.setColumnNm(XMLConfig.getString(key + "[@columnNm]"));
                bExtVO.setColumnType(XMLConfig.getString(key + "[@columnType]"));
                bExtVO.setColumnComment(XMLConfig.getString(key + "[@columnComment]"));
                bExtVO.setSearchYn(XMLConfig.getString(key + "[@searchYn]"));
                bExtVO.setSearchType(XMLConfig.getString(key + "[@searchType]"));
                bExtVO.setRequireYn(XMLConfig.getString(key + "[@requireYn]"));
                bExtVO.setUseYn(XMLConfig.getString(key + "[@useYn]"));

                insert("_boardconf.boardConfExtensionInsert", bExtVO);
            }

            if("Y".equals(boardConfVO.getCtgYn())) {
                insertBbsCtgAction(boardConfVO);
            }

            // 기본 배치 항목 등록
            String[][] lists = BoardConfConstant.LIST_ARRANGE_LIST;
            int orderNo = 0;
            for(int i = 0 ; i < lists.length ; i++) {
                BoardArrangeVO vo = new BoardArrangeVO();
                vo.setBbsCd(primaryKey);
                vo.setListViewGubun("list");
                vo.setColumnId(lists[i][0]);
                vo.setColumnNm(lists[i][1]);
                vo.setOrderNo(++orderNo);
                vo.setBeanNm(StringUtil.camelCase(lists[i][0]));
                insert("_boardconf.boardConfArrangeInsert", vo);
            }
            String[][] views = BoardConfConstant.VIEW_ARRANGE_LIST;
            orderNo = 0;
            for(int i = 0 ; i < views.length ; i++) {
                BoardArrangeVO vo = new BoardArrangeVO();
                vo.setBbsCd(primaryKey);
                vo.setListViewGubun("view");
                vo.setColumnId(views[i][0]);
                vo.setColumnNm(views[i][1]);
                vo.setOrderNo(++orderNo);
                vo.setBeanNm(StringUtil.camelCase(views[i][0]));
                insert("_boardconf.boardConfArrangeInsert", vo);
            }

            // 게시판 캐쉬를 리로드 합니다.
            //reloadBbsCache();
        }

        return primaryKey;
    }
    
    /**
     * 게시판 카테고리 등록
     */
    private void insertBbsCtgAction(BoardConfVO boardConfVO) {
        String[] ctgNms = boardConfVO.getCtgNms()[0].split(",");

        if(Validate.isNotEmpty(ctgNms) && (ctgNms[0].length() != 0)) {
            BoardCtgVO boardCtgVO = new BoardCtgVO();
            boardCtgVO.setBbsCd(boardConfVO.getBbsCd());
            if("Y".equals(boardConfVO.getCtgYn())) {
                delete("_boardconf.boardCtgDeleteAll", boardCtgVO);

                int orderNo = 1;
                for(String ctgNm : ctgNms) {
                    if(Validate.isEmpty(ctgNm.trim())) {
                        return;
                    }
                    boardCtgVO.setCtgNm(StringUtil.trim(ctgNm));
                    boardCtgVO.setOrderNo(orderNo++);
                    update("_boardconf.boardCtgInsert", boardCtgVO);
                }
            }
        }
    }
    
    
    /**
     * 게시판 상세 조회
     */
    @SuppressWarnings("unchecked")
    public BoardConfVO boardConfView(BoardConfVO boardConfVO) {
        BoardConfVO dataVO = null;

        if(BoardConfConstant.GUBUN_CD_GLOBAL == boardConfVO.getGubunCd()) {
            dataVO = (BoardConfVO) selectOne("_boardconf.boardConfView", boardConfVO.getBbsCd());
            // 카테고리 사용안할경우에도 카테고리를 유지한다.
            // if("Y".equals(dataVO.getCtgYn())){

            List<String> bbcCtgList = selectList("_boardconf.boardCtgNmList", boardConfVO.getBbsCd());

            String[] bbsCtgNms = bbcCtgList.toArray(new String[bbcCtgList.size()]);

            dataVO.setCtgNms(bbsCtgNms);
            // }
        } else if(BoardConfConstant.GUBUN_CD_LIST == boardConfVO.getGubunCd()) {
            dataVO = (BoardConfVO) selectOne("_boardconf.boardConfListView", boardConfVO.getBbsCd());
        } else if(BoardConfConstant.GUBUN_CD_VIEW == boardConfVO.getGubunCd()) {
            dataVO = (BoardConfVO) selectOne("_boardconf.boardConfViewView", boardConfVO.getBbsCd());
        } else if(BoardConfConstant.GUBUN_CD_FORM == boardConfVO.getGubunCd()) {
            dataVO = (BoardConfVO) selectOne("_boardconf.boardConfFormView", boardConfVO.getBbsCd());
        } else if(BoardConfConstant.GUBUN_CD_AUTH == boardConfVO.getGubunCd()) {
            dataVO = (BoardConfVO) selectOne("_boardconf.boardConfAuthView", boardConfVO.getBbsCd());

            /*if(Validate.isNotEmpty(dataVO.getAuthIds())) {
                String[] authIds = StringUtil.split(dataVO.getAuthIds(), ",");
                if(Validate.isNotEmpty(authIds)) {
                    List<MgrVO> authList = new ArrayList<MgrVO>(authIds.length);

                    MgrVO mgrVo = new MgrVO();
                    for(String mgrId : authIds) {
                        mgrVo.setMgrId(mgrId);
                        authList.add((MgrVO) selectOne("_mgr.view", mgrVo));
                    }
                    dataVO.setAuthList(authList);
                }
            }*/
        }

        return dataVO;
    }
    
    /**
     * 게시판 확장 관리 목록
     * 
     * @param bbsCd
     * @return
     */
    public List<BoardExtensionVO> boardConfExtList(Integer bbsCd) {
        @SuppressWarnings("unchecked")
        List<BoardExtensionVO> extList = selectList("_boardconf.boardConfExtensionList", bbsCd);

        return extList;
    }      
    
    /**
     * 게시판 표시항목 목록
     * 
     * @param bbsCd
     * @return
     */
    public List<BoardArrangeVO> boardDisplayColumnList(BoardArrangeVO boardArrangeVO) {
        @SuppressWarnings("unchecked")
        List<BoardArrangeVO> list = selectList("_boardconf.boardDisplayColumnList", boardArrangeVO);

        return list;
    }
    
    /**
     * 게시판 전체항목 목록
     * 
     * @param bbsCd
     * @return
     */
    public List<BoardArrangeVO> boardColumnList(Integer bbsCd) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("bbsCd", bbsCd);
        @SuppressWarnings("unchecked")
        List<BoardArrangeVO> list = selectList("_boardconf.boardColumnList", map);

        return list;
    }
    
    /**
     * 게시판 수정 액션
     */
    public int updateAction(BoardConfVO boardConfVO) {
        //boardConfVO.setModDt(DateFormatUtil.getToday());
    	boardConfVO.setModDt(DateFormatUtil.getTodayFull());
        int affected = update("_boardconf.boardConfUpdate", boardConfVO);

        if(affected == StringUtil.ONE) {
            if(BoardConfConstant.GUBUN_CD_GLOBAL == boardConfVO.getGubunCd()) {
                affected = update("_boardconf.boardConfGlobalUpdate", boardConfVO);
                if(affected == StringUtil.ONE) {
                    insertBbsCtgAction(boardConfVO);
                }
            } else if(BoardConfConstant.GUBUN_CD_LIST == boardConfVO.getGubunCd()) {
                affected = update("_boardconf.boardConfListUpdate", boardConfVO);
            } else if(BoardConfConstant.GUBUN_CD_VIEW == boardConfVO.getGubunCd()) {
                affected = update("_boardconf.boardConfViewUpdate", boardConfVO);
            } else if(BoardConfConstant.GUBUN_CD_FORM == boardConfVO.getGubunCd()) {
                affected = update("_boardconf.boardConfFormUpdate", boardConfVO);
            } else if(BoardConfConstant.GUBUN_CD_AUTH == boardConfVO.getGubunCd()) {
                affected = update("_boardconf.boardConfAuthUpdate", boardConfVO);
            }

            // 게시판 캐쉬를 리로드 합니다.
            //reloadBbsCache();
        }

        return affected;
    }
    
    /**
     * 게시판 목록/상세 배치 수정 액션
     */
    public int arrangeUpdateAction(BoardArrangeVO boardArrangeVO) {
        int affexted = 0, orderNo = 0;

        // 기존 표시항목 목록 삭제
        delete("_boardconf.boardConfArrangeDelete", boardArrangeVO);

        // 표시항목 등록
        String[] columns = boardArrangeVO.getDisplayColumns();
        String columnNm = "";
        for(String column : columns) {
            BoardArrangeVO vo = new BoardArrangeVO();
            vo.setBbsCd(boardArrangeVO.getBbsCd());
            vo.setListViewGubun(boardArrangeVO.getListViewGubun());
            vo.setColumnId(column);
            vo.setOrderNo(++orderNo);
            vo.setBeanNm(StringUtil.camelCase(column));
            columnNm = selectOne("_boardconf.getBoardColumnName", vo);
            vo.setColumnNm(columnNm);
            affexted += update("_boardconf.boardConfArrangeInsert", vo);
        }

        // 게시판 캐쉬를 리로드 합니다.
        //reloadBbsCache();

        return affexted;
    }
    
    /**
     * 게시판 확장 관리 수정 액션(추가컬럼 및 목록 표시 항목)
     */
    public int updateExtAction(List<BoardExtensionVO> extList, int bbsCd) {
        int affexted = 0;
        for(BoardExtensionVO extenstion : extList) {
        	extenstion.setBbsCd(bbsCd);
            affexted += update("_boardconf.boardConfExtensionUpdate", extenstion);
        }

        // 게시판 캐쉬를 리로드 합니다.
        //reloadBbsCache();

        return affexted;
    }
    
    /**
     * 게시판 설정 삭제
     */
    public Integer boardConfDelete(BoardConfVO boardConfVO) {    	
        return delete("_boardconf.boardConfDelete", boardConfVO.getBbsCd().toString());
    }
    
    /**
     * 게시판 설정(배치) 삭제
     * @param boardConfVO
     * @return
     */
    public Integer deleteBdConArrange(BoardConfVO boardConfVO) {
    	return delete("_boardconf.deleteBdConArrange", boardConfVO.getBbsCd().toString());
    }
    
	/**
	 * 게시판 설정(확장) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConExtension(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConExtension", boardConfVO.getBbsCd().toString());
	}
	
	/**
	 * 게시판 설정(입력폼) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConForm(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConForm", boardConfVO.getBbsCd().toString()); 
	}
	
	/**
	 * 게시판 설정(전역) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConGlobal(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConGlobal", boardConfVO.getBbsCd().toString());
	}
	
	/**
	 * 게시판 설정(목록) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConList(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConList", boardConfVO.getBbsCd().toString());
	}
	
	/**
	 * 게시판 설정(상세조회) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConView(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConView", boardConfVO.getBbsCd().toString());
	}
	
	/**
	 * 게시판 설정(카테고리) 삭제
	 * @param boardConfVO
	 * @return
	 */
	public Integer deleteBdConCtg(BoardConfVO boardConfVO) {
		return delete("_boardconf.deleteBdConCtg", boardConfVO.getBbsCd().toString());
	}	
    
    /**
     * 게시판 칼럼별 사용여부 수정 액션
     */
    public int updateAction(BoardConfYnVO boardConfYnVO) {
        int affected = 0;

        if(StringUtil.ZERO == boardConfYnVO.getGubunCd()) {
            boardConfYnVO.setModDt(DateFormatUtil.getToday());
            affected = update("_boardconf.boardConfYnUpdate", boardConfYnVO);
        } else if(BoardConfConstant.GUBUN_CD_GLOBAL == boardConfYnVO.getGubunCd()) {
            affected = update("_boardconf.boardConfGlobalYnUpdate", boardConfYnVO);
        } else if(BoardConfConstant.GUBUN_CD_LIST == boardConfYnVO.getGubunCd()) {
            affected = update("_boardconf.boardConfListYnUpdate", boardConfYnVO);
        } else if(BoardConfConstant.GUBUN_CD_VIEW == boardConfYnVO.getGubunCd()) {
            affected = update("_boardconf.boardConfViewYnUpdate", boardConfYnVO);
        } else if(BoardConfConstant.GUBUN_CD_FORM == boardConfYnVO.getGubunCd()) {
            affected = update("_boardconf.boardConfFormYnUpdate", boardConfYnVO);
        }

        return affected;
    }
    
}
