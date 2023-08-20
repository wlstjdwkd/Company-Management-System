package com.comm.response;

/**
 * JSON 형식의 단순 결과 메시지를 생성 전달하기 위한 VO 
 */
public class JsonVO {

    /** 성공여부 결과 */
    private Boolean result;

    /** 프로세스 결과값 */
    private Object value;

    /** 결과 메시지 */
    private String message;

    /**
     * Boolean result을 반환
     * 
     * @return Boolean result
     */
    public Boolean getResult() {
        return result;
    }

    /**
     * result을 설정
     * 
     * @param result 을(를) Boolean result로 설정
     */
    public JsonVO setResult(Boolean result) {
        this.result = result;
        return this;
    }

    /**
     * Object value을 반환
     * 
     * @return Object value
     */
    public Object getValue() {
        return value;
    }

    /**
     * value을 설정
     * 
     * @param value 을(를) Object value로 설정
     */
    public JsonVO setValue(Object value) {
        this.value = value;
        return this;
    }

    /**
     * String message을 반환
     * 
     * @return String message
     */
    public String getMessage() {
        return message;
    }

    /**
     * message을 설정
     * 
     * @param message 을(를) String message로 설정
     */
    public JsonVO setMessage(String message) {
        this.message = message;
        return this;
    }
}
