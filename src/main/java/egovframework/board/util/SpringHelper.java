/*** Eclipse Class Decompiler plugin, copyright (c) 2012 Chao Chen (cnfree2000@hotmail.com) ***/
package egovframework.board.util;

import java.util.Map;
import javax.servlet.ServletContext;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class SpringHelper {
	public static Object findController(ServletContext svrCtx,
			String serviceName) {
		ApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(svrCtx);

		Map applMap = ctx.getBeansWithAnnotation(Controller.class);

		return applMap.get(serviceName);
	}

	public static Object findService(ServletContext svrCtx, String serviceName) {
		ApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(svrCtx);

		Map applMap = ctx.getBeansWithAnnotation(Service.class);

		return applMap.get(serviceName);
	}

	public static Object findDao(ServletContext svrCtx, String serviceName) {
		ApplicationContext ctx = WebApplicationContextUtils
				.getWebApplicationContext(svrCtx);

		Map applMap = ctx.getBeansWithAnnotation(Repository.class);

		return applMap.get(serviceName);
	}
}