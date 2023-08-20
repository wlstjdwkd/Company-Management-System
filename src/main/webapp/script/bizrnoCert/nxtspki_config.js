/**
 * Created by jhkoo77 on 2015-08-26.
 */

var nxTSPKIConfig = {version:{},options:{}};

nxTSPKIConfig.version.nx             = "1,0,1,5";
nxTSPKIConfig.version.tstoolkit      = "2,0,7,7";
nxTSPKIConfig.installPage            = "/PGCMLOGIO0010.do?df_method_nm=bsisnoInstall";
nxTSPKIConfig.installMessage         = "SCORE PKI for OpenWeb 프로그램이 설치 되어 있지 않거나, 이전 버전이 설치되어 있습니다. \n\n설치페이지로 이동하시겠습니까?";
nxTSPKIConfig.processingImageUrl     = "/bizrnoCert/img/processing2.gif";

nxTSPKIConfig.options.siteName = "gpost";
nxTSPKIConfig.options.ldapInfo = "KISA:dirsys.rootca.or.kr:389|KICA:ldap.signgate.com:389|SignKorea:dir.signkorea.com:389|Yessign:ds.yessign.or.kr:389|CrossCert:dir.crosscert.com:389|TradeSign:ldap.tradesign.net:389|NCASign:ds.nca.or.kr:389|";
nxTSPKIConfig.options.ctlInfo = "";
nxTSPKIConfig.options.initPolicies = "1 2 410 200012 1 1 3:범용기업|1 2 410 200004 5 1 1 7:범용기업|1 2 410 200005 1 1 5:범용기업|1 2 410 200004 5 2 1 1:범용기업|1 2 410 200004 5 4 1 2:범용기업|1 2 410 200004 5 3 1 1:범용기관|1 2 410 200004 5 3 1 2:범용기업|1 2 410 200005 1 1 6 8:국세청신고용";
nxTSPKIConfig.options.includeCertPath = false;
nxTSPKIConfig.options.includeSigningTime = true;
nxTSPKIConfig.options.includeCRL = false;
nxTSPKIConfig.options.includeContent = true;
nxTSPKIConfig.options.crlCheckOption = true;
nxTSPKIConfig.options.arlCheckOption = true;
nxTSPKIConfig.options.loginDataKmCert = "-----BEGIN CERTIFICATE-----MIIFITCCBAmgAwIBAgIEWZpPyDANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJVHJhZGVTaWduMRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDFRyYWRlU2lnbkNBMjAeFw0xNjA2MjEwNTE3MDZaFw0xNzA3MDYwNTUyMDlaMGExCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlUcmFkZVNpZ24xEzARBgNVBAsMCkxpY2Vuc2VkQ0ExDjAMBgNVBAsMBUtUTkVUMRkwFwYDVQQDDBDthYzsiqTtirgoS1RORVQpMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzfow3ncW0W69HizlJclJBa8ezllNlCAs6sAWMCknvhiOYZHdr0ZIMT5AUeNdOuERVqszjirCT3VHzAPNtz3O00OjmDMii3+8pnLnWmRdjEBm7crahhEn72svv3RY0LOVjnWxpX+mMbuAdEYVj9N+mRSEkTw6bqzSdyV7w2rkkvhWM38gv8bIXBsmeGwBkahrN3AyIj4q2GL+A5kzbWcz/uyiaBQy7il9hbKLirCaCniyNVh1d/0v5+1DpE5ZmQZpwaJx4W/wsQyyn9ci0d6VbjZgNjFTAs57bQ2jeP/346WfgNKvNCsiHcfV3cTRX8q6g9dimQAcc/clI7H0WGCpbwIDAQABo4IB8TCCAe0wgY8GA1UdIwSBhzCBhIAUTV1WCgcD34PK89Vtjxn8EqyQooqhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQCTAdBgNVHQ4EFgQUdZHTNkC1wD6VwPOTjZ31BRDnUgMwDgYDVR0PAQH/BAQDAgUgMHoGA1UdIAEB/wRwMG4wbAYJKoMajJpMAQEEMF8wLgYIKwYBBQUHAgIwIh4gx3QAIMd4yZ3BHLKUACCs9cd4x3jJncEcACDHhbLIsuQwLQYIKwYBBQUHAgEWIWh0dHA6Ly93d3cudHJhZGVzaWduLm5ldC9jcHMuaHRtbDBmBgNVHR8EXzBdMFugWaBXhlVsZGFwOi8vbGRhcC50cmFkZXNpZ24ubmV0OjM4OS9jbj1jcmwxZHA4NjMsb3U9Y3JsZHAyLG91PUFjY3JlZGl0ZWRDQSxvPVRyYWRlU2lnbixjPUtSMEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AudHJhZGVzaWduLm5ldDoxODAwMC9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQBTGG0u5pqdKuOuM/KnyF01mUrJ7ADurLA8jq98B7pi8bdd03U4HpKbA0GfZks+Aiz2Jb/4Mq0yW19W8HBtd51zwELfBE5F+N4eTXy/PqYhwSg1HW2/tKbPr1dBQTJSKGSWZmLJaf4fmEiwYpuUEOkt19axsa0yRWtj68H4kzfkm1+qBeCxPHFCznZV00lqW7W07nD6k4KwUHGv4FGZ/NAp/k4pIQ60rOeDiehs3HBRG2PtQwXAMbDRjioyyfndqzw96eqxg0/4QDq6JpLzMvqSi1VX82hJz6YeptdMVW987ucwz2tfBS15pv4sUmeds2abdUdrc7v964cb9LGl+9pM-----END CERTIFICATE-----";
nxTSPKIConfig.options.selectCertFirstButton = "HDD";
nxTSPKIConfig.options.bannerUrl = "/bizrnoCert/img/gpost.bmp";
// nxTSPKIConfig.options.infovine = {};
// nxTSPKIConfig.options.phoneUrl = "http://test.ubikey.co.kr/infovine/1252/download.html";
// nxTSPKIConfig.options.phoneVersion  = "1,2,5,2";
// nxTSPKIConfig.options.phoneParam = "INFOVINE|http://test.ubikey.co.kr/infovine/1252/DownloadList &KTNET|NULL";

// nxTSPKIConfig.options.loadKmCert   = true;
// nxTSPKIConfig.options.tsaHashAlg   = "sha256";
// nxTSPKIConfig.options.tsaUrl       = "http://tsatest.tradesign.net:8090/service/timestamp/issue";
// nxTSPKIConfig.options.tsaId        = "test";
// nxTSPKIConfig.options.tsaPassword  = "testPwd";

nxTSPKIConfig.options.encryptionAlgorithm = "";
nxTSPKIConfig.options.defaultMediaType = "";


nxTSMessage.iframeTimeout = "응답이 지연되었습니다 잠시후 다시 시도해주세요..";
nxTSMessage.ajaxTimeout = "응답이 지연되었습니다 잠시후 다시 시도해주세요.";
