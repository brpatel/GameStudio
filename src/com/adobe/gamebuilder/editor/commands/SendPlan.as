package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.data.MailFormVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.core.events.CommandEvent;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.service.AppService;
    
    import mx.rpc.CallResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class SendPlan extends StarlingCommand 
    {

        [Inject]
        public var event:CommandEvent;


        override public function execute():void
        {
            var _local1:AppService = new AppService();
            var _local2:CallResponder = new CallResponder();
            _local2.addEventListener(FaultEvent.FAULT, this.serviceFaultListener, false, 0, true);
            _local2.addEventListener(ResultEvent.RESULT, this.serviceResultListener, false, 0, true);
            _local2.token = _local1.sendPlanToEmail((this.event.data as MailFormVO));
            commandMap.detain(this);
        }

        protected function serviceResultListener(_arg1:ResultEvent):void
        {
            if (_arg1.result == "success")
            {
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("sendPlan_successMessage"), SystemMessage.TYPE_CONFIRM)}));
            }
            else
            {
                Common.log(("AppService.sendPlanToEmail:" + _arg1), "ERROR");
                dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("sendPlan_errorMessage"), SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY)}));
            };
            commandMap.release(this);
        }

        protected function serviceFaultListener(_arg1:FaultEvent):void
        {
            Common.log(("AppService.sendPlanToEmail:" + _arg1), "ERROR");
            dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:new SystemMessage(Common.getResourceString("sendPlan_errorMessage"), SystemMessage.TYPE_ALERT, SystemMessage.LONG_DELAY)}));
            commandMap.release(this);
        }


    }
}//package at.polypex.badplaner.commands
