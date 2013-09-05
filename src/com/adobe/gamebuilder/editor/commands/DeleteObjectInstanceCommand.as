package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class DeleteObjectInstanceCommand extends StarlingCommand 
    {

        [Inject]
        public var event:ObjectInstanceEvent;
        [Inject]
        public var gameState:GameState;


        override public function execute():void
        {
            super.execute();
            this.gameState.deleteObject(this.event.objectInstance);
        }

       


    }
}//package commands
