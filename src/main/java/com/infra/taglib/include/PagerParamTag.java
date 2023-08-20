package com.infra.taglib.include;

import com.infra.system.GlobalConst;
import com.infra.taglib.JspIncludeTagSupport;
import com.infra.util.Validate;

/**
 * 페이지 정보 태그. <code>Pager</code> 객체를 입력받아 페이지 정보를 표시한다.
 */
public class PagerParamTag extends JspIncludeTagSupport {

    /** 페이지당 출력할 로우 개수 */
    private final int[] DEF_ROW_OPT = GlobalConst.DEFAULT_ROW_OPTION;    
    
    /** 페이지에 출력될 로우개수가(옵션) 변경될때 실행할 <code>Javascript</code> 함수 */
    private String script;
    
    /** 페이징 스크립트에 추가할 파라미터 */
    private String addJsRowParam;
    
    /**
     * 자바스크립트 추가 파라미터 
     * @param pager
     */
    public void setAddJsRowParam(String addJsRowParam) {
        this.addJsRowParam = addJsRowParam;
    }
    
    @Override
    public String getPage() {
        if(Validate.isEmpty(page)) {
            return GlobalConst.DEFAULT_PAGER_PARAM_JSP;
        }
        return this.page;
    }

    @Override
    public void beforeTag() {
    	addAttribute("DEF_ROW_OPT", DEF_ROW_OPT);
    	addAttribute("addJsRowParam", addJsRowParam);
    	
    	if(Validate.isEmpty(script)) {
            addAttribute("setRowScript", GlobalConst.DEFAULT_SET_ROW_JS);
        } else {
            addAttribute("setRowScript", script);
        }
    	
    }
}
