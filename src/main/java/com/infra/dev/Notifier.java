/**
 * 프로그램명: sql Session Reload Notifier
 * 내     용:
 * 이     력:
 *  ---------------------------------------------------------------
 *  Revision	Date		Author		Description
 *  --------------------------------------------------------------- 
 *  1.1			2014/04/22	강수종		최초 작성
 *  
 */
package com.infra.dev;

import java.util.Observable;
import java.util.Observer;

public class Notifier extends Observable {

	private static Notifier ntf = new Notifier();

	public static Notifier getInstance() {
		return ntf;
	}

	public void setObj(Observer o) {	
		ntf.addObserver(o);
	}
	
	public void order() {
		ntf.setChanged();
		ntf.notifyObservers();
	}
}
