package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.core.events.RoomSideEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    import com.adobe.gamebuilder.editor.view.screens.GameSetupScreen;
    
    import flash.geom.Point;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class GameSetupScreenMediator extends StarlingMediator 
    {

        [Inject]
        public var appModel:AppModel;
        [Inject]
        public var view:GameSetupScreen;


        override public function onRegister():void
        {
            this.view.selectedRoom = this.appModel.currentPlan.baseRoom;
            this.view.roomChange.add(this.roomChangeHandler);
            this.view.roomReflection.add(this.roomReflectionHandler);
            this.view.sideMeasureInputChange.add(this.sideMeasureInputChangeHandler);
            this.view.sidesUpdate.add(this.sidesUpdateHandler);
            this.view.initialComplete.add(this.initialCompleteHandler);
            this.view.measureRequest.add(this.measureRequestHandler);
            addContextListener(RoomSideEvent.INIT, this.sideMeasureInitHandler, RoomSideEvent);
            addContextListener(RoomSideEvent.CHANGE, this.sideMeasureChangeHandler, RoomSideEvent);
            addContextListener(RoomSideEvent.ENABLE, this.sideEnableChangeHandler, RoomSideEvent);
            addContextListener(ContextEvent.SET_SCREEN_REQUEST, this.screenChangeRequestHandler, ContextEvent);
			
			// For level editor
			this.view.addBgImage.add(this.addBgImageHandler);
        }

        private function initialCompleteHandler():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.INITIAL_REQUEST));
        }

        private function screenChangeRequestHandler(_arg1:ContextEvent):void
        {
            if (this.view.selectedRoom != this.appModel.currentPlan.baseRoom)
            {
                this.view.selectedRoom = this.appModel.currentPlan.baseRoom;
            };
            dispatch(new RoomSideEvent(RoomSideEvent.INITIAL_REQUEST));
        }

        private function roomReflectionHandler(_arg1:String):void
        {
            dispatch(new ContextEvent(ContextEvent.ROOM_REFLECTION, _arg1));
        }

        private function roomChangeHandler(_arg1:uint):void
        {
            this.appModel.currentPlan.baseRoom = _arg1;
            dispatch(new ContextEvent(ContextEvent.BASE_ROOM_CHANGED, _arg1));
        }

        override public function onRemove():void
        {
            this.view.roomChange.remove(this.roomChangeHandler);
            this.view.roomReflection.remove(this.roomReflectionHandler);
            this.view.sideMeasureInputChange.remove(this.sideMeasureInputChangeHandler);
            this.view.sidesUpdate.remove(this.sidesUpdateHandler);
            this.view.initialComplete.remove(this.initialCompleteHandler);
            this.view.measureRequest.remove(this.measureRequestHandler);
            removeContextListener(RoomSideEvent.INIT, this.sideMeasureInitHandler, RoomSideEvent);
            removeContextListener(RoomSideEvent.CHANGE, this.sideMeasureChangeHandler, RoomSideEvent);
            removeContextListener(ContextEvent.SET_SCREEN_REQUEST, this.screenChangeRequestHandler, ContextEvent);
        }

        private function measureRequestHandler():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.INITIAL_REQUEST));
        }

        private function sideMeasureInputChangeHandler(_arg1:String, _arg2:uint):void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.INPUT_CHANGE, false, {
                sideID:_arg1,
                value:_arg2
            }));
        }

        private function sidesUpdateHandler():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.SIDES_UPDATE));
        }

        private function sideMeasureChangeHandler(_arg1:RoomSideEvent):void
        {
            this.view.sideMeasureChangeHandler((_arg1.data as RoomSide));
        }

        private function sideEnableChangeHandler(_arg1:RoomSideEvent):void
        {
            this.view.sideEnableChangeHandler((_arg1.data as RoomSide));
        }

        private function sideMeasureInitHandler(_arg1:RoomSideEvent):void
        {
            this.view.sideMeasureInitHandler(_arg1.data);
        }
		
		// For Level Editor
		private function addBgImageHandler():void
		{
			var imageProductVO:MobileProductVO = new MobileProductVO();
			// Bg Image add to game
		/*	imageProductVO.id=9;
			imageProductVO.name="Image";
			imageProductVO.file_id = "1302686587";
			imageProductVO.className="com.citrusengine.objects.CitrusSprite";
			imageProductVO.superClassName ="com.citrusengine.core.CitrusObject";
			*/
			
			dispatch(new ContextEvent(ContextEvent.ADD_BACKGROUND_IMAGE, {image:imageProductVO}));
			/*var _local5:Point;
			
				_local5 = this._room.globalToLocal(this.localToGlobal(new Point(_arg3, _arg4)));
				this.room.addProduct((_arg2.getDataForFormat("product")["product"] as MobileProductVO), _local5, _arg2.getDataForFormat("product")["offsetX"], _arg2.getDataForFormat("product")["offsetY"]);
				var productVo:MobileProductVO = (_arg2.getDataForFormat("product")["product"] as MobileProductVO);
				this._productDrop.dispatch(this.room.productManager.getItemAt(this.room.productManager.length-1), _local5);
			*/
		}


    }
}//package at.polypex.badplaner.view.mediator
