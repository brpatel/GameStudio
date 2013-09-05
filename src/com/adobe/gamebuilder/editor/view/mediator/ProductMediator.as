package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstance;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstanceParam;
    import com.adobe.gamebuilder.editor.model.vo.PropertyUpdateVO;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class ProductMediator extends StarlingMediator 
    {

        [Inject]
        public var view:Product;
		
		[Inject]
		public var gameState:GameState;
		
		

        override public function onRegister():void
        {
		//	eventMap.mapListener(eventDispatcher, UpdateObjectPropertyEvent.OBJECT_PROPERTY_UPDATED, this.handleObjectPropertyUpdated, UpdateObjectPropertyEvent);
			
			
            this.view.productSelect.add(this.productSelectHandler);
			this.view.productMoveEnded.add(this.productMoveEndedHandler);
			this.view.productRotateEnded.add(this.productRotateEndedHandler);
			this.view.productResize.add(this.productResizeHandler);
			this.view.productDelete.add(this.productDeleteHandler);
			this.view.productDeSelect.add(this.productDeselectHandler);
         }
		
		private function handleObjectPropertyUpdated(e:UpdateObjectPropertyEvent):void
		{
			var updateVO:PropertyUpdateVO;
			var mapObject:Product;
			var param:ObjectInstanceParam;
			var i:int;
			while (i < e.updates.length)
			{
			
				updateVO = e.updates[i];
				mapObject = this.view;
				param = updateVO.objectInstance.getParamByName(updateVO.property);
				/*if (mapObject.hasOwnProperty(param.name))
				{
					mapObject[param.name] = param.value;
					if(param.name == "view"){
						mapObject.loadFile(String(param.value));
					}
				};*/
				if(param.name == "view" && param.value!=""){
					mapObject.loadExternalFile(String(param.value));
				}
				i++;
			};
		}
		
		private function productDeselectHandler():void
		{
			this.gameState.selectedObject = null;
		}
		
		private function productDeleteHandler(product:Product):void
		{
			var dataObject:ObjectInstance = this.gameState.getObjectByID(product._instanceID);
			dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.DELETE_OBJECT, dataObject));
			this.gameState.selectedObject = null;			
		}
		
		private function productResizeHandler(product:Product):void
		{			
			var dataObject:ObjectInstance = this.gameState.getObjectByID(product._instanceID);
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(dataObject, "x", product.x));
			updates.push(new PropertyUpdateVO(dataObject, "y", product.y));
			updates.push(new PropertyUpdateVO(dataObject, "width", product.originalWidth * product.scaleX ));
			updates.push(new PropertyUpdateVO(dataObject, "height", product.originalHeight * product.scaleY));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			var view:String = (dataObject.getParamByName("view").value as String);
			if (((view) && ((view.length > 0))))
			{
				dataObject.customSize = true;
			};
			
			/*if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode)
				GameBuilderApp.frameReRun(updates);*/
			
		}
		
		private function productMoveEndedHandler(product:Product):void
		{
			var dataObject:ObjectInstance = this.gameState.getObjectByID(product._instanceID);
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(dataObject, "x", product.x));
			updates.push(new PropertyUpdateVO(dataObject, "y", product.y));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
			/*if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode)
				GameBuilderApp.frameReRun(updates);*/
		}
		
		private function productRotateEndedHandler(product:Product):void
		{
			
		
			var dataObject:ObjectInstance = this.gameState.getObjectByID(product._instanceID);
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(dataObject, "x", product.x));
			updates.push(new PropertyUpdateVO(dataObject, "y", product.y));
			updates.push(new PropertyUpdateVO(dataObject, "rotation", (product.rotation* 180/Math.PI)));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
			/*if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode)
				GameBuilderApp.frameReRun(updates);*/
		}
		
		private function productSelectHandler(product:Product):void
		{
			var dataObject:ObjectInstance = this.gameState.getObjectByID(product._instanceID);
			this.gameState.selectedObject = dataObject;
			
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(dataObject, "x", product.x));
			updates.push(new PropertyUpdateVO(dataObject, "y", product.y));
			updates.push(new PropertyUpdateVO(dataObject, "width", product.originalWidth * product.scaleX ));
			updates.push(new PropertyUpdateVO(dataObject, "height", product.originalHeight * product.scaleY));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
		}
       

        

        override public function onRemove():void
        {
          super.onRemove();
        }


    }
}//package at.polypex.badplaner.view.mediator
