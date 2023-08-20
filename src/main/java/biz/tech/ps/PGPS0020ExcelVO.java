package biz.tech.ps;

import java.util.ArrayList;
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
public class PGPS0020ExcelVO implements IExcelVO {

	private static Logger logger = LoggerFactory.getLogger(PGPS0020ExcelVO.class);

    private String fileNmae = "";
    private int colIndex = 0;
    
    public PGPS0020ExcelVO() {

    }

    public PGPS0020ExcelVO(String fileName) {
        super();
        this.fileNmae = fileName;
    }
    
    @Override
    public void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model) {

    	@SuppressWarnings("unchecked")
        List<Map> list = (List<Map>) model.get("_list");
        Object[] headers = (Object[]) model.get("_headers");
        String[] items = (String[]) model.get("_items");        
        int searchIndex = (Integer) model.get("searchIndex");	//기준 컬럼index
        
        ArrayList<String> columnList = (ArrayList<String>) model.get("columnList");
        int columListLen = columnList.size();
  
        int startYr = (Integer)model.get("stdyySt");
        int endYr = (Integer)model.get("stdyyEd");                       
                        
        Sheet sheet = workbook.createSheet();

        // 헤더 로우 설정
        Row header = sheet.createRow(0);        
        
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

        //------------------------------------ 데이터 부분 -----------------------------------           
        int rowIndex = 1;
        Row row;           
        
        for(Map map : list) {
        	
        	row = sheet.createRow(rowIndex++);
        	
        	for(int i=0; i<items.length; i++) {
            	String item = items[i];
            	Object value = MapUtils.getObject(map, item);
            	
            	if(value != null) {            		
                    setCellValue(row, value);
                }
            }
        	
        	String columNM = columnList.get((rowIndex - 2)%columListLen);
        	
        	if(searchIndex == 1) {
        		if(columNM.equals("sumEntrprsCo")) {setCellValue(row, "기업수(개)");}        		        		
				if(columNM.equals("sumSelngAm")) {setCellValue(row, "매출액(조원)");}
				if(columNM.equals("sumBsnProfit")) {setCellValue(row, "영업이익(조원)");}
				if(columNM.equals("sumBsnProfitRt")) {setCellValue(row, "영업이익률(%)");}
				if(columNM.equals("sumXportAmDollar")) {setCellValue(row, "수출액(억불)");}
				if(columNM.equals("sumXportAmRt")) {setCellValue(row, "수출비중(%)");}
				if(columNM.equals("sumOrdtmLabrrCo")) {setCellValue(row, "근로자수(만명)");}
				if(columNM.equals("sumRsrchDevlopRt")) {setCellValue(row, "R&D집약도(%)");}
				if(columNM.equals("sumThstrmNtpf")) {setCellValue(row, "당기순이익(조원)");}        		
        	}
        	if(searchIndex == 2) {
        		if(columNM.equals("sumEntrprsCo")) {setCellValue(row, "기업수(개)");}
				if(columNM.equals("avgSelngAm")) {setCellValue(row, "평균매출액(억원)");}
				if(columNM.equals("avgBsnProfit")) {setCellValue(row, "평균영업이익(억원)");}
				if(columNM.equals("avgBsnProfitRt")) {setCellValue(row, "평균영업이익률(%)");}
				if(columNM.equals("avgXportAmDollar")) {setCellValue(row, "평균수출액(백만불)");}
				if(columNM.equals("avgXportAmRt")) {setCellValue(row, "평균수출비중(%)");}
				if(columNM.equals("avgOrdtmLabrrCo")) {setCellValue(row, "평균근로자수(백명)");}
				if(columNM.equals("avgRsrchDevlopRt")) {setCellValue(row, "평균R&D집약도(%)");}
				if(columNM.equals("avgThstrmNtpf")) {setCellValue(row, "평균당기순이익(억원)");}
				if(columNM.equals("avgCorage")) {setCellValue(row, "평균업력(년)");}
        	}
        	
        	String item = "";
			int idx = 0;			
			
			for(int i=startYr; i<=endYr; i++) {								
					
				if(i == startYr) {
					item = columNM;
				}else {
					idx++;
					item = "y"+idx+columNM;
				}
				
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
        } else {
            row.createCell(colIndex++).setCellValue(value.toString());
        }
    }

    @Override
    public String getFileName() {

        return this.fileNmae;
    }

}
