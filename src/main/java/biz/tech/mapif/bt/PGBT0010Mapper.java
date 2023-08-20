package biz.tech.mapif.bt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("PGBT0010Mapper")
public interface PGBT0010Mapper {

	public List<Map> selectEnpList() throws Exception;
	public void insertDecPwd(Map param) throws Exception;
}
