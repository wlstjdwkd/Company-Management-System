package com.infra.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.joda.time.LocalDate;

public class CalcUtil {

	/**
	 * 환급 결정액 계산 후 리턴
	 * 환급물량은 에러가 있는 경우와 없는 경우를 고려해서 계산
	 * 1의 자리는 버림
	 * @param rfdQty
	 * @param dbRfdQty
	 * @param dbAppUnitAmt
	 * @param param
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static Long getRefundAmt(Double rfdQty, Double dbRfdQty, Long dbAppUnitAmt, Map param) {
		Double xd;
		if(Validate.isNotEmpty(MapUtils.getString(param, "ERE013001"))) {		// 환급물량 에러가 있는 경우
			xd = rfdQty;
		} else {
			xd = dbRfdQty;
		}

		Double amt = xd * dbAppUnitAmt;
		Long result = amt.longValue();

		Long tmp = result % 10;
		result -= tmp;
		return result;
	}

	/**
	 * String 형태의 숫자를 +1 을 해서 String 형태로 넘겨주기
	 * String은 총 6자리, 빈값은 0으로 채운다.
	 * ex) 4 -> 000004
	 * @param s
	 * @return
	 */
	public static String getPlusNumber(String s) {
		Integer i1 = Integer.parseInt(s);
		i1 += 1;
		String result = i1.toString();

		if(result.length() == 1) result = "00000" + result;
		else if(result.length() == 2) result = "0000" + result;
		else if(result.length() == 3) result = "000" + result;
		else if(result.length() == 4) result = "00" + result;
		else if(result.length() == 5) result = "0" + result;

		return result;
	}

	/**
	 * ExcelCheckUtil 파일에서 결과로 얻은 List를 이용해서 중복값을 체크한다.
	 * @param checkList
	 * @return
	 */
	public static int overlapCnt(List<Map<String, Object>> checkList) {
		int cnt = 0;
		if(Validate.isNotEmpty(checkList)) {
			for(Map<String, Object> item : checkList) {
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y"))
					cnt++;
			}
		}

		return cnt;
	}

	/**
	 * 환급률 체크를 한다.
	 * true 리턴 시 OK / false 리턴 시 에러
	 * @param rfdRate
	 * @param rfdRateList
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static boolean compareRfdRate(Double rfdRate, List<Map> rfdRateList) {
		if(Validate.isNotEmpty(rfdRateList)) {
			for(Map item: rfdRateList) {
				if(Validate.isNotEmpty(MapUtils.getDouble(item, "RFD_RATE1")) && MapUtils.getDouble(item, "RFD_RATE1").equals(rfdRate)) {
					return true;			// RFD_RATE1에 값이 들어있고, 값이 같을 때
				}else if(Validate.isNotEmpty(MapUtils.getDouble(item, "RFD_RATE2")) && MapUtils.getDouble(item, "RFD_RATE2").equals(rfdRate)) {
					return true;			// RFD_RATE2에 값이 들어있고, 값이 같을 때
				}
			}
			return false;					// 맞는 값이 하나도 없는 경우
		} else {
			return true;					// 환급률 리스트에 값이 없는 경우 - 환급률의 경우 DB에 기준정보가 없다면 true를 리턴하도록 한다.
		}
	}

	/**
	 * 소요량 체크를 한다. 소요량은 최대 소수점 10자리까지 있다.
	 * true 리턴 시 정상 / false 리턴 시 에러가 있음
	 * @param useQty
	 * @param useQtyMap
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static boolean compareUseQty(Double useQty, Map useQtyMap) {
		if(Validate.isNotEmpty(useQtyMap)) {
			for(int i=1; i<=useQtyMap.size(); i++) {
				if(MapUtils.getDouble(useQtyMap, ("USE_QTY"+i)).equals(useQty)) {
					return true;			// 값이 같을 경우
				}
			}
		}
		return false;						// 같은 값이 하나도 없는 경우
	}

	/**
	 * 환급적용단가 체크
	 * 환급적용단가는 기준테이블에서 여러개가 나올 수 있고, 그 중에 맞으면 참 반환
	 * 다 틀리거나, 아예 리스트가 null인 경우는 거짓 반환
	 * @param appUnitAmt
	 * @param compareList
	 * @return
	 */
	public static boolean compareAppUnitAmt(Long appUnitAmt, List<Integer> compareList) {
		if(Validate.isNotEmpty(compareList)) {
			for(Integer aua: compareList) {
				Long value = aua.longValue();
				if(value.equals(appUnitAmt)) return true;
			}
			return false;
		}
		return false;
	}

