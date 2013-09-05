package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.view.screens.FinalizeScreen;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class FinalizeScreenMediator extends StarlingMediator 
    {

        [Inject]
        public var view:FinalizeScreen;


        override public function onRegister():void
        {
            this.view.btnRelease.add(this.btnReleaseHandler);
        }

        override public function onRemove():void
        {
            this.view.btnRelease.remove(this.btnReleaseHandler);
        }

        private function btnReleaseHandler(_arg1:String):void
        {
            dispatch(new ContextEvent(ContextEvent.OPEN_OVERLAY, {type:_arg1}));
        }


    }
}//package at.polypex.badplaner.view.mediator
