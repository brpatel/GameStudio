package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.data.SystemMessage;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.core.events.RoomSideEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstance;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstanceParam;
    import com.adobe.gamebuilder.editor.model.vo.PropertyUpdateVO;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.events.CreateObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    
    import flash.geom.Point;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class RoomMediator extends StarlingMediator 
    {

        [Inject]
        public var appModel:AppModel;
        [Inject]
        public var view:Room;
		[Inject]
		public var gameState:GameState;


        override public function onRegister():void
        {
            this.view.initialComplete.add(this.initialCompleteHandler);
            this.view.systemMessage.add(this.systemMessageHandler);
            addContextListener(RoomSideEvent.INITIAL_REQUEST, this.sideInitialRequestHandler, RoomSideEvent);
            addContextListener(ContextEvent.NEW_PLAN, this.newPlanHandler, ContextEvent);
            addContextListener(ContextEvent.BASE_ROOM_CHANGED, this.roomChangeHandler, ContextEvent);
            addContextListener(ContextEvent.ROOM_REFLECTION, this.roomReflectionHandler, ContextEvent);
            addContextListener(ContextEvent.SCREEN_CHANGED, this.screenChangeHandler, ContextEvent);
            addContextListener(ContextEvent.CONTAINER_TOUCH, this.containerTouchHandler, ContextEvent);
            addContextListener(ContextEvent.LOAD_PLAN, this.loadPlanHandler, ContextEvent);
            addContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeHandler, ContextEvent);
            addContextListener(ContextEvent.ADD_PRODUCT, this.addProductHandler, ContextEvent);
            this.view.loadBaseRoom(this.appModel.getBaseRoom(this.appModel.currentPlan.baseRoom), false);
			
			// For level editor
			addContextListener(ContextEvent.ADD_BACKGROUND_IMAGE, this.addBgImageHandler, ContextEvent);
			eventMap.mapListener(eventDispatcher, ObjectInstanceEvent.OBJECT_CREATED, this.handleObjectCreated, ObjectInstanceEvent);
			
			eventMap.mapListener(eventDispatcher, UpdateObjectPropertyEvent.OBJECT_PROPERTY_UPDATED, this.handleObjectPropertyUpdated, UpdateObjectPropertyEvent);
			
        }
		
		private function handleObjectCreated(e:ObjectInstanceEvent):void
		{
			var param:ObjectInstanceParam;
			var objectInstance:ObjectInstance = e.objectInstance;
	//		var mapObject:MapObjectInstance = this.view.createMapObject(objectInstance.id);
			var productVO:MobileProductVO = this.appModel.getProductByName(objectInstance.className).cloneForStorage();
			var pointX:Number = 0;
			var pointY:Number = 0;
			var view:String="";
			var width:Number=50;
			var height:Number = 50;
					
		
			
			for each (param in objectInstance.params)
			{
				if (productVO.hasOwnProperty(param.name))
				{
					productVO[param.name] = param.value;
				}else if(param.name == "x"){
					pointX = Number(param.value);
				}else if(param.name == "y"){
					pointX = Number(param.value);
				}else if(param.name == "view" && param.value!=""){
				//	view = String(param.value);
				}else if(param.name == "width"){
					width = Number(param.value);
				}else if(param.name == "height"){
					height = Number(param.value);
				}
				
			};
			productVO.file_id=null;
			var placementPoint:Point= new Point(pointX, pointY);
			this.view.addProduct(productVO, placementPoint, 0, 0);
			var product:Product = this.view.productManager.getItemAt(this.view.productManager.length-1);
			product._instanceID = objectInstance.id;

		}
		
		
		private function handleObjectPropertyUpdated(e:UpdateObjectPropertyEvent):void
		{
			var updateVO:PropertyUpdateVO;
			var mapObject:Product;
			var param:ObjectInstanceParam;
			var i:int;
			var view:String="";
			var width:Number=50;
			var height:Number = 50;
			
			while (i < e.updates.length)
			{
				
				updateVO = e.updates[i];
				mapObject = this.view.productManager.getProductObjectByID(updateVO.objectInstance.id);
			//	mapObject = this.view.productManager.selectedProduct;
				param = updateVO.objectInstance.getParamByName(updateVO.property);
				if(mapObject!=null){
					if (mapObject.hasOwnProperty(param.name))
					{
						
						 if(param.name == "width"){
							width = Number(param.value);
						}else if(param.name == "height"){
							height = Number(param.value);
						}else{
							mapObject[param.name] = param.value;
						}
					}else if(param.name == "view"){
						//	mapObject.loadFile(String(param.value));
						if(param.value ==""){
							var mProductVo:MobileProductVO = this.appModel.getProductByName(updateVO.objectInstance.className);
							mapObject.vo.file_id= mProductVo.file_id;
							mapObject.loadFile(mProductVo.file_id);
						}else{
							mapObject.loadExternalFile(String(param.value));
						}
					}
					
				}
				i++;
			};
			
			mapObject.setSizeWithoutDispatch(width,height);
			
			
		}

        private function systemMessageHandler(_arg1:SystemMessage):void
        {
            dispatch(new ContextEvent(ContextEvent.SYSTEM_MESSAGE, {message:_arg1}));
        }

        private function addProductHandler(_arg1:ContextEvent):void
        {
			var productVO:MobileProductVO = (_arg1.data.productVO as MobileProductVO);
			
			var placementPoint:Point= new Point(0, 0);
            this.view.addProduct(productVO, placementPoint, 0, 0);
			var product:Product = this.view.productManager.getItemAt(this.view.productManager.length-1);
			product._instanceID = this.gameState._lastObjectID +1;					
			dispatch(new CreateObjectInstanceEvent(product.vo.objectAsset, placementPoint.x, placementPoint.y));
			
        }
		
		private function addBgImageHandler(_arg1:ContextEvent):void
		{
			var productVO:MobileProductVO = this.appModel.productList[1]; // Set the productVO of Image (index: 1)
						var placementPoint:Point= new Point(0, 0);
			this.view.addProduct(productVO, placementPoint, 0, 0);
			var product:Product = this.view.productManager.getItemAt(this.view.productManager.length-1);
			product._instanceID = this.gameState._lastObjectID +1;			
			
			dispatch(new CreateObjectInstanceEvent(product.vo.objectAsset, placementPoint.x, placementPoint.y));
	//		product.loadExternalFile("_arg1.data.image");
		//	product.setSize(this.view.sideManager.getSideByID("A").measure,this.view.sideManager.getSideByID("B").measure);
			
			
		}

        private function initialCompleteHandler(_arg1:int):void
        {
            this.dispatchSideMeasure();
            if (_arg1 > 0)
            {
                this.appModel.currentPlan.baseRoom = _arg1;
            };
            dispatch(new ContextEvent(ContextEvent.SET_SCREEN_REQUEST, Constants.STEP_ROOM));
        }

        private function containerTouchHandler(_arg1:ContextEvent):void
        {
            this.view.outlineManager.hideAll();
        }

        private function roomReflectionHandler(_arg1:ContextEvent):void
        {
            this.view.reflect(String(_arg1.data), this.appModel.currentPlan.baseRoom);
            this.dispatchSideMeasure();
        }

        private function screenChangeHandler(_arg1:ContextEvent):void
        {
            this.view.screenChangeHandler(String(_arg1.data));
        }

        private function roomChangeHandler(_arg1:ContextEvent):void
        {
            this.view.loadBaseRoom(this.appModel.getBaseRoom(int(_arg1.data)));
        }

        private function loadPlanHandler(_arg1:ContextEvent):void
        {
            var _local2:String = ((((!((_arg1.data.storedPlan.name == null))) && (!((_arg1.data.storedPlan.name == ""))))) ? _arg1.data.storedPlan.name : String(_arg1.data.fileName).substr(0, String(_arg1.data.fileName).lastIndexOf(".")));
            dispatch(new ContextEvent(ContextEvent.SET_PLAN_NAME, {planName:_local2}));
            this.appModel.currentPlan.isNew = false;
            this.appModel.currentPlan.name = _local2;
            this.view.loadStoredRoom(_arg1.data.storedPlan);
            dispatch(new ContextEvent(ContextEvent.SET_SCREEN_REQUEST, Constants.STEP_ROOM));
        }

        private function newPlanHandler(_arg1:ContextEvent):void
        {
            this.appModel.currentPlan.baseRoom = 1;
            this.appModel.currentPlan.isNew = true;
            this.appModel.currentPlan.name = Common.getResourceString("newPlanName");
            this.view.loadBaseRoom(this.appModel.getBaseRoom(this.appModel.currentPlan.baseRoom));
            dispatch(new ContextEvent(ContextEvent.SET_PLAN_NAME, {planName:this.appModel.currentPlan.name}));
            dispatch(new ContextEvent(ContextEvent.SET_SCREEN_REQUEST, Constants.STEP_ROOM));
        }

        private function sideInitialRequestHandler(_arg1:RoomSideEvent):void
        {
            this.dispatchSideMeasure();
            dispatch(new RoomSideEvent(RoomSideEvent.SIDES_ENABLING_UPDATE));
        }

        private function dispatchSideMeasure():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.INIT, false, {
                A:this.view.sideManager.getSideByID(RoomSide.SIDE_A),
                B:this.view.sideManager.getSideByID(RoomSide.SIDE_B),
                C:this.view.sideManager.getSideByID(RoomSide.SIDE_C),
                D:this.view.sideManager.getSideByID(RoomSide.SIDE_D)
            }));
        }

        private function presentationModeHandler(_arg1:ContextEvent):void
        {
            this.view.outlineManager.hideOpeningOutline();
            this.view.outlineManager.hideProductOutline();
        }

        override public function onRemove():void
        {
            this.view.initialComplete.remove(this.initialCompleteHandler);
            this.view.systemMessage.remove(this.systemMessageHandler);
            removeContextListener(RoomSideEvent.INITIAL_REQUEST, this.sideInitialRequestHandler, RoomSideEvent);
            removeContextListener(ContextEvent.BASE_ROOM_CHANGED, this.roomChangeHandler, ContextEvent);
            removeContextListener(ContextEvent.NEW_PLAN, this.newPlanHandler, ContextEvent);
            removeContextListener(ContextEvent.ROOM_REFLECTION, this.roomReflectionHandler, ContextEvent);
            removeContextListener(ContextEvent.SCREEN_CHANGED, this.screenChangeHandler, ContextEvent);
            removeContextListener(ContextEvent.CONTAINER_TOUCH, this.containerTouchHandler, ContextEvent);
            removeContextListener(ContextEvent.LOAD_PLAN, this.loadPlanHandler, ContextEvent);
            removeContextListener(ContextEvent.SWITCH_PRESENTATION_MODE, this.presentationModeHandler, ContextEvent);
            removeContextListener(ContextEvent.ADD_PRODUCT, this.addProductHandler, ContextEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator
