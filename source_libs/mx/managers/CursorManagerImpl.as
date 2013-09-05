//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import mx.events.Request;
    import mx.core.FlexGlobals;
    import mx.styles.StyleManager;
    import mx.core.IFlexModuleFactory;
    import mx.styles.CSSStyleDeclaration;
    import flash.geom.Point;
    import mx.core.FlexSprite;
    import flash.ui.Mouse;
    import flash.display.InteractiveObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import mx.core.EventPriority;
    import flash.events.ContextMenuEvent;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import mx.core.ISystemCursorClient;
    import flash.text.TextFieldType;
    import flash.text.TextField;

    use namespace mx_internal;

    public class CursorManagerImpl extends EventDispatcher implements ICursorManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var instance:ICursorManager;
        public static var mixins:Array;

        private var nextCursorID:int = 1;
        private var cursorList:Array;
        private var busyCursorList:Array;
        mx_internal var initialized:Boolean = false;
        mx_internal var cursorHolder:Sprite;
        private var currentCursor:DisplayObject;
        private var listenForContextMenu:Boolean = false;
        private var overTextField:Boolean = false;
        private var overLink:Boolean = false;
        private var showSystemCursor:Boolean = false;
        private var showCustomCursor:Boolean = false;
        private var customCursorLeftStage:Boolean = false;
        mx_internal var systemManager:ISystemManager = null;
        mx_internal var sandboxRoot:IEventDispatcher = null;
        private var sourceArray:Array;
        mx_internal var _currentCursorID:int = 0;
        mx_internal var _currentCursorXOffset:Number = 0;
        mx_internal var _currentCursorYOffset:Number = 0;

        public function CursorManagerImpl(_arg1:ISystemManager=null)
        {
            var _local2:int;
            var _local3:int;
            this.cursorList = [];
            this.busyCursorList = [];
            this.sourceArray = [];
            super();
            if (((instance) && (!(_arg1))))
            {
                throw (new Error("Instance already exists."));
            };
            if (_arg1)
            {
                this.systemManager = (_arg1 as ISystemManager);
            }
            else
            {
                this.systemManager = (SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager);
            };
            if (mixins)
            {
                _local2 = mixins.length;
                _local3 = 0;
                while (_local3 < _local2)
                {
                    new mixins[_local3](this);
                    _local3++;
                };
            };
        }

        public static function getInstance():ICursorManager
        {
            if (!instance)
            {
                instance = new (CursorManagerImpl)();
            };
            return (instance);
        }


        public function get currentCursorID():int
        {
            return (this._currentCursorID);
        }

        public function set currentCursorID(_arg1:int):void
        {
            this._currentCursorID = _arg1;
            if (hasEventListener("currentCursorID"))
            {
                dispatchEvent(new Event("currentCursorID"));
            };
        }

        public function get currentCursorXOffset():Number
        {
            return (this._currentCursorXOffset);
        }

        public function set currentCursorXOffset(_arg1:Number):void
        {
            this._currentCursorXOffset = _arg1;
            if (hasEventListener("currentCursorXOffset"))
            {
                dispatchEvent(new Event("currentCursorXOffset"));
            };
        }

        public function get currentCursorYOffset():Number
        {
            return (this._currentCursorYOffset);
        }

        public function set currentCursorYOffset(_arg1:Number):void
        {
            this._currentCursorYOffset = _arg1;
            if (hasEventListener("currentCursorYOffset"))
            {
                dispatchEvent(new Event("currentCursorYOffset"));
            };
        }

        public function showCursor():void
        {
            if (this.cursorHolder)
            {
                this.cursorHolder.visible = true;
            };
            if (hasEventListener("showCursor"))
            {
                dispatchEvent(new Event("showCursor"));
            };
        }

        public function hideCursor():void
        {
            if (this.cursorHolder)
            {
                this.cursorHolder.visible = false;
            };
            if (hasEventListener("hideCursor"))
            {
                dispatchEvent(new Event("hideCursor"));
            };
        }

        public function setCursor(_arg1:Class, _arg2:int=2, _arg3:Number=0, _arg4:Number=0):int
        {
            var _local7:Request;
            if (hasEventListener("setCursor"))
            {
                _local7 = new Request("setCursor", false, true);
                _local7.value = [_arg1, _arg2, _arg3, _arg4];
                if (!dispatchEvent(_local7))
                {
                    return ((_local7.value as int));
                };
            };
            var _local5:int = this.nextCursorID++;
            var _local6:CursorQueueItem = new CursorQueueItem();
            _local6.cursorID = _local5;
            _local6.cursorClass = _arg1;
            _local6.priority = _arg2;
            _local6.x = _arg3;
            _local6.y = _arg4;
            if (this.systemManager)
            {
                _local6.systemManager = this.systemManager;
            }
            else
            {
                _local6.systemManager = FlexGlobals.topLevelApplication.systemManager;
            };
            this.cursorList.push(_local6);
            this.cursorList.sort(this.priorityCompare);
            this.showCurrentCursor();
            return (_local5);
        }

        private function priorityCompare(_arg1:CursorQueueItem, _arg2:CursorQueueItem):int
        {
            if (_arg1.priority < _arg2.priority)
            {
                return (-1);
            };
            if (_arg1.priority == _arg2.priority)
            {
                return (0);
            };
            return (1);
        }

        public function removeCursor(_arg1:int):void
        {
            var _local2:Object;
            var _local3:CursorQueueItem;
            if (hasEventListener("removeCursor"))
            {
                if (!dispatchEvent(new Request("removeCursor", false, true, _arg1)))
                {
                    return;
                };
            };
            for (_local2 in this.cursorList)
            {
                _local3 = this.cursorList[_local2];
                if (_local3.cursorID == _arg1)
                {
                    this.cursorList.splice(_local2, 1);
                    this.showCurrentCursor();
                    break;
                };
            };
        }

        public function removeAllCursors():void
        {
            if (hasEventListener("removeAllCursors"))
            {
                if (!dispatchEvent(new Event("removeAllCursors", false, true)))
                {
                    return;
                };
            };
            this.cursorList.splice(0);
            this.showCurrentCursor();
        }

        public function setBusyCursor():void
        {
            if (hasEventListener("setBusyCursor"))
            {
                if (!dispatchEvent(new Event("setBusyCursor", false, true)))
                {
                    return;
                };
            };
            var _local1:CSSStyleDeclaration = StyleManager.getStyleManager((this.systemManager as IFlexModuleFactory)).getMergedStyleDeclaration("mx.managers.CursorManager");
            var _local2:Class = _local1.getStyle("busyCursor");
            this.busyCursorList.push(this.setCursor(_local2, CursorManagerPriority.LOW));
        }

        public function removeBusyCursor():void
        {
            if (hasEventListener("removeBusyCursor"))
            {
                if (!dispatchEvent(new Event("removeBusyCursor", false, true)))
                {
                    return;
                };
            };
            if (this.busyCursorList.length > 0)
            {
                this.removeCursor(int(this.busyCursorList.pop()));
            };
        }

        private function showCurrentCursor():void
        {
            var _local1:CursorQueueItem;
            var _local2:Event;
            var _local3:Point;
            var _local4:Event;
            var _local5:Event;
            var _local6:Event;
            var _local7:Event;
            if (this.cursorList.length > 0)
            {
                if (!this.initialized)
                {
                    this.initialized = true;
                    if (hasEventListener("initialize"))
                    {
                        _local2 = new Event("initialize", false, true);
                    };
                    if (((!(_local2)) || (dispatchEvent(_local2))))
                    {
                        this.cursorHolder = new FlexSprite();
                        this.cursorHolder.name = "cursorHolder";
                        this.cursorHolder.mouseEnabled = false;
                        this.cursorHolder.mouseChildren = false;
                        this.systemManager.cursorChildren.addChild(this.cursorHolder);
                    };
                };
                _local1 = this.cursorList[0];
                if (this.currentCursorID == CursorManager.NO_CURSOR)
                {
                    Mouse.hide();
                };
                if (_local1.cursorID != this.currentCursorID)
                {
                    if (this.cursorHolder.numChildren > 0)
                    {
                        this.cursorHolder.removeChildAt(0);
                    };
                    this.currentCursor = new _local1.cursorClass();
                    if (this.currentCursor)
                    {
                        if ((this.currentCursor is InteractiveObject))
                        {
                            InteractiveObject(this.currentCursor).mouseEnabled = false;
                        };
                        if ((this.currentCursor is DisplayObjectContainer))
                        {
                            DisplayObjectContainer(this.currentCursor).mouseChildren = false;
                        };
                        this.cursorHolder.addChild(this.currentCursor);
                        this.addContextMenuHandlers();
                        if ((this.systemManager is SystemManager))
                        {
                            _local3 = new Point((SystemManager(this.systemManager).mouseX + _local1.x), (SystemManager(this.systemManager).mouseY + _local1.y));
                            _local3 = SystemManager(this.systemManager).localToGlobal(_local3);
                            _local3 = this.cursorHolder.parent.globalToLocal(_local3);
                            this.cursorHolder.x = _local3.x;
                            this.cursorHolder.y = _local3.y;
                        }
                        else
                        {
                            if ((this.systemManager is DisplayObject))
                            {
                                _local3 = new Point((DisplayObject(this.systemManager).mouseX + _local1.x), (DisplayObject(this.systemManager).mouseY + _local1.y));
                                _local3 = DisplayObject(this.systemManager).localToGlobal(_local3);
                                _local3 = this.cursorHolder.parent.globalToLocal(_local3);
                                this.cursorHolder.x = (DisplayObject(this.systemManager).mouseX + _local1.x);
                                this.cursorHolder.y = (DisplayObject(this.systemManager).mouseY + _local1.y);
                            }
                            else
                            {
                                this.cursorHolder.x = _local1.x;
                                this.cursorHolder.y = _local1.y;
                            };
                        };
                        if (hasEventListener("addMouseMoveListener"))
                        {
                            _local4 = new Event("addMouseMoveListener", false, true);
                        };
                        if (((!(_local4)) || (dispatchEvent(_local4))))
                        {
                            this.systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, true, EventPriority.CURSOR_MANAGEMENT);
                        };
                        if (hasEventListener("addMouseOutListener"))
                        {
                            _local5 = new Event("addMouseOutListener", false, true);
                        };
                        if (((!(_local5)) || (dispatchEvent(_local5))))
                        {
                            this.systemManager.stage.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler, true, EventPriority.CURSOR_MANAGEMENT);
                        };
                    };
                    this.currentCursorID = _local1.cursorID;
                    this.currentCursorXOffset = _local1.x;
                    this.currentCursorYOffset = _local1.y;
                };
            }
            else
            {
                this.showCustomCursor = false;
                if (this.currentCursorID != CursorManager.NO_CURSOR)
                {
                    this.currentCursorID = CursorManager.NO_CURSOR;
                    this.currentCursorXOffset = 0;
                    this.currentCursorYOffset = 0;
                    if (hasEventListener("removeMouseMoveListener"))
                    {
                        _local6 = new Event("removeMouseMoveListener", false, true);
                    };
                    if (((!(_local6)) || (dispatchEvent(_local6))))
                    {
                        this.systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, true);
                    };
                    if (hasEventListener("removeMouseMoveListener"))
                    {
                        _local7 = new Event("removeMouseOutListener", false, true);
                    };
                    if (((!(_local7)) || (dispatchEvent(_local7))))
                    {
                        this.systemManager.stage.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler, true);
                    };
                    this.cursorHolder.removeChild(this.currentCursor);
                    this.removeContextMenuHandlers();
                };
                Mouse.show();
            };
        }

        private function addContextMenuHandlers():void
        {
            var _local1:InteractiveObject;
            var _local2:InteractiveObject;
            if (!this.listenForContextMenu)
            {
                _local1 = (this.systemManager.document as InteractiveObject);
                _local2 = (this.systemManager as InteractiveObject);
                if (((_local1) && (_local1.contextMenu)))
                {
                    _local1.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, this.contextMenu_menuSelectHandler, true, EventPriority.CURSOR_MANAGEMENT);
                    this.listenForContextMenu = true;
                };
                if (((_local2) && (_local2.contextMenu)))
                {
                    _local2.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, this.contextMenu_menuSelectHandler, true, EventPriority.CURSOR_MANAGEMENT);
                    this.listenForContextMenu = true;
                };
            };
        }

        private function removeContextMenuHandlers():void
        {
            var _local1:InteractiveObject;
            var _local2:InteractiveObject;
            if (this.listenForContextMenu)
            {
                _local1 = (this.systemManager.document as InteractiveObject);
                _local2 = (this.systemManager as InteractiveObject);
                if (((_local1) && (_local1.contextMenu)))
                {
                    _local1.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, this.contextMenu_menuSelectHandler, true);
                };
                if (((_local2) && (_local2.contextMenu)))
                {
                    _local2.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, this.contextMenu_menuSelectHandler, true);
                };
                this.listenForContextMenu = false;
            };
        }

        public function registerToUseBusyCursor(_arg1:Object):void
        {
            if (hasEventListener("registerToUseBusyCursor"))
            {
                if (!dispatchEvent(new Request("registerToUseBusyCursor", false, true, _arg1)))
                {
                    return;
                };
            };
            if (((_arg1) && ((_arg1 is EventDispatcher))))
            {
                _arg1.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
                _arg1.addEventListener(Event.COMPLETE, this.completeHandler);
                _arg1.addEventListener(IOErrorEvent.IO_ERROR, this.completeHandler);
            };
        }

        public function unRegisterToUseBusyCursor(_arg1:Object):void
        {
            if (hasEventListener("unRegisterToUseBusyCursor"))
            {
                if (!dispatchEvent(new Request("unRegisterToUseBusyCursor", false, true, _arg1)))
                {
                    return;
                };
            };
            if (((_arg1) && ((_arg1 is EventDispatcher))))
            {
                _arg1.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
                _arg1.removeEventListener(Event.COMPLETE, this.completeHandler);
                _arg1.removeEventListener(IOErrorEvent.IO_ERROR, this.completeHandler);
            };
        }

        private function contextMenu_menuSelectHandler(_arg1:ContextMenuEvent):void
        {
            this.showCustomCursor = true;
            this.sandboxRoot.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
        }

        private function mouseOverHandler(_arg1:MouseEvent):void
        {
            this.sandboxRoot.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.mouseMoveHandler(_arg1);
        }

        private function findSource(_arg1:Object):int
        {
            var _local2:int = this.sourceArray.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                if (this.sourceArray[_local3] === _arg1)
                {
                    return (_local3);
                };
                _local3++;
            };
            return (-1);
        }

        mx_internal function mouseOutHandler(_arg1:MouseEvent):void
        {
            if ((((_arg1.relatedObject == null)) && ((this.cursorList.length > 0))))
            {
                this.customCursorLeftStage = true;
                this.hideCursor();
                Mouse.show();
            };
        }

        mx_internal function mouseMoveHandler(_arg1:MouseEvent):void
        {
            var _local2:Point = new Point(_arg1.stageX, _arg1.stageY);
            _local2 = this.cursorHolder.parent.globalToLocal(_local2);
            _local2.x = (_local2.x + this.currentCursorXOffset);
            _local2.y = (_local2.y + this.currentCursorYOffset);
            this.cursorHolder.x = _local2.x;
            this.cursorHolder.y = _local2.y;
            var _local3:Object = _arg1.target;
            var _local4:Boolean = (((((_local3 is TextField)) && ((_local3.type == TextFieldType.INPUT)))) || ((((_local3 is ISystemCursorClient)) && (ISystemCursorClient(_local3).showSystemCursor))));
            if (((!(this.overTextField)) && (_local4)))
            {
                this.overTextField = true;
                this.showSystemCursor = true;
            }
            else
            {
                if (((this.overTextField) && (!(_local4))))
                {
                    this.overTextField = false;
                    this.showCustomCursor = true;
                }
                else
                {
                    this.showCustomCursor = true;
                };
            };
            if (this.showSystemCursor)
            {
                this.showSystemCursor = false;
                this.cursorHolder.visible = false;
                Mouse.show();
            };
            if (this.showCustomCursor)
            {
                this.showCustomCursor = false;
                this.cursorHolder.visible = true;
                Mouse.hide();
                if (hasEventListener("showCustomCursor"))
                {
                    dispatchEvent(new Event("showCustomCursor"));
                };
            };
        }

        private function progressHandler(_arg1:ProgressEvent):void
        {
            var _local2:int = this.findSource(_arg1.target);
            if (_local2 == -1)
            {
                this.sourceArray.push(_arg1.target);
                this.setBusyCursor();
            };
        }

        private function completeHandler(_arg1:Event):void
        {
            var _local2:int = this.findSource(_arg1.target);
            if (_local2 != -1)
            {
                this.sourceArray.splice(_local2, 1);
                this.removeBusyCursor();
            };
        }


    }
}//package mx.managers

import mx.core.mx_internal;
import mx.managers.ISystemManager;

use namespace mx_internal;

class CursorQueueItem 
{

    mx_internal static const VERSION:String = "4.6.0.23201";

    public var cursorID:int = 0;
    public var cursorClass:Class = null;
    public var priority:int = 2;
    public var systemManager:ISystemManager;
    public var x:Number;
    public var y:Number;


}
