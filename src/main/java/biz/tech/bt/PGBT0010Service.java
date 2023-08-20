package biz.tech.bt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.cmmn.cipher.Seed128Cipher;
import biz.tech.mapif.bt.PGBT0010Mapper;
import com.infra.batch.BatchService;
import com.infra.util.crypto.Crypto;
import com.infra.util.crypto.CryptoFactory;

/**
 * 배치샘플
 * @author sujong
 *
 */
@Service("PGBT0010")
public class PGBT0010Service extends BatchService {

	private static final Logger logger = LoggerFactory.getLogger(PGBT0010Service.class);
	
	@Resource(name = "PGBT0010Mapper")
	PGBT0010Mapper pgbt0010Dao;
	
	@Override
	public void validateParameter() throws Exception {
		for (int i=0; i<args.length; i++) {
			logger.debug("Paramter["+(i+1)+"]==>"+args[i]);
		}
	}

	@Override
	public void processService() throws Exception {
		logger.debug("============= runService ============");

		List<Map> enpList = pgbt0010Dao.selectEnpList();
		
		for (Map enpInfo: enpList) {

			String data = (String) enpInfo.get("password");
			String result = "";
			byte[] key = new byte[64];
			for( int i = 0; i < key.length; i++ ) {
				key[i] = (byte)i;
			}
			result = Seed128Cipher.decrypt(data, key, null);
			
			// PASSWORD 암호화
			byte pszDigest[] = new byte[32];		
			Crypto cry = CryptoFactory.getInstance("SHA256");
			pszDigest =cry.encryptTobyte(result);
			
			
			HashMap param = new HashMap();		
			param.put("corpNo", enpInfo.get("corpNo"));
			param.put("decPwd", result);
			param.put("encPwd", pszDigest);
			
			pgbt0010Dao.insertDecPwd(param);
		}
	}
}
