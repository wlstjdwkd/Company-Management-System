package biz.tech.pm;

import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.infra.util.ResponseUtil;
import com.infra.web.GridCodi;

import biz.tech.mapif.pm.PGPM0010Mapper;
import biz.tech.mapif.pm.PGPM0030Mapper;
import biz.tech.mapif.pm.PGPM0040Mapper;
import biz.tech.mapif.pm.PGPM0070Mapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

/**
 * 메일 전송
 * 
 * 조회한 시기에 재직 중인 사원을 선택
 * 해당 사원들의 개별 또는 종합된 급여명세서를
 * 양식 엑셀 파일에서 복사 후 수정해 지정된 Local 폴더에 저장
 * 
 * 조회 / 개별 급여명세서 생성 / 종합 급여명세서 생성 / 메일 전송
 *  
 */
@Service("PGPM0070")
public class PGPM0070Service {
	private static final Logger logger = LoggerFactory.getLogger(PGPM0070Service.class);

	@Autowired
	PGPM0010Mapper pgpm0010Mapper;
	
	@Autowired
	PGPM0030Mapper pgpm0030Mapper;
	
	@Autowired
	PGPM0040Mapper pgpm0040Mapper;
	
	@Autowired
	PGPM0070Mapper pgpm0070Mapper;
	
	@Autowired
	private JavaMailSenderImpl mailSender;						// context-mail.xml에 Bean객체로 설정 정의

	private final String FOLDER_SEPARATOR = File.separator;		// 폴더 구분자: Windows('\'), Linux, MAC('/')
	private final String NAME_SEPARATOR = "-";					// 이름 구분자: 날짜'-'사번'-'성명
	private final String DIRECTORY_TOP = "급여항목";				// 작업 폴더 최상위 항목 명
	private final String INDIVIDUAL_PAY_STUB = "개별급여명세서";		// 작업 폴더 최상위 항목 명
	private final String INIT_NIX_PATH							// 유닉스 계열 디렉토리 시작 경로 
			= System.getProperty("user.home");
	private final String INIT_FILE_NAME = "테크블루제닉-급여내역-";	// 파일명 접두어
	private final ClassPathResource SAMPLE_FILE_PATH 			// 양식 위치
			= new ClassPathResource("sample" + FOLDER_SEPARATOR + "테크블루제닉-급여내역-양식.xlsx");
	private final String POSSIBLE = "가능";						// 가능여부 비교
	private final String NEGATIVE = "-";						// 없음 또는 비었음
	private final int EXCEL_START_ROW = 5;						// 엑셀에서 작업 시작할 행
	
