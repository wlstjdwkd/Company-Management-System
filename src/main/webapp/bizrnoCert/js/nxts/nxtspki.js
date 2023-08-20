/**
 * Created by jhkoo77 on 2015-09-04.
 */

function nx_callback(callback) {
    var fn = function(res) {
        console.log(res);
        callback(res);
    };
    return fn;
}
var nxTSPKIObj = (function(parentObj,$){
    var _toolkit = {};
    var _moduleName = nxTSConfig.TSTOOLKIT;
    _toolkit = $.extend({},parentObj);

    _toolkit._getResultTimer = new nxTSUtil.timer(nxTSConfig.getResultInterval,function(){
        nxTSPKIObj.getResult(nxts_get_result_complete_callback).invoke();
    });

    _toolkit.createCommand = function(cmd,data,ctx) {
        ctx = ctx || {};
        ctx.obj = nxTSPKIObj;
        var cmd = nxTSCommon.createCommand(_moduleName,cmd,data,ctx);
        cmd.data.async = true;
        return cmd;
    };

    _toolkit.signFile = function(dataFile,signedDataFile,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("signFile",{options:options,dataFile:dataFile,signedDataFile:signedDataFile},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.addSignInSignedData = function(signedData,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("addSignInSignedData",{options:options,signedData:signedData},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };

    _toolkit.addSignInSignedFile = function(signedDataFile,addedSignedDataFile,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("addSignInSignedFile",{options:options,signedDataFile:signedDataFile,addedSignedDataFile:addedSignedDataFile},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.signDataWithTimeStampToken = function(data,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("signDataWithTimeStampToken",{options:options,data:data},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.signData = function(data,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("signData",{options:options,data:data},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifySignedData = function(data,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifySignedData",{options:options,data:data},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;

    };
    _toolkit.verifySignedFile = function(signedDataFile,dataFile,contentFile,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifySignedFile",{options:options,signedDataFile:signedDataFile,dataFile:dataFile,contentFile:contentFile},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.base64EncodeData = function(data,callback,etc) {
        var cmd =  this.createCommand("base64EncodeData",{data:data},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.base64DecodeData = function(data,callback,etc) {
        var cmd = this.createCommand("base64DecodeData",{data:data},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.encryptData = function(data,key,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("encryptData",{options:options,data:data,key:key},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.decryptData = function(data,key,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("decryptData",{options:options,data:data,key:key}, {callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.encryptFile = function(dataFile,encryptedDataFile,key,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("encryptFile",{options:options,dataFile:dataFile,encryptedDataFile:encryptedDataFile,key:key},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.decryptFile = function(encryptedDataFile,dataFile,key,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd =this.createCommand("decryptFile",{options:options,encryptedDataFile:encryptedDataFile,dataFile:dataFile,key:key},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.envelopFile = function(dataFile,envelopedDataFile,kmCert,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("envelopFile",{options:options,dataFile:dataFile,envelopedDataFile:envelopedDataFile,kmCert:kmCert}, {callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.decryptEnvelopedFile = function(envelopedDataFile,dataFile,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("decryptEnvelopedFile",{options:options,envelopedDataFile:envelopedDataFile,dataFile:dataFile}, {callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.envelopData = function(data,kmCert,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("envelopData",{options:options,data:data,kmCert:kmCert},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.decryptEnvelopedData = function(envelopedData,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("decryptEnvelopedData",{options:options,envelopedData:envelopedData},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.hashData = function(algorithm,data,callback,etc) {
        var cmd = this.createCommand("hashData",{data:data,algorithm:algorithm},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.hashFile = function(algorithm,dataFile,callback,etc) {
        var cmd = this.createCommand("hashFile",{dataFile:dataFile,algorithm:algorithm},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.generateSignature = function(dataType,data,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("generateSignature",{dataType:dataType,data:data,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.generateRandomNumber = function(length,callback,etc) {
        var cmd = this.createCommand("generateRandomNumber",{length:length},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifySignature = function(dataType,data,signature,cert,callback,etc) {
        var cmd = this.createCommand("verifySignature",{dataType:dataType,data:data,signature:signature,cert:cert},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.getDataFromLDAP = function(url,dataType,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("getDataFromLDAP",{url:url,dataType:dataType,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.getCertificateProperties = function(cert,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("getCertificateProperties",{cert:cert,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.loginData = function(sessionId,ssn,userInfo,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("loginData",{sessionId:sessionId,ssn:ssn,userInfo:userInfo,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifySigData = function(sigData,contentFolderPath,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifySigData",{sigData:sigData,contentFolderPath:contentFolderPath,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.makeSigData = function(content,fileName,lastModificationTime,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("makeSigData",{content:content,fileName:fileName,lastModificationTime:lastModificationTime,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };

    _toolkit.makeSigFile = function(contentFilePath,sigFilePath,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("makeSigFile",{contentFilePath:contentFilePath,sigFilePath:sigFilePath,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.addSignInSigData = function(sigData,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("addSignInSigData",{sigData:sigData,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };

    _toolkit.addSignInSigFile = function(sigFilePath,newSigFilePath,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("addSignInSigFile",{sigFilePath:sigFilePath,newSigFilePath:newSigFilePath,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifySigFile = function(sigFilePath,contentFolderPath,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifySigFile",{sigFilePath:sigFilePath,contentFolderPath:contentFolderPath,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifyVID = function(ssn,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifyVID",{ssn:ssn,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.verifyVID2 = function(cert,ssn,r,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("verifyVID2",{ssn:ssn,cert:cert,r:r,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.makeBiddingData = function(data,kmCertInfo,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("makeBiddingData",{options:options,data:data,kmCertInfo:kmCertInfo},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
     _toolkit.multiSignData = function(data,options,callback,etc) {
        options = $.extend({}, nxTSPKIConfig.options, options);
        var cmd = this.createCommand("multiSignData", {options: options, data: data}, {callback: callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.multiSignFile = function(data,options,callback,etc) {
        options = $.extend({}, nxTSPKIConfig.options, options);
        var cmd = this.createCommand("multiSignFile", {options: options, data: data}, {callback: callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.multiGenerateSignature = function(data,options,callback,etc) {
        options = $.extend({}, nxTSPKIConfig.options, options);
        var cmd = this.createCommand("multiGenerateSignature", {options: options, data: data}, {callback: callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.multiSignDataWithTimeStampToken = function(data,options,callback,etc) {
        options = $.extend({}, nxTSPKIConfig.options, options);
        var cmd = this.createCommand("multiSignDataWithTimeStampToken", {options: options, data: data}, {callback: callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.getCertificatesAndKeys = function(data,options,callback,etc) {
        options = $.extend({}, nxTSPKIConfig.options, options);
        var cmd = this.createCommand("getCertificatesAndKeys", {options: options, data: data}, {callback: callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.genSignatureStart = function(options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("genSignatureStart",{options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.genSignatureRunAndClear = function(dataType,data,options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("genSignatureRunAndClear",{dataType:dataType,data:data,options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.genSignatureClear = function(options,callback,etc) {
        options = $.extend({},nxTSPKIConfig.options,options);
        var cmd = this.createCommand("genSignatureClear",{options:options},{callback:callback,etc:etc});
        this.startGetResultTimer(cmd.data.rid,etc);
        return cmd;
    };
    _toolkit.getResult  = function(callback) {
        var cmd = this.createCommand("getResult",{ajaxto:nxTSConfig.getResultTimeout},{callback:callback});
        cmd.data.async = false;
        return cmd;
    };



    return _toolkit;
})(nxTSCommonObj,jQuery);

var nxTSPKI = (function(parentObj,$){
    var _toolkit = {};
    var _parentToolkit = parentObj;

    var _proxyFunctionNames = [
        "signData",
        "verifySignedData",
        "signFile",
        "verifySignedFile",
        "encryptData",
        "decryptData",
        "encryptFile",
        "decryptFile",
        "envelopData",
        "decryptEnvelopedData",
        "envelopFile",
        "decryptEnvelopedFile",
        "generateSignature",
        "verifySignature",
        "verifySignedData",
        "addSignInSignedFile",
        "verifySignedFile",
        "hashData",
        "hashFile",
        "loginData",
        "base64EncodeData",
        "base64DecodeData",
        "getDataFromLDAP",
        "generateRandomNumber",
        "getCertificateProperties",
        "makeSigData",
        "verifySigData",
        "makeSigFile",
        "verifySigFile",
        "addSignInSigData",
        "addSignInSigFile",
        "verifyVID",
        "verifyVID2",
        "addSignInSignedData",
        "addSignInSignedFile",
        "signDataWithTimeStampToken",
        "makeBiddingData",
        "multiSignData",
        "multiSignFile",
        "multiGenerateSignature",
        "multiSignDataWithTimeStampToken",
        "getCertificatesAndKeys",
        "genSignatureStart",
        "genSignatureRunAndClear",
        "genSignatureClear"
    ];


    _toolkit = $.extend(parentObj,_toolkit);

    nxTSCommon.backupOrgFunctions(_parentToolkit,_proxyFunctionNames);
    nxTSCommon.createProxyFunctions(_parentToolkit,_toolkit,"callWithInit",_proxyFunctionNames);

    _toolkit.callWithInit = function(name,fn,args) {

        var initSuccess = function(res) {
            if(res == undefined || res.code != nxTSError.res_success) {
                nxTSUtil.showError(res);
                return;
            }
            nxTSLog.i(name.replace("_par_",""));
            //nxTSLog.d(name.replace("_par_",""),nxTSUtil.maskPassword(args));
            var cmd =fn.apply(parentObj,args);
            nxTSLog.d(name.replace("_par_",""),nxTSUtil.maskPassword(cmd.data.data));

            cmd.invoke();

        };

        if(nxTSSession.isInit() == false)
            nxTSCommon.init({versionCheck:[nxTSConfig.TSTOOLKIT],
                installMessage:nxTSPKIConfig.installMessage,
                installPage:nxTSPKIConfig.installPage},initSuccess);
        else
            initSuccess({code:nxTSError.res_success});
    };


    _toolkit.installCheck = function() {
        setTimeout(function(){
            nxTSCommon.installCheck(false,{ajaxto:3000,success:function(res,data){
                if(res.code != nxTSError.res_success) {
                    if(confirm(nxTSPKIConfig.installMessage) == true) {
                        window.location.href = nxTSPKIConfig.installPage;
                    }
                }
            },versionCheck:[nxTSConfig.TSTOOLKIT]});
        },500);
    };

    _toolkit.init = function(transparentDisableBrowser,disableBrowser,fn) {
        if(typeof disableBrowser === "function") {
            fn = disableBrowser;
            disableBrowser = true;
        }
        disableBrowser              = (typeof disableBrowser === 'boolean') ? disableBrowser :  true;
        transparentDisableBrowser   = (typeof transparentDisableBrowser === 'boolean') ? transparentDisableBrowser : false;

        if(fn != undefined) {
            nxTSPKI.onInit(fn);
        }
        setTimeout(function(){
            if(nxTSSession.isInit() == false) {
                nxTSCommon.init({
                        transparentDisableBrowser:transparentDisableBrowser,
                        disableBrowser:disableBrowser,
                        versionCheck:[nxTSConfig.TSTOOLKIT],
                        installMessage:nxTSPKIConfig.installMessage,
                        installPage:nxTSPKIConfig.installPage},
                    function(res){
                        if(res.code == nxTSError.res_success)
                            nxTSPKI.callPostInit();
                    });
            }
            else {
                nxTSPKI.callPostInit();
            }
        },500);
    };

    nxTSCommon.updateConfig(nxTSPKIConfig);


    return _toolkit;

})(nxTSPKIObj,jQuery);
