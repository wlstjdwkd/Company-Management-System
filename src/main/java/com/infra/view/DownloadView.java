package com.infra.view;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.infra.file.FileVO;
import com.infra.file.UploadHelper;
import com.infra.system.GlobalConst;
import com.infra.util.StringUtil;

import org.springframework.web.servlet.view.AbstractView;

/**
 * @author dongwoo
 *
 */
public class DownloadView extends AbstractView {

    private final int ILLEGAL_ARGUMENT = 1;
    private final int NO_EXIST = 2;
    public static final String DEFAULT_CONTENT_TYPE = "application/octet-stream";

    public DownloadView() {
    }

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
        HttpServletResponse response) throws RuntimeException, Exception {

        String encodedFileNm = null;
        File file = null;

        Object object = model.get(GlobalConst.FILE_DATA_KEY);
        if(object instanceof File) {
            file = (File) object;
            encodedFileNm = new String(file.getName().getBytes("KSC5601"), "8859_1");
        } else if(object instanceof FileVO) {
            FileVO baseFileVo = (FileVO) object;
            encodedFileNm = new String(baseFileVo.getLocalNm().getBytes("KSC5601"), "8859_1");
            String fileUrl = UploadHelper.WEBAPP_ROOT+baseFileVo.getFileUrl();
            logger.debug("^^^^^^^^^^^^^^^^^^^^ fileUrl: "+fileUrl);
            file = new File(fileUrl);
        } else {
            flushError(response, ILLEGAL_ARGUMENT, null);
            return;
        }

        if(file == null || !file.exists()) {
            flushError(response, NO_EXIST, encodedFileNm);
            return;
        }

        response.setHeader("Content-Transfer-Encoding", "binary");
        response.setContentLength((int) file.length());

        response.setHeader("Content-Disposition", "attachment;filename=" + encodedFileNm + ";");
        setContentType(DEFAULT_CONTENT_TYPE);

        byte b[] = new byte[1024];

        FileInputStream fileInS = new FileInputStream(file);
        BufferedInputStream fin = new BufferedInputStream(fileInS);
        BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
        int read = 0;

        try {
            while((read = fin.read(b)) != -1) {
                outs.write(b, 0, read);
            }

            outs.close();
        } catch (RuntimeException e) {
        	logger.warn("Download error : " + e);
        } catch (Exception e) {
            if(logger.isInfoEnabled()) {
                logger.warn("Download error : " + e);
            }
        } finally {
            if(fin != null) {
            	fin.close();
            }
            if(fileInS != null) {
            	fileInS.close();
            }
        }

        if(file.getName().startsWith("CompressDown_")) {
            try {
                file.delete();
            } catch (RuntimeException e) {
            	logger.error("", e);
            } catch (Exception e) {
            	logger.error("", e);
            }
        }
    }

    /**
     * 오류 발생 시 메시지를 생성하고 alert을 통하여 메시지를 전달 후 history.back()을 호출한다.
     *
     * @param response
     * @param flag
     * @throws Exception
     */
    private void flushError(HttpServletResponse response, int flag, String fileName) throws RuntimeException, Exception {

        String message = null;
        switch(flag) {
            case ILLEGAL_ARGUMENT:
                message = "요청 정보가 올바르게 전달되지 않았습니다.";
                break;
            case NO_EXIST:
                message = "[ " + fileName + " ] 파일이 삭제되었거나 존재하지 않습니다.";
                break;
            default:
                message = StringUtil.EMPTY;
                break;
        }
        /*
         * StringBuffer alertScript = new StringBuffer();
         * alertScript.append("<script type='text/javascript'>");
         * alertScript.append("    alert('" + message + "');  ");
         * alertScript.append("    history.back();            ");
         * alertScript.append("</script>                      ");
         * response.setContentType("text/html");
         * response.setCharacterEncoding("UTF-8");
         * response.getWriter().write(alertScript.toString());
         */
        response.sendError(404, message);
    }
}
