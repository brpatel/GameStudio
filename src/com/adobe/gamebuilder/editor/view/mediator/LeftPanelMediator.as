package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class LeftPanelMediator extends StarlingMediator 
    {

        [Inject]
        public var appModel:AppModel;
        [Inject]
        public var view:LeftPanel;


        override public function onRegister():void
        {
            this.view.init(this.appModel.currentPlan.baseRoom);
            this.view.screenChange.add(this.screenChangedHandler);
            addContextListener(ContextEvent.SET_SCREEN_REQUEST, this.screenChangeRequestHandler, ContextEvent);
        }

        private function screenChangedHandler(_arg1:String):void
        {
            dispatch(new ContextEvent(ContextEvent.SCREEN_CHANGED, _arg1));
        }

        private function screenChangeRequestHandler(_arg1:ContextEvent):void
        {
            this.view.switchScreen(String(_arg1.data));
        }

        override public function onRemove():void
        {
            this.view.screenChange.remove(this.screenChangedHandler);
            removeContextListener(ContextEvent.SET_SCREEN_REQUEST, this.screenChangeRequestHandler, ContextEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator
