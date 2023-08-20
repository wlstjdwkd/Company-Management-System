package com.comm.page;

import com.infra.system.GlobalConst;
/**
 * 페이징 클래스
 * makePaging()를 통해 페이징 정보를 만들 수 있다.
 * <pre>
 * 사용 예) 
 * Pager pager = new Pager.Builder().pageNo(pageNo).totalRowCount(totalRowCnt).build();
 * pager.makePaging();
 * </pre>
 * @author JGS
 *
 */
public class Pager{
    private int pageSize;       	// 출력할 페이지 수
    private int rowSize;        	// 출력할 게시글 수
    
    private int firstPageNo;    	// 첫 번째 페이지 번호
    private int finalPageNo;    	// 마지막 페이지 번호
    
    private int prevPageNo;     	// 이전 페이지 번호
    private int nextPageNo;     	// 다음 페이지 번호
    
    private int startPageNo;    	// 시작 페이지 (JSP에서 사용)
    private int endPageNo;      	// 끝 페이지 (JSP에서 사용)
    
    private int pageNo;         	// 페이지 번호    
    
    private int totalRowCount;  	// 전체 게시글 수
    
    private int startRowNum;		// 조회용 시작 글 번호(Oracle)
    private int endRowNum;			// 조회용 끝 글 번호(Oracle)
    
    private int limitFrom;			// 조회용 시작 글 번호(Mysql)
	private int limitTo;			// 조회용 끝 글 개수(Mysql)
    
    private boolean isNowFirst;	// 현재 시작 페이지 여부
    private boolean isNowFinal; 	// 현재 마지막 페이지 여부
    
    private int indexNo;			// 시작 인덱스 값

	/**
	 * 출력할 페이지 수
	 * 예)[1][2][3][4][5]
     * @return pageSize
     */
    public int getPageSize() {
        return pageSize;
    }

    /**
     * 출력할 페이지 수
     * 예)[1][2][3][4][5]
     * @param pageSize
     */
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    /**
     * 출력할 게시글 수
     * 예)1.
     *    --------------------------
     *    2.
     *    --------------------------
     *    3.
     *    --------------------------
     *    4.
     *    --------------------------
     *    5.
     *    --------------------------
     * @return rowSize
     */
    public int getRowSize() {
        return rowSize;
    }

    /**
     * 출력할 게시글 수
     * 예)1.
     * 	  --------------------------	
     *    2.
     *    --------------------------
     *    3.
     *    --------------------------
     *    4.
     *    --------------------------
     *    5.
     *    --------------------------
     * @param rowSize
     */
    public void setRowSize(int rowSize) {
        this.rowSize = rowSize;
    }

    /**
     * 첫번째 페이지 번호
     * 예)[1][2][3][4][5] 중 [1]
     * @return firstPageNo
     */
    public int getFirstPageNo() {
        return firstPageNo;
    }

    /**
     * 첫번째 페이지 번호
     * 예)[1][2][3][4][5] 중 [1]
     * @param firstPageNo
     */
    public void setFirstPageNo(int firstPageNo) {
        this.firstPageNo = firstPageNo;
    }

    /**
     * 마지막 페이지 번호
     * 예)[1][2][3][4][5] 중 [5]
     * @return finalPageNo
     */
    public int getFinalPageNo() {
        return finalPageNo;
    }

    /**
     * 마지막 페이지 번호
     * 예)[1][2][3][4][5] 중 [5]
     * @param finalPageNo
     */
    public void setFinalPageNo(int finalPageNo) {
        this.finalPageNo = finalPageNo;
    }    

    /**
     * 이전 페이지 번호 
     * @return prevPageNo
     */
    public int getPrevPageNo() {
        return prevPageNo;
    }

    /**
     * 이전 페이지 번호 
     * @param prevPageNo
     */
    public void setPrevPageNo(int prevPageNo) {
        this.prevPageNo = prevPageNo;
    }

    /**
     * 다음 페이지 번호
     * @return nextPageNo
     */
    public int getNextPageNo() {
        return nextPageNo;
    }

    /**
     * 다음 페이지 번호
     * @param nextPageNo
     */
    public void setNextPageNo(int nextPageNo) {
        this.nextPageNo = nextPageNo;
    }    

    /**
     * 시작 페이지 (JSP에서 사용)
     * 예)[3][4][5][6][7] 중 [3]
     * @return startPageNo
     */
    public int getStartPageNo() {
        return startPageNo;
    }

    /**
     * 시작 페이지 (JSP에서 사용)
     * 예)[3][4][5][6][7] 중 [3]
     * @param startPageNo
     */
    public void setStartPageNo(int startPageNo) {
        this.startPageNo = startPageNo;
    }
    
    /**
     * 끝 페이지 (JSP에서 사용)
     * 예)[3][4][5][6][7] 중 [7]
     * @return endPageNo
     */
    public int getEndPageNo() {
        return endPageNo;
    }

    /**
     * 끝 페이지 (JSP에서 사용)
     * 예)[3][4][5][6][7] 중 [7]
     * @param endPageNo
     */
    public void setEndPageNo(int endPageNo) {
        this.endPageNo = endPageNo;
    }

    /**
     * 현재 페이지 번호
     * @return pageNo
     */
    public int getPageNo() {
        return pageNo;
    }

