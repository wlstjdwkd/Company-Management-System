package com.infra.batch;

import org.springframework.context.ApplicationContext;

/**
 * 배치업무 서비스 인터페이스
 * 
 * @author sujong
 * 
 */
public abstract class BatchService {

	protected String[] args = null;
	protected ApplicationContext ac = null;

	/**
	 * 외부입력 파라미터 검증
	 * 
	 * @param param
	 * @return
	 */
	public abstract void validateParameter() throws Exception;
	
	/**
	 * 배치업무 서비스 수행
	 * @throws Exception
	 */
	public abstract void processService() throws Exception;

	/**
	 * 필수 파라미터 설정
	 * @param args
	 * @param ac
	 */
	public void setParam(String[] args, ApplicationContext ac) {
		this.args = args;
		this.ac = ac;
	}

}
