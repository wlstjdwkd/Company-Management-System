package com.comm.response;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comm.response.IExcelVO;

/**
 * 기본 엑셀 생성VO
 */
public class ExcelVO implements IExcelVO {

    private static Logger logger = LoggerFactory.getLogger(ExcelVO.class);

    private String fileNmae = "";

    public ExcelVO() {

    }

    public ExcelVO(String fileName) {
        super();
        this.fileNmae = fileName;
    }

    @Override
    public void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model) {

        @SuppressWarnings("unchecked")
        List<Map> list = (List<Map>) model.get("_list");
        Object[] headers = (Object[]) model.get("_headers");
        String[] items = (String[]) model.get("_items");

        Sheet sheet = workbook.createSheet();

        //헤더 색상 변경
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
        headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        colIndex = 0;
        Row header = sheet.createRow(0);
        for(Object head : headers) {
            if(head instanceof String) {
            	Cell headerCell = header.createCell(colIndex++);
            	headerCell.setCellValue(head.toString());
            	headerCell.setCellStyle(headerStyle);
            } else if(head instanceof String[]) {
                for(String strHead : (String[]) head) {
                	Cell headerCell = header.createCell(colIndex++);
                	headerCell.setCellValue(strHead);
                	headerCell.setCellStyle(headerStyle);
                }
            }
        }

        int rowIndex = 1;
        colIndex = 0;
        Row row;
        for(Map map : list) {
            row = sheet.createRow(rowIndex++);
            for(String item : items) {

                Object value = MapUtils.getObject(map, item);
                if(value != null) {
                    setCellValue(row, value, workbook);
                } else {
                    row.createCell(colIndex++).setCellValue("");
                }
            }
            colIndex = 0;
        }

        //width 지정
        for(int i = 0; i < headers.length; i++) {
        	sheet.autoSizeColumn(i);
        	sheet.setColumnWidth(i, (sheet.getColumnWidth(i)+2000));
        }

        //시트명 -> 제목과 동일하게 지정
        workbook.setSheetName(0, getFileName());
    }

    private int colIndex = 0;

    @SuppressWarnings("unchecked")
    private void setCellValue(Row row, Object value, Workbook workbook) {
    	//숫자 포맷팅 위해
        CellStyle colNumStyle = workbook.createCellStyle();
        XSSFDataFormat format = (XSSFDataFormat)workbook.createDataFormat();

        if(value instanceof Float) {
            row.createCell(colIndex++).setCellValue(((Float) value).doubleValue() + "%");

        } else if(value instanceof Integer) {
            row.createCell(colIndex++).setCellValue(((Integer) value).doubleValue());

        } else if(value instanceof List) {

            for(int i = 0 ; i < ((List<Integer>) value).size() ; i++) {
                Integer _value = ((List<Integer>) value).get(i);
                setCellValue(row, _value, workbook);
            }
        } else if(value instanceof Number) {
        	String strVal = String.valueOf(value);
        	int idx = strVal.indexOf(".");
        	if(idx > 0) colNumStyle.setDataFormat(format.getFormat("#,##0.######"));
        	else colNumStyle.setDataFormat(format.getFormat("#,###"));

        	Cell cell = row.createCell(colIndex++);
        	cell.setCellValue(((Number) value).doubleValue());
        	cell.setCellStyle(colNumStyle);
        } else {
            row.createCell(colIndex++).setCellValue(value.toString());
        }
    }

    @Override
    public String getFileName() {

        return this.fileNmae;
    }

}
