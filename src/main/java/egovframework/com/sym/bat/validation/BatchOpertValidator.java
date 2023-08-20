package egovframework.com.sym.bat.validation;

import java.io.File;

import egovframework.com.sym.bat.service.BatchOpert;

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
@Component("batchOpertValidator")
public class BatchOpertValidator implements Validator {

	/*
	 * (non-Javadoc)
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
    public boolean supports(Class clazz) {
        return BatchOpert.class.isAssignableFrom(clazz);
     }
	
    /*
     * (non-Javadoc)
     * @see org.springframework.validation.Validator#validate(java.lang.Object, org.springframework.validation.Errors)
     */
	public void validate(Object obj, Errors errors) {
		// 배치프로그램으로 지정된 값이 파일로 존재하는지 검사한다. 
		BatchOpert batchOpert = (BatchOpert) obj;
		
		// 필수값 체크
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "batchOpertNm", "errors.required", new String[] {"배치작업명"});
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "batchProgrm", "errors.required", new String[] {"배치프로그램"});

		// 길이체크
		if (batchOpert.getBatchOpertNm().length() > 60) errors.rejectValue("batchOpertNm", "errors.maxlength", new Object [] { "배치작업명", 60 }, null);
		if (batchOpert.getBatchProgrm().length() > 255) errors.rejectValue("batchProgrm", "errors.maxlength", new Object [] { "배치프로그램", 255 }, null);
		if (batchOpert.getParamtr().length() > 250) errors.rejectValue("batchProgrm", "errors.maxlength", new Object [] { "파라미터", 250 }, null);
		
		try {
			File file = new File(batchOpert.getBatchProgrm());
			
			if (!file.exists()) {
				errors.rejectValue("batchProgrm", "errors.batchProgrm", new Object [] { batchOpert.getBatchProgrm() },
			    "배치프로그램 {0}이  존재하지 않습니다.");
				return ;
			}
			if (!file.isFile()) {
				errors.rejectValue("batchProgrm", "errors.batchProgrm", new Object [] { batchOpert.getBatchProgrm() },
			    "배치프로그램 {0}이 파일이 아닙니다.");
				return ;
			}
		} catch (SecurityException  se) {
			errors.rejectValue("batchProgrm", "errors.batchProgrm", new Object [] { batchOpert.getBatchProgrm() },
		    " 배치프로그램 {0}에 접근할 수 없습니다. 파일접근권한을 확인하세요.");
		}
	}

}
