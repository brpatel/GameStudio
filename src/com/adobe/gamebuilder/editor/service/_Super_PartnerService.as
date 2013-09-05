package com.adobe.gamebuilder.editor.service
{
    import com.adobe.fiber.core.model_internal;
    import com.adobe.fiber.services.wrapper.RemoteObjectServiceWrapper;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.serializers.utility.TypeUtility;
    
    import mx.rpc.AbstractOperation;
    import mx.rpc.AsyncToken;
    import mx.rpc.remoting.Operation;
    import mx.rpc.remoting.RemoteObject;

    class _Super_PartnerService extends RemoteObjectServiceWrapper 
    {

        public function _Super_PartnerService()
        {
            var _local2:Operation;
            super();
            _serviceControl = new RemoteObject();
            var _local1:Object = new Object();
            _local2 = new Operation(null, "getPartners");
            _local2.resultElementType = PartnerVO;
            _local1["getPartners"] = _local2;
            _local2 = new Operation(null, "partnerRadiusSearch");
            _local2.resultElementType = PartnerVO;
            _local1["partnerRadiusSearch"] = _local2;
            _serviceControl.operations = _local1;
            _serviceControl.convertResultHandler = TypeUtility.convertResultHandler;
            _serviceControl.source = "PartnerService";
            _serviceControl.endpoint = Constants.GATEWAY;
            destination = "PartnerService";
            (model_internal::initialize());
        }

        public function getPartners(_arg1:String, _arg2:String, _arg3:String):AsyncToken
        {
            var _local4:AbstractOperation = _serviceControl.getOperation("getPartners");
            var _local5:AsyncToken = _local4.send(_arg1, _arg2, _arg3);
            return (_local5);
        }

        public function partnerRadiusSearch(_arg1:String, _arg2:String, _arg3:int):AsyncToken
        {
            var _local4:AbstractOperation = _serviceControl.getOperation("partnerRadiusSearch");
            var _local5:AsyncToken = _local4.send(_arg1, _arg2, _arg3);
            return (_local5);
        }


    }
}//package at.polypex.badplaner.service
