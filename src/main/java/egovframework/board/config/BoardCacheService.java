package egovframework.board.config;

public interface BoardCacheService {

	BoardConfVO findBoardConfig(int bbsCd);

	void resetBoardConfig(int bbsCd);
}
