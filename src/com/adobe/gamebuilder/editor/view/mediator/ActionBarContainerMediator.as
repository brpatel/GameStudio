package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class ActionBarContainerMediator extends StarlingMediator 
    {

        [Inject]
        public var view:ActionBarContainer;


        override public function onRegister():void
        {
            addContextListener(ContextEvent.HIDE_ACTION_BAR, this.hideActionBarHandler, ContextEvent);
            addContextListener(ContextEvent.SHOW_ACTION_BAR, this.showActionBarHandler, ContextEvent);
            this.view.reset.add(this.resetHandler);
        }

        private function hideActionBarHandler(_arg1:ContextEvent):void
        {
            this.view.hide(false);
        }

        private function showActionBarHandler(_arg1:ContextEvent):void
        {
            this.view.show(_arg1.data.type);
        }

        private function resetHandler():void
        {
            dispatch(new ContextEvent(ContextEvent.RESET_TOPBAR));
        }

        override public function onRemove():void
        {
            removeContextListener(ContextEvent.HIDE_ACTION_BAR, this.hideActionBarHandler, ContextEvent);
            removeContextListener(ContextEvent.SHOW_ACTION_BAR, this.showActionBarHandler, ContextEvent);
            this.view.reset.remove(this.resetHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator
