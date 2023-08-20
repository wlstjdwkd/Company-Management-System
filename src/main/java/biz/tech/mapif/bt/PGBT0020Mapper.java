package biz.tech.mapif.bt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGBT0020Mapper")
public interface PGBT0020Mapper {

	public List<Map> selectFileList() throws Exception;
	public void updateResult(Map param) throws Exception;
}
