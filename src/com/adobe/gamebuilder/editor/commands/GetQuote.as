package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.core.events.CommandEvent;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.service.AppService;
    
    import flash.utils.ByteArray;
    
    import mx.rpc.CallResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class GetQuote extends StarlingCommand 
    {

        [Inject]
        public var event:CommandEvent;


        override public function execute():void
        {
            var _local1:AppService = new AppService();
            var _local2:CallResponder = new CallResponder();
            _local2.addEventListener(FaultEvent.FAULT, this.serviceFaultListener, false, 0, true);
            _local2.addEventListener(ResultEvent.RESULT, this.serviceResultListener, false, 0, true);
            _local2.token = _local1.getQuote((this.event.data.contactForm as ContactFormVO), (this.event.data.partnerInfo as PartnerVO), (this.event.data.png as ByteArray), (this.event.data.partnerInfo2 as PartnerVO));
            commandMap.detain(this);
        }

        protected function serviceResultListener(_arg1:ResultEvent):void
        {
            Common.log(("GetQuote.serviceResultListener:" + _arg1));
            if (_arg1.result == "success")
            {
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("getQuote_successMessage"), SystemMessage.TYPE_CONFIRM)}));
            }
            else
            {
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("getQuote_errorMessage"), SystemMessage.TYPE_ALERT)}));
            };
            commandMap.release(this);
        }

        protected function serviceFaultListener(_arg1:FaultEvent):void
        {
            Common.log(("GetQuote.serviceFaultListener:" + _arg1));
            dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("getQuote_errorMessage"), SystemMessage.TYPE_ALERT)}));
            commandMap.release(this);
        }


    }
}//package at.polypex.badplaner.commands
