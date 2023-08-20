package com.comm.issue;


import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.comm.mapif.CertIssueMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

/**
 * 기업확인서발급출력
 * 
 * @author JGS
 * 
 */
@Service("certissueService")
public class CertIssueService extends EgovAbstractServiceImpl {
	
	private static final Logger logger = LoggerFactory.getLogger(CertIssueService.class);	
	
	@Resource(name = "certissueMapper")
	private CertIssueMapper certDAO;
	
	/**
	 * 사용자 조회
	 * @param param 로그인ID
	 * @return 사용자VO
	 * @throws Exception
	 */
	public CertIssueVo findCertIssueBsisInfo(Map<String, Object> inparam) throws Exception {	
		Calendar today = Calendar.getInstance();
		
		CertIssueVo CertIssueInfo = new CertIssueVo();
				
		 List<Map> certissuebsisinfo = certDAO.findCertIssueBsisInfo(inparam);
		
		if(Validate.isEmpty(certissuebsisinfo))
			return null;
		
		String rceptNoOrg = (String)certissuebsisinfo.get(0).get("rceptNo");
		
		if(StringUtil.equals((String)certissuebsisinfo.get(0).get("isgnAt"), "Y"))
		{
			inparam.put("rceptNo", rceptNoOrg);
			List<Map> certissueisgninfo = certDAO.findCertIssueIsgnInfo(inparam);
			
			if(Validate.isEmpty(certissueisgninfo))
				return null;
			
			inparam.remove("rceptNo");
			inparam.put("rceptNo", (String)certissueisgninfo.get(0).get("rceptNo"));
			
			List<Map> certissuebizlist = certDAO.findCertIssueBiznoList(inparam);

			if(Validate.isEmpty(certissuebizlist))
				return null;
			
			
			String docNo = certDAO.calldocNo(rceptNoOrg);
			
			if(Validate.isEmpty(docNo))
				return null;
			
			CertIssueInfo.setAddress((String)certissueisgninfo.get(0).get("hedofcAdres"));
			CertIssueInfo.setCeoNm((String)certissueisgninfo.get(0).get("rprsntvNm"));
			CertIssueInfo.setCorpNm((String)certissueisgninfo.get(0).get("entrprsNm"));
			CertIssueInfo.setDocNo(docNo);
			CertIssueInfo.setExpireDe(((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(0,4)+"-"+((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(4,6) 
					+"-"+((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(6,8) + " ~ " + ((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(0,4)+"-"
					+((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(4,6) +"-"+((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(6,8));
			CertIssueInfo.setIssueNo((String)inparam.get("issueNo"));
			CertIssueInfo.setJuriNo(StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),0,6)+"-"+StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),6));
			
			StringBuffer corpreqno = new StringBuffer();
			boolean first = false;

			for(Map map:certissuebizlist)
			{
				if(first)
				{
					corpreqno.append(",");
				}
				else
				{
					first = true;
				}
				corpreqno.append(((String)map.get("bizrNo")).substring(0,3)).append("-").append(((String)map.get("bizrNo")).substring(3,5));
				corpreqno.append("-").append(((String)map.get("bizrNo")).substring(5));
			}
			
			corpreqno.append(")");
			CertIssueInfo.setCorpRegNo(corpreqno.toString());
			
			// 재발급일자
			CertIssueInfo.setPrintDe(((String)certissueisgninfo.get(0).get("resnOccrrncDe")).substring(0,4)+"년 "
					+((String)certissueisgninfo.get(0).get("resnOccrrncDe")).substring(4,6)+"월 "
					+((String)certissueisgninfo.get(0).get("resnOccrrncDe")).substring(6,8)+"일");
		}
		else
		{
			String docNo = certDAO.calldocNo(rceptNoOrg);
			
			if(Validate.isEmpty(docNo))
				return null;
			
			inparam.put("rceptNo", rceptNoOrg);
			List<Map> certissuebizlist = certDAO.findCertIssueAddBiznoList(inparam);
			
			CertIssueInfo.setAddress((String)certissuebsisinfo.get(0).get("hedofcAdres"));
			CertIssueInfo.setCeoNm((String)certissuebsisinfo.get(0).get("rprsntvNm"));
			CertIssueInfo.setCorpNm((String)certissuebsisinfo.get(0).get("entrprsNm"));
			CertIssueInfo.setDocNo(docNo);
			CertIssueInfo.setExpireDe(((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(0,4)+"-"+((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(4,6) 
						+"-"+((String)certissuebsisinfo.get(0).get("validpdBeginDe")).substring(6,8) + " ~ " + ((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(0,4)+"-"
						+((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(4,6) +"-"+((String)certissuebsisinfo.get(0).get("validdpEndDe")).substring(6,8));
			CertIssueInfo.setIssueNo((String)inparam.get("issueNo"));
			CertIssueInfo.setJuriNo(StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),0,6)+"-"+StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),6));
			
			/*CertIssueInfo.setCorpRegNo(((String)certissuebsisinfo.get(0).get("bizrNo")).substring(0,3)+"-"+ ((String)certissuebsisinfo.get(0).get("bizrNo")).substring(3,5)
						+"-"+((String)certissuebsisinfo.get(0).get("bizrNo")).substring(5)+")");*/
			
			StringBuffer corpreqno = new StringBuffer();
			boolean first = false;
			
			for(Map map:certissuebizlist)
			{
				if(first)
				{
					corpreqno.append(",");
				}
				else
				{
					first = true;
				}
				corpreqno.append(((String)map.get("bizrNo")).substring(0,3)).append("-").append(((String)map.get("bizrNo")).substring(3,5));
				corpreqno.append("-").append(((String)map.get("bizrNo")).substring(5));
			}
			corpreqno.append(")");
			CertIssueInfo.setCorpRegNo(corpreqno.toString());
			
			// 발급일자
			CertIssueInfo.setPrintDe(((String)certissuebsisinfo.get(0).get("issuDe")).substring(0,4)+"년 "
						+((String)certissuebsisinfo.get(0).get("issuDe")).substring(4,6)+"월 "
						+((String)certissuebsisinfo.get(0).get("issuDe")).substring(6,8)+"일");
		}
		
		// 출력일자(현재일자) -> 발급일자 로 변경
		/*CertIssueInfo.setPrintDe(String.valueOf(today.get(Calendar.YEAR))+"년 "+StringUtil.leftPad(String.valueOf((today.get(Calendar.MONTH) + 1)),2,'0')+"월 "
								+StringUtil.leftPad(String.valueOf((today.get(Calendar.DAY_OF_MONTH))),2,'0') +"일");*/
		
		return CertIssueInfo;

	}
	
	/**
	 * 사용자 조회(기업 확인서 발급 신청증)
	 * @param param 로그인ID
	 * @return 사용자VO
	 * @throws Exception
	 */
	public CertIssueVo findCertIssueBsisInfo2(Map<String, Object> inparam) throws Exception {	
		Calendar today = Calendar.getInstance();
		
		CertIssueVo CertIssueInfo = new CertIssueVo();
		
		List<Map> certissuebsisinfo = certDAO.findCertIssueBsisInfo2(inparam);
		
		if(Validate.isEmpty(certissuebsisinfo))
			return null;
		
		String rceptNoOrg = (String)inparam.get("rceptNo");
		
		List<Map> certissuebizlist = certDAO.findCertIssueAddBiznoList(inparam);
		
		if(!StringUtil.equals((String)certissuebsisinfo.get(0).get("isgnAt"), "Y"))
		{
			String docNo = certDAO.calldocNo2(rceptNoOrg);
			
			if(Validate.isEmpty(docNo))
				return null;
			
			CertIssueInfo.setAddress((String)certissuebsisinfo.get(0).get("hedofcAdres"));
			CertIssueInfo.setCeoNm((String)certissuebsisinfo.get(0).get("rprsntvNm"));
			CertIssueInfo.setCorpNm((String)certissuebsisinfo.get(0).get("entrprsNm"));
			CertIssueInfo.setDocNo(docNo);
			CertIssueInfo.setRceptNo((String)inparam.get("rceptNo"));
			CertIssueInfo.setJuriNo(StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),0,6)+"-"+StringUtil.substring((String)certissuebsisinfo.get(0).get("jurirNo"),6));
			CertIssueInfo.setRceptDe(((String)certissuebsisinfo.get(0).get("rceptDe")).substring(0,4)+"-"+((String)certissuebsisinfo.get(0).get("rceptDe")).substring(4,6)
						+"-"+((String)certissuebsisinfo.get(0).get("rceptDe")).substring(6,8));
			/*CertIssueInfo.setCorpRegNo(((String)certissuebsisinfo.get(0).get("bizrNo")).substring(0,3)+"-"+ ((String)certissuebsisinfo.get(0).get("bizrNo")).substring(3,5)
						+"-"+((String)certissuebsisinfo.get(0).get("bizrNo")).substring(5)+")");*/
			
			StringBuffer corpreqno = new StringBuffer();
			boolean first = false;
			
			for(Map map:certissuebizlist)
			{
				if(first)
				{
					corpreqno.append(",");
				}
				else
				{
					first = true;
				}
				corpreqno.append(((String)map.get("bizrNo")).substring(0,3)).append("-").append(((String)map.get("bizrNo")).substring(3,5));
				corpreqno.append("-").append(((String)map.get("bizrNo")).substring(5));
			}
			corpreqno.append(")");
			CertIssueInfo.setCorpRegNo(corpreqno.toString());
		}
		
		CertIssueInfo.setPrintDe(String.valueOf(today.get(Calendar.YEAR))+"년 "+StringUtil.leftPad(String.valueOf((today.get(Calendar.MONTH) + 1)),2,'0')+"월 "
								+StringUtil.leftPad(String.valueOf((today.get(Calendar.DAY_OF_MONTH))),2,'0') +"일");
		
		return CertIssueInfo;
	}
}
