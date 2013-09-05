//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.dragDrop
{
    import flash.geom.Point;
    import starling.display.DisplayObject;
    import starling.core.Starling;
    import org.josht.starling.foxhole.core.PopUpManager;
    import starling.events.TouchEvent;
    import flash.events.KeyboardEvent;
    import starling.events.Touch;
    import flash.errors.IllegalOperationError;
    import flash.ui.Keyboard;
    import starling.display.Stage;
    import __AS3__.vec.Vector;
    import starling.events.TouchPhase;

    public class DragDropManager 
    {

        private static const HELPER_POINT:Point = new Point();

        protected static var _touchPointID:int = -1;
        protected static var dragSource:IDragSource;
        protected static var _dragData:DragData;
        protected static var dropTarget:IDropTarget;
        protected static var isAccepted:Boolean = false;
        protected static var avatar:DisplayObject;
        protected static var avatarOffsetX:Number;
        protected static var avatarOffsetY:Number;
        protected static var dropTargetLocalX:Number;
        protected static var dropTargetLocalY:Number;
        protected static var avatarOldTouchable:Boolean;


        public static function get touchPointID():int
        {
            return (_touchPointID);
        }

        public static function get isDragging():Boolean
        {
            return (!((_dragData == null)));
        }

        public static function get dragData():DragData
        {
            return (_dragData);
        }

        public static function startDrag(_arg1:IDragSource, _arg2:Touch, _arg3:DragData, _arg4:DisplayObject=null, _arg5:Number=0, _arg6:Number=0):void
        {
            if (isDragging)
            {
                cancelDrag();
            };
            if (!_arg1)
            {
                throw (new ArgumentError("Drag source cannot be null."));
            };
            if (!_arg3)
            {
                throw (new ArgumentError("Drag data cannot be null."));
            };
            dragSource = _arg1;
            _dragData = _arg3;
            _touchPointID = _arg2.id;
            avatar = _arg4;
            avatarOffsetX = _arg5;
            avatarOffsetY = _arg6;
            _arg2.getLocation(Starling.current.stage, HELPER_POINT);
            if (avatar)
            {
                avatarOldTouchable = avatar.touchable;
                avatar.touchable = false;
                avatar.x = (HELPER_POINT.x + avatarOffsetX);
                avatar.y = (HELPER_POINT.y + avatarOffsetY);
                PopUpManager.addPopUp(avatar, false, false);
            };
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
            Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
            dragSource.onDragStart.dispatch(dragSource, _arg3);
            updateDropTarget(HELPER_POINT);
        }

        public static function acceptDrag(_arg1:IDropTarget):void
        {
            if (dropTarget != _arg1)
            {
                throw (new ArgumentError("Drop target cannot accept a drag at this time. Acceptance may only happen after the onDragEnter signal is dispatched and before the onDragExit signal is dispatched."));
            };
            isAccepted = true;
        }

        public static function cancelDrag():void
        {
            if (!isDragging)
            {
                return;
            };
            completeDrag(false);
        }

        protected static function completeDrag(_arg1:Boolean):void
        {
            if (!isDragging)
            {
                throw (new IllegalOperationError("Drag cannot be completed because none is currently active."));
            };
            if (dropTarget)
            {
                dropTarget.onDragExit.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
                dropTarget = null;
            };
            var _local2:IDragSource = dragSource;
            var _local3:DragData = _dragData;
            cleanup();
            _local2.onDragComplete.dispatch(_local2, _local3, _arg1);
        }

        protected static function cleanup():void
        {
            if (avatar)
            {
                if (PopUpManager.isPopUp(avatar))
                {
                    PopUpManager.removePopUp(avatar);
                };
                avatar.touchable = avatarOldTouchable;
                avatar = null;
            };
            Starling.current.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
            Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
            dragSource = null;
            _dragData = null;
        }

        protected static function updateDropTarget(_arg1:Point):void
        {
            var _local2:DisplayObject = Starling.current.stage.hitTest(_arg1, true);
            while (((_local2) && (!((_local2 is IDropTarget)))))
            {
                _local2 = _local2.parent;
            };
            if (_local2)
            {
                _local2.globalToLocal(_arg1, _arg1);
            };
            if (_local2 != dropTarget)
            {
                if (((dropTarget) && (isAccepted)))
                {
                    dropTarget.onDragExit.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
                };
                dropTarget = IDropTarget(_local2);
                isAccepted = false;
                if (dropTarget)
                {
                    dropTargetLocalX = _arg1.x;
                    dropTargetLocalY = _arg1.y;
                    dropTarget.onDragEnter.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
                };
            }
            else
            {
                if (dropTarget)
                {
                    dropTargetLocalX = _arg1.x;
                    dropTargetLocalY = _arg1.y;
                    dropTarget.onDragMove.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
                };
            };
        }

        protected static function nativeStage_keyDownHandler(_arg1:KeyboardEvent):void
        {
            if ((((_arg1.keyCode == Keyboard.ESCAPE)) || ((_arg1.keyCode == Keyboard.BACK))))
            {
                _arg1.preventDefault();
                cancelDrag();
            };
        }

        protected static function stage_touchHandler(_arg1:TouchEvent):void
        {
            var _local2:Stage;
            var _local4:Touch;
            var _local5:Touch;
            var _local6:Boolean;
            _local2 = Starling.current.stage;
            var _local3:Vector.<Touch> = _arg1.getTouches(_local2);
            if ((((_local3.length == 0)) || ((_touchPointID < 0))))
            {
                return;
            };
            for each (_local5 in _local3)
            {
                if (_local5.id == _touchPointID)
                {
                    _local4 = _local5;
                    break;
                };
            };
            if (!_local4)
            {
                return;
            };
            if (_local4.phase == TouchPhase.MOVED)
            {
                _local4.getLocation(_local2, HELPER_POINT);
                if (avatar)
                {
                    avatar.x = (HELPER_POINT.x + avatarOffsetX);
                    avatar.y = (HELPER_POINT.y + avatarOffsetY);
                };
                updateDropTarget(HELPER_POINT);
            }
            else
            {
                if (_local4.phase == TouchPhase.ENDED)
                {
                    _touchPointID = -1;
                    _local6 = false;
                    if (((dropTarget) && (isAccepted)))
                    {
                        dropTarget.onDragDrop.dispatch(dropTarget, _dragData, dropTargetLocalX, dropTargetLocalY);
                        _local6 = true;
                    };
                    dropTarget = null;
                    completeDrag(_local6);
                    return;
                };
            };
        }


    }
}//package org.josht.starling.foxhole.dragDrop
