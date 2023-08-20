package com.infra.taglib.include;

import java.io.IOException;
import java.beans.PropertyEditor;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringArrayPropertyEditor;

import com.infra.system.GlobalConst;



/**
 * JSP에서 GlobalConst를 별도 선언하지 않고 바로 사용하도록 등록
 * 
 * <pre>
 * 사용 예 :
 * <ap:globalConst />
 * </pre>
 */
public class GlobalConstTag extends SimpleTagSupport {
	
	private static final Logger logger = LoggerFactory.getLogger(GlobalConstTag.class);

	private static Map<Class<?>, PropertyEditor> defaultEditors = new HashMap<Class<?>, PropertyEditor>() {        
		private static final long serialVersionUID = -996041036651539276L;

		{
            put(boolean.class, new CustomBooleanEditor(false));
            put(Boolean.class, new CustomBooleanEditor(true));
            put(byte.class, new CustomNumberEditor(Byte.class, false));
            put(Byte.class, new CustomNumberEditor(Byte.class, true));
            put(int.class, new CustomNumberEditor(Integer.class, false));
            put(Integer.class, new CustomNumberEditor(Integer.class, true));
            put(float.class, new CustomNumberEditor(Float.class, false));
            put(Float.class, new CustomNumberEditor(Float.class, true));
            put(long.class, new CustomNumberEditor(Long.class, false));
            put(Long.class, new CustomNumberEditor(Long.class, true));                        
            put(List.class, new CustomCollectionEditor(List.class));
            
            StringArrayPropertyEditor sae = new StringArrayPropertyEditor();
            put(String[].class, sae);
            put(short[].class, sae);
            put(int[].class, sae);
            put(long[].class, sae);
        }
    };

    /**
     * GlobalConst.class에 public으로 선언된 변수들을 JSP Attribute에 추가한다.
     */
    @Override
    public void doTag() throws JspException, IOException {
    	Field[] fields = GlobalConst.class.getFields();
    	for (Field field : fields) {
			try {				
				String fieldName = field.getName();    		
	    		String fieldValue = String.valueOf(field.get(fieldName));	    		
	    		
	            if (field.getType() == String.class) {
	            	getJspContext().setAttribute(fieldName, fieldValue);
	                continue;
	            }
	            
	    		PropertyEditor propertyEditor = defaultEditors.get(field.getType());
	    		if (propertyEditor != null) {
	                propertyEditor.setAsText(fieldValue);
	                getJspContext().setAttribute(fieldName, propertyEditor.getValue());
	            }
	    		
			} catch (IllegalArgumentException e) {
				throw new JspException(e);
			} catch (IllegalAccessException e) {
				throw new JspException(e);
			}
    	}
    }
    
}
