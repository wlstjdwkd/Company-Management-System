package com.comm.response;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.comm.menu.MenuVO;

/**
 * JSON 형식 Grid 데이터 전달
 */
public class GridJsonVO {

	// 현재 페이지
	private int page;
	// 총 로우 개수
    private int records;
    // 총 페이지 개수
    private int total;
    // 현재 로우 데이터
    private List<Map> rows = new ArrayList<Map>();

	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRecords() {
		return records;
	}
	public void setRecords(int records) {
		this.records = records;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public List<Map> getRows() {
		List<Map> rows = this.rows;
		return rows;
	}
	public void setRows(List<Map> rows) {
		for(int i = 0; i < rows.size(); i++) {
			this.rows.set(i, rows.get(i));
		}
	}

}
