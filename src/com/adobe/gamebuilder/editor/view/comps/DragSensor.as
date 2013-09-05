package com.adobe.gamebuilder.editor.view.comps
{
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    
    import org.josht.starling.foxhole.dragDrop.DragData;
    import org.josht.starling.foxhole.dragDrop.DragDropManager;
    import org.josht.starling.foxhole.dragDrop.IDropTarget;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    
    import starling.display.DisplayObject;
    import starling.display.Quad;

    public class DragSensor extends Quad implements IDropTarget 
    {

        private var _onDragEnter:Signal;
        private var _onDragMove:Signal;
        private var _onDragExit:Signal;
        private var _onDragDrop:Signal;

        public function DragSensor(_arg1:Number, _arg2:Number, _arg3:uint=8816521, _arg4:Boolean=false)
        {
            super(_arg1, _arg2, _arg3, _arg4);
            name = "dragSensor";
            alpha = 0;
            pivotX = 0;
            pivotY = (_arg2 >> 1);
            this.init();
        }

        private function init():void
        {
            this._onDragEnter = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragMove = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragExit = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragDrop = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragExit.add(this.onDragExitHandler);
            this._onDragEnter.add(this.onDragEnterHandler);
        }

        public function get onDragEnter():ISignal
        {
            return (this._onDragEnter);
        }

        public function get onDragMove():ISignal
        {
            return (this._onDragMove);
        }

        public function get onDragExit():ISignal
        {
            return (this._onDragExit);
        }

        public function get onDragDrop():ISignal
        {
            return (this._onDragDrop);
        }

        private function onDragEnterHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            if (((_arg2.hasDataForFormat("opening")) && ((RoomMeasure.px2cm(this.width, false) >= 80))))
            {
                DragDropManager.acceptDrag(_arg1);
                (_arg2.getDataForFormat("opening")["avatar"] as DisplayObject).rotation = parent.rotation;
                (_arg2.getDataForFormat("opening")["avatar"] as OpeningAvatar).showIcon();
            };
            if (_arg2.hasDataForFormat("product"))
            {
                DragDropManager.acceptDrag(_arg1);
                (_arg2.getDataForFormat("product")["avatar"] as ProductAvatar).showIcon();
            };
        }

        private function onDragExitHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            if (_arg2.hasDataForFormat("opening"))
            {
                (_arg2.getDataForFormat("opening")["avatar"] as OpeningAvatar).hideIcon();
            };
            if (_arg2.hasDataForFormat("product"))
            {
                (_arg2.getDataForFormat("product")["avatar"] as ProductAvatar).hideIcon();
            };
        }


    }
}//package at.polypex.badplaner.view.comps
