package egovframework.com.uss.olp.qtm.web;

import egovframework.com.uss.olp.qtm.service.QustnrTmplatManageVO;

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
@Component("qustnrTmplatManageValidator")
public class QustnrTmplatManageValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return QustnrTmplatManageVO.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		QustnrTmplatManageVO vo = (QustnrTmplatManageVO) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrTmplatTy", "errors.required", new String[] {"템플릿명"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrTmplatCn", "errors.required", new String[] {"템플릿설명"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrTmplatCours", "errors.required", new String[] {"템플릿파일(경로)"});
		
		// 길이체크
		if (vo.getQestnrTmplatTy().length() > 100) errors.rejectValue("qestnrTmplatTy", "errors.maxlength", new Object [] { "템플릿명", 100 }, null);
		if (vo.getQestnrTmplatCn().length() > 1000) errors.rejectValue("qestnrTmplatCn", "errors.maxlength", new Object [] { "템플릿설명", 1000 }, null);
		if (vo.getQestnrTmplatCours().length() > 100) errors.rejectValue("qestnrTmplatCours", "errors.maxlength", new Object [] { "템플릿파일(경로)", 100 }, null);

	}

}
