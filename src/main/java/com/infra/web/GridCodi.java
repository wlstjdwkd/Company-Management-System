package com.infra.web;

import java.util.Iterator;
import java.util.Map;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JSONParser
 * 맵을 json타입으로 바꿔줌
 * DHTMLX GRID와 RealGrid 사용 시 적용
 * @author LYJ
 * 
 */
public class GridCodi
{
	private static final Logger logger = LoggerFactory.getLogger(GridCodi.class);
	
	public static String MaptoJson(List<Map> dataList) throws Exception
	{
		String resData;

		resData = "[\n";
		for (int ii = 0; ii < dataList.size(); ii++) {
			Map map = dataList.get(ii);
			resData += "\t\t{";

			Iterator<String> itrKey = map.keySet().iterator();

			while (itrKey.hasNext()) {
				String keys = itrKey.next();

				resData += "\n\t\t\"" + keys + "\" : \"" + map.get(keys) + "\"";
				if (itrKey.hasNext())
					resData += ",";
				else
					resData += "";
			}

			resData += "\n\t\t}";
			if ((ii + 1) != dataList.size())
				resData += ",\n";
			else
				resData += "\n";
		}
		resData += "]";
		
		return resData;
	}
	
	public static String MaptoTreeJson(List<Map> dataList, String itemCodeKey, String upCodeKey) throws Exception
	{
		int j = 1;
		for (int i = 0; i < dataList.size(); i++) {
			if (dataList.get(i).get(upCodeKey).toString().equals("0")) {
				dataList.get(i).put("treeId", j);
				j++;
				createTreeJson(dataList, itemCodeKey, upCodeKey,
						dataList.get(i).get(itemCodeKey).toString(), dataList.get(i).get("treeId").toString());
			}
		}
		return MaptoJson(dataList);
	}
	
	private static void createTreeJson(List<Map> dataList, String itemCodeKey, String upCodeKey, String itemCode, String treeId) throws Exception
	{
		int j = 1;
		for (int i = 0; i < dataList.size(); i++) {
			if (dataList.get(i).get(upCodeKey).toString().equals(itemCode)) {
				dataList.get(i).put("treeId", treeId + "." + j);
				j++;
				createTreeJson(dataList, itemCodeKey, upCodeKey, dataList.get(i).get(itemCodeKey).toString(), dataList.get(i).get("treeId").toString());
			}
		}
	}
}