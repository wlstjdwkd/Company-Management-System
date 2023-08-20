/*
 * Copyright (c) 2012 ZES Inc. All rights reserved. This software is the
 * confidential and proprietary information of ZES Inc. You shall not disclose
 * such Confidential Information and shall use it only in accordance with the
 * terms of the license agreement you entered into with ZES Inc.
 * (http://www.zesinc.co.kr/)
 */
package com.infra.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.infra.system.GlobalConst;

import org.springframework.web.servlet.view.AbstractView;

import com.infra.util.Validate;
import com.infra.util.StringUtil;

public class TextView extends AbstractView {

    public static final String DEFAULT_CONTENT_TYPE = "text/plain";

    public TextView() {
        setContentType(DEFAULT_CONTENT_TYPE);
    }

    @Override
    protected void prepareResponse(HttpServletRequest request, HttpServletResponse response) {
        String cont = response.getContentType();
        if(Validate.isEmpty(cont)) {
            response.setContentType(getContentType());
        }
        response.setCharacterEncoding(GlobalConst.ENCODING);
    }

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
        HttpServletResponse response) throws RuntimeException, Exception {

        Object object = model.get(GlobalConst.TEXT_DATA_KEY);

        if(object != null) {
            response.getWriter().write(object.toString());
        } else {
            response.getWriter().write(StringUtil.EMPTY);
        }
    }
}
