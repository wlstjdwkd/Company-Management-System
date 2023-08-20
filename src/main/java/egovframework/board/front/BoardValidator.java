package egovframework.board.front;

import com.infra.util.Validate;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import egovframework.board.admin.BoardVO;

@Component("boardValidator")
public class BoardValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		// TODO Auto-generated method stub
		return BoardVO.class.isAssignableFrom(clazz);
	}
	
	@Override
	public void validate(Object target, Errors errors) {
		// TODO Auto-generated method stub
		BoardVO vo = (BoardVO) target;
		
		if(vo.getBbsCd() == 1025) {
			if(Validate.isEmpty(vo.getEmailAddr())) errors.rejectValue("emailAddr", "errors.required", new Object[] {"이메일"}, null);
			if(Validate.isEmpty(vo.getCtgCd())) errors.rejectValue("ctgCd", "errors.required", new Object[] {"분류"}, null);
		}		
		
		if(Validate.isEmpty(vo.getTitle())) errors.rejectValue("title", "errors.required", new Object[] {"제목"}, null);		
		if (vo.getTitle().length() < 3) errors.rejectValue("title", "errors.minlength", new Object [] { "제목", 3 }, null);
		if (vo.getTitle().length() > 200) errors.rejectValue("title", "errors.maxlength", new Object [] { "제목", 200 }, null);
		
		if (vo.getContents().length() < 10) errors.rejectValue("contents", "errors.minlength", new Object [] { "내용", 10 }, null);
		
	}
}
