package com.infra.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.infra.file.FileVO;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.opencsv.CSVReader;

public class BizUtilTest {
	private static final Logger logger = LoggerFactory.getLogger(BizUtilTest.class);
	
	public static Map<String, Object> checkFile(HashMap param,  String[] columparam, List<FileVO> file) throws Exception{
		logger.debug("#########################################################");
		logger.debug("#########################BizUtilTest#######################");
		logger.debug("#########################################################");

		String FDelimiter = (String) param.get("FDelimiter");
		String FEncoding= (String) param.get("FEncoding");
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> errorList = new ArrayList<Map<String, Object>>();

		InputStream ins = new FileInputStream(file.get(0).getFile());
		if(file.get(0).getFileExt().equals("xls") || file.get(0).getFileExt().equals("xlsx")){	// 엑셀 파일
			logger.debug("#################################################");
			logger.debug("################# EXCEL FILE UPLOAD ##################");
			logger.debug("#################################################");
			
			Workbook workbook = null;
			try{
				workbook = WorkbookFactory.create(ins);
				Sheet sheet = workbook.getSheetAt(0);
				int rows = sheet.getPhysicalNumberOfRows();
				Map<String, Object> errorMap = new HashMap<String, Object>();
				
				for(int r = 1; r < rows; r++ ){
					Row row = sheet.getRow(r); 	// row 가져오기
					Cell cell = null;
					Map<String, Object> dataMap = new HashMap<String, Object>();
					for (int c = 0; c < columparam.length; c++) {
						cell = row.getCell(c);
	
						if (cell != null) {
							String value = null;
							switch (cell.getCellType()) {
							case Cell.CELL_TYPE_FORMULA:
								value = cell.getCellFormula();
								break;
							case Cell.CELL_TYPE_NUMERIC:
								value = "" + cell.getNumericCellValue();
								break;
							case Cell.CELL_TYPE_STRING:
								value = "" + cell.getStringCellValue();
								break;
							case Cell.CELL_TYPE_BLANK:
								value = "";
								break;
							case Cell.CELL_TYPE_ERROR:
								value = "" + cell.getErrorCellValue();
								break;
							default:
							}
							
							dataMap.put((String) columparam[c], value);
							
							/*
							 * 데이터 검증
							 */
							// 숫자 체크
							if(columparam[c].equals("drposqotaRt") &&!NumberUtils.isNumber(MapUtils.getString(dataMap, "drposqotaRt"))){  // isNumber()은 정수, 실수 / isDigits는 자연수 / isNumeric은 자연수, 공백
								errorMap.put("name", "직접소유지분율");
								errorMap.put("reason", "Type");
								errorList.add(errorMap);
								map.put("errorList", errorList);
								
								return map;
							};

							if(columparam[c].equals("ndrposqotaRt1") &&!NumberUtils.isNumber(MapUtils.getString(dataMap, "ndrposqotaRt1"))){  // isNumber()은 정수, 실수 / isDigits는 자연수 / isNumeric은 자연수, 공백
								errorMap.put("name", "간접소유지분율1");
								errorMap.put("reason", "Type");
								errorList.add(errorMap);
								map.put("errorList", errorList);
							
								return map;
							};
						}
					}
					
					resultList.add(dataMap);
				}
			}catch(Exception e){
	            logger.error("엑셀파일을 파싱하던 중 에러가 발생하였습니다.", e);
			}finally{
				
			}
			map.put("resultList", resultList);
		} else {	// csv 파일
			logger.debug("########################################");
			logger.debug("############# CSV file upload ##############");
			logger.debug("########################################");
			
			CSVReader reader = null;
			try{
				reader = new CSVReader(new InputStreamReader(ins, FEncoding), FileUtil.getDelimiter(FDelimiter));
				
				String[] row;
				int rowcnt = 0;
				Map<String, Object> errorMap = new HashMap<String, Object>();
				
				while((row = reader.readNext()) != null){
					if(rowcnt > 0){
						Map<String, Object> dataMap = new LinkedHashMap<String, Object>();
						for(int c = 0; c<columparam.length; c++){
							
							if(!StringUtils.trimToEmpty(row[c]).equals("")) {
								dataMap.put(columparam[c],  StringUtils.trimToEmpty(row[c]));

								/*
								 * 데이터 검증
								 */
								// 숫자 체크
								if(columparam[c].equals("drposqotaRt") && !NumberUtils.isNumber(StringUtils.trimToEmpty(row[c]))){  // isNumber()은 정수, 실수 / isDigits는 자연수 / isNumeric은 자연수, 공백
									errorMap.put("name", "직접소유지분율");
									errorMap.put("reason", "Type");
									errorList.add(errorMap);
									map.put("errorList", errorList);
									
									return map;
								};

								if(columparam[c].equals("ndrposqotaRt1") && !NumberUtils.isNumber(StringUtils.trimToEmpty(row[c]))){  // isNumber()은 정수, 실수 / isDigits는 자연수 / isNumeric은 자연수, 공백
									errorMap.put("name", "간접소유지분율1");
									errorMap.put("reason", "Type");
									errorList.add(errorMap);
									map.put("errorList", errorList);
								
									return map;
								};

							}
						}

						resultList.add(dataMap);
					}
					rowcnt++;
				}
			}catch(Exception e){
	            logger.error("CSV 파일을 파싱하던 중 에러가 발생하였습니다.", e);
			}finally{
				
			}
			map.put("resultList", resultList);
		}
		
		return map;
	}
}
