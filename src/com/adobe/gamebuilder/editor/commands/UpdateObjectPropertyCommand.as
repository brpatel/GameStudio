package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstanceParam;
    import com.adobe.gamebuilder.editor.model.vo.PropertyUpdateVO;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class UpdateObjectPropertyCommand extends StarlingCommand 
    {

        [Inject]
        public var event:UpdateObjectPropertyEvent;
        [Inject]
        public var gameState:GameState;
        private var _oldPropertyValues:Array;


        override public function execute():void
        {
            var newUpdateVO:PropertyUpdateVO;
            var property:ObjectInstanceParam;
            super.execute();
            this._oldPropertyValues = new Array();
            var i:int;
            while (i < this.event.updates.length)
            {
                newUpdateVO = this.event.updates[i];
                property = newUpdateVO.objectInstance.getParamByName(newUpdateVO.property);
                this._oldPropertyValues.push(new PropertyUpdateVO(newUpdateVO.objectInstance, newUpdateVO.property, property.value));
                property.value = newUpdateVO.value;
                if (property.name == "group")
                {
                    this.gameState.lastGroupUsed = Number(property.value);
                };
                i++;
            };
			
			
			
            this.gameState.isFileOutOfDate = true;
            eventDispatcher.dispatchEvent(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.OBJECT_PROPERTY_UPDATED, this.event.updates));
        }

      


    }
}//package commands
