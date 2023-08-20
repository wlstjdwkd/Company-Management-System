package com.infra.system;

import java.net.URL;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.DefaultConfigurationBuilder;

/**
 * 환경설정 파일 로드
 *
 */
public class ConfigManager {

    /**
     * 환경설정을 로드한다.
     * 환경설정은 xml 파일 사용을 기본으로 하며, 패키지의 폴더에
     * 위치하는 것을 기본으로 한다.
     */
    public static Configuration getConfig(String config) {
        try {

            URL resource = getDefaultClassLoader().getResource(config);

            DefaultConfigurationBuilder builder = new DefaultConfigurationBuilder(resource);

            return builder.getConfiguration(true);

        } catch (ConfigurationException e) {
            throw new RuntimeException(
                "환경설정 경로를 확인하세요. Root cause: " + e);
        }
    }

    /**
     * 현재 스레드의 <code>ClassLoader</code>를 구한다.
     * 오류발생시 현재 클레스의 기본 <code>ClassLoader</code>를 호출하여 반환한다.
     *
     * @return ClassLoader
     */
    private static ClassLoader getDefaultClassLoader() {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        if(cl == null) {
            cl = ConfigManager.class.getClassLoader();
        }
        return cl;
    }

}
