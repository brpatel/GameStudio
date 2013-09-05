
package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.ApplicationModel;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstance;
    import com.adobe.gamebuilder.editor.view.events.CreateObjectInstanceEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class CreateObjectInstanceCommand extends StarlingCommand 
    {

        [Inject]
        public var event:CreateObjectInstanceEvent;
        [Inject]
        public var gameState:GameState;
        [Inject]
        public var applicationModel:ApplicationModel;
        private var _objectInstance:ObjectInstance;


        override public function execute():void
        {
            var object:ObjectInstance;
            super.execute();
            var numObjectsOfType:uint;
            for each (object in this.gameState.objects)
            {
                if (object.className == this.event.objectAsset.className)
                {
                    numObjectsOfType++;
                };
            };
            this._objectInstance = this.gameState.createObject(this.event.objectAsset, this.event.x, this.event.y, this.gameState.lastGroupUsed,false);
        }

        


    }
}//package commands
