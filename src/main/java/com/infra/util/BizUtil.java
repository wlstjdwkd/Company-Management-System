package com.infra.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BizUtil {

	private static final Logger logger = LoggerFactory.getLogger(BizUtil.class);
	/**
	 * 확인서발행가능 최종년도
	 * 
	 * @param month
	 *            결산월
	 * @return String 최종년도
	 * @throws Exception
	 */
	public static int getLastIssuYear(int acctMonth) throws Exception {

		int addMonth = 4;
		int defaultDay = 1;
		Calendar curCal = Calendar.getInstance();
		int curYear = curCal.get(Calendar.YEAR); // 현재년도
		curCal.set(Calendar.DATE, defaultDay);

		int acctMonth4Cal = acctMonth - 1;
		int lastYear; // 확인서발행가능최종년도
		if ((acctMonth4Cal + addMonth) <= 12) {
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.YEAR, curYear);
			cal.set(Calendar.MONTH, acctMonth4Cal);
			cal.set(Calendar.DATE, defaultDay);
			cal.add(Calendar.YEAR, addMonth);
			// 현재년월<(현재년||결산월+4개월)
			if (curCal.before(cal)) {
				lastYear = curYear - 1; // 현재년도-1
			} else {
				lastYear = curYear; // 현재년도
			}
		} else {
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.YEAR, curYear - 1);
			cal.set(Calendar.MONTH, acctMonth4Cal);
			cal.set(Calendar.DATE, defaultDay);
			cal.add(Calendar.YEAR, addMonth);
			// 현재년월<((현재년-1)||(결산월+4개월))
			if (curCal.before(cal)) {
				lastYear = curYear - 2; // 현재년도-2
			} else {
				lastYear = curYear - 1; // 현재년도-1
			}
		}

		return lastYear;
	}

	/**
	 * 엑셀파일 파싱
	 * 
	 * @param columList
	 * @param columparam
	 * @param file
	 * @param sheetidx
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> paserExcelFile(String[] columList, String[] columparam, File file, int sheetidx)
			throws Exception {
		
		InputStream ins = null;
		List<Map<String, Object>> resultList = null;
		
		try {
			ins = new FileInputStream(file);
			resultList = paserExcelFile(columList, columparam, ins, sheetidx);
		} catch (Exception e) {
			
		} finally {
			if (ins != null) ins.close();
		}

		return resultList;
	}
	
	/**
	 * 엑셀파일 파싱
	 * 
	 * @param columList
	 * @param columparam
	 * @param inputstream
	 * @param sheetidx
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String, Object>> paserExcelFile(String[] columList, String[] columparam, InputStream ins, int sheetidx)
			throws Exception {

		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Row row = null;
		Cell cell = null;
		Boolean columinfo = true;
		int columcnt = 0;
		HashMap paraminfo = new HashMap();
		int[] columidx = new int[columList.length];

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(ins);

		int sheetCn = workbook.getNumberOfSheets();

		// 0번째 sheet 정보 취득
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(sheetidx);

		// 취득된 sheet에서 rows수 취득
		int rows = sheet.getPhysicalNumberOfRows();

		// 취득된 row에서 취득대상 cell수 취득
		int cells = sheet.getRow(sheetidx).getPhysicalNumberOfCells();

		for (int r = 0; r < rows; r++) {
			row = sheet.getRow(r); // row 가져오기
			if (row != null) {
				if (columinfo) {
					for (int c = 0; c < cells; c++) {
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
							for (int j = 0; j < columList.length; j++) {
								logger.debug("###### value ====> "+ value);
								logger.debug("###### columList ====> "+ columList[j]);
								
								if (value.equals(columList[j])) {
									paraminfo.put(c, columparam[j]);
									columidx[columcnt] = c;
									columcnt++;
								}
							}

							if (columcnt == columList.length) {
								columinfo = false;
							}
						} else {
						}
					} // for(c) 문
				} else {
					Map<String, Object> dataMap = new HashMap<String, Object>();

					for (int c = 0; c < columidx.length; c++) {
						cell = row.getCell(columidx[c]);

						if (cell != null) {
							String value = null;
							switch (cell.getCellType()) {
							case Cell.CELL_TYPE_FORMULA:
								value = cell.getCellFormula();
								break;
							case Cell.CELL_TYPE_NUMERIC:
								logger.debug("####### 숫자 ===> " + cell.getNumericCellValue());
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
							dataMap.put((String) paraminfo.get(c), value);
						} else {
						}
					}
					resultList.add(dataMap);
				}
			}
		}
		return resultList;
	}	
}
