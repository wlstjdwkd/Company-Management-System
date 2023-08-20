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
 *진입시기별 성장현황 > 성장현황 엑셀형식
 */
public class PGPS0063ExcelVO implements IExcelVO {

	private static Logger logger = LoggerFactory.getLogger(PGPS0063ExcelVO.class);

    private String fileNmae = "";

    public PGPS0063ExcelVO() {

    }

    public PGPS0063ExcelVO(String fileName) {
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
        
        String gSelect1 = (String)model.get("gSelect1");
        String gSelect2 = (String)model.get("gSelect2");
        
        Sheet sheet = workbook.createSheet();
        
        /*
         * IssuExcelVO.java, PGIM0030Service.java 참조
         */
        
        // 헤더 로우 설정
        Row header = sheet.createRow(0);
        Row subHeader = sheet.createRow(1);
        
        colIndex = 3;
        if(("G".equals(gSelect1) && "G".equals(gSelect2)) || ("W".equals(gSelect1) && "W".equals(gSelect2))){
        	colIndex = 3;
        }else if("G".equals(gSelect1) && "W".equals(gSelect2)){
        	colIndex = 2;
        }else if("W".equals(gSelect1) && "G".equals(gSelect2)){
        	colIndex = 2;
        }
        
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
        
        colIndex = 3;		// 초기화
        if(("G".equals(gSelect1) && "G".equals(gSelect2)) || ("W".equals(gSelect1) && "W".equals(gSelect2))){
        	colIndex = 3;
        }else if("G".equals(gSelect1) && "W".equals(gSelect2)){
        	colIndex = 2;
        }else if("W".equals(gSelect1) && "G".equals(gSelect2)){
        	colIndex = 2;
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
        
        // Header 생성 및 병합
        if(("G".equals(gSelect1) && "G".equals(gSelect2)) || ("W".equals(gSelect1) && "W".equals(gSelect2))){
	        header.createCell(0).setCellValue("지역");
	        header.createCell(1).setCellValue("업종");
	        header.createCell(2).setCellValue("기업수(개)");
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 2, 2));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 4));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 5, 6));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 7, 8));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 10));
	        
        }else if("G".equals(gSelect1) && "W".equals(gSelect2)){
	        header.createCell(0).setCellValue("업종");
	        header.createCell(1).setCellValue("기업수(개)");
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 2, 3));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 4, 5));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 6, 7));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 8, 9));
	        
        }else if("W".equals(gSelect1) && "G".equals(gSelect2)){
        	header.createCell(0).setCellValue("지역");
	        header.createCell(1).setCellValue("기업수(개)");
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 0));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        sheet.addMergedRegion(new CellRangeAddress(0, 1, 1, 1));			// 헤더 병합 (시작로우, 종료로우, 시작컬럼, 종료컬럼)
	        
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 2, 3));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 4, 5));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 6, 7));
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 8, 9));
        }
        
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

    private int colIndex = 0;

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
        } else {
            row.createCell(colIndex++).setCellValue(value.toString());
        }
    }

    @Override
    public String getFileName() {

        return this.fileNmae;
    }

}
