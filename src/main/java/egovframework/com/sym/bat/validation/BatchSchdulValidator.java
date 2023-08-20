package egovframework.com.sym.bat.validation;

import egovframework.com.sym.bat.service.BatchSchdul;

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
@Component("batchSchdulValidator")
public class BatchSchdulValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return BatchSchdul.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {

		//BatchSchdul batchSchdul = (BatchSchdul) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "batchOpertId", "errors.required", new String[] {"배치작업ID"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "executCycle", "errors.required", new String[] {"실행주기"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "executSchdulHour", "errors.required", new String[] {"실행스케줄시간"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "executSchdulMnt", "errors.required", new String[] {"실행스케줄분"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "executSchdulSecnd", "errors.required", new String[] {"실행스케줄초"});
	}

}
