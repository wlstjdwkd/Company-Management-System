package egovframework.board.config;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.infra.util.StringUtil;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Service("boardCacheService")
public class BoardCacheServiceImpl extends EgovAbstractMapper implements BoardCacheService {
		
	@Override
	@Cacheable(value="boardConfig")
	public BoardConfVO findBoardConfig(int bbsCd) {
		
		//캐싱 될 VO객체
		BoardConfVO _boardConfVO = null;
		
		//parameter 용
		Map<String, Object> paramMap = new HashMap<String, Object>();
		BoardConfVO paramVO = new BoardConfVO();
		paramVO.setBbsCd(bbsCd);
		
		_boardConfVO = (BoardConfVO) selectOne("_boardCache.boardConfView", paramVO);
		
		if("Y".equals(_boardConfVO.getCtgYn())) {
            List<BoardCtgVO> ctgList = selectList("_boardCache.boardCtgList", bbsCd);
            _boardConfVO.setCtgList(ctgList);
        }
        List<BoardArrangeVO> listArrange = selectList("_boardCache.boardListArrange", bbsCd);
        _boardConfVO.setListArrange(listArrange);

        List<BoardArrangeVO> viewArrange = selectList("_boardCache.boardViewArrange", bbsCd);
        _boardConfVO.setViewArrange(viewArrange);

        List<BoardExtensionVO> extVoList;
        paramMap.put("bbsCd", _boardConfVO.getBbsCd());
		
        // 검색 시 확장 항목
        paramMap.put("searchYn", "Y");
        extVoList = selectList("_boardCache.boardExtensionList", paramMap);
        for(BoardExtensionVO extVO : extVoList) {
            extVO.setBeanName(StringUtil.camelCase(extVO.getColumnId()));
        }
        _boardConfVO.setSearchColunms(extVoList);

        // 등록 시 확장 항목
        paramMap.put("searchYn", "");
        extVoList = selectList("_boardCache.boardExtensionList", paramMap);
        for(BoardExtensionVO extVO : extVoList) {
            extVO.setBeanName(StringUtil.camelCase(extVO.getColumnId()));
        }
        _boardConfVO.setFormColunms(extVoList);
				
		return _boardConfVO;
	}
	
	@Override
	@CacheEvict(value="boardConfig", key="#bbsCd")
	public void resetBoardConfig(int bbsCd) {
		// TODO Auto-generated method stub
		
	}

}
