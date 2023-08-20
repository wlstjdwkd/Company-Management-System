package biz.tech.mapif.ps;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("PGPS0080Mapper")
public interface PGPS0080Mapper {
	
	public List<Map> List(Map<?,?> param) throws Exception;

	public int deletrelPossessionList(HashMap param);

	public int deletrelPossessionMgr(HashMap param);
	
	public void insertrelPossessionMgr(HashMap param);
	
	public void intsertrelPossession(HashMap param);
}