	/**
	 * 산정상태 코드를 정한다.
	 * 산정회차가 "00" 인 경우와 아닌 경우를 고려할 것.
	 * 들어온 param에 이미 값이 있다면 무조건 에러인 경우로 고려
	 * rfdAmt와 dbRfdAmt의 값이 같은지 비교한다.
	 * @param reqstOdr 산정차수
	 * @param param
	 * @param rfdAmt   계산한 환급금액
	 * @param dbRfdAmt db에 저장된 환급금액
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static String calcSttusCode(String reqstOdr, Map param, Long rfdAmt, Long dbRfdAmt) {
		String returnString = "";

		if(param.size() == 0) {
			if(reqstOdr.equals("00")) {											// 첫 산정인 경우
				if(rfdAmt.equals(dbRfdAmt)) returnString = "02";				// 산정 완료
				else returnString = "05";										// 산정 에러
			} else {															// 재산정일 경우
				if(rfdAmt.equals(dbRfdAmt)) returnString = "04";				// 재산정 완료
				else returnString = "06";										// 재산정 에러
			}
		} else {																// 에러가 있는 경우
			if(reqstOdr.equals("00")) returnString = "05";
			else returnString = "06";
		}

		return returnString;
	}

	/**
	 * ExcelCheckUtil의 overlapcheck()를 약간 변형시킴
	 * 추가사항 : 중복이 났을 때 어떤 중복이 났는지 확인할 수 있도록 구분
	 * @param param
	 * @param targetList
	 * @param compareList
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, Object> overLapCheckDetail(Map param , List<Map> targetList , List<Map> compareList) throws RuntimeException, Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String dtlsfcCd = MapUtils.getString(param, "dtlsfcCd");

		//환급신청서(을) 마스터에 결과 있음 > 중복
		if(Validate.isNotEmpty(compareList)) {
			//중복체크
			for(Map masterItem : compareList) {
				for(Map item : targetList) {
					//제품수출-국제연합군납
					if(dtlsfcCd.equals("3104")) {
						//증빙서번호 + 공급일자 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) && MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "supplyDe")) && MapUtils.getString(item, "supplyDe").equals(MapUtils.getString(masterItem, "supplyDe")))
								&& Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty"))){
							masterItem.put("overlap", "Y3");
						}
					}

					//제품수출-항공급유 , 제품수출-선박급유  , 제품수출-원양어선공급
					if(dtlsfcCd.equals("3102") || dtlsfcCd.equals("3103") || dtlsfcCd.equals("3106")) {
						//세관코드 + 증빙서번호 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "csmhseCd")) && MapUtils.getString(item, "csmhseCd").equals(MapUtils.getString(masterItem, "customerCd")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) && MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty")))){
							masterItem.put("overlap", "Y2");
						}
					}

					//공업원료-석유화학 , 비축
					if(dtlsfcCd.equals("3201") || dtlsfcCd.equals("3301") || dtlsfcCd.equals("3401")) {
						//증빙서번호 + 제품코드 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) && MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "prdGrpDtlcd")) && MapUtils.getString(item, "prdGrpDtlcd").equals(MapUtils.getString(masterItem, "prdGrpDtlcd")))
								&& (Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty")))) {
							masterItem.put("overlap", "Y4");
						}
					}

					//제품수출-일반수출 , 제품수출-북한반출
					//공업원료-비료제조 , 공업원료 - 노말파라핀 , 공업원료-카본블랙제조 , 공업원료-이산화티타늄제조
					//윤활기유 제조 , 다변화원유
					if(dtlsfcCd.equals("3101") || dtlsfcCd.equals("3105")
							|| dtlsfcCd.equals("3202") || dtlsfcCd.equals("3203") || dtlsfcCd.equals("3204") || dtlsfcCd.equals("3205")
							|| dtlsfcCd.equals("3501") || dtlsfcCd.equals("3801")) {
						//증빙서번호 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) && MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty")))) {
							masterItem.put("overlap", "Y1");
						}
					}

					//전자상거래-주유소(경쟁) , 전자상거래-주유소(협의) , 전자상거래-주요소 외(경쟁) , 전자상거래-주유소 외(경쟁)
					if(dtlsfcCd.equals("3601") || dtlsfcCd.equals("3602") || dtlsfcCd.equals("3603") || dtlsfcCd.equals("3604")) {
						//형태코드 + 증빙서번호 + 제품코드 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "dtlsfcCd")) && MapUtils.getString(item, "dtlsfcCd").equals(MapUtils.getString(masterItem, "dtlsfcCd")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) &&  MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "prdGrpDtlcd")) && MapUtils.getString(item, "prdGrpDtlcd").equals(MapUtils.getString(masterItem, "prdGrpDtlcd")))
								&& (Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty")))) {
							masterItem.put("overlap", "Y6");
						}
					}

					//천연가스
					if(dtlsfcCd.equals("3701") || dtlsfcCd.equals("3702") || dtlsfcCd.equals("3703") || dtlsfcCd.equals("3704") || dtlsfcCd.equals("3705")) {
						//형태코드 + 증빙서번호 + 물량
						if((Validate.isNotEmpty(MapUtils.getString(item, "dtlsfcCd")) && MapUtils.getString(item, "dtlsfcCd").equals(MapUtils.getString(masterItem, "dtlsfcCd")))
								&& (Validate.isNotEmpty(MapUtils.getString(item, "crtfNum")) && MapUtils.getString(item, "crtfNum").equals(MapUtils.getString(masterItem, "crtfNum")))
								&& (Validate.isNotEmpty(MapUtils.getDouble(item, "tradeQty")) && MapUtils.getDouble(item, "tradeQty").equals(MapUtils.getDouble(masterItem, "tradeQty")))) {
							masterItem.put("overlap", "Y5");
						}
					}
				}
			}
		}
		map.put("compareList", compareList);

		return map;
	}

	/**
	 * 을지 중복 관련 - 에러 조회에서 사용하는 코드
	 * 경우에 따라 에러 내용이 다르기 때문에 이렇게 진행함
	 * @param checkList
	 * @return
	 */
	public static List<String> overLapDetailCntList(List<Map<String, Object>> checkList) {
		List<String> yList = new ArrayList<>();
		if(Validate.isNotEmpty(checkList)) {
			for(Map<String, Object> item: checkList) {
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y1")) {
					yList.add("EFU05-4010");
				}
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y2")) {
					yList.add("EFU05-5010");
				}
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y3")) {
					yList.add("EFU05-5011");
				}
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y4")) {
					yList.add("EFU05-5012");
				}
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y5")) {
					yList.add("EFU05-5013");
				}
				if(Validate.isNotEmpty(MapUtils.getString(item, "overlap")) && MapUtils.getString(item, "overlap").equals("Y6")) {
					yList.add("EFU05-6010");
				}
			}
		}
		return yList;
	}

	/**
	 * 연도 구하기 - null로 들어올 경우 현재 연도를 리턴한다
	 * @param nowYear
	 * @return
	 */
	public static String getNowYear(String nowYear) {
		if(Validate.isEmpty(nowYear)) {
			Integer year = LocalDate.now().getYear();
			return year.toString();
		}
		return nowYear;
	}

	/**
	 * 월 구하기 - null로 들어올 경우 현재 월을 리턴한다
	 * 2글자가 되도록 리턴한다.
	 * @param nowMonth
	 * @return
	 */
	public static String getNowMonth(String nowMonth) {
		if(Validate.isEmpty(nowMonth)) {
			Integer month = LocalDate.now().getMonthOfYear();
			if(month < 10) return "0" + month;
			return month.toString();
		} else {
			if(nowMonth.length() == 1) return "0" + nowMonth;
			else return nowMonth;
		}
	}

	/**
	 * 상태 & 스텝에 따라 리턴값 달라짐
	 * RC3 or RC5 or RC6 이어야 함
	 * PS2 or PS7 이어야 함
	 * 두 조건에 해당하면 참 / 아니면 거짓
	 * @param ss
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static boolean StepAndStatus(Map ss) {
		String status = MapUtils.getString(ss, "RCEPT_STTUS");
		String step   = MapUtils.getString(ss, "RCEPT_STEP");

		if(!status.equals("RC3") && !status.equals("RC5") && !status.equals("RC6"))
			return false;

		if(!step.equals("PS2") && !step.equals("PS7"))
			return false;

		return true;
	}
}
