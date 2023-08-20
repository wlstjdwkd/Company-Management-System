package com.infra.batch;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 배치실행 클래스
 * 
 * @author sujong
 * 
 */
public class BatchRunner {

	private static final Logger logger = LoggerFactory.getLogger(BatchRunner.class);

	private static final int FIN_OK = 0;
	private static final int FIN_ERR = 1;
	
	private String[] args = null;
	
	/**
	 *  외부입력 파라미터 전달
	 * @param args
	 */
	public BatchRunner(String[] args) {
		this.args = args;
	}

	/**
	 * 배치업무 서비스 수행
	 */
	public void invokeService() throws Exception {
		
		ApplicationContext applicationContext = new ClassPathXmlApplicationContext("/egovframework/batch/context-batch.xml");
		
		String beanName = args[0];
		
		BatchService service = (BatchService) applicationContext.getBean(beanName);
		
		service.setParam(args, applicationContext);
		service.validateParameter();
		service.processService();
	}
	
	/**
	 * 배치실행
	 * 
	 * @param args
	 *            외부입력 파라미터(서비스ID, 기타입력파라미터)
	 * 
	 */
	public static void main(String[] args) {

		// 수행할 서비스ID가 파라미터로 지정되지 않으면 오류
		if(args.length <= 0) {
			logger.error("서비스ID가 지정되지 않았습니다.");
			System.out.println("ERROR");
			System.exit(FIN_ERR);
		}

		try {

			BatchRunner run = new BatchRunner(args);
			run.invokeService();
			System.out.println("SUCCESS");
			System.exit(FIN_OK);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			System.out.println("ERROR");
			System.exit(FIN_ERR);
		}
	}

}
