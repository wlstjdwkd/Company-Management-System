package com.infra.taglib;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.infra.system.*;

/**
 * Taglib에서 사용되는 JSP 파일을 include 하기 위한 기능을 지원하는 클래스
 *
 */
public abstract class JspIncludeTagSupport extends SimpleTagSupport {

    /** VIEW에 해당하는 JSP 파일 루트 경로 */
    public final String TAGLIB_JSP_ROOT = GlobalConst.INCLUDE_TAGLIB_BASE;

    /** JSP 파일명 */
    protected String page;

    /**
     * JSP 파일 설정
     *
     * @param page
     */
    public void setPage(String page) {
        this.page = page;
    }

    /**
     * 이름에 해당하는 <code>Object</code>를 반환
     *
     * @param name
     * @return
     */
    protected Object getPageObject(String name) {
        return getJspContext().getAttribute(name, PageContext.PAGE_SCOPE);
    }

    /**
     * JSP 파일에 넘길 <code>Object</code> 추가(키/값 쌍)
     *
     * @param key
     * @param value
     */
    protected void addAttribute(String key, Object value) {
        getJspContext().setAttribute(key, value, PageContext.REQUEST_SCOPE);
    }

    /**
     * <code>HttpServletRequest</code> 객체의 <code>Attribute</code>를 반환한다.
     *
     * @param key
     * @param value
     */
    protected Object getAttribute(String key) {
        return getJspContext().getAttribute(key, PageContext.REQUEST_SCOPE);
    }

    /**
     * 개별 구현 대상
     * <p />
     * 우선 처리되어야 할 메소드 정의
     */
    protected void beforeTag() {
    }

    @Override
    public void doTag() throws JspException, IOException {

        ServletConfig cfg = (ServletConfig) getPageObject(PageContext.CONFIG);
        ServletContext sc = cfg.getServletContext();

        String name = TAGLIB_JSP_ROOT + getPage();

        /*
         * Tomcat의 경우 대상 JSP 파일이 없더라도 RequestDispatcher을 반환하므로,
         * 우선 해당 파일이 물리적으로 존재하는지 먼저 체크함
         */
        if(sc.getResource(name) != null) {
            RequestDispatcher disp = sc.getRequestDispatcher(name);
            if(disp != null) {

                beforeTag();

                try {
                    HttpServletRequest request = (HttpServletRequest) getPageObject(PageContext.REQUEST);
                    disp.include(request, new TagResponseWrapper(
                        (HttpServletResponse) getPageObject(PageContext.RESPONSE), new PrintWriter(
                        		getJspContext().getOut())));
                } catch (ServletException e) {
                    throw new JspException(e);
                } finally {}

                return;
            }
        } else {
            getJspContext().getOut()
                .write("<div class=\"error\">" + page + " 파일을 찾을 수 업습니다.</div>");
        }
    }

    /**
     * 개별 구현
     * <p />
     * 구현 Taglib에서 사용되는 JSP 파일명 설정
     *
     * @return
     */
    protected abstract String getPage();

    /**
     * include Wrapper 클래스
     * request 객체의 PrintWriter 클래스를 JspContext의 Writer로 대체
     * @version 1.0
     * @author JGS
     */
    public class TagResponseWrapper extends HttpServletResponseWrapper {

        private final PrintWriter pw;

        public TagResponseWrapper(HttpServletResponse httpServletResponse, PrintWriter w) {
            super(httpServletResponse);
            this.pw = w;
        }

        @Override
        public PrintWriter getWriter() throws IOException {
            return pw;
        }

    }
}
