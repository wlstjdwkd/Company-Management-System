/**
 * 프로그램명: sql Session Factory
 * 내     용: SQL Session Factory
 * 이     력:
 *  ---------------------------------------------------------------
 *  Revision	Date		Author		Description
 *  ---------------------------------------------------------------
 *  1.1			2014/04/22	강수종		최초 작성
 *
 */
package com.infra.dev;

import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Observable;
import java.util.Observer;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import com.infra.dev.Notifier;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.builder.xml.XMLConfigBuilder;
import org.apache.ibatis.executor.ErrorContext;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

/**
 * mybatis mapper 서버 재시작이 필요 없이 반영
 */
public class RefreshableSqlSessionFactoryBean extends SqlSessionFactoryBean implements Observer {
	private static final Log log = LogFactory.getLog(RefreshableSqlSessionFactoryBean.class);

	private SqlSessionFactory proxy;

	private Resource configLocation;

	private Resource[] mapperLocations;

	private Properties configurationProperties;

	private Map<Resource, Long> map = new HashMap<Resource, Long>();

	/**
	 * Set optional properties to be passed into the SqlSession configuration, as alternative to a
	 * {@code &lt;properties&gt;} tag in the configuration xml file. This will be used to
	 * resolve placeholders in the config file.
	 */
	public void setConfigurationProperties(Properties sqlSessionFactoryProperties) {
		super.setConfigurationProperties(sqlSessionFactoryProperties);
		this.configurationProperties = sqlSessionFactoryProperties;
	}

	private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();

	private final Lock r = rwl.readLock();

	private final Lock w = rwl.writeLock();

	public void setConfigLocation(Resource configLocation) {
		super.setConfigLocation(configLocation);
		this.configLocation = configLocation;
	}

	public void setMapperLocations(Resource[] mapperLocations) {
		super.setMapperLocations(mapperLocations);
		 this.mapperLocations = new Resource[mapperLocations.length];
	     for(int i = 0; i < mapperLocations.length; ++i) {
	    	 this.mapperLocations[i] = mapperLocations[i];
	     }
	}

	public void refresh() throws RuntimeException, Exception {
		if (log.isInfoEnabled()) {
			log.info("refreshing SqlSessionFactory.");
		}

		w.lock();

		try {
			if (isModified()) {
				super.afterPropertiesSet();
			} else {
				log.info("no sql files modified.");
			}
		} finally {
			w.unlock();
		}
	}

	/**
	 *
	 * 싱글톤 멤버로 SqlSessionFactory 원본 대신 프록시로 설정하도록 오버라이드.
	 */
	public void afterPropertiesSet() throws RuntimeException, Exception {
		super.afterPropertiesSet();
		setRefreshable();
		Notifier.getInstance().setObj(this);
	}

	private void setRefreshable() {
		proxy = (SqlSessionFactory) Proxy.newProxyInstance(

		SqlSessionFactory.class.getClassLoader(),

		new Class[] { SqlSessionFactory.class },

		new InvocationHandler() {
			public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
				//log.debug("method.getName() : " + method.getName());
				return method.invoke(getParentObject(), args);
			}
		});

		isModified();
	}

	private boolean isModified() {
		boolean retVal = false;

		if (mapperLocations != null) {
			for (int i = 0; i < mapperLocations.length; i++) {
				Resource mappingLocation = mapperLocations[i];
				retVal |= findModifiedResource(mappingLocation);
				if (retVal)
					break;
			}
		}

		if (configLocation != null) {
			Configuration configuration = null;

			XMLConfigBuilder xmlConfigBuilder = null;
			try {
				xmlConfigBuilder = new XMLConfigBuilder(configLocation.getInputStream(), null, configurationProperties);
				configuration = xmlConfigBuilder.getConfiguration();
			} catch (IOException e) {
				log.error(e);
			}

			if (xmlConfigBuilder != null) {
				try {
					xmlConfigBuilder.parse();

					// Configuration 클래스의 protected member field 인 loadedResources 를 얻기 위해 reflection 을 사용함.

					Field loadedResourcesField = Configuration.class.getDeclaredField("loadedResources");
					loadedResourcesField.setAccessible(true);

					@SuppressWarnings("unchecked")
					Set<String> loadedResources = (Set<String>) loadedResourcesField.get(configuration);

					for (Iterator<String> iterator = loadedResources.iterator(); iterator.hasNext();) {
						String resourceStr = (String) iterator.next();
						if (resourceStr.endsWith(".xml")) {
							Resource mappingLocation = new ClassPathResource(resourceStr);
							retVal |= findModifiedResource(mappingLocation);
							if (retVal) {
								break;
							}
						}
					}

				} catch (RuntimeException ex) {
					throw new RuntimeException("Failed to parse config resource: " + configLocation, ex);
				} catch (Exception ex) {
					throw new RuntimeException("Failed to parse config resource: " + configLocation, ex);
				} finally {
					ErrorContext.instance().reset();
				}
			}
		}

		return retVal;
	}

	private boolean findModifiedResource(Resource resource) {
		boolean retVal = false;
		List<String> modifiedResources = new ArrayList<String>();

		try {
			long modified = resource.lastModified();

			if (map.containsKey(resource)) {
				long lastModified = ((Long) map.get(resource)).longValue();

				if (lastModified != modified) {
					map.put(resource, new Long(modified));

					modifiedResources.add(resource.getDescription());

					retVal = true;
				}
			} else {
				map.put(resource, new Long(modified));
			}

		} catch (IOException e) {
			log.error("caught exception", e);
		}

		if (retVal) {
			if (log.isInfoEnabled()) {
				log.info("modified files : " + modifiedResources);
			}
		}

		return retVal;
	}

	private Object getParentObject() throws RuntimeException, Exception {
		r.lock();

		try {
			return super.getObject();

		} finally {
			r.unlock();
		}
	}

	public SqlSessionFactory getObject() {
		return this.proxy;
	}

	public Class<? extends SqlSessionFactory> getObjectType() {
		return (this.proxy != null ? this.proxy.getClass() : SqlSessionFactory.class);
	}

	public boolean isSingleton() {
		return true;
	}

	public void update(Observable o, Object arg) {
		try {
			refresh();
		} catch (RuntimeException e) {
			log.fatal("error occured while refreshing sql files...."+e);
			log.error(e);
			//e.printStackTrace();
		} catch (Exception e) {
			log.fatal("error occured while refreshing sql files...."+e);
			log.error(e);
			//e.printStackTrace();
		}
	}

}
