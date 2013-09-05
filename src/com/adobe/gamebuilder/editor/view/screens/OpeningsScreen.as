package com.adobe.gamebuilder.editor.view.screens
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.view.comps.Opening;
    import com.adobe.gamebuilder.editor.view.comps.OpeningAvatar;
    import com.adobe.gamebuilder.editor.view.parts.DragDoor;
    import com.adobe.gamebuilder.editor.view.parts.DragWindow;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.dragDrop.DragData;
    import org.josht.starling.foxhole.dragDrop.DragDropManager;
    import org.josht.starling.foxhole.dragDrop.IDragSource;
    
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;

    public class OpeningsScreen extends Screen 
    {

        private var _moveTouches:Vector.<Touch>;


        override protected function initialize():void
        {
            var _local1:TextField = Common.labelField(100, 30, Common.getResourceString("label_door"), 16);
            _local1.x = 22;
            _local1.y = 30;
            addChild(_local1);
            var _local2:DragDoor = new DragDoor();
            _local2.x = 122;
            _local2.y = 142;
            _local2.addEventListener(TouchEvent.TOUCH, this.openingTouchHandler);
            _local2.onDragStart.add(this.onDragStart);
            _local2.onDragComplete.add(this.onDragComplete);
            addChild(_local2);
            var _local3:Image = Common.separator(14, 171, 232, "sidebar");
            addChild(_local3);
            _local1 = Common.labelField(100, 30, Common.getResourceString("label_window"), 16);
            _local1.x = 22;
            _local1.y = 191;
            addChild(_local1);
            var _local4:DragWindow = new DragWindow();
            _local4.x = 121;
            _local4.y = 265;
            _local4.addEventListener(TouchEvent.TOUCH, this.openingTouchHandler);
            _local4.onDragStart.add(this.onDragStart);
            _local4.onDragComplete.add(this.onDragComplete);
            addChild(_local4);
        }

        private function onDragComplete(_arg1:IDragSource, _arg2:DragData, _arg3:Boolean):void
        {
        }

        private function onDragStart(_arg1:IDragSource, _arg2:DragData):void
        {
        }

        private function openingTouchHandler(_arg1:TouchEvent):void
        {
            var _local2:DisplayObject;
            var _local3:DragData;
            this._moveTouches = _arg1.getTouches(this, TouchPhase.MOVED);
            if (this._moveTouches.length == 1)
            {
                if (!DragDropManager.isDragging)
                {
                    _local2 = new OpeningAvatar((((_arg1.currentTarget is DragDoor)) ? Opening.DOOR : Opening.WINDOW));
                    _local3 = new DragData();
                    _local3.setDataForFormat("opening", {
                        type:(((_arg1.currentTarget is DragDoor)) ? Opening.DOOR : Opening.WINDOW),
                        avatar:_local2
                    });
                    DragDropManager.startDrag((_arg1.currentTarget as IDragSource), this._moveTouches[0], _local3, _local2, 0, 0);
                };
            };
        }


    }
}//package at.polypex.badplaner.view.screens
