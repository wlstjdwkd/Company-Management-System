/*
 * Copyright (c) 2012 ZES Inc. All rights reserved.
 * This software is the confidential and proprietary information of ZES Inc.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZES Inc. (http://www.zesinc.co.kr/)
 */
package com.infra.util;

import java.util.Random;
import java.util.Date;

public final class RandomNumber {

    public static int getInt() {
    	int rnd = 0;
    	if(_rnd != null) rnd = _rnd.nextInt();
        return rnd;
    }
    public static int getInt(int n) {
    	int rnd = 0;
    	if(_rnd != null) rnd = _rnd.nextInt(n);
        return rnd;
    }
    private static Random _rnd = null;
    static {
        _rnd = new Random(new Date().getTime());
    }
}