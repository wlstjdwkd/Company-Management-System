package egovframework.com.uss.olp.qim.web;

import egovframework.com.uss.olp.qim.service.QustnrItemManageVO;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

/**
 * BatchOpert클래스에대한 validator 클래스.
 * common validator가 처리하지 못하는 부분 검사. 
 * 
 * @author 김진만
 * @version 1.0
 * @see
 * <pre>
 * == 개정이력(Modification Information) ==
 * 
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2010.08.20   김진만     최초 생성
 * </pre>
 */
@Component("qustnrItemManageValidator")
public class QustnrItemManageValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return QustnrItemManageVO.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		QustnrItemManageVO itemVo = (QustnrItemManageVO) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "iemSn", "errors.required", new String[] {"항목순번"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "iemCn", "errors.required", new String[] {"항목내용"});

		// 길이체크
		if (itemVo.getIemSn().length() > 60) errors.rejectValue("iemSn", "errors.maxlength", new Object [] { "항목순번", 5 }, null);
		if (itemVo.getIemCn().length() > 1000) errors.rejectValue("iemCn", "errors.maxlength", new Object [] { "항목내용", 1000 }, null);

		// 타입체크
		if (!StringUtils.isNumeric(itemVo.getIemSn())) errors.rejectValue("iemSn", "errors.integer", new Object [] { "항목순번"}, null);
	}

}
