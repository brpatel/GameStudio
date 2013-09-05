package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.view.bars.PropertyTab;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class PropertyTabMediator extends StarlingMediator 
    {

        [Inject]
        public var view:PropertyTab;


        override public function onRegister():void
        {
            this.view.actionSignal.add(this.viewActionHandler);
        }

        private function screenChangeHandler(_arg1:ContextEvent):void
        {
            
        }

        private function viewActionHandler(_arg1:String):void
        {
            //any actions if required
        }

        override public function onRemove():void
        {
            this.view.actionSignal.remove(this.viewActionHandler);
        }


    }
}//package at.polypex.badplaner.view.mediator
