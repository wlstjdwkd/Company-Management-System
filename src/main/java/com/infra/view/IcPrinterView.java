package com.infra.view;

import java.io.File;
import java.io.ObjectOutputStream;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.view.AbstractView;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

public class IcPrinterView extends AbstractView {

	private static final Logger logger = LoggerFactory.getLogger(IcPrinterView.class);

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws RuntimeException, Exception {

		String filePath = (String) model.get("url");
		JRDataSource dtSource = (JRDataSource) model.get("datasource");

		Resource mainReport = getApplicationContext().getResource(filePath);

		File jasperFile = mainReport.getFile();
		logger.debug("jrxmlFile ==>"+jasperFile.getAbsolutePath());

		JasperReport jReport = (JasperReport)JRLoader.loadObject(jasperFile);
		JasperPrint jasperPrint = JasperFillManager.fillReport(jReport, null, dtSource);


		if(jasperPrint != null) {
			ServletOutputStream ouputStream = response.getOutputStream();

			ObjectOutputStream oos = new ObjectOutputStream(ouputStream);
			oos.writeObject(jasperPrint);
			oos.flush();
			oos.close();

			ouputStream.flush();
			ouputStream.close();
		} else {
			throw new RuntimeException("View Error: Fail to making Instance of JasperPrint");
		}

	}
}
