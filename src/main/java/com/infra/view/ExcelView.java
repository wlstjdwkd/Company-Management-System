package com.infra.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.comm.response.IExcelVO;
import com.infra.system.GlobalConst;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

/**
 *
 * @author JGS
 *
 */
public class ExcelView extends AbstractExcelView {

    @Override
    protected void buildExcelDocument(Map<String, Object> model, SXSSFWorkbook workbook, HttpServletRequest request,
        HttpServletResponse response) throws RuntimeException, Exception {


        IExcelVO excelVo = (IExcelVO) model.get(GlobalConst.OBJ_DATA_KEY);

        if(excelVo != null) {

            String encodedFileNm = new String(excelVo.getFileName().getBytes("KSC5601"), "8859_1");

            response.setHeader("Content-Disposition", "attachment; fileName=\"" + encodedFileNm + ".xlsx\";");

            excelVo.createExcelDocument(workbook, model);
        }
    }
}
