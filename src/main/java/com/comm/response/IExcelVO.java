package com.comm.response;

import java.util.Map;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

/**
 * Excel View 구현을 위한 기본 공통 메소드 정의<br />
 * Jakarta Commons Project POI 라이브러리 이용
 * < p />
 * org.springframework.web.servlet.view.BeanNameViewResolver를 설정으로 excelView 를
 * 통하여 화면 출력 
 */
public interface IExcelVO {

    /**
     * Create excel document
     * 
     * @param workbook
     * @param model
     */
    void createExcelDocument(SXSSFWorkbook workbook, Map<String, Object> model);

    /**
     * 저장 파일명
     * 
     * @return
     */
    String getFileName();
}
