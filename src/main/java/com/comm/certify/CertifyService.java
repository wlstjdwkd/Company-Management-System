package com.comm.certify;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.infra.system.GlobalConst;
import com.infra.util.SessionUtil;

import org.apache.commons.collections.MapUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import Kisinfo.Check.IPINClient;
import NiceID.Check.CPClient;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
//import com.comm.mapif.CodeMapper;

/**
 * NICE 암/복호화 서비스 클래스
 * @author JGS
 *
 */
@Service("certifyService")
public class CertifyService extends EgovAbstractServiceImpl {

	private Locale locale = Locale.getDefault();

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	/**
	 * 인증에 필요한 기초 정보 암호화(NICE)
	 * @param
	 * @return
	 * @throws Exception
	 */
	public NiceEncVO encDataNice() throws RuntimeException, Exception {
		CPClient niceCheck = new CPClient();
		NiceEncVO niceEncVo = new NiceEncVO();

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		if(request.isSecure()) {
			niceEncVo.setReturnUrl(GlobalConst.NICE_RETURN_URL_S);
			niceEncVo.setIpinreturnUrl(GlobalConst.NICE_IPIN_RETURN_URL_S);
		}

		niceEncVo.setRequestNumber(niceCheck.getRequestNO(niceEncVo.getSiteCode()));

		StringBuffer plainData = new StringBuffer();
		plainData.append("7:REQ_SEQ");
		plainData.append(niceEncVo.getRequestNumber().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getRequestNumber());

		plainData.append("8:SITECODE");
		plainData.append(niceEncVo.getSiteCode().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getSiteCode());

		plainData.append("9:AUTH_TYPE");
		plainData.append(niceEncVo.getAuthType().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getAuthType());

		plainData.append("7:RTN_URL");
		plainData.append(niceEncVo.getReturnUrl().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getReturnUrl());

		plainData.append("7:ERR_URL");
		plainData.append(niceEncVo.getErrorUrl().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getErrorUrl());

		plainData.append("11:POPUP_GUBUN");
		plainData.append(niceEncVo.getPopgubun().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getPopgubun());

		plainData.append("9:CUSTOMIZE");
		plainData.append(niceEncVo.getCustomize().getBytes().length);
		plainData.append(":");
		plainData.append(niceEncVo.getCustomize());

		niceEncVo.setPlainData(plainData.toString());

		int rtnCd = niceCheck.fnEncode(niceEncVo.getSiteCode(), niceEncVo.getSitePassword(), niceEncVo.getPlainData());
		String msg = "암호화";
		switch(rtnCd) {
		case 0:		// 정상
			niceEncVo.setEncData(niceCheck.getCipherData());
			break;
		case -1:	// 암호화 시스템 에러
			niceEncVo.setMessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -2:	// 암호화 처리 오류
			niceEncVo.setMessage(messageSource.getMessage("errors.nice.process", new String[] {msg}, locale));
			break;
		case -3:	// 암호화 데이터 오류
			niceEncVo.setMessage(messageSource.getMessage("errors.nice.data", new String[] {msg}, locale));
			break;
		case -9:	// 입력 데이터 오류
			niceEncVo.setMessage(messageSource.getMessage("errors.nice.indata", new String[] {msg}, locale));
			break;
		default:	// 알 수 없는 에러
			niceEncVo.setMessage(messageSource.getMessage("errors.nice.etc", new String[] {msg}, locale));
			break;
		}

		niceEncVo.setEncErrCd(rtnCd);

		IPINClient pClient = new IPINClient();
		niceEncVo.setIpinrequestNumber(pClient.getRequestNO(niceEncVo.getIpinsiteCode()));
		rtnCd = -1;
		rtnCd = pClient.fnRequest(niceEncVo.getIpinsiteCode(), niceEncVo.getIpinsitePassword(), niceEncVo.getIpinrequestNumber(), niceEncVo.getIpinreturnUrl());

		msg = "암호화";
		switch(rtnCd) {
		case 0:		// 정상
			niceEncVo.setIpinencData(pClient.getCipherData());
			break;
		case -1:	// 암호화 시스템 에러
			niceEncVo.setIpinmessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -2:	// 암호화 처리 오류
			niceEncVo.setIpinmessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -9:	// 입력 데이터 오류
			niceEncVo.setIpinmessage(messageSource.getMessage("errors.nice.indata", new String[] {msg}, locale));
			break;
		default:	// 알 수 없는 에러
			niceEncVo.setIpinmessage(messageSource.getMessage("errors.nice.etc", new String[] {msg}, locale));
			break;
		}

		niceEncVo.setIpinencErrCd(rtnCd);

		return niceEncVo;
	}