	/**
	 * 메인 화면
	 * 
	 * 이동할 JSP파일을 지정하며 현재 날짜를 전송
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 */
	public ModelAndView index(Map<?, ?> rqstMap) {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		Calendar today = Calendar.getInstance();	// 현재 시간
		
		// 현재 년도를 받아 화면단에서 조회년도를 어디까지할 것인지 지정
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)));
		
		mv.addObject("frontParam",param);
		mv.setViewName("/admin/pm/BD_UIPMA0070");

		return mv;
	}
	
	/**
	 * 메일 송신 처리 및 기록 (메일 전송 버튼)
	 * 
	 * 메일을 전송할 전체 사원을 받아 개별 전송하고 전송 내역을 테이블에 기록 
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws RuntimeException, Exception
	 */
	public ModelAndView processSendMail(Map<?, ?> rqstMap) throws RuntimeException, Exception {
		HashMap param = new HashMap();
		JSONArray mailArr = new JSONArray();
		JSONObject mailObj = new JSONObject();
		String content;		// 메일 내용
		String year;
		String month;
		String mailData;
		
		mailData = MapUtils.getString(rqstMap, "employee_mail_array");
		year = MapUtils.getString(rqstMap, "search_year");
		month = MapUtils.getString(rqstMap, "search_month");
		content = "안녕하세요, 테크블루제닉입니다. \n " + makeSubject(year, month) + "를 드립니다.\n 귀하의 노고에 감사드립니다.";
		
		// jsonParse
		try {
			// 화면단에서 받은 JSON이 담긴 String을 JSONArray로 변경
			mailArr = PGPM0030Service.convertStrToJArr(mailData);		
			
			for (int i = 0; i < mailArr.size(); i++) {
				String empNo;			// 사원번호
				String comMail;			// 전송할 메일
				String subject;			// 제목
				String fileName;		// 첨부 파일 경로
				String filePath;		// 첨부 파일 경로
				//String makeExcelYn;		// 메일 전송 가능 여부
				
				// 메일 전송
				mailObj = (JSONObject) mailArr.get(i);
				fileName = mailObj.get("fileName").toString();
				if(!(fileName.equals(NEGATIVE))) {						// 첨부할 파일 이름이 존재할 때	
					empNo = mailObj.get("empNo").toString();
					comMail = mailObj.get("comMail").toString();
					subject = year + "년 " + Integer.parseInt(month) + "월분 급여명세서";
					filePath = mailObj.get("filePath").toString();
					
					generateAndSendEmail(comMail, subject, filePath, content);
					
					// 전송 기록 저장 (TB_PAY_SND_LOG)
					param.clear();
					param.put("empNo", empNo);							// 사원번호
					param.put("mailTt", subject);						// 메일제목
					param.put("fileNm", fileName);						// 파일명
					pgpm0070Mapper.insertSendLog(param);				// 전송 기록 저장 
				}
			}
		}
		catch (ParseException e) {
			String errMsg = "cannot parsing input data";
			logger.error("Error message" + errMsg);
			throw new ParseException(ParseException.ERROR_UNEXPECTED_EXCEPTION, "cannot parsing input data");
		}
		
		// 화면 refresh
		param.clear();
		param.put("search_year", year);
		param.put("search_month", month);
		
		return searchWorkFile(param);
	}
	
	/**
	 * 개별 메일 전송
	 * 
	 * 매개변수로 받은 내용으로 메일을 생성해 receiver에게 메일을 전송
	 * 
	 * @param receiver, subject, filePath, content
	 */
	public void generateAndSendEmail(String receiver, String subject, String filePath, String content) {
		final MimeMessage msg = mailSender.createMimeMessage();						// 메일 내용을 가진 객체		
		
		try {
			logger.debug("\n\n ===> send Mail");
			// 메일 옵션, 내용 설정
			MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");	// true는 멀티파트 메시지를 전송하겠다는 의미
			helper.setFrom(new InternetAddress("xkakrlfh@naver.com", "테크블루제닉"));
			// 빈에 아이디 설정한 것은 단순히 smtp 인증을 받기 위해 사용 따라서 보내는이(setFrom())반드시 필요
			InternetAddress to = new InternetAddress(receiver);
			helper.setTo(to);
			helper.setSubject(subject);
			helper.setText(content);												// 매개변수 true를 추가하는 것으로 html 태그 사용 가능

			// 메일 송신 콘텐츠
			FileSystemResource file = new FileSystemResource(filePath);
	        helper.addAttachment(file.getFilename(), file);
			
	        // 메일 전송
			mailSender.send(msg);	
		}
		catch(AddressException ae) {
			logger.debug("AddressException: " + ae.getMessage());
		}
		catch(MessagingException me) {
			logger.debug("MessagingException: " + me.getMessage());
		}
		catch(UnsupportedEncodingException ue) {
			logger.debug("UnsupportedEncodingException: " + ue.getMessage());
		}
	}
	
	// 특정 파일 자동 이동 및 관련 폴더 생성
	// !! 개발 단계에서 동작방법 변경으로 인한 미사용
	// 1) 작업할 폴더를 찾아 해당 위치로 이동 (필요시 폴더 생성)
	// 2) 지정한 형태의 파일을 해당 위치로 이동 (다운로드 폴더에 있다고 가정, 가져올 파일은 '???.엑셀')
	public void ctrlExcelFile(Map<?, ?> rqstMap) {
		final String DIRECTORY_YEAR = MapUtils.getString(rqstMap, "search_year");
		String resExp = "[^\\.]*\\.(xls|xlsx)";
		String asIsPath;
		String toBePath;
		File dir;
		File fl;
		
		// 경로지정
		if(System.getProperty("os.name").toLowerCase().contains("win")) {
			toBePath = "C:" + FOLDER_SEPARATOR + DIRECTORY_TOP;
		}
		else {
			toBePath = INIT_NIX_PATH + FOLDER_SEPARATOR + DIRECTORY_TOP;
		}
		dir = new File(toBePath);		
		checkFolder(dir);
		toBePath += FOLDER_SEPARATOR + DIRECTORY_YEAR;
		dir = new File(toBePath);		
		checkFolder(dir); 
		
		// AS-IS, 이동시키는 파일은 엑셀 파일로 한정
		asIsPath = System.getProperty("user.home") + FOLDER_SEPARATOR + "Downloads";	
		
		// 다운로드에 있는 파일 찾기
		String[] fileNames = new File(asIsPath).list();
		for(String flNm : fileNames) {
			if(flNm.matches(resExp)) {
				File destination = new File(toBePath + FOLDER_SEPARATOR + flNm);	// TO-BE
				fl = new File(asIsPath + FOLDER_SEPARATOR + flNm);
				fl.renameTo(destination);
			}
		}
	}
	
	/**
	 * 화면 조회
	 * 
	 * 검색 버튼 및 화면 재 출력을 위해 사용
	 * 사원번호, 이름, 전송할 메일 등의 정보를 테이블에서 가져와 조회
	 * 
	 * 1) 작업 폴더 확인
	 * 2) 해당 사원의 개인별 급여항목 있는지 확인
	 * 3) 전송일  확인
	 * 4) 첨부파일 검사
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView searchWorkFile(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap();
		final String DIRECTORY_YEAR 
							= MapUtils.getString(rqstMap, "search_year");	// 작업 년도, 경로 지정에 사용
		final String DIRECTORY_MONTH
							= MapUtils.getString(rqstMap, "search_month");	// 작업 월, 경로 지정에 사용
		final String PAY_DATE = DIRECTORY_YEAR + NAME_SEPARATOR				// 조회기간, 쿼리용 
					+ DIRECTORY_MONTH + NAME_SEPARATOR + "01";
		final boolean isFolderExist;										// 작업 폴더 존재 유무
		final boolean isFolderCheck;										// 작업 폴더를 확인해야 하는지
		File[] filePaths;													// 작업 폴더에 존재하는 파일들
		String path;														// 작업폴더 경로
		File dir;															// 작업 폴더
		List<Map> empMailList;												// 화면단(메일전송) 조회 내용

		//// 1) 작업 폴더 확인
		// 폴더 존재 확인, 없다면 생성
		// 경로지정, 'C:/최상위/년도/월별/테크블루제닉-급여내역-년도월-이름.xlsx'
		isFolderCheck = rqstMap.containsKey("is_folder_check");
		// 운영체제에 맞게 시작 경로 설정
		if(System.getProperty("os.name").toLowerCase().contains("win")) {
			path = "C:" + FOLDER_SEPARATOR + FOLDER_SEPARATOR + DIRECTORY_TOP;
		}
		else {
			path = INIT_NIX_PATH + FOLDER_SEPARATOR + FOLDER_SEPARATOR + DIRECTORY_TOP;
		}
		if(isFolderCheck) {
			dir = new File(path);
			checkFolder(dir);				// 최상위 폴더 생성
		}
		path += FOLDER_SEPARATOR + FOLDER_SEPARATOR + DIRECTORY_YEAR;
		if(isFolderCheck) {
			dir = new File(path);
			checkFolder(dir);				// 년도 폴더 생성
		}
		path += FOLDER_SEPARATOR + FOLDER_SEPARATOR + INDIVIDUAL_PAY_STUB;
		if(isFolderCheck) {
			dir = new File(path);
			checkFolder(dir);				// 개별급여명세서 폴더 생성
		}
		path += FOLDER_SEPARATOR + FOLDER_SEPARATOR + DIRECTORY_MONTH;
		dir = new File(path);
		isFolderExist = checkFolder(dir);	// 월별 폴더 생성
		filePaths = dir.listFiles();		// 파일 경로 받기
		
		// 당시 재직 중인 사원만 조회
		param.put("payDate", PAY_DATE);
		empMailList = pgpm0040Mapper.findCurrEmpList(param);				// 해당 기간 재직 중인 사원 조회
		
		// 사원별로 급여명세서 생성
		for(Map emp : empMailList) {
			String empNo = MapUtils.getString(emp,"empNo");					// 사원번호
			String sendDt = NEGATIVE;										// 전송일: 가장 최근 날짜가 들어가며, 없다면 "-"
			String fileName = NEGATIVE;										// 첨부파일: 첨부파일명이 들어가며, 없다면 "-"
			String filePath = "";											// 파일 경로
			String findFile = makeFileName(DIRECTORY_YEAR, DIRECTORY_MONTH,
					empNo, MapUtils.getString(emp, "empNm"));				// 첨부할 파일명
			boolean makeExcelYn = false;									// 엑셀 파일 생성 가능여부 (해당월 개인월급여로 있는지로 구분)
			List<Map> mntPayList;											// 개인별월급여 쿼리 리턴값
			Map<?,?> sendLog;												// 전송일 쿼리 리턴값

			// 2) 해당 사원의 개인별 급여항목 있는지 확인
			param.clear();
			param.put("empNo", empNo);
			param.put("payYm", DIRECTORY_YEAR + DIRECTORY_MONTH);
			mntPayList = pgpm0070Mapper.findIndvPayMnt(param);				// 해당월 개인월급여 조회
			if(!(mntPayList.isEmpty())) {									// 해당월 개인월급여가 있다면
				makeExcelYn = true;											// 엑셀파일 생성 가능하다
			}
			
			// 3) 전송일  확인
			param.clear();
			param.put("fileNm", findFile);
			sendLog = pgpm0070Mapper.findSendLog(param);					// 메일 전송 기록 조회
			if(sendLog != null && !(sendLog.isEmpty())) {
				sendDt = sendLog.get("sendDt").toString();
			}
			
			// 4) 첨부파일 검사
			if(isFolderExist) {			// 폴더가 이미 있다면
				// 파일 확인
				// 첨부할 파일 있는지 탐색
				for(File f : filePaths) {
					String flNm = f.getName();
					if(flNm.equals(findFile)) {
						fileName = flNm;
						filePath = path + FOLDER_SEPARATOR + FOLDER_SEPARATOR + fileName;
						break;
					}
				}
			}
			
			//logger.debug(MapUtils.getString(emp,"empNm")+" fileName: "+fileName");
			emp.put("fileName", fileName);
			emp.put("filePath", filePath);
			emp.put("sendDate", sendDt);
			if(makeExcelYn) {		//emp.put("makeExcelYn", makeExcelYn);	
				emp.put("makeExcelYn", POSSIBLE);	
			}
			else {
				emp.put("makeExcelYn", "불가");
			}
		}

		String jsData = GridCodi.MaptoJson(empMailList);
		  
		return ResponseUtil.responseText(mv, jsData); 
	}

	/**
	 * 폴더 자동 생성
	 * 
	 * 매개 변수로 들어온 폴더가 있다면 아무일 하지 않고,
	 * 폴더가 없다면 해당 명칭으로 파일을 생성한다
	 * 폴더를 이미 있는 경우에만 true 반환
	 * 
	 * @param dir
	 * @return boolean
	 */
	private boolean checkFolder(File dir) {
		if ( !dir.exists() ) {	// 폴더가 없다면 
			if (dir.mkdir()) {	// 폴더 생성에 성공했다면
				logger.debug("폴더 생성 성공");
				return false;
			}
			else {				// 폴더를 만들지 못했다면
				logger.debug("폴더 생성 실패");
				return false;
			}
		}
		else { 					// 폴더가 존재한다면 true 반환
			logger.debug("폴더가 이미 존재합니다.");
			return true;
		} 
	}
	
	/**
	 * 가변인수 입출력 닫기
	 * 
	 * @param closeables
	 */
	private static void closeCleanly(Closeable... closeables) {
		for(Closeable c : closeables) {
			if(c != null) try {
				c.close();
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * 월급여 명세서 제목 생성 (메일 내용 용도)
	 * 
	 * @param year, month
	 * @return String
	 */
	private String makeSubject(String year, String month) {
		return year + "년 " + month + "월 급여명세서";
	}

	/**
	 * 개인 월급여 명세서 파일 이름 생성
	 * 
	 * @param year, month, empNo, empNm
	 * @return String
	 */
	private String makeFileName(String year, String month, String empNo, String empNm) {
		return INIT_FILE_NAME + year + month + NAME_SEPARATOR + empNo 
				+ NAME_SEPARATOR + empNm + ".xlsx";
	}
	
	/**
	 * 월급여 명세서 경로 생성 (윈도우용)
	 * 
	 * @param year, month, fileName
	 * @return String
	 * @throws Exception
	 */
	private String makeFilePathWin(String year, String month, String fileName) throws Exception {
		 return "C:" + FOLDER_SEPARATOR + DIRECTORY_TOP + FOLDER_SEPARATOR
				 + year + FOLDER_SEPARATOR + INDIVIDUAL_PAY_STUB + FOLDER_SEPARATOR
				 + month + FOLDER_SEPARATOR + fileName;
	}
	
	/**
	 * 월급여 명세서 경로 생성 (유눅스 계열 용)
	 * 
	 * @param year, month, fileName
	 * @return String
	 * @throws Exception
	 */
	private String makeFilePathNix(String year, String month, String fileName) throws Exception {
		 return INIT_NIX_PATH + FOLDER_SEPARATOR + DIRECTORY_TOP + FOLDER_SEPARATOR	 
				 + year + FOLDER_SEPARATOR + INDIVIDUAL_PAY_STUB + FOLDER_SEPARATOR
				 + month + FOLDER_SEPARATOR + fileName;
	}
	
	/**
	 * 월급여 개별 명세서 엑셀 생성
	 * 
	 * 1) 엑셀 파일 설정
	 * 2) 엑셀 파일 작성
	 * 3) 개별 급여명세서 출력
	 * 
	 * @param rqstMap
	 * @returnModelAndView
	 * @throws Exception
	 */
	public ModelAndView makeIndvPayStubExcel(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		final String DIRECTORY_YEAR = MapUtils.getString(rqstMap, "search_year");	// 작업 년도, 경로 지정에 사용
		final String DIRECTORY_MONTH = MapUtils.getString(rqstMap, "search_month");	// 작업 월, 경로 지정에 사용
		final String PAY_YEAR_MONTH = DIRECTORY_YEAR + DIRECTORY_MONTH;
		String fosPath = "";
		String empData = MapUtils.getString(rqstMap, "emplyee_excel_array");
		JSONArray empJArr;
		JSONObject empJObj;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		XSSFWorkbook wb;
		
		try {
			empJArr = PGPM0030Service.convertStrToJArr(empData);
			for (int i = 0; i < empJArr.size(); i++) {
				String empNo;			// 사원번호
				String empNm;			// 사원이름
				String makeExcelYn;		// 메일 전송 가능 여부
				String subject;			// 엑셀 내부 제목
				String fileName;		// 첨부 파일 경로
				String filePath;		// 첨부 파일 경로
				
				empJObj = (JSONObject) empJArr.get(i);
				makeExcelYn = empJObj.get("makeExcelYn").toString();
				// 해당 사원이 급여명세서를 만들 수 있을 때
				if(makeExcelYn.equals(POSSIBLE)) {										
					// 1) 제어할 엑셀 파일 설정
					empNo = empJObj.get("empNo").toString();
					empNm = empJObj.get("empNm").toString();
					fileName = makeFileName(DIRECTORY_YEAR, DIRECTORY_MONTH, empNo, empNm);
					subject = makeSubject(DIRECTORY_YEAR , DIRECTORY_MONTH);
					// 운영체제에 맞게 저장할 파일 경로 설정
					if(System.getProperty("os.name").toLowerCase().contains("win")) {		
						filePath = makeFilePathWin(DIRECTORY_YEAR, DIRECTORY_MONTH, fileName);
					}
					else {
						filePath = makeFilePathNix(DIRECTORY_YEAR, DIRECTORY_MONTH, fileName);
					}

					fis = new FileInputStream(SAMPLE_FILE_PATH.getFile());				// 양식 파일 받기
					wb = new XSSFWorkbook(fis);
					
					// 2) 엑셀 파일 작성
					fillPayStubSubject(wb, subject);									// 제목 채우기
					fillPayStubContent(wb, EXCEL_START_ROW, empNo, PAY_YEAR_MONTH);		// 내용 채우기
					
					// 3) 개별 급여명세서 출력
					fos = new FileOutputStream(filePath);
					wb.write(fos);

					logger.debug("개별 명세서 생성 완료 \n " + System.getProperty("user.dir"));
				}
			}
			
		}
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		finally {
			closeCleanly(fis, fos);
		}
		
		// 화면 refresh
		param.clear();
		param.put("search_year", DIRECTORY_YEAR);
		param.put("search_month", DIRECTORY_MONTH);
		
		return searchWorkFile(param);
	}
	
	/**
	 * 월급여 종합 명세서 엑셀 생성
	 * 
	 * 개별과 달리 항목별 합계 기능도 추가
	 * 
	 * 1) 운영체제에 맞게 저장할 파일 경로 설정
	 * 2) 지정된 모든 사원으로 내용 채우기
	 * 3) 종합 급여명세서 출력
	 * 
	 * @param rqstMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	public ModelAndView makeAllPayStubExcel(Map<?, ?> rqstMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		HashMap param = new HashMap<>();
		final String DIRECTORY_YEAR = MapUtils.getString(rqstMap, "search_year");	// 작업 년도, 경로 지정에 사용
		final String DIRECTORY_MONTH = MapUtils.getString(rqstMap, "search_month");	// 작업 월, 경로 지정에 사용
		final String PAY_YEAR_MONTH = DIRECTORY_YEAR + DIRECTORY_MONTH;
		String fosPath = "";
		String empData = MapUtils.getString(rqstMap, "emplyee_excel_array");
		JSONArray empJArr;
		JSONObject empJObj;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		XSSFWorkbook wb;
		
		try {
			String empNo;			// 사원번호
			String empNm;			// 사원이름
			String makeExcelYn;		// 메일 전송 가능 여부
			String subject;			// 엑셀 내부 제목
			String fileName;		// 엑셀 파일명
			int rowCnt = 0;
			
			// 1) 엑셀 파일 설정
			fileName = INIT_FILE_NAME + DIRECTORY_YEAR + DIRECTORY_MONTH + ".xlsx"; 
			subject = makeSubject(DIRECTORY_YEAR, DIRECTORY_MONTH);
			if(System.getProperty("os.name").toLowerCase().contains("win")) {
				fosPath = "C:" + FOLDER_SEPARATOR + DIRECTORY_TOP + FOLDER_SEPARATOR 
						+ DIRECTORY_YEAR + FOLDER_SEPARATOR + fileName;
			}
			else {
				fosPath = INIT_NIX_PATH + FOLDER_SEPARATOR + DIRECTORY_TOP + FOLDER_SEPARATOR 
						+ DIRECTORY_YEAR + FOLDER_SEPARATOR + fileName;
			}

			// 제어할 엑셀 파일
			fis = new FileInputStream(SAMPLE_FILE_PATH.getFile());	// 양식 파일 받기
			wb = new XSSFWorkbook(fis);
			
			fillPayStubSubject(wb, subject);						// 제목 채우기
			
			// 2) 지정된 모든 사원으로 내용 채우기
			empJArr = PGPM0030Service.convertStrToJArr(empData);
			for (int i = 0; i < empJArr.size(); i++) {
								
				empJObj = (JSONObject) empJArr.get(i);
				makeExcelYn = empJObj.get("makeExcelYn").toString();
				if(makeExcelYn.equals(POSSIBLE)) {					// 해당 인원이 급여 명세서를 만들 수 있을 때
					empNo = empJObj.get("empNo").toString();
					empNm = empJObj.get("empNm").toString();
					
					// 내용 채우기
					fillPayStubContent(wb, EXCEL_START_ROW + rowCnt * 2, empNo, PAY_YEAR_MONTH);	
					rowCnt++;
				}
			}
			
			fillPayStubFooter(wb, EXCEL_START_ROW + rowCnt * 2);	// 합계 채우기

			// 3) 종합 급여명세서 출력
			fos = new FileOutputStream(fosPath);
			wb.write(fos);

		} 
		catch (FileNotFoundException e) {
			e.printStackTrace();
		} 
		catch (IOException e) {
			e.printStackTrace();
		}
		finally {
			closeCleanly(fis, fos);
		}
		
		// 화면 refresh
		param.clear();
		param.put("search_year", DIRECTORY_YEAR);
		param.put("search_month", DIRECTORY_MONTH);
		
		return searchWorkFile(param);
	}
	
	/**
	 * 엑셀 제목 작성
	 * 
	 * 엑셀 파일 내에 위치하는 제목 작성
	 * 
	 * @param wb, subject
	 */
	private void fillPayStubSubject(XSSFWorkbook wb, String subject) {
		XSSFSheet sheet;												// 작업할 시트
		XSSFRow curRow = null;											// 작업할 행
		XSSFCell cell = null;											// 작업할 셀(열)
		
		sheet = wb.getSheetAt(0);										// 작업할 시트 위치, 첫 번째
		curRow = sheet.getRow(0);										// 첫 번째 행
		cell = curRow.getCell(0);										// 첫 번째 열
		cell.setCellValue(subject);										// 제목 작성
	}
	
	/**
	 * 엑셀 footer 작성
	 * 
	 * 엑셀 파일내 최하단의 항목별 합계 작성
	 * 
	 * @param wb, startRow
	 */
	private void fillPayStubFooter(XSSFWorkbook wb, int startRow) {
		XSSFSheet sheet;
		XSSFRow curRow = null;
		XSSFCell cell = null;
		XSSFRow tmpRow = null;
		int cellSum[] = {3, 4, 5, 6, 7, 8, 9, 10, 14, 16};
		int rowCnt = startRow;
		int sum = 0;
		
		// 폰트 설정
		Font fontText = wb.createFont();								// '합계'용
		fontText.setFontName("맑은 고딕");									// 글꼴, 맑은 고딕
		fontText.setFontHeight((short)(12*20));							// 12pt
		fontText.setBoldweight(Font.BOLDWEIGHT_BOLD);					// 굵게
		
		Font fontNum = wb.createFont();									// 금액 글꼴
		fontNum.setFontName("맑은 고딕");									// 글꼴, 맑은 고딕
		fontNum.setFontHeight((short)(10*20));							// 10pt
		
		// 스타일 설정
		XSSFDataFormat format = wb.createDataFormat();
		
		CellStyle styleNumUp = wb.createCellStyle();					
		styleNumUp.setAlignment(CellStyle.ALIGN_RIGHT);					// 오른쪽 정렬
		styleNumUp.setVerticalAlignment(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleNumUp.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleNumUp.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		styleNumUp.setBorderRight(XSSFCellStyle.BORDER_THIN);			// 오른쪽 테두리: 얇게
		styleNumUp.setBorderBottom(XSSFCellStyle.BORDER_THIN);			// 아래 테두리: 얇게
		styleNumUp.setFont(fontNum);									// 글꼴 적용
		styleNumUp.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumDown = wb.createCellStyle();
		styleNumDown.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumDown.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleNumDown.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleNumDown.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		styleNumDown.setBorderRight(XSSFCellStyle.BORDER_THIN);			// 오른쪽 테두리: 얇게
		styleNumDown.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleNumDown.setFont(fontNum);									// 글꼴 적용
		styleNumDown.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumDown2 = wb.createCellStyle();
		styleNumDown2.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumDown2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleNumDown2.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleNumDown2.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		styleNumDown2.setBorderLeft(XSSFCellStyle.BORDER_THIN);			// 왼쪽 테두리: 얇게
		styleNumDown2.setBorderRight(XSSFCellStyle.BORDER_THIN);		// 오른쪽 테두리: 얇게
		styleNumDown2.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleNumDown2.setFont(fontNum);									// 글꼴 적용
		styleNumDown2.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumDown3 = wb.createCellStyle();
		styleNumDown3.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumDown3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleNumDown3.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleNumDown3.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		styleNumDown3.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM);		// 왼쪽 테두리: 중간
		styleNumDown3.setBorderRight(XSSFCellStyle.BORDER_THIN);		// 오른쪽 테두리: 얇게
		styleNumDown3.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleNumDown3.setFont(fontNum);									// 글꼴 적용
		styleNumDown3.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
				
		CellStyle styleNumEnd = wb.createCellStyle();
		styleNumEnd.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumEnd.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleNumEnd.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleNumEnd.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		styleNumEnd.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM);			// 왼쪽 테두리: 중간
		styleNumEnd.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);		// 오른쪽 테두리: 중간
		styleNumEnd.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleNumEnd.setFont(fontNum);									// 글꼴 적용
		styleNumEnd.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleText = wb.createCellStyle();
		styleText.setAlignment(CellStyle.ALIGN_CENTER);					// 가운데 정렬
		styleText.setVerticalAlignment(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleText.setFillForegroundColor
					(IndexedColors.PALE_BLUE.getIndex());				// 배경색
		styleText.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);		
		styleText.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM);			// 왼쪽 테두리: 중간
		styleText.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);			// 오른쪽 테두리: 중간
		styleText.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);			// 아래 테두리: 아래
		styleText.setFont(fontText);									// 글꼴 적용
				
		// 사용 시트 위치
		sheet = wb.getSheetAt(0);
				
		// 셀 병합
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 0, 2));
		for(int cellNum : cellSum) {
			sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, cellNum, cellNum));
		}
			
		// 첫쨰 행
		curRow = sheet.createRow(startRow);

		for(int i=0; i < 16; i++) {
			cell = curRow.createCell(i);
			
			// 스타일 지정
			if(i == 8) {
				cell.setCellStyle(styleNumDown3);
			}
			else {
				cell.setCellStyle(styleNumUp);
			}
		}
		cell = curRow.createCell(16);
		cell.setCellStyle(styleNumEnd);
		
		// '합계' 작성
		cell = curRow.createCell(0);
		cell.setCellStyle(styleText);
		cell.setCellValue("합   계");
		cell = curRow.createCell(1);
		cell.setCellStyle(styleText);
		cell = curRow.createCell(2);
		cell.setCellStyle(styleText);
		
		for(int cellNum : cellSum) {
			rowCnt = startRow;
			sum = 0;
			tmpRow = null;
			while(rowCnt-- > EXCEL_START_ROW) {
				sum += new Double(sheet.getRow(rowCnt).getCell(cellNum).getNumericCellValue()).intValue();
			}
			cell = curRow.getCell(cellNum);
			cell.setCellValue(sum);
		}
		
		// 직원예수금 (국민연금, 고용보험, 건강보험)
		for(int i=11; i < 14; i++) {
			sum = 0;
			tmpRow = null;
			
			for(int j = startRow; j >= EXCEL_START_ROW; j-=2) {
				sum += new Double(sheet.getRow(j).getCell(i).getNumericCellValue()).intValue();
			}
			
			cell = curRow.getCell(i);
			cell.setCellValue(sum);
		}
		
		// 본인공제총액
		sum = 0;
		tmpRow = null;
		for(int j = startRow; j >= EXCEL_START_ROW; j-=2) {
			sum += new Double(sheet.getRow(j).getCell(15).getNumericCellValue()).intValue();
		}		
		cell = curRow.getCell(15);
		cell.setCellValue(sum);
				
		// 둘째 행
		curRow = sheet.createRow(startRow+1);
		
		for(int i=0; i < 16; i++) {
			cell = curRow.createCell(i);
			if(i == 8) {
				cell.setCellStyle(styleNumDown3);
			}
			else {
				cell.setCellStyle(styleNumDown);
			}
		}
		cell = curRow.createCell(16);
		cell.setCellStyle(styleNumEnd);

		// '합계' 작성
		cell = curRow.createCell(0);
		cell.setCellStyle(styleText);
		cell = curRow.createCell(1);
		cell.setCellStyle(styleText);
		cell = curRow.createCell(2);
		cell.setCellStyle(styleText);
		
		// 회사부담금 (국민연금, 고용보험, 건강보험)
		for(int i=11; i < 14; i++) {
			sum = 0;
			tmpRow = null;
			
			for(int j = startRow+1; j >= EXCEL_START_ROW; j-=2) {
				sum += new Double(sheet.getRow(j).getCell(i).getNumericCellValue()).intValue();
			}
			
			cell = curRow.getCell(i);
			cell.setCellValue(sum);
		}
		
		// 회사부담총액
		sum = 0;
		tmpRow = null;
		for(int j = startRow+1; j >= EXCEL_START_ROW; j-=2) {
			sum += new Double(sheet.getRow(j).getCell(15).getNumericCellValue()).intValue();
		}		
		cell = curRow.getCell(15);
		cell.setCellValue(sum);
		
		// 셋째 행
		curRow = sheet.createRow(startRow+2);
		
		cell = curRow.createCell(11);
		cell.setCellStyle(styleNumDown2);
		for(int i=12; i < 14; i++) {
			cell = curRow.createCell(i);
			cell.setCellStyle(styleNumDown);
		}		
				
		// 4대 보험 합계 (국민연금, 고용보험, 건강보험)
		for(int i=11; i < 14; i++) {
			sum = 0;
			tmpRow = null;
			
			sum += new Double(sheet.getRow(startRow).getCell(i).getNumericCellValue()).intValue();
			sum += new Double(sheet.getRow(startRow+1).getCell(i).getNumericCellValue()).intValue();
			
			cell = curRow.getCell(i);
			cell.setCellValue(sum);
		}
	}
	
	/**
	 * 엑셀 사원 정보 작성
	 * 
	 * 엑셀 파일 내 전달 받은 사원의 정보 및 급여내역 작성
	 * 
	 * @param wb, startRow, empNo, payYm
	 * @throws RuntimeException, Exception
	 */
	private void fillPayStubContent(XSSFWorkbook wb, int startRow, String empNo, String payYm)
								throws RuntimeException, Exception {
		XSSFSheet sheet = null;
		XSSFRow curRow = null;
		XSSFCell cell = null;
		HashMap param = new HashMap<>();
		String picArr1[] = {"noooooooo",
				"noooooooo","noooooooo","101000000","102000000","103010000",
				"103020000","100000000","201010000","201020000","202000000",
				"203010100","203020100","203030100","206000000","700000000",
				"900000000" };
		String picArr2[] = {"noooooooo",
				"noooooooo","noooooooo","noooooooo","noooooooo","103030000",
			 	"103040000","noooooooo","noooooooo","noooooooo","noooooooo",
			 	"203010200","203020200","203030200","noooooooo","800000000",
				"noooooooo" };
		List<Map> payInfoList = null;
		List<Map> empInfoList = null;
		Map empInfo = null;
		Map payInfo = new HashMap<String, Integer>();
		Map tmpMap = null;
		String value = "";
		
		param.put("empNo", empNo);
		empInfoList = pgpm0030Mapper.findEmpList(param);				// 직원 정보 조회
		empInfo = empInfoList.get(0);
		param.put("payYm", payYm);
		payInfoList = pgpm0070Mapper.findIndvPayMnt(param);				// 해당월 개인월급여 조회
		for(int i=0; i<payInfoList.size(); i++) {
			Map tmp = payInfoList.get(i);
			value = MapUtils.getString(tmp, "payItmCd");
			payInfo.put(value, i);
		}
		// 글꼴 설정
		Font font = wb.createFont();									
		font.setFontName("맑은 고딕");										// 글꼴, 맑은 고딕
		font.setFontHeight((short)(10*20));								// 10pt
		
		// 스타일 설정
		XSSFDataFormat format = wb.createDataFormat();					// 마스크 지정용
		
		CellStyle styleText = wb.createCellStyle();
		styleText.setAlignment(CellStyle.ALIGN_CENTER);					// 가운데 정렬
		styleText.setVerticalAlignment(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleText.setBorderLeft(XSSFCellStyle.BORDER_THIN);				// 왼쪽 테두리: 얇게
		styleText.setFont(font);										// 폰트 적용
		
		CellStyle styleTextUp = wb.createCellStyle();
		styleTextUp.setAlignment(CellStyle.ALIGN_CENTER);				// 가운데 정렬
		styleTextUp.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleTextUp.setBorderLeft(XSSFCellStyle.BORDER_THIN);			// 왼쪽 테두리: 얇게
		styleTextUp.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);		// 오른쪽 테두리: 중간
		styleTextUp.setBorderBottom(XSSFCellStyle.BORDER_THIN);			// 아래 테두리: 얇게
		styleTextUp.setFont(font);										// 폰트 적용
		
		CellStyle styleTextDown = wb.createCellStyle();
		styleTextDown.setAlignment(CellStyle.ALIGN_CENTER);				// 가운데 정렬
		styleTextDown.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleTextDown.setBorderLeft(XSSFCellStyle.BORDER_THIN);			// 왼쪽 테두리: 얇게
		styleTextDown.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);		// 오른쪽 테두리: 중간
		styleTextDown.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleTextDown.setFont(font);									// 폰트 적용
		
		CellStyle styleTextDown2 = wb.createCellStyle();
		styleTextDown2.setAlignment(CellStyle.ALIGN_CENTER);			// 가운데 정렬
		styleTextDown2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleTextDown2.setBorderLeft(XSSFCellStyle.BORDER_MEDIUM);		// 왼쪽 테두리: 중간
		styleTextDown2.setBorderRight(XSSFCellStyle.BORDER_THIN);		// 오른쪽 테두리: 얇게
		styleTextDown2.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);	// 아래 테두리: 중간
		styleTextDown2.setFont(font);									// 폰트 적용
				
		CellStyle styleNumUp = wb.createCellStyle();
		styleNumUp.setAlignment(CellStyle.ALIGN_RIGHT);					// 오른쪽 정렬
		styleNumUp.setVerticalAlignment(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleNumUp.setBorderRight(XSSFCellStyle.BORDER_THIN);			// 오른쪽 테두리: 얇게
		styleNumUp.setBorderBottom(XSSFCellStyle.BORDER_THIN);			// 아래 테두리: 얇게
		styleNumUp.setFont(font);										// 폰트 적용
		styleNumUp.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumUpBdR = wb.createCellStyle();
		styleNumUpBdR.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumUpBdR.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	// 높이 가운데 정렬
		styleNumUpBdR.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);		// 오른쪽 테두리: 중간
		styleNumUpBdR.setBorderBottom(XSSFCellStyle.BORDER_THIN);		// 아래 테두리: 얇게
		styleNumUpBdR.setFont(font);									// 폰트 적용
		styleNumUpBdR.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumDown = wb.createCellStyle();
		styleNumDown.setAlignment(CellStyle.ALIGN_RIGHT);				// 오른쪽 정렬
		styleNumDown.setVerticalAlignment
									(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleNumDown.setBorderRight(XSSFCellStyle.BORDER_THIN);			// 오른쪽 테두리: 얇게
		styleNumDown.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);		// 아래 테두리: 중간
		styleNumDown.setFont(font);										// 폰트 적용
		styleNumDown.setDataFormat(format.getFormat("#,##0"));			// 천단위 마스크
		
		CellStyle styleNumDownBdR = wb.createCellStyle();
		styleNumDownBdR.setAlignment(CellStyle.ALIGN_RIGHT);			// 오른쪽 정렬
		styleNumDownBdR.setVerticalAlignment
									(CellStyle.VERTICAL_CENTER);		// 높이 가운데 정렬
		styleNumDownBdR.setBorderRight(XSSFCellStyle.BORDER_MEDIUM);	// 오른쪽 테두리: 중간
		styleNumDownBdR.setBorderBottom(XSSFCellStyle.BORDER_MEDIUM);	// 아래 테두리: 중간
		styleNumDownBdR.setFont(font);									// 폰트 적용
		styleNumDownBdR.setDataFormat(format.getFormat("#,##0"));		// 천단위 마스크
		
		// 엑셀의 시작은 0,0
		sheet = wb.getSheetAt(0);			// 첫번째 시트에서
		
		// 셀 병합
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 0, 0));	// 사번
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 1, 1));	// 이름
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 3, 3));	// 기본급
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 4, 4));	// 인센티브
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 7, 7));	// 급여총액
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 8, 8));	// 갑근세
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 9, 9));	// 주민세
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 10, 10));	// 사우회비
		sheet.addMergedRegion(new CellRangeAddress(startRow, startRow+1, 16, 16));	// 차인지급액
		
		curRow = sheet.createRow(startRow);	// 작업 행
				
		for(int i=0; i<picArr1.length; i++) {
			cell = curRow.createCell(i);

			// 스타일 지정
			if(i == 7 || i == 15 || i == 16) {
				cell.setCellStyle(styleNumUpBdR);
			}
			else {
				cell.setCellStyle(styleNumUp);
			}
			
			if(picArr1[i].equals("noooooooo")) continue;
						
			value = MapUtils.getString(payInfo, picArr1[i]);
			tmpMap = payInfoList.get(Integer.parseInt(value));
			value = MapUtils.getString(tmpMap, "itmAmt");
			cell.setCellValue(Integer.parseInt(value));
		}
		
		// 사번
		cell = curRow.createCell(0);
		cell.setCellStyle(styleTextDown2);
		cell.setCellValue(empNo);
		
		// 이름
		cell = curRow.createCell(1);
		cell.setCellStyle(styleText);
		value = MapUtils.getString(empInfo, "empNm");
		cell.setCellValue(value);
		
		// 부서
		cell = curRow.createCell(2);
		cell.setCellStyle(styleTextUp);
		value = MapUtils.getString(empInfo, "deptCd");					// 부서코드
		param.clear();									
		param.put("codeGroupNo", 89);
		param.put("code", value);
		tmpMap = pgpm0010Mapper.findCmmnCode(param);					// 부서명 찾기
		value = MapUtils.getString(tmpMap, "codeNm");
		cell.setCellValue(value);
		
		curRow = sheet.createRow(startRow+1);							// 둘째 행에서
				
		for(int i=0; i<picArr2.length; i++) {
			cell = curRow.createCell(i);
			
			// 스타일 지정
			if(i == 0) {
				cell.setCellStyle(styleTextDown2);
			}
			else if(i == 7 || i == 15 || i == 16) {
				cell.setCellStyle(styleNumDownBdR);
			}
			else {
				cell.setCellStyle(styleNumDown);
			}
			
			if(picArr2[i].equals("noooooooo")) continue;
			
			value = MapUtils.getString(payInfo, picArr2[i]);
			tmpMap = payInfoList.get(Integer.parseInt(value));
			value = MapUtils.getString(tmpMap, "itmAmt");
			cell.setCellValue(Integer.parseInt(value));
		}

		// 직위
		cell = curRow.createCell(2);
		cell.setCellStyle(styleTextDown);
		value = MapUtils.getString(empInfo, "posCd");					// 직급 코드
		param.clear();								
		param.put("codeGroupNo", 31);
		param.put("code", value);
		tmpMap = pgpm0010Mapper.findCmmnCode(param);					// 직급명 찾기
		value = MapUtils.getString(tmpMap, "codeNm");
		cell.setCellValue(value);
	}
}