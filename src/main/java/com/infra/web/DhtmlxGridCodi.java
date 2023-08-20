package com.infra.web;

import java.util.Iterator;
import java.util.Map;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


/**
 * JSONParser
 * 맵을 json타입으로 바꿔줌
 * 
 * @author LYJ
 * 
 */
public class DhtmlxGridCodi
{
	private static final Logger logger = LoggerFactory.getLogger(DhtmlxGridCodi.class);
	
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

				resData += "\n\t\t\"" + keys + "\":\"" + map.get(keys) + "\"";
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
		resData += "\t]";
		
		return resData;
	}
}