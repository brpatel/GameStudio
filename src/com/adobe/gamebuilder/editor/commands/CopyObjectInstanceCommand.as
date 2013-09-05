package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstance;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class CopyObjectInstanceCommand extends StarlingCommand 
    {

        [Inject]
        public var event:ObjectInstanceEvent;
        [Inject]
        public var gameState:GameState;
        private var _objectInstance:ObjectInstance;


        override public function execute():void
        {
            var object:ObjectInstance;
            super.execute();
            var numObjectsOfType:uint;
            for each (object in this.gameState.objects)
            {
                if (object.className == this.event.objectInstance.className)
                {
                    numObjectsOfType++;
                };
            };
            this._objectInstance = this.gameState.copyObject(this.event.objectInstance, (this.event.objectInstance.getUnqualifiedClassName() + numObjectsOfType));
        }

       


    }
}//package commands
