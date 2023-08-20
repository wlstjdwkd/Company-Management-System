package com.infra.taglib.include;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.comm.menu.MenuService;
import com.comm.menu.MenuVO;
import com.infra.taglib.include.PageTitle.orderAscCompare;
import com.infra.util.SessionUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * 페이지 타이틀 생성 태그 클래스
 * <pre>
 * 사용 예 :
 * <op:title menuNo="3" />
 * </pre>
 *
 * @author JGS
 */
public class PageTitle extends SimpleTagSupport{

	private static final Logger logger = LoggerFactory.getLogger(PageTitle.class);

	// 페이지 타이틀
    private String pageTitle;
    // 메뉴
    private LinkedHashMap<String, MenuVO> menuMap = (LinkedHashMap<String, MenuVO>) SessionUtil.getMenuInfo();
    // 메뉴 번호
    private String menuNo;
    // 화면이 메뉴 번호
    private List<String> noScreenMenuNo;

	public String getPageTitle() {
		return pageTitle;
	}
	public void setPageTitle(String pageTitle) {
		this.pageTitle = pageTitle;
	}
	public LinkedHashMap<String, MenuVO> getMenuMap() {
		return menuMap;
	}
	public void setMenuMap(LinkedHashMap<String, MenuVO> menuMap) {
		this.menuMap = menuMap;
	}
	public String getMenuNo() {
		return menuNo;
	}
	public void setMenuNo(String menuNo) {
		this.menuNo = menuNo;
	}
	public List<String> getNoScreenMenuNo() {
		List<String> noScreenMenuNo = this.noScreenMenuNo;
		return noScreenMenuNo;
	}
	public void setNoScreenMenuNo(List<String> noScreenMenuNo) {
		for(int i = 0; i < noScreenMenuNo.size(); i++) {
			this.noScreenMenuNo.set(i, noScreenMenuNo.get(i));
		}
	}
	public static Logger getLogger() {
		return logger;
	}


	/**
     *  Page title을 출력 한다
     */
    @Override
    public void doTag() throws JspException, IOException {
    	JspWriter writer = getJspContext().getOut();
    	String html;
    	if(Validate.isEmpty(this.menuNo)) {
    		writer.write("");
    		return;
    	}

		try {
			html = getHistoricalTrail();
		} catch (RuntimeException e) {
			//writer.write("<div class=\"error\">" + e.toString() + "</div>");
			html = "";
		} catch (Exception e) {
			//writer.write("<div class=\"error\">" + e.toString() + "</div>");
			html = "";
		}
        writer.write(html);
        // 기업정의 | 페이지 타이틀
    }

    private String getHistoricalTrail() throws RuntimeException, Exception {

    	ServletConfig cfg = (ServletConfig) getJspContext().getAttribute(PageContext.CONFIG, PageContext.PAGE_SCOPE);
        MenuService menuService = (MenuService) WebApplicationContextUtils.getWebApplicationContext(cfg.getServletContext()).getBean("menuService");
        noScreenMenuNo = menuService.findNoScreenMenu();

    	// 현재 메뉴번호를 기준으로 화면이 있는 첫번째 자식 메뉴번호를 구함
    	String lastMemuNo = getFirstMenuNoWithSreen(this.menuNo);

    	// 페이지 타이틀
    	if(this.pageTitle==null) {
    		this.pageTitle = menuMap.get(lastMemuNo).getMenuNm();
    	}

    	String stackMenuNo = lastMemuNo;
    	List<MenuVO> menuStack = new ArrayList<MenuVO>();
    	// 현재 메뉴 부터 최상위 메뉴까지 저장
    	while(true) {
    		MenuVO stackMenuVO = menuMap.get(stackMenuNo);
    		menuStack.add(stackMenuVO);
    		if(stackMenuVO.getTopNodeAt().equals("Y")) {break;}
    		stackMenuNo = String.valueOf(stackMenuVO.getParntsMenuNo());
    	}

    	List<String> outMemuList = new ArrayList<String>();
    	MenuVO oldMenuVO = new MenuVO();
    	// Historical Trail 생성
    	for(MenuVO popMenuVo: menuStack) {
    		StringBuilder tmpHtml = new StringBuilder();
    		String menuNm 		= popMenuVo.getMenuNm();
    		// 최상위 메뉴가 화면이 없을 경우
    		// 화면을 가지는 자식 메뉴 중 출력 순서가 가장 빠른 메뉴를 링크
    		if(popMenuVo.getTopNodeAt().equals("Y")) {
    			String fmMenuNo = getFirstMenuNoWithSreen(String.valueOf(popMenuVo.getMenuNo()));
    			MenuVO fmMenuVo = menuMap.get(fmMenuNo);

    			int pMenuNo 		= fmMenuVo.getParntsMenuNo();
        		int menuNo 			= fmMenuVo.getMenuNo();
        		String programId 	= fmMenuVo.getProgrmId();

        		tmpHtml.append(menuNm);

        		outMemuList.add(tmpHtml.toString());

    			break;
    		}
    	}

    	Collections.reverse(outMemuList);
    	StringBuilder html = new StringBuilder();
    	html.append(this.pageTitle);

    	for(String str: outMemuList) {
    		html.append(" | ");
    		html.append(str);
    	}

    	return html.toString();
    }

    /**
     * 현재 메뉴번호를 기준으로 화면이 있는 첫번째 자식 메뉴번호를 구함
     * <p />
     * @param nemuNo 현재 메뉴번호
     * @return lastMenuNo 화면이 있는 첫 자식 메뉴번호
     */
    private String getFirstMenuNoWithSreen(String menuNo) {

    	String lastMemuNo = menuNo;
    	while(noScreenMenuNo.contains(lastMemuNo)) {
    		MenuVO menuVo = menuMap.get(lastMemuNo);
    		List<MenuVO> subMenuList = new ArrayList<MenuVO>();
    		subMenuList = menuVo.getSubMenu();
    		Collections.sort(subMenuList, new orderAscCompare());
			MenuVO subMenuVo = subMenuList.get(0);
			lastMemuNo = String.valueOf(subMenuVo.getMenuNo());
    	}

		return lastMemuNo;
    }

    /**
     * MenuVo 오름차순 정렬
     */
    static class orderAscCompare implements Comparator<MenuVO> {

		/**
		 * 오름차순(ASC)
		 */
		@Override
		public int compare(MenuVO arg0, MenuVO arg1) {
			return arg0.getOutptOrdr() < arg1.getOutptOrdr() ? -1 : arg0.getOutptOrdr() > arg1.getOutptOrdr() ? 1:0;
		}

	}
}
