package egovframework.com.uss.olp.qqm.web;

import egovframework.com.uss.olp.qqm.service.QustnrQestnManageVO;

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
@Component("qustnrQestnManageValidator")
public class QustnrQestnManageValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return QustnrQestnManageVO.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		QustnrQestnManageVO vo = (QustnrQestnManageVO) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnSn", "errors.required", new String[] {"질문순번"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnTyCode", "errors.required", new String[] {"질문유형"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnCn", "errors.required", new String[] {"질문 내용"});
		
		// 길이체크
		if (vo.getQestnSn().length() > 10) errors.rejectValue("qestnSn", "errors.maxlength", new Object [] { "질문순번", 10 }, null);
		if (vo.getQestnCn().length() > 2500) errors.rejectValue("qestnCn", "errors.maxlength", new Object [] { "질문 내용", 2500 }, null);

		// 타입체크
		if (!StringUtils.isNumeric(vo.getQestnSn())) errors.rejectValue("qestnSn", "errors.integer", new Object [] { "질문순번"}, null);
	}

}
