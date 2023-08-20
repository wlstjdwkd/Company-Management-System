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
public class PGPS0020_2ExcelVO implements IExcelVO {

	private static Logger logger = LoggerFactory.getLogger(PGPS0020_2ExcelVO.class);

    private String fileNmae = "";
    private int colIndex = 0;
    
    public PGPS0020_2ExcelVO() {

    }

    public PGPS0020_2ExcelVO(String fileName) {
        super();
        this.fileNmae = fileName;
    }
    
    @Override
    public void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model) {

        @SuppressWarnings("unchecked")
        List<Map> list = (List<Map>) model.get("_list");
        Object[] headers = (Object[]) model.get("_headers");
        String[] items = (String[]) model.get("_items");
        String searchIndex = (String) model.get("searchIndex");	//기준 컬럼index
        
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
        
        int rowIndex = 1;
        Row row;
        colIndex = 0;
        
        int columnCnt = 0;
        
        if(searchIndex.equals("A")) {            	
        	columnCnt = 8;
        }
        if(searchIndex.equals("B")) {
        	columnCnt = 9;
        }
    	if(searchIndex.equals("C")) {
    		columnCnt = 8;
        }
		if(searchIndex.equals("D")) {
			columnCnt = 7;
		}
		if(searchIndex.equals("E")) {
			columnCnt = 7;
		}
		if(searchIndex.equals("F")) {
			columnCnt = 9;
		}
        
        for(Map map : list) {
        	
            row = sheet.createRow(rowIndex++);
            
            for(int i=0; i<items.length; i++) {
            	String item = items[i];
            	Object value = MapUtils.getObject(map, item);
            	
            	if(value != null) {            		
                    setCellValue(row, value);
                }
            }                        
            
            if(searchIndex.equals("A")) {            	
            	if((rowIndex-1)%8 == 1) {setCellValue(row, "없음");}
                if((rowIndex-1)%8 == 2) {setCellValue(row, "1.0%미만");}
                if((rowIndex-1)%8 == 3) {setCellValue(row, "2.0~3.0%");}
                if((rowIndex-1)%8 == 4) {setCellValue(row, "3.0~5.0%");}
                if((rowIndex-1)%8 == 5) {setCellValue(row, "5.0%~10.0%");}
                if((rowIndex-1)%8 == 6) {setCellValue(row, "10.0%~30.0%");}
                if((rowIndex-1)%8 == 7) {setCellValue(row, "30.0%이상");}
                if((rowIndex-1)%8 == 0) {setCellValue(row, "합계");}
            }
            if(searchIndex.equals("B")) {
            	if((rowIndex-1)%9 == 1) {setCellValue(row, "100억미만");}
                if((rowIndex-1)%9 == 2) {setCellValue(row, "100억원~500억원");}
                if((rowIndex-1)%9 == 3) {setCellValue(row, "500억원~1천억원");}
                if((rowIndex-1)%9 == 4) {setCellValue(row, "1천억원~2천억원");}
                if((rowIndex-1)%9 == 5) {setCellValue(row, "2천억원~3천억원");}
                if((rowIndex-1)%9 == 6) {setCellValue(row, "3천억원~5천억원");}
                if((rowIndex-1)%9 == 7) {setCellValue(row, "5천억원~1조원");}
                if((rowIndex-1)%9 == 8) {setCellValue(row, "1조원이상");}
                if((rowIndex-1)%9 == 0) {setCellValue(row, "합계");}
            }
        	if(searchIndex.equals("C")) {
        		if((rowIndex-1)%8 == 1) {setCellValue(row, "없음");}
                if((rowIndex-1)%8 == 2) {setCellValue(row, "1백만~5백만불");}
                if((rowIndex-1)%8 == 3) {setCellValue(row, "5백만~1천만불");}
                if((rowIndex-1)%8 == 4) {setCellValue(row, "1천만~3천만불");}
                if((rowIndex-1)%8 == 5) {setCellValue(row, "3천만~5천만불");}
                if((rowIndex-1)%8 == 6) {setCellValue(row, "5천만~1억불");}
                if((rowIndex-1)%8 == 7) {setCellValue(row, "1억불 이상");}	                                    
                if((rowIndex-1)%8 == 0) {setCellValue(row, "합계");}
            }
    		if(searchIndex.equals("D")) {
    			if((rowIndex-1)%7 == 1) {setCellValue(row, "10인 미만");}
                if((rowIndex-1)%7 == 2) {setCellValue(row, "10인~50인");}
                if((rowIndex-1)%7 == 3) {setCellValue(row, "50인~100인");}
                if((rowIndex-1)%7 == 4) {setCellValue(row, "100인~200인");}
                if((rowIndex-1)%7 == 5) {setCellValue(row, "200인~300인");}
                if((rowIndex-1)%7 == 6) {setCellValue(row, "300인 이상");}	                                    
                if((rowIndex-1)%7 == 0) {setCellValue(row, "합계");}
			}
			if(searchIndex.equals("E")) {
				if((rowIndex-1)%7 == 1) {setCellValue(row, "0~6년");}
	            if((rowIndex-1)%7 == 2) {setCellValue(row, "7~20년");}
	            if((rowIndex-1)%7 == 3) {setCellValue(row, "21~30년");}
	            if((rowIndex-1)%7 == 4) {setCellValue(row, "31~40년");}
	            if((rowIndex-1)%7 == 5) {setCellValue(row, "41~50년");}
	            if((rowIndex-1)%7 == 6) {setCellValue(row, "51년이상");}	                                    
	            if((rowIndex-1)%7 == 0) {setCellValue(row, "합계");}
			}
			if(searchIndex.equals("F")) {
				if((rowIndex-1)%9 == 1) {setCellValue(row, "100억미만");}
	            if((rowIndex-1)%9 == 2) {setCellValue(row, "100억원~500억원");}
	            if((rowIndex-1)%9 == 3) {setCellValue(row, "500억원~1천억원");}
	            if((rowIndex-1)%9 == 4) {setCellValue(row, "1천억원~2천억원");}
	            if((rowIndex-1)%9 == 5) {setCellValue(row, "2천억원~3천억원");}
	            if((rowIndex-1)%9 == 6) {setCellValue(row, "3천억원~5천억원");}
	            if((rowIndex-1)%9 == 7) {setCellValue(row, "5천억원~1조원");}
	            if((rowIndex-1)%9 == 8) {setCellValue(row, "1조원이상");}
	            if((rowIndex-1)%9 == 0) {setCellValue(row, "합계");}
			}
			
			String item = "sctn";
			int idx = 0;			
			
			for(int i=startYr; i<=endYr; i++) {								
																												
				if(i == startYr) {
					if((rowIndex-1)%columnCnt == 0) {
						item = "sctnSum";
					}else {
						item = "sctn" + ((rowIndex-1)%columnCnt);
					}
										
				}else {
					idx++;
					
					if((rowIndex-1)%columnCnt == 0) {
						item = "y"+idx+"sctnSum";
					}else {
						item = "y"+idx+"sctn" + ((rowIndex-1)%columnCnt);
					}
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
