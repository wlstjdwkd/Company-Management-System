package com.infra.taglib.include;

import com.comm.page.Pager;
import com.infra.system.GlobalConst;
import com.infra.taglib.JspIncludeTagSupport;
import com.infra.util.Validate;;

/**
 * 목록 페이징 태그. <code>Pager</code> 객체를 입력받아 페이징 UI를 생성한다.
 * 
 */
public class PagerTag extends JspIncludeTagSupport {

    /** 페이징 객체 */
    private Pager pager;

    /**
     * 페이징 객체 설정 
     * @param pager
     */
    public void setPager(Pager pager) {
        this.pager = pager;
    }

    /** 페이징 UI에서 페이지 번호를 클릭시 사용될 <code>Javascript</code> 함수 */
    private String script;

    /**
     * <code>Javascript</code> 함수 설정
     * 예) onclick="func()"
     * 
     * @param script
     */
    public void setScript(String script) {
        this.script = script;
    }
    
    /** 페이징 스크립트에 추가할 파라미터 */
    private String addJsParam;

    /**
     * 자바스크립트 추가 파라미터 
     * @param pager
     */
    public void setAddJsParam(String addJsParam) {
        this.addJsParam = addJsParam;
    }
    

    @Override
    protected String getPage() {
        if(Validate.isEmpty(page)) {
            return GlobalConst.DEFAULT_PAGER_JSP;
        }

        return this.page;
    }

    @Override
    protected void beforeTag() {
        addAttribute("pager", pager);
        addAttribute("addJsParam", addJsParam);
        
        if(Validate.isEmpty(script)) {
            addAttribute("movePageScript", GlobalConst.DEFAULT_MOVE_PAGE_JS);
        } else {
            addAttribute("movePageScript", script);
        }
    }
}
