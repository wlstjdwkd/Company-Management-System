package com.infra.taglib.include;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.infra.system.GlobalConst;
import com.infra.util.ArrayUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;
import com.comm.code.CodeService;
import com.comm.code.CodeVO;


/**
 * <pre>
 * 코드 데이터를 기준으로 html 코드를 생성한다.
 * 코드는 select, radio, checkbox 를 지원한다.
 * </pre>
 *
 * @see
 */
public class CodeTag extends SimpleTagSupport {

    /** SL4J 로깅 */
    private static Logger logger = LoggerFactory.getLogger(CodeTag.class);

    /** 그룹 코드 */
    private String grpCd;
    /** HTML 기준 radio, checkbox, select 중 선택 */
    private TAG_TYPE type = TAG_TYPE.select;
    /** 고유 식별자 */
    private String id;
    /** Only 셀렉트 박스 - 첫번째 옵션 라벨 */
    private String defaultLabel = GlobalConst.SELECT_TEXT;
    /** 셀렉트 박스의 크기 설정 */
    private String size;
    /** 셀렉트 박스의 title 설정 */
    private String title;
    /** 셀렉트 박스의 name 설정 */
    private String name;
    /** 기타 옵션 Attributes */
    private String option;

	/** javascript onclick event 발생시 적용할 메소드 */
    private String onclick;
    /** javascript onchange event 발생시 적용할 메소드 */
    private String onchange;
    /** 코드 목록 */
    private List<CodeVO> codeList;
    /** 기본석택코드 */
    private String selectedCd;
    /** 출력제외코드 */
    private String ignoreCd;
    private boolean disabled = false;
    /** select element 포함 여부 **/
    private boolean includeSelect = true;


