package biz.tech.dc;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.infra.util.ResponseUtil;
import com.infra.util.StringUtil;
import com.infra.util.Validate;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import biz.tech.mapif.dc.PGDC0020Mapper;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.property.EgovPropertyService;

/**
 * 신용평가사정보수집관리
 * @author DST
 *
 */
@Service("PGDC0020")
public class PGDC0020Service  extends EgovAbstractServiceImpl {

	private static final Logger logger = LoggerFactory.getLogger(PGDC0020Service.class);
	private Locale locale = Locale.getDefault();
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "messageSource")
	private MessageSource messageSource;
	
	@Resource(name = "PGDC0020Mapper")
	private PGDC0020Mapper pgdc0020Mapper;
	
	
	public ModelAndView index(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		
		Calendar today = Calendar.getInstance();
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		if( Validate.isEmpty(tarket_year) )
		{
			param.put("stdYy", String.valueOf(today.get(Calendar.YEAR)-1));
		}
		else
		{
			param.put("stdYy", tarket_year);
		}

		// 주가정보수집 목록
		List<Map> entInfoMgrList = pgdc0020Mapper.findentInfoMgrList(param);
	
		ModelAndView mv = new ModelAndView();

		mv.addObject("entInfoMgrList", entInfoMgrList);
		
		param.put("curr_year", String.valueOf(today.get(Calendar.YEAR)-1));
		param.put("pre_year", String.valueOf(today.get(Calendar.YEAR)-1));
		mv.addObject("inparam",param);

		mv.setViewName("/admin/dc/BD_UIDCA0020");
		
		return mv;
	}

	public ModelAndView insertentInfo(Map<?, ?> rqstMap) throws Exception {
		
		HashMap param = new HashMap();
		ModelAndView mv = new ModelAndView();
		boolean			sendflag ;
		
		Calendar today = Calendar.getInstance();
		
		String tarket_year = MapUtils.getString(rqstMap, "tarket_year");
		
		if( Validate.isEmpty(tarket_year) )
		{
			param.put("stdYy", String.valueOf(today.get(Calendar.YEAR)-1));
		}
		else
		{
			param.put("stdYy", tarket_year);
		}
		
		List<Map> entReqList = pgdc0020Mapper.callentInfoReq(param);
		
		String file_path =  propertiesService.getString("attachFilePath")+ propertiesService.getString("kedfilepath");
		String file_prefix =  propertiesService.getString("file_prefix","AHPEK01_");
		String file_extension =  propertiesService.getString("file_extension",".txt");
		
		String file_name_format =file_prefix+ String.valueOf(today.get(Calendar.YEAR)) + StringUtil.fillSpaceLeft(String.valueOf(today.get(Calendar.MONTH)+1),2,'0')+
							StringUtil.fillSpaceLeft(String.valueOf(today.get(Calendar.DAY_OF_MONTH)),2,'0')+file_extension;
		
		File	file_path_dir = new File(file_path);
		if(!file_path_dir.exists())
			file_path_dir.mkdirs();
		
		FileWriter  fwriter =new FileWriter( file_path+file_name_format, false);
		
		BufferedWriter bwriter  = null;
		
		try {

			bwriter = new BufferedWriter(fwriter);
			
			for( Map map :entReqList)
			{
				if( map != null) {
					if(map.get("HPE_CD") != null)
						bwriter.write((String)map.get("HPE_CD"));
					bwriter.write("|");
					if(map.get("JURIRNO") != null)
						bwriter.write((String)map.get("JURIRNO"));
					bwriter.write("|");
					if(map.get("BIZRNO") != null)
						bwriter.write((String)map.get("BIZRNO"));
					bwriter.write("|");
					if(map.get("KEDCD") != null)
						bwriter.write((String)map.get("KEDCD"));
					bwriter.write("|");
					if(map.get("ENTRPRS_NM") != null)
						bwriter.write((String)map.get("ENTRPRS_NM"));
					bwriter.newLine();
				}
			}
			
			bwriter.close();
			fwriter.close();

		}
		catch (Exception ex)
		{
			if(bwriter != null)
			{
				bwriter.close();
			}
			if(fwriter != null)
			{
				fwriter.close();
			}
		}
		
		try {
			//sendflag = SendSFTP(file_name_format, "ked");
			//sendflag = SendSFTP(file_name_format, "nice");
			sendflag = SendFTP(file_name_format, "ked");
			// 2017년도 대상 이후 부터 NICE 요청 제거
			// sendflag = SendFTP(file_name_format, "nice");
		}
		catch (Exception ex) {
			 ex.printStackTrace();
			 logger.info("파일전송 실패 ::" + ex.getMessage());
			 sendflag = false;
		 }

		if( sendflag)
		{
			param.put("reqCnt", entReqList.size());
			
			pgdc0020Mapper.insertentInfoMgr(param);
			// 2017년도 대상 이후 부터 NICE 요청 제거
			// pgdc0020Mapper.insertentInfoMgrNice(param);
		
			logger.info("요청리스트 생성건수 ::" + entReqList.size());
			return ResponseUtil.responseText(mv,  "{\"result\":true,\"value\":null,\"message\":\"상호출자제한기업 등록이 정상처리되었습니다.\"}");
			//return ResponseUtil.responseJson(mv, true,"상호출자제한기업 등록이 정상처리되었습니다.");
		}
		else
		{
			String[] mparam = new String[1];
			mparam[0]=file_name_format;
			return ResponseUtil.responseText(mv,  "{\"result\":false,\"value\":null,\"message\":\""+messageSource.getMessage("errors.sftp.fail" ,mparam,locale)+"\"}");
			//return ResponseUtil.responseJson(mv, false,messageSource.getMessage("errors.sftp.fail" ,mparam,locale));
		}
	}

	
	 public boolean SendSFTP(String filename, String type){
		 
		 //StandardFileSystemManager manager = new StandardFileSystemManager();
		 Session session = null;
		 Channel channel = null;
		 ChannelSftp channelSftp = null;
		 FileInputStream in = null;
		 JSch jsch = new JSch();
		 
		 try {
			String localdir =  propertiesService.getString("attachFilePath")+ propertiesService.getString("kedfilepath");
			String remotedir =  null;
			String serverAddress =  null;
			String serverPort=  null;
			
			String userId = null;
			String password = null;
			
			if(type.equals("nice")) {
				remotedir =  propertiesService.getString("niceremotefilepath");
				serverAddress =  propertiesService.getString("nicesftpserver");
				serverPort=  propertiesService.getString("nicesftpport");
				
				userId =  propertiesService.getString("nicesftpuserid").trim();
				password = propertiesService.getString("nicesftppassword").trim();
			} else {
				remotedir =  propertiesService.getString("kedremotefilepath");
				serverAddress =  propertiesService.getString("kedsftpserver");
				serverPort=  propertiesService.getString("kedsftpport");
				
				userId =  propertiesService.getString("kedsftpuserid").trim();
				password = propertiesService.getString("kedsftppassword").trim();
			}
			
			int Port = 0;
			
			if( serverPort != null)
			{
				Port = Integer.parseInt(serverPort);
			}
			else
			{
				Port = 22;
			}
			
			logger.info("Connection Info["+serverAddress+":"+Port+"]");
			//System.out.println("Connection Info["+serverAddress+":"+Port+"]");
			session = jsch.getSession(userId, serverAddress, Port);
			session.setPassword(password);
			
			java.util.Properties config = new java.util.Properties();
			
			config.put("StrictHostKeyChecking", "no");
			session.setConfig(config);
		 
			session.connect();
			channel = session.openChannel("sftp");
			
			channel.connect();
			
			channelSftp = (ChannelSftp)channel;
			//check if the file exists
			String filepath = localdir +  filename;
			File file = new File(filepath);
			if (!file.exists())
					throw new RuntimeException("Error. Local file not found");
		 
			in = new FileInputStream(file);
			
			channelSftp.cd(remotedir);
			
			channelSftp.put(in,filename);

			logger.info("File upload successful["+filename+"]");
			//System.out.println("File upload successful["+filename+"]");
		
			return true;
		 }
		 catch (Exception ex) {
			 ex.printStackTrace();
			 return false;
		 }
		 finally {
			 try {
				 if(in !=null)
					 in.close();
				 if(channelSftp !=null)
					 	channelSftp.exit();
			 } catch (IOException e) {
	                e.printStackTrace();
	         }
		 }

	 }

	 public boolean SendFTP(String filename, String type){
		 
		 //StandardFileSystemManager manager = new StandardFileSystemManager();
		 FileInputStream in = null;
		 FTPClient ftpClient = new FTPClient();

		 try {
			String localdir =  propertiesService.getString("attachFilePath")+ propertiesService.getString("kedfilepath");
			String remotedir =  null;
			String serverAddress =  null;
			String serverPort=  null;
			
			String userId = null;
			String password = null;
			
			if(type.equals("nice")) {
				remotedir =  propertiesService.getString("niceremotefilepath");
				serverAddress =  propertiesService.getString("niceftpserver");
				serverPort=  propertiesService.getString("niceftpport");
				
				userId =  propertiesService.getString("niceftpuserid").trim();
				password = propertiesService.getString("niceftppassword").trim();
			} else {
				remotedir =  propertiesService.getString("kedremotefilepath");
				serverAddress =  propertiesService.getString("kedftpserver");
				serverPort=  propertiesService.getString("kedftpport");
				
				userId =  propertiesService.getString("kedftpuserid").trim();
				password = propertiesService.getString("kedftppassword").trim();
			}
			
			int Port = 0;
			
			if( serverPort != null)
			{
				Port = Integer.parseInt(serverPort);
			}
			else
			{
				Port = 21;
			}
			
			logger.info("Connection Info["+serverAddress+":"+Port+"]");
			ftpClient.connect(serverAddress, Port);
			ftpClient.login(userId, password);
			
			ftpClient.enterLocalPassiveMode();
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

			//check if the file exists
			String filepath = localdir +  filename;
			File file = new File(filepath);
			if (!file.exists())
					throw new RuntimeException("Error. Local file not found");
		 
			in = new FileInputStream(file);
			
			ftpClient.cwd(remotedir);

			boolean done = ftpClient.storeFile(filename, in);
            in.close();
            
            if (done) {
            	logger.info("File upload successful["+filename+"]");
            	return true;
            }
            else
            {
            	logger.info("File upload false["+filename+"]");
            	return false;
            }
		 }
		 catch (Exception ex) {
			 logger.error(ex.getMessage());
			 return false;
		 }
		 finally {
			 try {
				 if(in !=null)
					 in.close();
				 if (ftpClient.isConnected()) {
	                    ftpClient.logout();
	                    ftpClient.disconnect();
	                }
			 } catch (IOException e) {
				 	logger.error(e.getMessage());
	                e.printStackTrace();
	         }
		 }

	 }
	 
}
