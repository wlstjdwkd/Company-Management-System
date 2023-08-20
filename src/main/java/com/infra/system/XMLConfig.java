package com.infra.system;

import java.text.MessageFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.apache.commons.configuration.Configuration;

import com.infra.util.StringUtil;
import com.infra.util.Validate;

/**
 * Apache Jakarta commons-configration 프로젝트를 통한 속성 객체 
 */
public final class XMLConfig {

    /** 환결설정 객체 */
    private static Configuration conf = ConfigManager.getConfig(GlobalConst.INCLUDE_SCRIPT_FILES);

    public static void setConfiguration(Configuration _conf) {
        conf = _conf;
    }

    public static void setConfiguration(String config) {
        conf = ConfigManager.getConfig(config);
    }

    public static String getString(String key) {
        return conf.getString(key);
    }

    public static String getString(String key, String defaultValue) {
        return conf.getString(key, defaultValue);
    }

    public static String[] getStringArray(String key) {
        return conf.getStringArray(key);
    }

    public static List<?> getList(String key) {
        return conf.getList(key);
    }

    public static List<?> getList(String key, List<Object> defaultValue) {
        return conf.getList(key, defaultValue);
    }

    public static boolean getBoolean(String key) {
        return conf.getBoolean(key);
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        return conf.getBoolean(key, defaultValue);
    }

    public static double getDouble(String key) {
        return conf.getDouble(key);
    }

    public static double getDouble(String key, double defaultValue) {
        return conf.getDouble(key, defaultValue);
    }

    public static long getLong(String key) {
        return conf.getLong(key);
    }

    public static long getLong(String key, long defaultValue) {
        return conf.getLong(key, defaultValue);
    }

    public static float getFloat(String key) {
        return conf.getFloat(key);
    }

    public static float getFloat(String key, float defaultValue) {
        return conf.getFloat(key, defaultValue);
    }

    public static int getInt(String key) {
        return conf.getInt(key);
    }

    public static int getInt(String key, int defaultValue) {
        return conf.getInt(key, defaultValue);
    }

    public static short getShort(String key) {
        return conf.getShort(key);
    }

    public static short getShort(String key, short defaultValue) {
        return conf.getShort(key, defaultValue);
    }

    public static Iterator<String> getKeys(String key) {
        return conf.getKeys(key);
    }

    public static Properties getProperties(String key) {
        return conf.getProperties(key);
    }

    public static String getText(String key) {
        return getText(key, null);
    }

    public static String getText(String key, String[] messages) {

        String returnVal = getString(key);

        return Validate.isEmpty(returnVal) && Validate.isEmpty(messages) ? StringUtil.EMPTY
            : Validate.isEmpty(messages) ? returnVal.trim()
                : new MessageFormat(returnVal).format(messages).trim();
    }
}
