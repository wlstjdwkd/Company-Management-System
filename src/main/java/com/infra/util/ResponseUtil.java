package com.infra.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;

import com.comm.response.GridJsonVO;
import com.comm.response.JsonVO;
import com.infra.system.GlobalConst;

public class ResponseUtil {	
	private static final Logger logger = LoggerFactory.getLogger(ResponseUtil.class);
	 /**
     * <code>Grid Data Object</code>를 JSON 타입으로 변경하여 응답
     * (content type = application/json)
     * 
     * @param model
     * @return ModelAndView
     */
    public static ModelAndView responseGridJson(ModelAndView model, GridJsonVO gridJsonVo) {        

        return responseJson(model, gridJsonVo);
    }

    /**
     * 파라미터로 전달되는 항목을 json VO 객체에 담아서 응답
     * (content type = application/json)
     * 
     * @param model
     * @param result 처리결과
     * @return ModelAndView
     */
    public static ModelAndView responseJson(ModelAndView model, Boolean result) {

        JsonVO jsonVo = new JsonVO().setResult(result);

        return responseJson(model, jsonVo);
    }
    
    /**
     * 파라미터로 전달되는 항목을 json VO 객체에 담아서 응답
     * (content type = application/json)
     * 
     * @param model
     * @param result 처리결과
     * @param value 결과 값
     * @param  응답메시지
     * @return ModelAndView
     */
    public static ModelAndView responseJson(ModelAndView model, Boolean result, Object value) {

        JsonVO jsonVo = new JsonVO().setResult(result).setValue(value);
        
        return responseJson(model, jsonVo);
    }

    /**
     * 파라미터로 전달되는 항목을 json VO 객체에 담아서 응답
     * (content type = application/json)
     * 
     * @param model
     * @param result 처리결과
     * @param message 응답메시지
     * @return ModelAndView
     */
    public static ModelAndView responseJson(ModelAndView model, Boolean result, String message) {

        JsonVO jsonVo = new JsonVO().setResult(result).setMessage(message);
        
        return responseJson(model, jsonVo);
    }

    /**
     * 파라미터로 전달되는 항목을 json VO 객체에 담아서 응답
     * (content type = application/json)
     * 
     * @param model 
     * @param value 결과 값
     * @param message 응답메시지
     * @return ModelAndView
     */
    public static ModelAndView responseJson(ModelAndView model, Object value, String message) {

        JsonVO jsonVo = new JsonVO().setValue(value).setMessage(message);

        return responseJson(model, jsonVo);
    }

    /**
     * 파라미터로 전달되는 항목을 json VO 객체에 담아서 응답
     * (content type = application/json)
     * 
     * @param model
     * @param result 처리결과 
     * @param value 결과 값
     * @param message 응답메시지
     * @return ModelAndView
     */
    public static ModelAndView responseJson(ModelAndView model, Boolean result, Object value, String message) {

        JsonVO jsonVo = new JsonVO().setResult(result).setValue(value).setMessage(message);

        return responseJson(model, jsonVo);
    }

    /**
     * <code>Object</code>를 JSON 타입으로 변경하여 응답
     * (content type = application/json)
     * 
     * @param model
     * @param target
     * @return ModelAndView
     * @see com.infra.view.JsonView
     */
    public static ModelAndView responseJson(ModelAndView model, Object target) {
        model.addObject(GlobalConst.JSON_DATA_KEY, target);
        model.setViewName(GlobalConst.JSON_VIEW_NAME);
        return model;
    }
    
    
    
	/**
     * textView를 통한 문자열 응답 (응답 문자열 없음)
     * 인자가 없이 호출되었기 때문에 기본 응답 "true" 문자열이 전송됨.
     * (content type = text/plain)
     * 
     * @param model
     * @return ModelAndView
     * @see #responseText(ModelAndView, Object)
     */
	public static ModelAndView responseText(ModelAndView model) {    	
        return responseText(model, Boolean.TRUE);
    }

    /**
     * textView를 통한 문자열 응답 (<code>Object.toString()</code> 값이 응답문자열로 생성됨)
     * (content type = text/plain)
     * 
     * @param model
     * @param target
     * @return ModelAndView
     * @see com.infra.view.TextView
     */
	public static ModelAndView responseText(ModelAndView model, Object target) {

		logger.debug("######### target ==> " + target);
		logger.debug("######### TEXT_DATA_KEY ==> " + GlobalConst.TEXT_DATA_KEY);
		logger.debug("######### TEXT_VIEW_NAME ==> " + GlobalConst.TEXT_VIEW_NAME);
        model.addObject(GlobalConst.TEXT_DATA_KEY, target);
        model.setViewName(GlobalConst.TEXT_VIEW_NAME);

        return model;
    }
	
	/**
     * excelView를 통한 excel 파일 다운로드
     * (content type = application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
     * 
     * @param model
     * @param target
     * @return
     */
	public static ModelAndView responseExcel(ModelAndView model, Object target) {

        model.addObject(GlobalConst.OBJ_DATA_KEY, target);
        model.setViewName(GlobalConst.EXCEL_VIEW_NAME);

        return model;
    }
}
