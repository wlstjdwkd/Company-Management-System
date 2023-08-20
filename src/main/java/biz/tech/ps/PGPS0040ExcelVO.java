package biz.tech.ps;

import java.util.List;
import java.util.Map;

import com.comm.response.IExcelVO;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 외투기업별현황 엑셀
 */
public class PGPS0040ExcelVO implements IExcelVO {

	private static Logger logger = LoggerFactory.getLogger(PGPS0040ExcelVO.class);

    private String fileNmae = "";
    private int colIndex = 0;
    
    public PGPS0040ExcelVO() {

    }

    public PGPS0040ExcelVO(String fileName) {
        super();
        this.fileNmae = fileName;
    }
    
    @Override
    public void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model) {

        @SuppressWarnings("unchecked")
        List<Map> list = (List<Map>) model.get("_list");
        Object[] headers = (Object[]) model.get("_headers");
        Object[] subHeaders = (Object[]) model.get("_subHeaders");
        String[] items = (String[]) model.get("_items");
        
        Sheet sheet = workbook.createSheet();

        // 헤더 로우 설정
        Row header = sheet.createRow(0);
        Row subHeader = sheet.createRow(1);
        
        colIndex = 0;
        // Header 생성
        for(Object head : headers) {
            if(head instanceof String) {
            	header.createCell(colIndex++).setCellValue(head.toString());
            } else if(head instanceof String[]) {
                for(String strHead : (String[]) head) {
                	header.createCell(colIndex++).setCellValue(strHead);
                }
            }
        }
        
        colIndex = 0;
        // Header 생성 및 병합
        if (items[colIndex].equals("upperNm") || items[colIndex].equals("abrv")) {
        	sheet.addMergedRegion(new CellRangeAddress(0, 1, colIndex, colIndex));	// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
        	colIndex++;
        }
        if (items[colIndex].equals("indutySeNm") || items[colIndex].equals("dtlclfcNm") || items[colIndex].equals("indutyNm")) {
        	sheet.addMergedRegion(new CellRangeAddress(0, 1, colIndex, colIndex));
        	colIndex++;
        }

        // Sub Header 생성
        for(Object subHead : subHeaders) {
            if(subHead instanceof String) {
            	subHeader.createCell(colIndex++).setCellValue(subHead.toString());
            } else if(subHead instanceof String[]) {
                for(String strHead : (String[]) subHead) {
                	subHeader.createCell(colIndex++).setCellValue(strHead);
                }
            }
        }

        // 헤더병합(금액)
        colIndex = 0;
        // Header 생성 및 병합
        if (items[colIndex].equals("upperNm") || items[colIndex].equals("abrv")) {
        	colIndex++;
        }
        if (items[colIndex].equals("indutySeNm") || items[colIndex].equals("dtlclfcNm") || items[colIndex].equals("indutyNm")) {
        	colIndex++;
        }
        
        sheet.addMergedRegion(new CellRangeAddress(0, 0, colIndex, ++colIndex));
        colIndex++;
        sheet.addMergedRegion(new CellRangeAddress(0, 0, colIndex, ++colIndex));
        colIndex++;
        sheet.addMergedRegion(new CellRangeAddress(0, 0, colIndex, ++colIndex));
        
        //------------------------------------ 데이터 부분 -----------------------------------
        
        int rowIndex = 2;
        colIndex = 0;
        Row row;
        for(Map map : list) {
            row = sheet.createRow(rowIndex++);
            for(String item : items) {
            	
                Object value = MapUtils.getObject(map, item);                
                if(value != null) {
                    setCellValue(row, value);
                } else {
                    row.createCell(colIndex++).setCellValue("");
                }
            }
            colIndex = 0;
        }
        
    }


    @SuppressWarnings("unchecked")
    private void setCellValue(Row row, Object value) {

        if(value instanceof Float) {
            row.createCell(colIndex++).setCellValue(((Float) value).doubleValue() + "%");

        } else if(value instanceof Integer) {
            row.createCell(colIndex++).setCellValue(((Integer) value).doubleValue());

        } else if(value instanceof List) {

            for(int i = 0 ; i < ((List<Integer>) value).size() ; i++) {
                Integer _value = ((List<Integer>) value).get(i);
                setCellValue(row, _value);
            }
        } else if(value instanceof Number) {
        	row.createCell(colIndex++).setCellValue(((Number) value).doubleValue());
        }  else {
            row.createCell(colIndex++).setCellValue(value.toString());
        }
    }

    @Override
    public String getFileName() {

        return this.fileNmae;
    }

}
