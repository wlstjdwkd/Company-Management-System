package biz.tech.bt;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.lang.Character.UnicodeBlock;
import java.nio.channels.FileChannel;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import biz.tech.mapif.bt.PGBT0020Mapper;
import com.infra.batch.BatchService;

/**
 * 배치샘플
 * @author sujong
 *
 */
@Service("PGBT0020")
public class PGBT0020Service extends BatchService {

	private static final Logger logger = LoggerFactory.getLogger(PGBT0020Service.class);
	private static final String BASE_PATH = "/app/wasapp/tmp/";
	
	@Resource(name = "PGBT0020Mapper")
	PGBT0020Mapper pgbt0020Dao;
	
	@Override
	public void validateParameter() throws Exception {
		for (int i=0; i<args.length; i++) {
			logger.debug("Paramter["+(i+1)+"]==>"+args[i]);
		}
	}

	@Override
	public void processService() throws Exception {
		logger.debug("============= runService ============");

		List<Map> fileList = pgbt0020Dao.selectFileList();
		boolean procYn = false;
		
		for (Map fileInfo: fileList) {
			procYn = false;
			String fileNm = (String) fileInfo.get("fileNm");
			String filePath = (String) fileInfo.get("filePath");

			filePath = filePath.substring(32);
			
			String newFileNm = "";
			for (int i=0; i<fileNm.length(); i++) {
				UnicodeBlock block = UnicodeBlock.of(fileNm.charAt(i));
				
				if (UnicodeBlock.HANGUL_SYLLABLES == block || UnicodeBlock.HANGUL_JAMO == block || UnicodeBlock.HANGUL_COMPATIBILITY_JAMO == block) {
					newFileNm = newFileNm.concat("?");
					procYn = true;
		        } else {
		        	newFileNm = newFileNm.concat(String.valueOf(fileNm.charAt(i)));
		        }
			}
			
			File file = new File(BASE_PATH+filePath+newFileNm);
			logger.debug("File Path ======>"+file.getAbsolutePath());
			logger.debug("File Exists =====>"+file.exists());

			// 파일명이 영문파일명이면 그냥 SKIP
			if (!procYn) continue;

			if (!file.exists()) {
				HashMap param = new HashMap();		
				param.put("seq", fileInfo.get("seq"));
				param.put("sucessAt", "N");
				param.put("failResn", "파일 찾기 실패~");
				pgbt0020Dao.updateResult(param);
				continue;
			}
			
			File newFile = new File(BASE_PATH+filePath+fileNm);
			
			FileInputStream inputStream = new FileInputStream(file);
			FileOutputStream outputStream = new FileOutputStream(newFile);

			FileChannel fcin = inputStream.getChannel();
			FileChannel fcout = outputStream.getChannel();

			long size = fcin.size();
			fcin.transferTo(0, size, fcout);

			fcout.close();
			fcin.close();

			outputStream.close();
			inputStream.close();			
			
			HashMap param = new HashMap();		
			param.put("seq", fileInfo.get("seq"));
			param.put("sucessAt", "Y");
			param.put("failResn", "");
			pgbt0020Dao.updateResult(param);

		}
	}
}