	/**
	 * 인증에 필요한 기초 정보 복호(NICE)
	 * @param
	 * @return
	 * @throws Exception
	 */
	public NiceDecVO decDataNice(String encParam) throws RuntimeException, Exception {
		CPClient niceCheck = new CPClient();
		NiceDecVO niceDecVo = new NiceDecVO();
		String encodeData = requestReplace(encParam,"encodeData");

		int rtnCd = niceCheck.fnDecode(niceDecVo.getSiteCode(), niceDecVo.getSitePassword(), encodeData);
		String msg = "복호화";
		niceDecVo.setDecErrCd(rtnCd);
		switch(rtnCd) {
		case 0:		// 정상
			niceDecVo.setPlainData(niceCheck.getPlainData());
			niceDecVo.setCipherTime(niceCheck.getCipherDateTime());
			niceDecVo.setCipherIPAddress(niceCheck.getCipherIPAddress());
			// 데이터 추출
			Map<String,String> parsedMap = new HashMap<String,String>();
			parsedMap = niceCheck.fnParse(niceDecVo.getPlainData());
			niceDecVo.setRequestNumber(MapUtils.getString(parsedMap, "REQ_SEQ", ""));
			niceDecVo.setResponseNumber(MapUtils.getString(parsedMap, "RES_SEQ", ""));
			niceDecVo.setAuthType(MapUtils.getString(parsedMap, "AUTH_TYPE", ""));
			niceDecVo.setName(MapUtils.getString(parsedMap, "NAME", ""));
			niceDecVo.setBirthDate(MapUtils.getString(parsedMap, "BIRTHDATE", ""));
			niceDecVo.setGender(MapUtils.getString(parsedMap, "GENDER", ""));
			niceDecVo.setNationalInfo(MapUtils.getString(parsedMap, "NATIONALINFO", ""));
			niceDecVo.setDupInfo(MapUtils.getString(parsedMap, "DI", ""));
			niceDecVo.setConnInfo(MapUtils.getString(parsedMap, "CI", ""));
			niceDecVo.setFailErrCd(MapUtils.getString(parsedMap, "ERR_CODE", ""));
			break;
		case -1:	// 복호화 시스템 에러
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -4:	// 복호화 처리 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.process", new String[] {msg}, locale));
			break;
		case -5:	// 복호화 해쉬 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.hash", new String[] {msg}, locale));
			break;
		case -6:	// 복호화 데이터 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.data", new String[] {msg}, locale));
			break;
		case -9:	// 입력 데이터 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.indata", new String[] {msg}, locale));
			break;
		case -12:	// 사이트 패스워드 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.pass", new String[] {}, locale));
			break;
		default:	// 알 수 없는 에러
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.etc", new String[] {}, locale));
			break;
		}

		return niceDecVo;
	}

	/**
	 * 인증에 필요한 기초 정보 복호(NICE)
	 * @param
	 * @return
	 * @throws Exception
	 */
	public NiceDecVO ipindecDataNice(String encParam) throws RuntimeException, Exception {
		IPINClient pClient = new IPINClient();
		NiceDecVO niceDecVo = new NiceDecVO();
		String encodeData = requestReplace(encParam,"encodeData");

		int rtnCd = pClient.fnResponse(niceDecVo.getIpinsiteCode(), niceDecVo.getIpinsitePassword(), encodeData);
		String msg = "복호화";
		niceDecVo.setDecErrCd(rtnCd);
		switch(rtnCd) {
		case 1:		// 정상
			// 데이터 추출
			niceDecVo.setRequestNumber(pClient.getCPRequestNO());
			niceDecVo.setResponseNumber(pClient.getCPRequestNO());
			niceDecVo.setName(pClient.getName());
			niceDecVo.setBirthDate(pClient.getBirthDate());
			niceDecVo.setAgeCode(pClient.getAgeCode());
			niceDecVo.setGender(pClient.getGenderCode());
			niceDecVo.setNationalInfo(pClient.getNationalInfo());
			niceDecVo.setDupInfo(pClient.getDupInfo());
			niceDecVo.setConnInfo(pClient.getVNumber());
			break;
		case -1:	// 복호화 시스템 에러
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -4:	// 복호화 처리 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -6:	// 복호화 해쉬 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.system", new String[] {msg}, locale));
			break;
		case -9:	// 입력 데이터 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.indata", new String[] {msg}, locale));
			break;
		case -12:	// 사이트 패스워드 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.pass", new String[] {}, locale));
			break;
		case -13:	// 복호화 데이터 오류
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.data", new String[] {msg}, locale));
			break;
		default:	// 알 수 없는 에러
			niceDecVo.setMessage(messageSource.getMessage("errors.nice.etc", new String[] {}, locale));
			break;
		}

		return niceDecVo;
	}

	private String requestReplace (String paramValue, String gubun) {
        String result = "";

        if (paramValue != null) {

        	paramValue = paramValue.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

        	paramValue = paramValue.replaceAll("\\*", "");
        	paramValue = paramValue.replaceAll("\\?", "");
        	paramValue = paramValue.replaceAll("\\[", "");
        	paramValue = paramValue.replaceAll("\\{", "");
        	paramValue = paramValue.replaceAll("\\(", "");
        	paramValue = paramValue.replaceAll("\\)", "");
        	paramValue = paramValue.replaceAll("\\^", "");
        	paramValue = paramValue.replaceAll("\\$", "");
        	paramValue = paramValue.replaceAll("'", "");
        	paramValue = paramValue.replaceAll("@", "");
        	paramValue = paramValue.replaceAll("%", "");
        	paramValue = paramValue.replaceAll(";", "");
        	paramValue = paramValue.replaceAll(":", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll("#", "");
        	paramValue = paramValue.replaceAll("--", "");
        	paramValue = paramValue.replaceAll("-", "");
        	paramValue = paramValue.replaceAll(",", "");

        	if(gubun != "encodeData"){
        		paramValue = paramValue.replaceAll("\\+", "");
        		paramValue = paramValue.replaceAll("/", "");
            paramValue = paramValue.replaceAll("=", "");
        	}

        	result = paramValue;

        }
        return result;
  }
}
