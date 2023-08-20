package com.infra.util;

import java.io.IOException;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infra.util.Validate;

/**
 *
 */
public class JsonUtil {

    /** 로깅 */
    private static Logger logger = LoggerFactory.getLogger(JsonUtil.class);

    /**
     * 대상 객체를 JSON 객체 문자열로 반환한다.
     * 대상이 없거나, 오류 발생시 빈 배열형식("{}")의 문자열을 반환한다.
     *
     * @param jsonObj
     * @return
     */
    public static String toJson(Object jsonObj) {

        String json = "{}";
        if(Validate.isNull(jsonObj)) {
            return json;
        }

        ObjectMapper mapper = new ObjectMapper();
        try {
            json = mapper.writeValueAsString(jsonObj);
        } catch (IOException e) {
        	logger.error("", e);
        }

        return json;
    }

    /**
     * JSON 문자열로 객체를 생성하여 반환한다.
     * JSON과 Class TYPE이 일치 하지 않는 경우 <code>null</code>을 반환한다.
     *
     * @param jsonStr
     * @param objType
     * @return
     */
    public static <T> T fromJson(String jsonStr, Class<T> objType) {
        T obj = null;

        ObjectMapper mapper = new ObjectMapper();
        try {
            obj = mapper.readValue(jsonStr, objType);
        } catch (IOException e) {
            if(logger.isDebugEnabled()) {
                logger.debug("change type failed", e);
            }
        }

        return obj;
    }
}
