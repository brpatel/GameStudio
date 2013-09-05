package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.comps.DragSensor;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    
    import flash.geom.Point;
    
    import org.josht.starling.foxhole.dragDrop.DragData;
    import org.josht.starling.foxhole.dragDrop.IDropTarget;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;

    public class RoomLine extends DisplayObjectContainer 
    {

        private var _sensor:DragSensor;
        private var _visual:Quad;

        public function RoomLine()
        {
            this.init();
        }

        public function get sensor():DragSensor
        {
            return (this._sensor);
        }

        private function init():void
        {
            this._visual = new Quad(RoomMeasure.WALL_SIZE, RoomMeasure.WALL_SIZE, Constants.LINE_COLOR);
            this._visual.pivotX = 0;
            this._visual.pivotY = (this._visual.height >> 1);
            addChild(this._visual);
            this._sensor = new DragSensor(RoomMeasure.WALL_SIZE, (2 * RoomPoint.VISUAL_RADIUS));
            this._sensor.onDragDrop.add(this.onDragDropHandler);
            addChild(this._sensor);
        }

        public function update():void
        {
            this._sensor.width = (Math.sqrt((Math.pow((RoomPoint(parent).successor.x - RoomPoint(parent).x), 2) + Math.pow((RoomPoint(parent).successor.y - RoomPoint(parent).y), 2))) - (((Common.appStep)==Constants.STEP_ROOM) ? RoomPoint.VISUAL_RADIUS : 0));
            this._visual.width = this._sensor.width;
            rotation = Math.atan2((RoomPoint(parent).successor.y - RoomPoint(parent).y), (RoomPoint(parent).successor.x - RoomPoint(parent).x));
        }

        private function onDragDropHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            var _local5:Opening;
            var _local6:Point;
            if (_arg2.hasDataForFormat("opening"))
            {
                if (_arg2.getDataForFormat("opening")["type"] == Opening.DOOR)
                {
                    _local5 = new Door((parent as RoomPoint));
                }
                else
                {
                    _local5 = new Window((parent as RoomPoint));
                };
                _local5.x = Math.min(((this._sensor.width - RoomMeasure.cm2px(Opening.DEFAULT_SIZE)) + (RoomMeasure.WALL_SIZE >> 1)), Math.max(0, ((_arg3 * DragSensor(_arg1).scaleX) - RoomMeasure.cm2px((Opening.DEFAULT_SIZE >> 1)))));
                (parent as RoomPoint).room.openingManager.add(_local5, (parent as RoomPoint));
            }
            else
            {
                if (_arg2.hasDataForFormat("product"))
                {
                    _local6 = ((this.parent as RoomPoint).room.parent as Container).globalToLocal(this._sensor.localToGlobal(new Point(_arg3, _arg4)));
                    ((this.parent as RoomPoint).room.parent as Container).onDragDropHandler(_arg1, _arg2, _local6.x, _local6.y);
                };
            };
        }


    }
}//package at.polypex.badplaner.view.parts
