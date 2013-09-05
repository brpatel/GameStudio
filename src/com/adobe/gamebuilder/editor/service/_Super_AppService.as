package com.adobe.gamebuilder.editor.service
{
    import com.adobe.fiber.core.model_internal;
    import com.adobe.fiber.services.wrapper.RemoteObjectServiceWrapper;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.core.data.MailFormVO;
    import com.adobe.gamebuilder.editor.core.data.OSInfo;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.serializers.utility.TypeUtility;
    
    import flash.utils.ByteArray;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.remoting.Operation;
    import mx.rpc.remoting.RemoteObject;

    class _Super_AppService extends RemoteObjectServiceWrapper 
    {

        public function _Super_AppService()
        {
            var _local2:Operation;
            super();
            _serviceControl = new RemoteObject();
            var _local1:Object = new Object();
            _local2 = new Operation(null, "sendPlanToEmail");
            _local2.resultType = Object;
            _local1["sendPlanToEmail"] = _local2;
            _local2 = new Operation(null, "getQuote");
            _local2.resultType = Object;
            _local1["getQuote"] = _local2;
            _serviceControl.operations = _local1;
            _serviceControl.convertResultHandler = TypeUtility.convertResultHandler;
            _serviceControl.source = "AppService";
            _serviceControl.endpoint = Constants.GATEWAY;
            destination = "AppService";
            (model_internal::initialize());
        }

        public function sendPlanToEmail(_arg1:MailFormVO):AsyncToken
        {
            var _local2:AbstractOperation = _serviceControl.getOperation("sendPlanToEmail");
            var _local3:AsyncToken = _local2.send(_arg1, new OSInfo());
            return (_local3);
        }

        public function getQuote(_arg1:ContactFormVO, _arg2:PartnerVO, _arg3:ByteArray, _arg4:PartnerVO):AsyncToken
        {
            var _local5:AbstractOperation = _serviceControl.getOperation("getQuote");
            var _local6:AsyncToken = _local5.send(_arg1, _arg2, _arg3, _arg4, new OSInfo());
            return (_local6);
        }


    }
}//package at.polypex.badplaner.service