	public boolean isDisabled() {
		return disabled;
	}

	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}

	/**
     * html tag 코드
     *
     */
    enum TAG_TYPE {
        select, radio, checkbox, text, codeSelect
    }

    /**
     * 코드목록으로 html tag를 생성한다.
     */
    @Override
    public void doTag() throws JspException, IOException {
        JspWriter writer = getJspContext().getOut();

        try {

        	this.codeList = getCodeList();

            if(Validate.isEmpty(codeList)) {
                writer.write("<div class=\"error\">[" + grpCd + "]에 해당하는 공통코드 정보가 없습니다.</div>");
                return;
            }

            if(TAG_TYPE.select.equals(type)) {
                writer.write(createSelectTag());
            } else if(TAG_TYPE.radio.equals(type) || TAG_TYPE.checkbox.equals(type)) {
                writer.write(createRadioOrCheckTag());
            } else if(TAG_TYPE.text.equals(type)) {
            	writer.write(createCodeText());
            } else if(TAG_TYPE.codeSelect.equals(type)) {
            	writer.write(createCodeSelectTag());
            }
            else {
                writer.write(StringUtil.EMPTY);
            }

        } catch (RuntimeException e) {
            writer.write("<div class=\"error\">" + e + "</div>");
            return;
        } catch (Exception e) {
            writer.write("<div class=\"error\">" + e + "</div>");
            return;
        }

    }

    /**
     * select tag html 생성
     *
     * @return
     */
    private String createSelectTag() {
        StringBuilder html = new StringBuilder();
        String[] ignores = Validate.isEmpty(ignoreCd) ? null : ignoreCd.split(",");

        if(includeSelect) {
	        if(Validate.isNotEmpty(name)) {
	            html.append("<select name=\"" + name + "\" ");
	        }else{
	            html.append("<select name=\"" + id + "\" ");
	        }
	        html.append("id=\"" + id + "\"");

	        if(disabled) {
	            html.append(" disabled ");
	        }

	        if(Validate.isNotEmpty(size)) {
	            html.append(" size=\"" + size + "\"");
	        }
	        if(Validate.isNotEmpty(title)) {
	            html.append(" title=\"" + title + "\"");
	        }
	        if(Validate.isNotEmpty(onchange)) {
	            html.append(" onchange=\"" + onchange + "\"");
	        }
	        if(Validate.isNotEmpty(option)) {
	            html.append(" " + option);
	        }
	        html.append(">\n");

	        if(Validate.isNotEmpty(defaultLabel)) {
	            html.append("<option value=\"\">" + defaultLabel + "</option>\n");
	        }
        }

        for(CodeVO bean : codeList) {
        	if(Validate.isNotEmpty(ignores)) {
        		if(ArrayUtil.contains(ignores, bean.getCode())) {
        			continue;
        		}
        	}
            html.append("<option value=\"" + bean.getCode() + "\" ");
            if(bean.getCode().equals(selectedCd)) {
                html.append("selected=\"selected\"");
            }
            html.append(">" + bean.getCodeNm() + "</option>\n");
        }

        if(includeSelect) {
        	html.append("</select>\n");
        }

        return html.toString();
    }

    /**
     * select tag html 생성 (code 포함)
     *
     * @return
     */
    private String createCodeSelectTag() {
    	StringBuilder html = new StringBuilder();
    	String[] ignores = Validate.isEmpty(ignoreCd) ? null : ignoreCd.split(",");

    	if(includeSelect) {
    		if(Validate.isNotEmpty(name)) {
    			html.append("<select name=\"" + name + "\" ");
    		}else{
    			html.append("<select name=\"" + id + "\" ");
    		}
    		html.append("id=\"" + id + "\"");

    		if(disabled) {
    			html.append(" disabled ");
    		}

    		if(Validate.isNotEmpty(size)) {
    			html.append(" size=\"" + size + "\"");
    		}
    		if(Validate.isNotEmpty(title)) {
    			html.append(" title=\"" + title + "\"");
    		}
    		if(Validate.isNotEmpty(onchange)) {
    			html.append(" onchange=\"" + onchange + "\"");
    		}
    		if(Validate.isNotEmpty(option)) {
    			html.append(" " + option);
    		}
    		html.append(">\n");

    		if(Validate.isNotEmpty(defaultLabel)) {
    			html.append("<option value=\"\">" + defaultLabel + "</option>\n");
    		}
    	}

    	for(CodeVO bean : codeList) {
    		if(Validate.isNotEmpty(ignores)) {
    			if(ArrayUtil.contains(ignores, bean.getCode())) {
    				continue;
    			}
    		}
    		html.append("<option value=\"" + bean.getCode() + "\" ");
    		if(bean.getCode().equals(selectedCd)) {
    			html.append("selected=\"selected\"");
    		}
    		html.append(">" + bean.getCode() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + bean.getCodeNm() + "</option>\n");
    	}

    	if(includeSelect) {
    		html.append("</select>\n");
    	}

    	return html.toString();
    }

    /**
     * input radio 또는 checkbox tag html 생성
     *
     * @return
     */
    private String createRadioOrCheckTag() {
        int idSeq = 1;
        String eleType = null;
        String eleId = null;

        if(TAG_TYPE.radio.equals(type)) {
            eleType = "radio";
            eleId = "_rb_";
        } else {
            eleType = "checkbox";
            eleId = "_cb_";
        }

        StringBuilder html = new StringBuilder();
        String[] checkeds = Validate.isEmpty(selectedCd) ? null : selectedCd.split(",");
        String[] ignores = Validate.isEmpty(ignoreCd) ? null : ignoreCd.split(",");

        html.append("<ul>");

        int tempFlag = 0;

        for(CodeVO bean : codeList) {
        	if(Validate.isNotEmpty(ignores)) {
        		if(ArrayUtil.contains(ignores, bean.getCode())) {
        			continue;
        		}
        	}

        	String __id = id + eleId + "0";

        	if(tempFlag == 0) {
	        	/////////////// CHECKBOX 전체항목 추가 시작 /////////////////

	        	if(grpCd.equals("20"))
	        		html.append("<li style='float:left;width:102px;'>");
	        	else if(grpCd.equals("18"))
	        		html.append("<li style='float:left;width:130px;'>");
	        	else if(grpCd.equals("38"))
	        		html.append("<li style='float:left;width:102px;'>");
	        	else
	        		html.append("<li>");
	            html.append("<input type=\"" + eleType + "\"");
	            html.append(" name=\"" + id + "\"");
	            html.append(" id=\"" + __id + "\"");
	            html.append(" onclick=\"" + "javascript:check_all('" + id + "');" + "\"");
	            html.append(" value=\"" + bean.getCode().substring(0, bean.getCode().length()-1) + "0" + "\"");

	            if(Validate.isNotEmpty(option)) {
	                html.append(" " + option);
	            }
	            html.append("/>");
	            html.append("<label for=\"" + __id + "\">");
	            html.append("전체" + "</label>\n");
	            html.append("</li>");

	            /////////////// CHECKBOX 전체항목 추가 끝 /////////////////
	            tempFlag = tempFlag + 1;
        	}
            __id = id + eleId + (idSeq++);

            if(grpCd.equals("20"))
        		html.append("<li style='float:left;width:102px;'>");
        	else if(grpCd.equals("18"))
        		html.append("<li style='float:left;width:130px;'>");
        	else if(grpCd.equals("38"))
        		html.append("<li style='float:left;width:102px;'>");
        	else
        		html.append("<li>");
            html.append("<input type=\"" + eleType + "\"");
            html.append(" name=\"" + id + "\"");
            html.append(" class=\"" + id + "\"");
            html.append(" value=\"" + bean.getCode() + "\"");

            /*if(bean.getCode().equals(selectedCd)) {
                html.append("checked=\"checked\"");
            }*/

            if(Validate.isNotEmpty(checkeds)) {
	            if(ArrayUtil.contains(checkeds, bean.getCode())) {
	            	html.append(" checked=\"checked\"");
	            }
            }

            if(Validate.isNotEmpty(onclick)) {
                html.append(" onclick=\"" + onclick + "\"");
            }

            if(Validate.isNotEmpty(option)) {
                html.append(" " + option);
            }
            html.append("/>");
            html.append("<label for=\"" + __id + "\">");
            if(grpCd.equals("20"))
            	html.append(bean.getCodeNm().replaceAll("신청", "") + "</label>\n");
            else
            	html.append(bean.getCodeNm() + "</label>\n");
            html.append("</li>");
        }

        html.append("</ul>");

        return html.toString();
    }

    /**
     * 코드에 해당하는 코드명 출력
     * @return
     */
    private String createCodeText() {

       /* for(CodeVO bean : codeList) {
            if(bean.getCode().equals(selectedCd)) {
                return bean.getCodeNm();
            }
        }
        return "";*/

        StringBuilder html = new StringBuilder();
        String[] checkeds = Validate.isEmpty(selectedCd) ? null : selectedCd.split(",");
        String[] ignores = Validate.isEmpty(ignoreCd) ? null : ignoreCd.split(",");

        html.append("<ul>");

        for(CodeVO bean : codeList) {
        	if(Validate.isNotEmpty(ignores)) {
        		if(ArrayUtil.contains(ignores, bean.getCode())) {
        			continue;
        		}
        	}

            if(Validate.isNotEmpty(checkeds)) {
	            if(!ArrayUtil.contains(checkeds, bean.getCode())) {
	            	continue;
	            }
            } else {
            	continue;
            }

            html.append("<li>");
            html.append(bean.getCodeNm());
            html.append("</li>");
        }

        html.append("</ul>");

        return html.toString();
    }

    /**
     * 코드 목록을 가져 온다
     *
     * @return
     * @throws Exception
     */
    private List<CodeVO> getCodeList() throws RuntimeException, Exception {
        ServletConfig cfg = (ServletConfig) getJspContext().getAttribute(PageContext.CONFIG, PageContext.PAGE_SCOPE);
        CodeService codeService = (CodeService) WebApplicationContextUtils.getWebApplicationContext(cfg.getServletContext()).getBean("codeService");
/*
        if(Validate.isNotEmpty(ctgCd)) {
            CodeCtgVO vo = new CodeCtgVO();
            vo.setGrpCd(grpCd);
            vo.setCtgCd(ctgCd);
            return codeDao.prvNmForCtgCd(vo);
        }
*/
        return codeService.findCodesByGroupNo(grpCd);
    }

    /**
     * 그룹코드 설정
     *
     * @param grpCd
     */
    public void setGrpCd(String grpCd) {
        this.grpCd = grpCd;
    }

    /**
     * html tag 설정
     *
     * @param type
     */
    public void setType(String type) {
        this.type = TAG_TYPE.valueOf(type);
    }

    /**
     * html tag의 고유 id 설정
     *
     * @param id
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * select tag의 첫 선택 항목의 텍스트
     *
     * @param defaultLabel
     * @see
     */
    public void setDefaultLabel(String defaultLabel) {
        this.defaultLabel = defaultLabel;
    }

    /**
     * javascript onclick 이벤트시 실행될 메소드 명
     *
     * @param onclick
     */
    public void setOnclick(String onclick) {
        this.onclick = onclick;
    }

    /**
     * javascript onchange 이벤트시 실행될 메소드 명
     *
     * @param onclick
     */
    public void setOnchange(String onchange) {
        this.onchange = onchange;
    }

    /**
     * select tag에서만 사용되며 화면에 표시될 크기 설정
     *
     * @param size
     */
    public void setSize(String size) {
        this.size = size;
    }

    /**
     * 적용 html tag에 설정할 추가 속성
     * 예) class="design"
     *
     * @param option
     */
    public void setOption(String option) {
        this.option = option;
    }

    /**
     * String title을 반환
     * @return String title
     */
    public String getTitle() {
        return title;
    }

    /**
     * title을 설정
     * @param title 을(를) String title로 설정
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * String name을 반환
     * @return String name
     */
    public String getName() {
        return name;
    }

    /**
     * name을 설정
     * @param name 을(를) String name로 설정
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * selectedCd을 설정
     * @param selectedCd 반환
     */
	public String getSelectedCd() {
		return selectedCd;
	}

	/**
     * selectedCd을 설정
     * @param selectedCd 을(를) String selectedCd로 설정
     */
	public void setSelectedCd(String selectedCd) {
		this.selectedCd = selectedCd;
	}

	/**
     * ignoreCd을 설정
     * @param ignoreCd 반환
     */
    public String getIgnoreCd() {
		return ignoreCd;
	}

    /**
     * ignoreCd을 설정
     * @param ignoreCd 을(를) String ignoreCd로 설정
     */
	public void setIgnoreCd(String ignoreCd) {
		this.ignoreCd = ignoreCd;
	}

	/**
	 * includeSelect을 반환
	 * @return
	 */
	public boolean isIncludeSelect() {
		return includeSelect;
	}

	/**
	 * includeSelect를 설정
	 * @param includeSelect
	 */
	public void setIncludeSelect(boolean includeSelect) {
		this.includeSelect = includeSelect;
	}


}