    /**
     * 현재 페이지 번호
     * @param pageNo 
     */
    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }

    /**
     * 전체 게시글 수
     * @return totalRowCount
     */
    public int getTotalRowCount() {
        return totalRowCount;
    }

    /**
     * 전체 게시글 수
     * @param totalRowCount
     */
    public void setTotalRowCount(int totalRowCount) {
        this.totalRowCount = totalRowCount;
    }

    /**
     * 조회용 시작 글 번호(Query에서 사용)
     * @return startRowNum
     */
    public int getStartRowNum() {
        return startRowNum;
    }

    /**
     * 조회용 시작 글 번호(Query에서 사용)
     * @param startRowNum
     */
    public void setStartRowNum(int startRowNum) {
        this.startRowNum = startRowNum;
    }

    /**
     * 조회용 끝 글 번호(Query에서 사용)
     * @return endRowNum
     */
    public int getEndRowNum() {
        return endRowNum;
    }

    /**
     * 조회용 끝 글 번호(Query에서 사용)
     * @param endRowNum
     */
    public void setEndRowNum(int endRowNum) {
        this.endRowNum = endRowNum;
    }
    
	public int getLimitFrom() {
		return limitFrom;
	}

	public void setLimitFrom(int limitFrom) {
		this.limitFrom = limitFrom;
	}

	public int getLimitTo() {
		return limitTo;
	}

	public void setLimitTo(int limitTo) {
		this.limitTo = limitTo;
	}

	public boolean isNowFirst() {
		return isNowFirst;
	}

	public void setNowFirst(boolean isNowFirst) {
		this.isNowFirst = isNowFirst;
	}

	public boolean isNowFinal() {
		return isNowFinal;
	}

	public void setNowFinal(boolean isNowFinal) {
		this.isNowFinal = isNowFinal;
	}
	
	public int getIndexNo() {
		return indexNo;
	}

	public void setIndexNo(int indexNo) {
		this.indexNo = indexNo;
	}







	public static class Builder{ 
		
        private int pageNo = 1; // 페이지 번호
        private int pageSize = GlobalConst.DEFAULT_PAGE_SIZE;	// 출력할 페이지 수
        private int rowSize = GlobalConst.DEFAULT_ROW_SIZE; 	// 출력할 게시 글 수
        private int totalRowCount = 0;	// 게시 글 전체 수        
         
        public Builder pageNo(int pageNo){ 
        	if(pageNo > 0) {
        		this.pageNo = pageNo;
        	}             
            return this; 
        } 

        public Builder pageSize(int pageSize){
        	if(pageSize > 0) {
        		this.pageSize = pageSize; 
        	}
            return this; 
        }

        public Builder rowSize(int rowSize){
        	if(rowSize > 0) {    		
        		this.rowSize = rowSize; 
        	}            
            return this; 
        }

        public Builder totalRowCount(int totalRowCount){
        	if(totalRowCount >= 0) {
        		this.totalRowCount = totalRowCount;
    		}             
            return this; 
        }

        public Pager build(){ 
            return new Pager(this); 
        } 
    }
	
	
    private Pager(Builder builder) {
   		this.pageNo 		= builder.pageNo;
		this.pageSize 		= builder.pageSize;
		this.rowSize		= builder.rowSize;
		this.totalRowCount 	= builder.totalRowCount;
	}

    public void makePaging(){
    	if(this.totalRowCount == 0){return;}

    	// 마지막 페이지 번호
    	int _fanalPageNo = (this.totalRowCount + (this.rowSize -1))/this.rowSize;

    	// 현재 페이지 유효성 체크
    	if(this.pageNo > _fanalPageNo){this.pageNo = _fanalPageNo;}
    	if(this.pageNo <= 0){this.pageNo = 1;}

    	// 현재 시작, 마지막 페이지 여부
    	this.isNowFirst = (this.pageNo == 1 ? true : false);
    	this.isNowFinal = (this.pageNo == _fanalPageNo ? true : false);

    	// 출력용 시작 페이지 번호
    	int _startPageNo = ((this.pageNo -1)/this.pageSize) * this.pageSize +1;    	
    	// 출력용 끝 페이지 번호
    	int _endPageNo = _startPageNo + this.pageSize -1;    	
    	if(_endPageNo > _fanalPageNo){_endPageNo = _fanalPageNo;}    	

    	// 이전 페이지
    	if(this.isNowFirst){
    		this.prevPageNo = 1;
    	}else{
    		this.prevPageNo = ((this.pageNo - 1) < 1 ? 1 : (this.pageNo - 1));
    	}

    	// 다음 페이지
    	if(this.isNowFinal){
    		this.nextPageNo = _fanalPageNo;
    	}else{
    		this.nextPageNo = ((this.pageNo + 1) > _fanalPageNo ? _fanalPageNo : (this.pageNo + 1));
    	}

    	// 첫 페이지 번호
    	this.firstPageNo = 1;
    	// 마지막 페이지 번호
    	this.finalPageNo = _fanalPageNo;
    	
    	// 출력용 시작 페이지 번호
    	this.startPageNo = _startPageNo;
    	// 출력용 끝 페이지 번호
    	this.endPageNo = _endPageNo;
    	
    	// 조회용 시작 글 번호(Oracle)
    	this.startRowNum = (this.pageNo * this.rowSize) - (this.rowSize - 1);
    	// 조회용 종료 글 번호(Oracle)
    	this.endRowNum = startRowNum + (this.rowSize - 1);
    	
    	// 조회용 시작 글 번호(Mysql)
    	this.limitFrom	= (this.pageNo * this.rowSize) - this.rowSize;
    	// 조회용 글 개수(Mysql)
    	this.limitTo	= this.rowSize;
    	
    	// 목록 시작 인덱스 번호
    	this.indexNo 	= this.totalRowCount - ((this.pageNo - 1) * this.rowSize);

    }
}