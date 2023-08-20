package biz.tech.ps;

import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comm.response.IExcelVO;

/**
 * 기업검색 엑셀VO
 */
public class PGPS0010ExcelVO implements IExcelVO {
    
    private static Logger logger = LoggerFactory.getLogger(PGPS0010ExcelVO.class);

    private String fileNmae = "";

    public PGPS0010ExcelVO() {

    }

    public PGPS0010ExcelVO(String fileName) {
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

        colIndex = 0;
        Row header = sheet.createRow(0);
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
        
        List<Map> invstList = (List<Map>) model.get("_invstList");
        Object[] invstHeaders = (Object[]) model.get("_invstHeaders");
        String[] invstItems = (String[]) model.get("_invstItems");
        
        if (invstList != null && invstList.size() > 0) {
        	
        	sheet = workbook.createSheet();
        	
            colIndex = 0;
            header = sheet.createRow(0);
            for(Object head : invstHeaders) {
                if(head instanceof String) {
                    header.createCell(colIndex++).setCellValue(head.toString());
                } else if(head instanceof String[]) {
                    for(String strHead : (String[]) head) {
                        header.createCell(colIndex++).setCellValue(strHead);
                    }
                }
            }

            rowIndex = 1;
            colIndex = 0;
            for(Map map : invstList) {
                row = sheet.createRow(rowIndex++);
                for(String item : invstItems) {
                	
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
