package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.events.RoomSideEvent;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    
    import org.robotlegs.mvcs.StarlingMediator;

    public class RoomSideMediator extends StarlingMediator 
    {

        [Inject]
        public var view:RoomSide;


        override public function onRegister():void
        {
            this.view.move.add(this.roomSideChangeHandler);
            this.view.enableSignal.add(this.roomSideEnableHandler);
            this.view.onRemove.add(this.onRemoveHandler);
            addContextListener(RoomSideEvent.SIDES_UPDATE, this.sidesUpdateHandler, RoomSideEvent);
            addContextListener(RoomSideEvent.INPUT_CHANGE, this.sideMeasureInputChangeHandler, RoomSideEvent);
            addContextListener(RoomSideEvent.SIDES_DIRECTION_UPDATE, this.sidesDirectionUpdateHandler, RoomSideEvent);
            addContextListener(RoomSideEvent.SIDES_ENABLING_UPDATE, this.sidesEnablingUpdateHandler, RoomSideEvent);
        }

        private function sidesUpdateHandler(_arg1:RoomSideEvent):void
        {
            this.view.update();
        }

        private function sidesEnablingUpdateHandler(_arg1:RoomSideEvent):void
        {
            this.view.checkEnabling();
        }

        private function sidesDirectionUpdateHandler(_arg1:RoomSideEvent):void
        {
            if (this.view.id != _arg1.data.sideID)
            {
                this.view.directionUpdate((_arg1.data.movedPoint as RoomPoint));
            };
        }

        private function sideMeasureInputChangeHandler(_arg1:RoomSideEvent):void
        {
            if (this.view.id == _arg1.data.sideID)
            {
                this.view.measure = Math.min(2500, Math.max(1, _arg1.data.value));
                dispatch(new RoomSideEvent(RoomSideEvent.SIDES_DIRECTION_UPDATE, false, {
                    sideID:this.view.id,
                    movedPoint:this.view.movedPoint
                }));
            };
        }

        private function roomSideEnableHandler():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.ENABLE, false, this.view));
        }

        private function roomSideChangeHandler():void
        {
            dispatch(new RoomSideEvent(RoomSideEvent.CHANGE, false, this.view));
        }

        private function onRemoveHandler():void
        {
            this.onRemove();
        }

        override public function onRemove():void
        {
            this.view.move.remove(this.roomSideChangeHandler);
            removeContextListener(RoomSideEvent.SIDES_UPDATE, this.sidesUpdateHandler, RoomSideEvent);
            removeContextListener(RoomSideEvent.INPUT_CHANGE, this.sideMeasureInputChangeHandler, RoomSideEvent);
            removeContextListener(RoomSideEvent.SIDES_DIRECTION_UPDATE, this.sidesDirectionUpdateHandler, RoomSideEvent);
            removeContextListener(RoomSideEvent.SIDES_ENABLING_UPDATE, this.sidesEnablingUpdateHandler, RoomSideEvent);
        }


    }
}//package at.polypex.badplaner.view.mediator
