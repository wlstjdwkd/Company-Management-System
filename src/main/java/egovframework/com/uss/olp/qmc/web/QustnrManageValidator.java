package egovframework.com.uss.olp.qmc.web;

import com.infra.util.DateUtil;
import egovframework.com.uss.olp.qmc.service.QustnrManageVO;

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
@Component("qustnrManageValidator")
public class QustnrManageValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return QustnrManageVO.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		QustnrManageVO vo = (QustnrManageVO) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrSj", "errors.required", new String[] {"설문제목"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrPurps", "errors.required", new String[] {"설문목적"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrWritngGuidanceCn", "errors.required", new String[] {"설문작성안내 내용"});
		//ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrTrget", "errors.required", new String[] {"설문대상"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrBeginDe", "errors.required", new String[] {"설문기간  시작일자"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "qestnrEndDe", "errors.required", new String[] {"설문기간  종료일자"});
		
		// 길이체크
		if (vo.getQestnrSj().length() > 250) errors.rejectValue("qestnrSj", "errors.maxlength", new Object [] { "설문제목", 250 }, null);
		if (vo.getQestnrPurps().length() > 1000) errors.rejectValue("qestnrPurps", "errors.maxlength", new Object [] { "설문목적", 1000 }, null);
		if (vo.getQestnrWritngGuidanceCn().length() > 500) errors.rejectValue("qestnrWritngGuidanceCn", "errors.maxlength", new Object [] { "설문작성안내 내용", 2000 }, null);

		// 타입체크
		try {
			DateUtil.convertStringToDate(vo.getQestnrBeginDe());
		} catch (Exception e) {
			errors.rejectValue("qestnrBeginDe", "errors.date", new Object [] { "설문기간  시작일자"}, null);
		}

		try {
			DateUtil.convertStringToDate(vo.getQestnrBeginDe());
		} catch (Exception e) {
			errors.rejectValue("qestnrEndDe", "errors.date", new Object [] { "설문기간  종료일자"}, null);
		}
	}

}
