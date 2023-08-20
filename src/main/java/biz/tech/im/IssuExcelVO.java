package biz.tech.im;

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
 * 확인서발급현황 엑셀형식
 */
public class IssuExcelVO implements IExcelVO {

	private static Logger logger = LoggerFactory.getLogger(IssuExcelVO.class);

    private String fileNmae = "";

    public IssuExcelVO() {

    }

    public IssuExcelVO(String fileName) {
        super();
        this.fileNmae = fileName;
    }
    
    @Override
    public void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model) {

        @SuppressWarnings("unchecked")
        List<Map> list = (List<Map>) model.get("_list");
        List<Integer> listCnt = (List<Integer>) model.get("_listCnt");
        String headers = (String) model.get("_headers");
        Object[] subHeaders = (Object[]) model.get("_subHeaders");
        String[] items = (String[]) model.get("_items");
        
        Sheet sheet = workbook.createSheet();
        
        colIndex = 2;
        Row header = sheet.createRow(0);
        Row subHeader = sheet.createRow(1);
        
        // Sub Header 생성
        for(Object subHead : subHeaders) {
            if(subHead instanceof String) {
            	header.createCell(colIndex);
            	subHeader.createCell(colIndex++).setCellValue(subHead.toString());
            } else if(subHead instanceof String[]) {
                for(String strHead : (String[]) subHead) {
                	header.createCell(colIndex);
                	subHeader.createCell(colIndex++).setCellValue(strHead);
                }
            }
        }
        header.getCell(2).setCellValue(headers);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 2, colIndex-1));
        
        // Header 생성 및 병합
        header.createCell(0).setCellValue("구분");
        header.createCell(1);
        subHeader.createCell(0);
        subHeader.createCell(1);
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 1));

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
        
        int cnt=0;
        rowIndex=2;
   
        // 년도별 병합
        for(int i=0; i< listCnt.size(); i++) {
        	cnt = listCnt.get(i);
        	if(i == listCnt.size()-1)	{
        		
        		sheet.getRow(rowIndex).getCell(0).setCellValue("총계");
        		sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex+cnt-1, 0, 1));
        		
        		
        	} else {
        		sheet.addMergedRegion(new CellRangeAddress(rowIndex, rowIndex+cnt-1, 0, 0));
        	}
        	rowIndex += cnt;
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

        } else {
            row.createCell(colIndex++).setCellValue(value.toString());
        }
    }

    @Override
    public String getFileName() {

        return this.fileNmae;
    }

}
