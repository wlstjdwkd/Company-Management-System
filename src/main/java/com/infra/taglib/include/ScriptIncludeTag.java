package com.infra.taglib.include;

import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.infra.system.XMLConfig;

/**
 * JavaScript 를 일관적으로 관리하기 위한 태그.
 * names는 해당 스크립트의 약칭을 사용한다.
 * (/config/commons/js-plugins.xml 파일 내용을 참조한다.)
 * <p />
 * type은 현재 openworks, jquery 두개의 네이밍을 지원한다. names가 설정되지 않는 경우 core에 해당하는 항목만
 * 자동으로 설정된다.
 * 
 * <pre>
 * 사용 예 :
 * <op:jsTag type="web" items="validate,form" />
 * <op:jsTag type="ahpek" items="cmm-core" />
 * </pre>
 */
public class ScriptIncludeTag extends SimpleTagSupport {
	
	private static final Logger logger = LoggerFactory.getLogger(ScriptIncludeTag.class);

    /** 기본키 prefix */
    private String DEFALT_PREFIX = "javascript";
    /** 호출시 기본적으로 포함되는 항목 */
    private String DEFALT_KEY = "core";
    /** 별칭 이름 */
    private String items;
    /** type 기본값: web 또는 ahpek */
    private String type = "web";
    /** 줄바꿈 */
    private String CR = "\n    ";

    /**
     * String items을 반환
     * 
     * @return String items
     */
    public String getItems() {
        return items;
    }

    /**
     * items을 설정
     * 
     * @param items 을(를) String items로 설정
     */
    public void setItems(String items) {
        this.items = items;
    }

    /**
     * String type을 반환
     * 
     * @return String type
     */
    public String getType() {
        return type;
    }

    /**
     * type을 설정
     * 
     * @param type 을(를) String type로 설정
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * 네이밍에 해당하는 스크립트들을 생성 출력한다.
     */
    @Override
    public void doTag() throws JspException, IOException {
        JspWriter writer = getJspContext().getOut();

        List<String> nameList = new LinkedList<String>();

        if(Validate.isNotEmpty(this.items)) {
            nameList.addAll(Arrays.asList(this.items.split(",")));
        } else {
            nameList.add(DEFALT_KEY);
        }

        String html = getScripts(nameList);
        writer.write(html);
    }

    /**
     * JavaScript 및 CSS를 환경설정에서 읽어 설정한다.
     * 
     * @param nameList
     * @return
     */
    private String getScripts(List<String> nameList) {
        HttpServletRequest request = (HttpServletRequest)
            getJspContext().getAttribute(PageContext.REQUEST, PageContext.PAGE_SCOPE);

        String contextPath = request.getContextPath();

        StringBuilder sb = new StringBuilder();
        String prefix = DEFALT_PREFIX + "." + this.type + ".";

        String cont;
        String cssCont;
        String jsCont;

        for(String name : nameList) {
            name = name.trim();
            if(name.contains(".")) {
                cont = XMLConfig.getString(prefix + name);
                if(cont != null) {
                    sb.append(cont);
                    sb.append(CR);
                }
            } else {
                cssCont = XMLConfig.getString(prefix + name + ".css");                
                jsCont = XMLConfig.getString(prefix + name + ".js");                
                if(cssCont != null) {
                    sb.append(cssCont);
                    sb.append(CR);
                }
                if(jsCont != null) {
                    sb.append(jsCont);
                    sb.append(CR);
                }
            }

        }
        String staticCont = sb.toString();        
        if(!staticCont.equals("")) {
            staticCont = StringUtil.replace(staticCont, "${contextPath}", contextPath);
        }

        return staticCont;
    }
}
