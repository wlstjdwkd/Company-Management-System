package egovframework.com.uss.olp.qri.web;

import egovframework.com.uss.olp.qri.service.QustnrRespondInfoVO;

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
@Component("qustnrRespondInfoValidator")
public class QustnrRespondInfoValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return QustnrRespondInfoVO.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		QustnrRespondInfoVO vo = (QustnrRespondInfoVO) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "respondNm", "errors.required", new String[] {"응답자명"});
		
		// 길이체크
		if (vo.getRespondNm().length() > 50) errors.rejectValue("respondNm", "errors.maxlength", new Object [] { "응답자명", 50 }, null);
		if (vo.getRespondAnswerCn() != null && vo.getRespondAnswerCn().length() > 1000) errors.rejectValue("respondAnswerCn", "errors.maxlength", new Object [] { "응답자답변내용(주관식)", 1000 }, null);
		if (vo.getEtcAnswerCn() != null && vo.getEtcAnswerCn().length() > 1000) errors.rejectValue("etcAnswerCn", "errors.maxlength", new Object [] { "기타답변내용", 1000 }, null);
	}

}
