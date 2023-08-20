package com.infra.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.view.AbstractView;

import com.infra.system.GlobalConst;
import com.infra.util.JsonUtil;

/**
 * Jackson Java JSON-processor 라이브러리를 이용하여 오브젝트를 JSON화 하여 응답한다.
 * <p />
 * 대상 객체가 <code>null</code>인 경우 그대로 <code>null</code>을 출력한다.
 * @see <a href="http://jackson.codehaus.org/">Jackson Java JSON-processor</a>
 */
public class JsonView extends AbstractView {

    public static final String DEFAULT_CONTENT_TYPE = "application/json";

    public JsonView() {
        setContentType(DEFAULT_CONTENT_TYPE);
    }

    @Override
    protected void prepareResponse(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(getContentType());
        response.setCharacterEncoding(GlobalConst.ENCODING);
    }

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
        HttpServletResponse response) throws RuntimeException, Exception {

        Object object = model.get(GlobalConst.JSON_DATA_KEY);
        String json = JsonUtil.toJson(object);
        response.getWriter().write(json);
    }

}
