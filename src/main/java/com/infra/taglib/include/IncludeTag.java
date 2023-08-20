package com.infra.taglib.include;

import com.infra.taglib.JspIncludeTagSupport;

/**
 * JSP 파일을 include한 것과 동일한 효과를 발생하는 태그
 * <p />
 * 지정된 위치 
 * 
 * @see JspIncludeTagSupport
 */
public class IncludeTag extends JspIncludeTagSupport {

    @Override
    protected String getPage() {
        return this.page;
    }
}
