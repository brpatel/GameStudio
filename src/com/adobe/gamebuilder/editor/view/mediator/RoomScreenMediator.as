package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.core.events.RoomSideEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    import com.adobe.gamebuilder.editor.view.screens.RoomScreen;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class RoomScreenMediator extends StarlingMediator 
    {

        [Inject]
        public var appModel:AppModel;
        [Inject]
        public var view:RoomScreen;


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


    }
}//package at.polypex.badplaner.view.mediator
