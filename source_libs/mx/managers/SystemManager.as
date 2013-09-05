//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import flash.display.MovieClip;
    import mx.core.mx_internal;
    import flash.utils.Dictionary;
    import flash.display.Stage;
    import mx.preloaders.Preloader;
    import flash.display.Sprite;
    import mx.core.IUIComponent;
    import flash.utils.Timer;
    import flash.geom.Rectangle;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
    import flash.display.DisplayObject;
    import mx.core.IChildList;
    import flash.events.TimerEvent;
    import mx.utils.DensityUtil;
    import mx.events.RSLEvent;
    import flash.display.LoaderInfo;
    import __AS3__.vec.Vector;
    import mx.core.RSLData;
    import mx.events.DynamicEvent;
    import flash.events.MouseEvent;
    import mx.events.SandboxMouseEvent;
    import mx.events.FlexEvent;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import mx.core.IRawChildrenContainer;
    import mx.core.RSLItem;
    import mx.core.Singleton;
    import mx.utils.LoaderUtil;
    import flash.display.Loader;
    import flash.text.Font;
    import flash.text.TextFormat;
    import flash.display.Graphics;
    import mx.core.FlexSprite;
    import mx.core.IFlexModuleFactory;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.events.EventPhase;
    import mx.core.IInvalidating;
    import mx.events.Request;
    import __AS3__.vec.*;
    import mx.core.*;

    use namespace mx_internal;

    public class SystemManager extends MovieClip implements IChildList, IFlexDisplayObject, IFlexModuleFactory, ISystemManager 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static const IDLE_THRESHOLD:Number = 1000;
        private static const IDLE_INTERVAL:Number = 100;

        mx_internal static var allSystemManagers:Dictionary = new Dictionary(true);

        mx_internal var topLevel:Boolean = true;
        private var isDispatchingResizeEvent:Boolean;
        mx_internal var isStageRoot:Boolean = true;
        mx_internal var isBootstrapRoot:Boolean = false;
        private var _topLevelSystemManager:ISystemManager;
        mx_internal var childManager:ISystemManagerChildManager;
        private var _stage:Stage;
        mx_internal var nestLevel:int = 0;
        mx_internal var preloader:Preloader;
        private var mouseCatcher:Sprite;
        mx_internal var topLevelWindow:IUIComponent;
        mx_internal var idleCounter:int = 0;
        private var idleTimer:Timer;
        private var nextFrameTimer:Timer = null;
        private var lastFrame:int;
        private var readyForKickOff:Boolean;
        public var _resourceBundles:Array;
        private var rslDataList:Array;
        private var _height:Number;
        private var _width:Number;
        private var _allowDomainsInNewRSLs:Boolean = true;
        private var _allowInsecureDomainsInNewRSLs:Boolean = true;
        private var _applicationIndex:int = 1;
        private var _cursorChildren:SystemChildrenList;
        private var _cursorIndex:int = 0;
        private var _densityScale:Number = NaN;
        private var _document:Object;
        private var _fontList:Object = null;
        private var _explicitHeight:Number;
        private var _explicitWidth:Number;
        private var _focusPane:Sprite;
        private var _noTopMostIndex:int = 0;
        private var _numModalWindows:int = 0;
        private var _popUpChildren:SystemChildrenList;
        private var _rawChildren:SystemRawChildrenList;
        mx_internal var _screen:Rectangle;
        private var _toolTipChildren:SystemChildrenList;
        private var _toolTipIndex:int = 0;
        private var _topMostIndex:int = 0;
        mx_internal var _mouseX;
        mx_internal var _mouseY;
        private var implMap:Object;

        public function SystemManager()
        {
            this.implMap = {};
            super();
            if (this.stage)
            {
                this.stage.scaleMode = StageScaleMode.NO_SCALE;
                this.stage.align = StageAlign.TOP_LEFT;
                this.stage.quality = StageQuality.HIGH;
            };
            if ((((SystemManagerGlobals.topLevelSystemManagers.length > 0)) && (!(this.stage))))
            {
                this.topLevel = false;
            };
            if (!this.stage)
            {
                this.isStageRoot = false;
            };
            if (this.topLevel)
            {
                SystemManagerGlobals.topLevelSystemManagers.push(this);
            };
            stop();
            if (((root) && (root.loaderInfo)))
            {
                root.loaderInfo.addEventListener(Event.INIT, this.initHandler);
            };
        }

        public static function getSWFRoot(_arg1:Object):DisplayObject
        {
            var _local3:*;
            var _local4:ISystemManager;
            var _local5:ApplicationDomain;
            var _local6:Class;
            var _local2:String = getQualifiedClassName(_arg1);
            for (_local3 in allSystemManagers)
            {
                _local4 = (_local3 as ISystemManager);
                _local5 = _local4.loaderInfo.applicationDomain;
                try
                {
                    _local6 = Class(_local5.getDefinition(_local2));
                    if ((_arg1 is _local6))
                    {
                        return ((_local4 as DisplayObject));
                    };
                }
                catch(e:Error)
                {
                };
            };
            return (null);
        }

        private static function getChildListIndex(_arg1:IChildList, _arg2:Object):int
        {
            var _local3:int = -1;
            try
            {
                _local3 = _arg1.getChildIndex(DisplayObject(_arg2));
            }
            catch(e:ArgumentError)
            {
            };
            return (_local3);
        }


        private function deferredNextFrame():void
        {
            if ((currentFrame + 1) > totalFrames)
            {
                return;
            };
            if ((currentFrame + 1) <= framesLoaded)
            {
                nextFrame();
            }
            else
            {
                this.nextFrameTimer = new Timer(100);
                this.nextFrameTimer.addEventListener(TimerEvent.TIMER, this.nextFrameTimerHandler);
                this.nextFrameTimer.start();
            };
        }

        override public function get height():Number
        {
            return (this._height);
        }

        override public function get stage():Stage
        {
            var _local2:DisplayObject;
            if (this._stage)
            {
                return (this._stage);
            };
            var _local1:Stage = super.stage;
            if (_local1)
            {
                this._stage = _local1;
                return (_local1);
            };
            if (((!(this.topLevel)) && (this._topLevelSystemManager)))
            {
                this._stage = this._topLevelSystemManager.stage;
                return (this._stage);
            };
            if (((!(this.isStageRoot)) && (this.topLevel)))
            {
                _local2 = this.getTopLevelRoot();
                if (_local2)
                {
                    this._stage = _local2.stage;
                    return (this._stage);
                };
            };
            return (null);
        }

        override public function get width():Number
        {
            return (this._width);
        }

        override public function get numChildren():int
        {
            return ((this.noTopMostIndex - this.applicationIndex));
        }

        public function get allowDomainsInNewRSLs():Boolean
        {
            return (this._allowDomainsInNewRSLs);
        }

        public function set allowDomainsInNewRSLs(_arg1:Boolean):void
        {
            this._allowDomainsInNewRSLs = _arg1;
        }

        public function get allowInsecureDomainsInNewRSLs():Boolean
        {
            return (this._allowInsecureDomainsInNewRSLs);
        }

        public function set allowInsecureDomainsInNewRSLs(_arg1:Boolean):void
        {
            this._allowInsecureDomainsInNewRSLs = _arg1;
        }

        public function get application():IUIComponent
        {
            return (IUIComponent(this._document));
        }

        mx_internal function get applicationIndex():int
        {
            return (this._applicationIndex);
        }

        mx_internal function set applicationIndex(_arg1:int):void
        {
            this._applicationIndex = _arg1;
        }

        public function get cursorChildren():IChildList
        {
            if (!this.topLevel)
            {
                return (this._topLevelSystemManager.cursorChildren);
            };
            if (!this._cursorChildren)
            {
                this._cursorChildren = new SystemChildrenList(this, new QName(mx_internal, "toolTipIndex"), new QName(mx_internal, "cursorIndex"));
            };
            return (this._cursorChildren);
        }

        mx_internal function get cursorIndex():int
        {
            return (this._cursorIndex);
        }

        mx_internal function set cursorIndex(_arg1:int):void
        {
            var _local2:int = (_arg1 - this._cursorIndex);
            this._cursorIndex = _arg1;
        }

        mx_internal function get densityScale():Number
        {
            var _local1:Number;
            var _local2:Number;
            if (isNaN(this._densityScale))
            {
                _local1 = this.info()["applicationDPI"];
                _local2 = DensityUtil.getRuntimeDPI();
                this._densityScale = DensityUtil.getDPIScale(_local1, _local2);
                if (isNaN(this._densityScale))
                {
                    this._densityScale = 1;
                };
            };
            return (this._densityScale);
        }

        public function get document():Object
        {
            return (this._document);
        }

        public function set document(_arg1:Object):void
        {
            this._document = _arg1;
        }

        public function get embeddedFontList():Object
        {
            var _local1:Object;
            var _local2:String;
            var _local3:Object;
            if (this._fontList == null)
            {
                this._fontList = {};
                _local1 = this.info()["fonts"];
                for (_local2 in _local1)
                {
                    this._fontList[_local2] = _local1[_local2];
                };
                if (((!(this.topLevel)) && (this._topLevelSystemManager)))
                {
                    _local3 = this._topLevelSystemManager.embeddedFontList;
                    for (_local2 in _local3)
                    {
                        this._fontList[_local2] = _local3[_local2];
                    };
                };
            };
            return (this._fontList);
        }

        public function get explicitHeight():Number
        {
            return (this._explicitHeight);
        }

        public function set explicitHeight(_arg1:Number):void
        {
            this._explicitHeight = _arg1;
        }

        public function get explicitWidth():Number
        {
            return (this._explicitWidth);
        }

        public function set explicitWidth(_arg1:Number):void
        {
            this._explicitWidth = _arg1;
        }

        public function get focusPane():Sprite
        {
            return (this._focusPane);
        }

        public function set focusPane(_arg1:Sprite):void
        {
            if (_arg1)
            {
                this.addChild(_arg1);
                _arg1.x = 0;
                _arg1.y = 0;
                _arg1.scrollRect = null;
                this._focusPane = _arg1;
            }
            else
            {
                this.removeChild(this._focusPane);
                this._focusPane = null;
            };
        }

        public function get isProxy():Boolean
        {
            return (false);
        }

        public function get measuredHeight():Number
        {
            return (((this.topLevelWindow) ? this.topLevelWindow.getExplicitOrMeasuredHeight() : loaderInfo.height));
        }

        public function get measuredWidth():Number
        {
            return (((this.topLevelWindow) ? this.topLevelWindow.getExplicitOrMeasuredWidth() : loaderInfo.width));
        }

        mx_internal function get noTopMostIndex():int
        {
            return (this._noTopMostIndex);
        }

        mx_internal function set noTopMostIndex(_arg1:int):void
        {
            var _local2:int = (_arg1 - this._noTopMostIndex);
            this._noTopMostIndex = _arg1;
            this.topMostIndex = (this.topMostIndex + _local2);
        }

        final mx_internal function get $numChildren():int
        {
            return (super.numChildren);
        }

        public function get numModalWindows():int
        {
            return (this._numModalWindows);
        }

        public function set numModalWindows(_arg1:int):void
        {
            this._numModalWindows = _arg1;
        }

        public function get preloadedRSLs():Dictionary
        {
            return (null);
        }

        public function addPreloadedRSL(_arg1:LoaderInfo, _arg2:Vector.<RSLData>):void
        {
            var _local3:RSLEvent;
            this.preloadedRSLs[_arg1] = _arg2;
            if (hasEventListener(RSLEvent.RSL_ADD_PRELOADED))
            {
                _local3 = new RSLEvent(RSLEvent.RSL_ADD_PRELOADED);
                _local3.loaderInfo = _arg1;
                dispatchEvent(_local3);
            };
        }

        public function get preloaderBackgroundAlpha():Number
        {
            return (this.info()["backgroundAlpha"]);
        }

        public function get preloaderBackgroundColor():uint
        {
            var _local1:* = this.info()["backgroundColor"];
            if (_local1 == undefined)
            {
                return (0xFFFFFFFF);
            };
            return (_local1);
        }

        public function get preloaderBackgroundImage():Object
        {
            return (this.info()["backgroundImage"]);
        }

        public function get preloaderBackgroundSize():String
        {
            return (this.info()["backgroundSize"]);
        }

        public function get popUpChildren():IChildList
        {
            if (!this.topLevel)
            {
                return (this._topLevelSystemManager.popUpChildren);
            };
            if (!this._popUpChildren)
            {
                this._popUpChildren = new SystemChildrenList(this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));
            };
            return (this._popUpChildren);
        }

        public function get rawChildren():IChildList
        {
            if (!this._rawChildren)
            {
                this._rawChildren = new SystemRawChildrenList(this);
            };
            return (this._rawChildren);
        }

        public function get screen():Rectangle
        {
            if (!this._screen)
            {
                this.Stage_resizeHandler();
            };
            if (!this.isStageRoot)
            {
                this.Stage_resizeHandler();
            };
            return (this._screen);
        }

        public function get toolTipChildren():IChildList
        {
            if (!this.topLevel)
            {
                return (this._topLevelSystemManager.toolTipChildren);
            };
            if (!this._toolTipChildren)
            {
                this._toolTipChildren = new SystemChildrenList(this, new QName(mx_internal, "topMostIndex"), new QName(mx_internal, "toolTipIndex"));
            };
            return (this._toolTipChildren);
        }

        mx_internal function get toolTipIndex():int
        {
            return (this._toolTipIndex);
        }

        mx_internal function set toolTipIndex(_arg1:int):void
        {
            var _local2:int = (_arg1 - this._toolTipIndex);
            this._toolTipIndex = _arg1;
            this.cursorIndex = (this.cursorIndex + _local2);
        }

        public function get topLevelSystemManager():ISystemManager
        {
            if (this.topLevel)
            {
                return (this);
            };
            return (this._topLevelSystemManager);
        }

        mx_internal function get topMostIndex():int
        {
            return (this._topMostIndex);
        }

        mx_internal function set topMostIndex(_arg1:int):void
        {
            var _local2:int = (_arg1 - this._topMostIndex);
            this._topMostIndex = _arg1;
            this.toolTipIndex = (this.toolTipIndex + _local2);
        }

        final mx_internal function $addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            super.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }

        public function get childAllowsParent():Boolean
        {
            try
            {
                return (loaderInfo.childAllowsParent);
            }
            catch(error:Error)
            {
            };
            return (false);
        }

        public function get parentAllowsChild():Boolean
        {
            try
            {
                return (loaderInfo.parentAllowsChild);
            }
            catch(error:Error)
            {
            };
            return (false);
        }

        override public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            var request:DynamicEvent;
            var type:String = _arg1;
            var listener:Function = _arg2;
            var useCapture:Boolean = _arg3;
            var priority:int = _arg4;
            var useWeakReference:Boolean = _arg5;
            if ((((((((((type == MouseEvent.MOUSE_MOVE)) || ((type == MouseEvent.MOUSE_UP)))) || ((type == MouseEvent.MOUSE_DOWN)))) || ((type == Event.ACTIVATE)))) || ((type == Event.DEACTIVATE))))
            {
                try
                {
                    if (this.stage)
                    {
                        this.stage.addEventListener(type, this.stageEventHandler, false, 0, true);
                    };
                }
                catch(error:SecurityError)
                {
                };
            };
            if (hasEventListener("addEventListener"))
            {
                request = new DynamicEvent("addEventListener", false, true);
                request.eventType = type;
                request.listener = listener;
                request.useCapture = useCapture;
                request.priority = priority;
                request.useWeakReference = useWeakReference;
                if (!dispatchEvent(request))
                {
                    return;
                };
            };
            if (type == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
            {
                try
                {
                    if (this.stage)
                    {
                        this.stage.addEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler, false, 0, true);
                    }
                    else
                    {
                        super.addEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler, false, 0, true);
                    };
                }
                catch(error:SecurityError)
                {
                    super.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
                };
            };
            if ((((type == FlexEvent.RENDER)) || ((type == FlexEvent.ENTER_FRAME))))
            {
                if (type == FlexEvent.RENDER)
                {
                    type = Event.RENDER;
                }
                else
                {
                    type = Event.ENTER_FRAME;
                };
                try
                {
                    if (this.stage)
                    {
                        this.stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
                    }
                    else
                    {
                        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
                    };
                }
                catch(error:SecurityError)
                {
                    super.addEventListener(type, listener, useCapture, priority, useWeakReference);
                };
                if (((this.stage) && ((type == Event.RENDER))))
                {
                    this.stage.invalidate();
                };
                return;
            };
            if ((((type == FlexEvent.IDLE)) && (!(this.idleTimer))))
            {
                this.idleTimer = new Timer(IDLE_INTERVAL);
                this.idleTimer.addEventListener(TimerEvent.TIMER, this.idleTimer_timerHandler);
                this.idleTimer.start();
                this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, true);
                this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler, true);
            };
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        final mx_internal function $removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            super.removeEventListener(_arg1, _arg2, _arg3);
        }

        override public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            var _local4:DynamicEvent;
            if (hasEventListener("removeEventListener"))
            {
                _local4 = new DynamicEvent("removeEventListener", false, true);
                _local4.eventType = _arg1;
                _local4.listener = _arg2;
                _local4.useCapture = _arg3;
                if (!dispatchEvent(_local4))
                {
                    return;
                };
            };
            if ((((_arg1 == FlexEvent.RENDER)) || ((_arg1 == FlexEvent.ENTER_FRAME))))
            {
                if (_arg1 == FlexEvent.RENDER)
                {
                    _arg1 = Event.RENDER;
                }
                else
                {
                    _arg1 = Event.ENTER_FRAME;
                };
                try
                {
                    if (this.stage)
                    {
                        this.stage.removeEventListener(_arg1, _arg2, _arg3);
                    };
                }
                catch(error:SecurityError)
                {
                };
                super.removeEventListener(_arg1, _arg2, _arg3);
                return;
            };
            if (_arg1 == FlexEvent.IDLE)
            {
                super.removeEventListener(_arg1, _arg2, _arg3);
                if (((!(hasEventListener(FlexEvent.IDLE))) && (this.idleTimer)))
                {
                    this.idleTimer.stop();
                    this.idleTimer = null;
                    this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
                    this.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
                };
            }
            else
            {
                super.removeEventListener(_arg1, _arg2, _arg3);
            };
            if ((((((((((_arg1 == MouseEvent.MOUSE_MOVE)) || ((_arg1 == MouseEvent.MOUSE_UP)))) || ((_arg1 == MouseEvent.MOUSE_DOWN)))) || ((_arg1 == Event.ACTIVATE)))) || ((_arg1 == Event.DEACTIVATE))))
            {
                if (!hasEventListener(_arg1))
                {
                    try
                    {
                        if (this.stage)
                        {
                            this.stage.removeEventListener(_arg1, this.stageEventHandler, false);
                        };
                    }
                    catch(error:SecurityError)
                    {
                    };
                };
            };
            if (_arg1 == SandboxMouseEvent.MOUSE_UP_SOMEWHERE)
            {
                if (!hasEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE))
                {
                    try
                    {
                        if (this.stage)
                        {
                            this.stage.removeEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler);
                        };
                    }
                    catch(error:SecurityError)
                    {
                    };
                    super.removeEventListener(Event.MOUSE_LEAVE, this.mouseLeaveHandler);
                };
            };
        }

        override public function addChild(_arg1:DisplayObject):DisplayObject
        {
            var _local2:int = this.numChildren;
            if (_arg1.parent == this)
            {
                _local2--;
            };
            return (this.addChildAt(_arg1, _local2));
        }

        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            this.noTopMostIndex++;
            var _local3:DisplayObjectContainer = _arg1.parent;
            if (_local3)
            {
                _local3.removeChild(_arg1);
            };
            return (this.rawChildren_addChildAt(_arg1, (this.applicationIndex + _arg2)));
        }

        final mx_internal function $addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            return (super.addChildAt(_arg1, _arg2));
        }

        final mx_internal function $removeChildAt(_arg1:int):DisplayObject
        {
            return (super.removeChildAt(_arg1));
        }

        override public function removeChild(_arg1:DisplayObject):DisplayObject
        {
            this.noTopMostIndex--;
            return (this.rawChildren_removeChild(_arg1));
        }

        override public function removeChildAt(_arg1:int):DisplayObject
        {
            this.noTopMostIndex--;
            return (this.rawChildren_removeChildAt((this.applicationIndex + _arg1)));
        }

        override public function getChildAt(_arg1:int):DisplayObject
        {
            return (super.getChildAt((this.applicationIndex + _arg1)));
        }

        override public function getChildByName(_arg1:String):DisplayObject
        {
            return (super.getChildByName(_arg1));
        }

        override public function getChildIndex(_arg1:DisplayObject):int
        {
            return ((super.getChildIndex(_arg1) - this.applicationIndex));
        }

        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void
        {
            super.setChildIndex(_arg1, (this.applicationIndex + _arg2));
        }

        override public function getObjectsUnderPoint(_arg1:Point):Array
        {
            var _local5:DisplayObject;
            var _local6:Array;
            var _local2:Array = [];
            var _local3:int = this.topMostIndex;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = super.getChildAt(_local4);
                if ((_local5 is DisplayObjectContainer))
                {
                    _local6 = DisplayObjectContainer(_local5).getObjectsUnderPoint(_arg1);
                    if (_local6)
                    {
                        _local2 = _local2.concat(_local6);
                    };
                };
                _local4++;
            };
            return (_local2);
        }

        override public function contains(_arg1:DisplayObject):Boolean
        {
            var _local2:int;
            var _local3:int;
            var _local4:DisplayObject;
            if (super.contains(_arg1))
            {
                if (_arg1.parent == this)
                {
                    _local2 = super.getChildIndex(_arg1);
                    if (_local2 < this.noTopMostIndex)
                    {
                        return (true);
                    };
                }
                else
                {
                    _local3 = 0;
                    while (_local3 < this.noTopMostIndex)
                    {
                        _local4 = super.getChildAt(_local3);
                        if ((_local4 is IRawChildrenContainer))
                        {
                            if (IRawChildrenContainer(_local4).rawChildren.contains(_arg1))
                            {
                                return (true);
                            };
                        };
                        if ((_local4 is DisplayObjectContainer))
                        {
                            if (DisplayObjectContainer(_local4).contains(_arg1))
                            {
                                return (true);
                            };
                        };
                        _local3++;
                    };
                };
            };
            return (false);
        }

        public function callInContext(_arg1:Function, _arg2:Object, _arg3:Array, _arg4:Boolean=true)
        {
            return (undefined);
        }

        public function create(... _args):Object
        {
            var _local4:String;
            var _local5:int;
            var _local6:int;
            var _local2:String = this.info()["mainClassName"];
            if (_local2 == null)
            {
                _local4 = loaderInfo.loaderURL;
                _local5 = _local4.lastIndexOf(".");
                _local6 = _local4.lastIndexOf("/");
                _local2 = _local4.substring((_local6 + 1), _local5);
            };
            var _local3:Class = Class(this.getDefinitionByName(_local2));
            return (((_local3) ? new (_local3)() : null));
        }

        public function info():Object
        {
            return ({});
        }

        mx_internal function initialize():void
        {
            var _local7:int;
            var _local8:int;
            var _local12:String;
            var _local13:Class;
            var _local14:Array;
            var _local15:Object;
            var _local16:RSLItem;
            var _local1:Class = (this.info()["runtimeDPIProvider"] as Class);
            if (_local1)
            {
                Singleton.registerClass("mx.core::RuntimeDPIProvider", _local1);
            };
            if (this.isStageRoot)
            {
                this.Stage_resizeHandler();
            }
            else
            {
                this._width = loaderInfo.width;
                this._height = loaderInfo.height;
            };
            this.preloader = new Preloader();
            this.preloader.addEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY, this.preloader_preloaderDocFrameReadyHandler);
            this.preloader.addEventListener(Event.COMPLETE, this.preloader_completeHandler);
            this.preloader.addEventListener(FlexEvent.PRELOADER_DONE, this.preloader_preloaderDoneHandler);
            this.preloader.addEventListener(RSLEvent.RSL_COMPLETE, this.preloader_rslCompleteHandler);
            if (!this._popUpChildren)
            {
                this._popUpChildren = new SystemChildrenList(this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));
            };
            this._popUpChildren.addChild(this.preloader);
            var _local2:Array = this.info()["rsls"];
            var _local3:Array = this.info()["cdRsls"];
            var _local4:Boolean = true;
            if (this.info()["usePreloader"] != undefined)
            {
                _local4 = this.info()["usePreloader"];
            };
            var _local5:Class = (this.info()["preloader"] as Class);
            var _local6:Array = [];
            if (((_local3) && ((_local3.length > 0))))
            {
                if (this.isTopLevel())
                {
                    this.rslDataList = _local3;
                }
                else
                {
                    this.rslDataList = LoaderUtil.processRequiredRSLs(this, _local3);
                };
                _local12 = LoaderUtil.normalizeURL(this.loaderInfo);
                _local13 = Class(this.getDefinitionByName("mx.core::CrossDomainRSLItem"));
                _local7 = this.rslDataList.length;
                _local8 = 0;
                while (_local8 < _local7)
                {
                    _local14 = this.rslDataList[_local8];
                    _local15 = new _local13(_local14, _local12, this);
                    _local6.push(_local15);
                    _local8++;
                };
            };
            if (((!((_local2 == null))) && ((_local2.length > 0))))
            {
                if (this.rslDataList == null)
                {
                    this.rslDataList = [];
                };
                if (_local12 == null)
                {
                    _local12 = LoaderUtil.normalizeURL(this.loaderInfo);
                };
                _local7 = _local2.length;
                _local8 = 0;
                while (_local8 < _local7)
                {
                    _local16 = new RSLItem(_local2[_local8].url, _local12, this);
                    _local6.push(_local16);
                    this.rslDataList.push([new RSLData(_local2[_local8].url, null, null, null, false, false, "current")]);
                    _local8++;
                };
            };
            var _local9:String = loaderInfo.parameters["resourceModuleURLs"];
            var _local10:Array = ((_local9) ? _local9.split(",") : null);
            var _local11:ApplicationDomain = ((((!(this.topLevel)) && ((this.parent is Loader)))) ? Loader(this.parent).contentLoaderInfo.applicationDomain : (this.info()["currentDomain"] as ApplicationDomain));
            this.preloader.initialize(_local4, _local5, this.preloaderBackgroundColor, this.preloaderBackgroundAlpha, this.preloaderBackgroundImage, this.preloaderBackgroundSize, ((this.isStageRoot) ? this.stage.stageWidth : loaderInfo.width), ((this.isStageRoot) ? this.stage.stageHeight : loaderInfo.height), null, null, _local6, _local10, _local11);
        }

        mx_internal function rawChildren_addChild(_arg1:DisplayObject):DisplayObject
        {
            this.childManager.addingChild(_arg1);
            super.addChild(_arg1);
            this.childManager.childAdded(_arg1);
            return (_arg1);
        }

        mx_internal function rawChildren_addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            if (this.childManager)
            {
                this.childManager.addingChild(_arg1);
            };
            super.addChildAt(_arg1, _arg2);
            if (this.childManager)
            {
                this.childManager.childAdded(_arg1);
            };
            return (_arg1);
        }

        mx_internal function rawChildren_removeChild(_arg1:DisplayObject):DisplayObject
        {
            this.childManager.removingChild(_arg1);
            super.removeChild(_arg1);
            this.childManager.childRemoved(_arg1);
            return (_arg1);
        }

        mx_internal function rawChildren_removeChildAt(_arg1:int):DisplayObject
        {
            var _local2:DisplayObject = super.getChildAt(_arg1);
            this.childManager.removingChild(_local2);
            super.removeChildAt(_arg1);
            this.childManager.childRemoved(_local2);
            return (_local2);
        }

        mx_internal function rawChildren_getChildAt(_arg1:int):DisplayObject
        {
            return (super.getChildAt(_arg1));
        }

        mx_internal function rawChildren_getChildByName(_arg1:String):DisplayObject
        {
            return (super.getChildByName(_arg1));
        }

        mx_internal function rawChildren_getChildIndex(_arg1:DisplayObject):int
        {
            return (super.getChildIndex(_arg1));
        }

        mx_internal function rawChildren_setChildIndex(_arg1:DisplayObject, _arg2:int):void
        {
            super.setChildIndex(_arg1, _arg2);
        }

        mx_internal function rawChildren_getObjectsUnderPoint(_arg1:Point):Array
        {
            return (super.getObjectsUnderPoint(_arg1));
        }

        mx_internal function rawChildren_contains(_arg1:DisplayObject):Boolean
        {
            return (super.contains(_arg1));
        }

        public function allowDomain(... _args):void
        {
        }

        public function allowInsecureDomain(... _args):void
        {
        }

        public function getExplicitOrMeasuredWidth():Number
        {
            return (((isNaN(this.explicitWidth)) ? this.measuredWidth : this.explicitWidth));
        }

        public function getExplicitOrMeasuredHeight():Number
        {
            return (((isNaN(this.explicitHeight)) ? this.measuredHeight : this.explicitHeight));
        }

        public function move(_arg1:Number, _arg2:Number):void
        {
        }

        public function setActualSize(_arg1:Number, _arg2:Number):void
        {
            if (this.isStageRoot)
            {
                return;
            };
            if (this.mouseCatcher)
            {
                this.mouseCatcher.width = _arg1;
                this.mouseCatcher.height = _arg2;
            };
            if (((!((this._width == _arg1))) || (!((this._height == _arg2)))))
            {
                this._width = _arg1;
                this._height = _arg2;
                dispatchEvent(new Event(Event.RESIZE));
            };
        }

        public function getDefinitionByName(_arg1:String):Object
        {
            var _local3:Object;
            var _local2:ApplicationDomain = ((((!(this.topLevel)) && ((this.parent is Loader)))) ? Loader(this.parent).contentLoaderInfo.applicationDomain : (this.info()["currentDomain"] as ApplicationDomain));
            if (_local2.hasDefinition(_arg1))
            {
                _local3 = _local2.getDefinition(_arg1);
            };
            return (_local3);
        }

        public function isTopLevel():Boolean
        {
            return (this.topLevel);
        }

        public function isTopLevelRoot():Boolean
        {
            return (((this.isStageRoot) || (this.isBootstrapRoot)));
        }

        public function isTopLevelWindow(_arg1:DisplayObject):Boolean
        {
            return ((((_arg1 is IUIComponent)) && ((IUIComponent(_arg1) == this.topLevelWindow))));
        }

        public function isFontFaceEmbedded(_arg1:TextFormat):Boolean
        {
            var _local9:Font;
            var _local10:String;
            var _local2:String = _arg1.font;
            var _local3:Boolean = _arg1.bold;
            var _local4:Boolean = _arg1.italic;
            var _local5:Array = Font.enumerateFonts();
            var _local6:int = _local5.length;
            var _local7:int;
            while (_local7 < _local6)
            {
                _local9 = Font(_local5[_local7]);
                if (_local9.fontName == _local2)
                {
                    _local10 = "regular";
                    if (((_local3) && (_local4)))
                    {
                        _local10 = "boldItalic";
                    }
                    else
                    {
                        if (_local3)
                        {
                            _local10 = "bold";
                        }
                        else
                        {
                            if (_local4)
                            {
                                _local10 = "italic";
                            };
                        };
                    };
                    if (_local9.fontStyle == _local10)
                    {
                        return (true);
                    };
                };
                _local7++;
            };
            if (((((!(_local2)) || (!(this.embeddedFontList)))) || (!(this.embeddedFontList[_local2]))))
            {
                return (false);
            };
            var _local8:Object = this.embeddedFontList[_local2];
            return (!(((((((_local3) && (!(_local8.bold)))) || (((_local4) && (!(_local8.italic)))))) || (((((!(_local3)) && (!(_local4)))) && (!(_local8.regular)))))));
        }

        private function resizeMouseCatcher():void
        {
            var _local1:Graphics;
            var _local2:Rectangle;
            if (this.mouseCatcher)
            {
                try
                {
                    _local1 = this.mouseCatcher.graphics;
                    _local2 = this.screen;
                    _local1.clear();
                    _local1.beginFill(0, 0);
                    _local1.drawRect(0, 0, _local2.width, _local2.height);
                    _local1.endFill();
                }
                catch(e:SecurityError)
                {
                };
            };
        }

        private function initHandler(_arg1:Event):void
        {
            if (!this.isStageRoot)
            {
                if (root.loaderInfo.parentAllowsChild)
                {
                    try
                    {
                        if (((!(this.parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)))) || (!(root.loaderInfo.sharedEvents.hasEventListener("bridgeNewApplication")))))
                        {
                            this.isBootstrapRoot = true;
                        };
                    }
                    catch(e:Error)
                    {
                    };
                };
            };
            allSystemManagers[this] = this.loaderInfo.url;
            root.loaderInfo.removeEventListener(Event.INIT, this.initHandler);
            if (!SystemManagerGlobals.info)
            {
                SystemManagerGlobals.info = this.info();
            };
            if (!SystemManagerGlobals.parameters)
            {
                SystemManagerGlobals.parameters = loaderInfo.parameters;
            };
            var _local2:int = (((totalFrames)==1) ? 0 : 1);
            this.addEventListener(Event.ENTER_FRAME, this.docFrameListener);
            this.initialize();
        }

        private function docFrameListener(_arg1:Event):void
        {
            if (currentFrame == 2)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.docFrameListener);
                if (totalFrames > 2)
                {
                    this.addEventListener(Event.ENTER_FRAME, this.extraFrameListener);
                };
                this.docFrameHandler();
            };
        }

        private function extraFrameListener(_arg1:Event):void
        {
            if (this.lastFrame == currentFrame)
            {
                return;
            };
            this.lastFrame = currentFrame;
            if ((currentFrame + 1) > totalFrames)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.extraFrameListener);
            };
            this.extraFrameHandler();
        }

        private function preloader_preloaderDocFrameReadyHandler(_arg1:Event):void
        {
            this.preloader.removeEventListener(FlexEvent.PRELOADER_DOC_FRAME_READY, this.preloader_preloaderDocFrameReadyHandler);
            this.deferredNextFrame();
        }

        private function preloader_preloaderDoneHandler(_arg1:Event):void
        {
            var _local2:IUIComponent = this.topLevelWindow;
            this.preloader.removeEventListener(FlexEvent.PRELOADER_DONE, this.preloader_preloaderDoneHandler);
            this.preloader.removeEventListener(RSLEvent.RSL_COMPLETE, this.preloader_rslCompleteHandler);
            this._popUpChildren.removeChild(this.preloader);
            this.preloader = null;
            this.mouseCatcher = new FlexSprite();
            this.mouseCatcher.name = "mouseCatcher";
            this.noTopMostIndex++;
            super.addChildAt(this.mouseCatcher, 0);
            this.resizeMouseCatcher();
            if (!this.topLevel)
            {
                this.mouseCatcher.visible = false;
                mask = this.mouseCatcher;
            };
            this.noTopMostIndex++;
            super.addChildAt(DisplayObject(_local2), 1);
            _local2.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
            dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
        }

        private function preloader_rslCompleteHandler(_arg1:RSLEvent):void
        {
            var _local2:Vector.<RSLData>;
            var _local3:IFlexModuleFactory;
            if (((!(_arg1.isResourceModule)) && (_arg1.loaderInfo)))
            {
                _local2 = Vector.<RSLData>(this.rslDataList[_arg1.rslIndex]);
                _local3 = this;
                if (((_local2) && (_local2[0].moduleFactory)))
                {
                    _local3 = _local2[0].moduleFactory;
                };
                if (_local3 == this)
                {
                    this.preloadedRSLs[_arg1.loaderInfo] = _local2;
                }
                else
                {
                    _local3.addPreloadedRSL(_arg1.loaderInfo, _local2);
                };
            };
        }

        mx_internal function docFrameHandler(_arg1:Event=null):void
        {
            if (this.readyForKickOff)
            {
                this.kickOff();
            };
        }

        mx_internal function preloader_completeHandler(_arg1:Event):void
        {
            this.preloader.removeEventListener(Event.COMPLETE, this.preloader_completeHandler);
            this.readyForKickOff = true;
            if (currentFrame >= 2)
            {
                this.kickOff();
            };
        }

        mx_internal function kickOff():void
        {
            var _local5:int;
            var _local6:int;
            var _local7:Class;
            if (this.document)
            {
                return;
            };
            if (!this.isTopLevel())
            {
                SystemManagerGlobals.topLevelSystemManagers[0].dispatchEvent(new FocusEvent(FlexEvent.NEW_CHILD_APPLICATION, false, false, this));
            };
            Singleton.registerClass("mx.core::IEmbeddedFontRegistry", Class(this.getDefinitionByName("mx.core::EmbeddedFontRegistry")));
            Singleton.registerClass("mx.styles::IStyleManager", Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
            Singleton.registerClass("mx.styles::IStyleManager2", Class(this.getDefinitionByName("mx.styles::StyleManagerImpl")));
            Singleton.registerClass("mx.managers::IBrowserManager", Class(this.getDefinitionByName("mx.managers::BrowserManagerImpl")));
            Singleton.registerClass("mx.managers::ICursorManager", Class(this.getDefinitionByName("mx.managers::CursorManagerImpl")));
            Singleton.registerClass("mx.managers::IHistoryManager", Class(this.getDefinitionByName("mx.managers::HistoryManagerImpl")));
            Singleton.registerClass("mx.managers::ILayoutManager", Class(this.getDefinitionByName("mx.managers::LayoutManager")));
            Singleton.registerClass("mx.managers::IPopUpManager", Class(this.getDefinitionByName("mx.managers::PopUpManagerImpl")));
            Singleton.registerClass("mx.managers::IToolTipManager2", Class(this.getDefinitionByName("mx.managers::ToolTipManagerImpl")));
            var _local1:Class;
            var _local2:Object = this.info()["useNativeDragManager"];
            var _local3:Boolean = (((_local2 == null)) ? true : (String(_local2) == "true"));
            if (_local3)
            {
                _local1 = Class(this.getDefinitionByName("mx.managers::NativeDragManagerImpl"));
            };
            if (_local1 == null)
            {
                _local1 = Class(this.getDefinitionByName("mx.managers::DragManagerImpl"));
            };
            Singleton.registerClass("mx.managers::IDragManager", _local1);
            Singleton.registerClass("mx.core::ITextFieldFactory", Class(this.getDefinitionByName("mx.core::TextFieldFactory")));
            var _local4:Array = this.info()["mixins"];
            if (((_local4) && ((_local4.length > 0))))
            {
                _local5 = _local4.length;
                _local6 = 0;
                while (_local6 < _local5)
                {
                    _local7 = Class(this.getDefinitionByName(_local4[_local6]));
                    var _local8 = _local7;
                    (_local8["init"](this));
                    _local6++;
                };
            };
            _local7 = Singleton.getClass("mx.managers::IActiveWindowManager");
            if (_local7)
            {
                this.registerImplementation("mx.managers::IActiveWindowManager", new _local7(this));
            };
            _local7 = Singleton.getClass("mx.managers::IMarshalSystemManager");
            if (_local7)
            {
                this.registerImplementation("mx.managers::IMarshalSystemManager", new _local7(this));
            };
            this.initializeTopLevelWindow(null);
            this.deferredNextFrame();
        }

        private function keyDownHandler(_arg1:KeyboardEvent):void
        {
            var _local2:KeyboardEvent;
            if (!_arg1.cancelable)
            {
                switch (_arg1.keyCode)
                {
                    case Keyboard.UP:
                    case Keyboard.DOWN:
                    case Keyboard.PAGE_UP:
                    case Keyboard.PAGE_DOWN:
                    case Keyboard.HOME:
                    case Keyboard.END:
                    case Keyboard.LEFT:
                    case Keyboard.RIGHT:
                    case Keyboard.ENTER:
                        _arg1.stopImmediatePropagation();
                        _local2 = new KeyboardEvent(_arg1.type, _arg1.bubbles, true, _arg1.charCode, _arg1.keyCode, _arg1.keyLocation, _arg1.ctrlKey, _arg1.altKey, _arg1.shiftKey);
                        _arg1.target.dispatchEvent(_local2);
                };
            };
        }

        private function mouseEventHandler(_arg1:MouseEvent):void
        {
            var _local2:MouseEvent;
            var _local3:Class;
            if (((!(_arg1.cancelable)) && (!((_arg1.eventPhase == EventPhase.BUBBLING_PHASE)))))
            {
                _arg1.stopImmediatePropagation();
                _local2 = null;
                if (("clickCount" in _arg1))
                {
                    _local3 = MouseEvent;
                    _local2 = new _local3(_arg1.type, _arg1.bubbles, true, _arg1.localX, _arg1.localY, _arg1.relatedObject, _arg1.ctrlKey, _arg1.altKey, _arg1.shiftKey, _arg1.buttonDown, _arg1.delta, _arg1["commandKey"], _arg1["controlKey"], _arg1["clickCount"]);
                }
                else
                {
                    _local2 = new MouseEvent(_arg1.type, _arg1.bubbles, true, _arg1.localX, _arg1.localY, _arg1.relatedObject, _arg1.ctrlKey, _arg1.altKey, _arg1.shiftKey, _arg1.buttonDown, _arg1.delta);
                };
                _arg1.target.dispatchEvent(_local2);
            };
        }

        private function extraFrameHandler(_arg1:Event=null):void
        {
            var _local3:Class;
            var _local2:Object = this.info()["frames"];
            if (((_local2) && (_local2[currentLabel])))
            {
                _local3 = Class(this.getDefinitionByName(_local2[currentLabel]));
                var _local4 = _local3;
                (_local4["frame"](this));
            };
            this.deferredNextFrame();
        }

        private function nextFrameTimerHandler(_arg1:TimerEvent):void
        {
            if ((currentFrame + 1) <= framesLoaded)
            {
                nextFrame();
                this.nextFrameTimer.removeEventListener(TimerEvent.TIMER, this.nextFrameTimerHandler);
                this.nextFrameTimer.reset();
            };
        }

        private function initializeTopLevelWindow(_arg1:Event):void
        {
            var _local2:Number;
            var _local3:Number;
            var _local4:DisplayObjectContainer;
            var _local5:ISystemManager;
            var _local6:DisplayObject;
            if (this.getSandboxRoot() == this)
            {
                this.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, true, 1000);
                this.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseEventHandler, true, 1000);
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseEventHandler, true, 1000);
            };
            if (((this.isTopLevelRoot()) && (this.stage)))
            {
                this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 1000);
                this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseEventHandler, false, 1000);
                this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseEventHandler, false, 1000);
            };
            if (((!(this.parent)) && (this.parentAllowsChild)))
            {
                return;
            };
            if (!this.topLevel)
            {
                if (!this.parent)
                {
                    return;
                };
                _local4 = this.parent.parent;
                if (!_local4)
                {
                    return;
                };
                while (_local4)
                {
                    if ((_local4 is IUIComponent))
                    {
                        _local5 = IUIComponent(_local4).systemManager;
                        if (((_local5) && (!(_local5.isTopLevel()))))
                        {
                            _local5 = _local5.topLevelSystemManager;
                        };
                        this._topLevelSystemManager = _local5;
                        break;
                    };
                    _local4 = _local4.parent;
                };
            };
            if (((this.isTopLevelRoot()) && (this.stage)))
            {
                this.stage.addEventListener(Event.RESIZE, this.Stage_resizeHandler, false, 0, true);
            }
            else
            {
                if (((this.topLevel) && (this.stage)))
                {
                    _local6 = this.getSandboxRoot();
                    if (_local6 != this)
                    {
                        _local6.addEventListener(Event.RESIZE, this.Stage_resizeHandler, false, 0, true);
                    };
                };
            };
            if (((this.isStageRoot) && (this.stage)))
            {
                this.Stage_resizeHandler();
                if ((((((((this._width == 0)) && ((this._height == 0)))) && (!((loaderInfo.width == this._width))))) && (!((loaderInfo.height == this._height)))))
                {
                    this._width = loaderInfo.width;
                    this._height = loaderInfo.height;
                };
                _local2 = this._width;
                _local3 = this._height;
            }
            else
            {
                _local2 = loaderInfo.width;
                _local3 = loaderInfo.height;
            };
            this.childManager.initializeTopLevelWindow(_local2, _local3);
        }

        private function appCreationCompleteHandler(_arg1:FlexEvent):void
        {
            this.invalidateParentSizeAndDisplayList();
        }

        public function invalidateParentSizeAndDisplayList():void
        {
            var _local1:DisplayObjectContainer;
            if (((!(this.topLevel)) && (this.parent)))
            {
                _local1 = this.parent.parent;
                while (_local1)
                {
                    if ((_local1 is IInvalidating))
                    {
                        IInvalidating(_local1).invalidateSize();
                        IInvalidating(_local1).invalidateDisplayList();
                        return;
                    };
                    _local1 = _local1.parent;
                };
            };
            dispatchEvent(new Event("invalidateParentSizeAndDisplayList"));
        }

        private function Stage_resizeHandler(_arg1:Event=null):void
        {
            var m:Number;
            var n:Number;
            var scale:Number;
            var event = _arg1;
            if (this.isDispatchingResizeEvent)
            {
                return;
            };
            var w:Number = 0;
            var h:Number = 0;
            try
            {
                m = loaderInfo.width;
                n = loaderInfo.height;
            }
            catch(error:Error)
            {
                if (!_screen)
                {
                    _screen = new Rectangle();
                };
                return;
            };
            var align:String = StageAlign.TOP_LEFT;
            try
            {
                if (this.stage)
                {
                    w = this.stage.stageWidth;
                    h = this.stage.stageHeight;
                    align = this.stage.align;
                };
            }
            catch(error:SecurityError)
            {
                if (hasEventListener("getScreen"))
                {
                    dispatchEvent(new Event("getScreen"));
                    if (_screen)
                    {
                        w = _screen.width;
                        h = _screen.height;
                    };
                };
            };
            var x:Number = ((m - w) / 2);
            var y:Number = ((n - h) / 2);
            if (align == StageAlign.TOP)
            {
                y = 0;
            }
            else
            {
                if (align == StageAlign.BOTTOM)
                {
                    y = (n - h);
                }
                else
                {
                    if (align == StageAlign.LEFT)
                    {
                        x = 0;
                    }
                    else
                    {
                        if (align == StageAlign.RIGHT)
                        {
                            x = (m - w);
                        }
                        else
                        {
                            if ((((align == StageAlign.TOP_LEFT)) || ((align == "LT"))))
                            {
                                y = 0;
                                x = 0;
                            }
                            else
                            {
                                if (align == StageAlign.TOP_RIGHT)
                                {
                                    y = 0;
                                    x = (m - w);
                                }
                                else
                                {
                                    if (align == StageAlign.BOTTOM_LEFT)
                                    {
                                        y = (n - h);
                                        x = 0;
                                    }
                                    else
                                    {
                                        if (align == StageAlign.BOTTOM_RIGHT)
                                        {
                                            y = (n - h);
                                            x = (m - w);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (!this._screen)
            {
                this._screen = new Rectangle();
            };
            this._screen.x = x;
            this._screen.y = y;
            this._screen.width = w;
            this._screen.height = h;
            if (this.isStageRoot)
            {
                scale = this.densityScale;
                root.scaleX = (root.scaleY = scale);
                this._width = (this.stage.stageWidth / scale);
                this._height = (this.stage.stageHeight / scale);
                this._screen.x = (this._screen.x / scale);
                this._screen.y = (this._screen.y / scale);
                this._screen.width = (this._screen.width / scale);
                this._screen.height = (this._screen.height / scale);
            };
            if (event)
            {
                this.resizeMouseCatcher();
                this.isDispatchingResizeEvent = true;
                dispatchEvent(event);
                this.isDispatchingResizeEvent = false;
            };
        }

        private function mouseMoveHandler(_arg1:MouseEvent):void
        {
            this.idleCounter = 0;
        }

        private function mouseUpHandler(_arg1:MouseEvent):void
        {
            this.idleCounter = 0;
        }

        private function idleTimer_timerHandler(_arg1:TimerEvent):void
        {
            this.idleCounter++;
            if ((this.idleCounter * IDLE_INTERVAL) > IDLE_THRESHOLD)
            {
                dispatchEvent(new FlexEvent(FlexEvent.IDLE));
            };
        }

        override public function get mouseX():Number
        {
            if (this._mouseX === undefined)
            {
                return (super.mouseX);
            };
            return (this._mouseX);
        }

        override public function get mouseY():Number
        {
            if (this._mouseY === undefined)
            {
                return (super.mouseY);
            };
            return (this._mouseY);
        }

        private function getTopLevelSystemManager(_arg1:DisplayObject):ISystemManager
        {
            var _local3:ISystemManager;
            var _local2:DisplayObjectContainer = DisplayObjectContainer(_arg1.root);
            if (((((!(_local2)) || ((_local2 is Stage)))) && ((_arg1 is IUIComponent))))
            {
                _local2 = DisplayObjectContainer(IUIComponent(_arg1).systemManager);
            };
            if ((_local2 is ISystemManager))
            {
                _local3 = ISystemManager(_local2);
                if (!_local3.isTopLevel())
                {
                    _local3 = _local3.topLevelSystemManager;
                };
            };
            return (_local3);
        }

        override public function get parent():DisplayObjectContainer
        {
            try
            {
                return (super.parent);
            }
            catch(e:SecurityError)
            {
            };
            return (null);
        }

        public function getTopLevelRoot():DisplayObject
        {
            var _local1:ISystemManager;
            var _local2:DisplayObject;
            var _local3:DisplayObject;
            try
            {
                _local1 = this;
                if (_local1.topLevelSystemManager)
                {
                    _local1 = _local1.topLevelSystemManager;
                };
                _local2 = DisplayObject(_local1).parent;
                _local3 = DisplayObject(_local1);
                while (_local2)
                {
                    if ((_local2 is Stage))
                    {
                        return (_local3);
                    };
                    _local3 = _local2;
                    _local2 = _local2.parent;
                };
            }
            catch(error:SecurityError)
            {
            };
            return (null);
        }

        public function getSandboxRoot():DisplayObject
        {
            var _local2:DisplayObject;
            var _local3:DisplayObject;
            var _local4:Loader;
            var _local5:LoaderInfo;
            var _local1:ISystemManager = this;
            try
            {
                if (_local1.topLevelSystemManager)
                {
                    _local1 = _local1.topLevelSystemManager;
                };
                _local2 = DisplayObject(_local1).parent;
                if ((_local2 is Stage))
                {
                    return (DisplayObject(_local1));
                };
                if (((_local2) && (!(_local2.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true))))))
                {
                    return (this);
                };
                _local3 = this;
                while (_local2)
                {
                    if ((_local2 is Stage))
                    {
                        return (_local3);
                    };
                    if (!_local2.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)))
                    {
                        return (_local3);
                    };
                    if ((_local2 is Loader))
                    {
                        _local4 = Loader(_local2);
                        _local5 = _local4.contentLoaderInfo;
                        if (!_local5.childAllowsParent)
                        {
                            return (_local5.content);
                        };
                    };
                    if (_local2.hasEventListener("systemManagerRequest"))
                    {
                        _local3 = _local2;
                    };
                    _local2 = _local2.parent;
                };
            }
            catch(error:Error)
            {
            };
            return ((((_local3)!=null) ? _local3 : DisplayObject(_local1)));
        }

        public function registerImplementation(_arg1:String, _arg2:Object):void
        {
            var _local3:Object = this.implMap[_arg1];
            if (!_local3)
            {
                this.implMap[_arg1] = _arg2;
            };
        }

        public function getImplementation(_arg1:String):Object
        {
            var _local2:Object = this.implMap[_arg1];
            return (_local2);
        }

        public function getVisibleApplicationRect(_arg1:Rectangle=null, _arg2:Boolean=false):Rectangle
        {
            var _local3:Request;
            var _local4:DisplayObject;
            var _local5:Rectangle;
            var _local6:Point;
            var _local7:Rectangle;
            var _local8:DisplayObjectContainer;
            var _local9:Rectangle;
            if (hasEventListener("getVisibleApplicationRect"))
            {
                _local3 = new Request("getVisibleApplicationRect", false, true);
                _local3.value = {
                    bounds:_arg1,
                    skipToSandboxRoot:_arg2
                };
                if (!dispatchEvent(_local3))
                {
                    return (Rectangle(_local3.value));
                };
            };
            if (((_arg2) && (!(this.topLevel))))
            {
                return (this.topLevelSystemManager.getVisibleApplicationRect(_arg1, _arg2));
            };
            if (!_arg1)
            {
                _arg1 = getBounds(DisplayObject(this));
                _local4 = this.getSandboxRoot();
                _local5 = this.screen.clone();
                _local5.topLeft = _local4.localToGlobal(this.screen.topLeft);
                _local5.bottomRight = _local4.localToGlobal(this.screen.bottomRight);
                _local6 = new Point(Math.max(0, _arg1.x), Math.max(0, _arg1.y));
                _local6 = localToGlobal(_local6);
                _arg1.x = _local6.x;
                _arg1.y = _local6.y;
                _arg1.width = _local5.width;
                _arg1.height = _local5.height;
                _local7 = this.stage.softKeyboardRect;
                _arg1.height = (_arg1.height - _local7.height);
            };
            if (!this.topLevel)
            {
                _local8 = this.parent.parent;
                if (("getVisibleApplicationRect" in _local8))
                {
                    _local9 = _local8["getVisibleApplicationRect"](true);
                    _arg1 = _arg1.intersection(_local9);
                };
            };
            return (_arg1);
        }

        public function deployMouseShields(_arg1:Boolean):void
        {
            var _local2:DynamicEvent;
            if (hasEventListener("deployMouseShields"))
            {
                _local2 = new DynamicEvent("deployMouseShields");
                _local2.deploy = _arg1;
                dispatchEvent(_local2);
            };
        }

        private function stageEventHandler(_arg1:Event):void
        {
            var _local2:MouseEvent;
            var _local3:Point;
            var _local4:Point;
            if ((((_arg1.target is Stage)) && (this.mouseCatcher)))
            {
                if ((_arg1 is MouseEvent))
                {
                    _local2 = MouseEvent(_arg1);
                    _local3 = new Point(_local2.stageX, _local2.stageY);
                    _local4 = this.mouseCatcher.globalToLocal(_local3);
                    _local2.localX = _local4.x;
                    _local2.localY = _local4.y;
                };
                this.mouseCatcher.dispatchEvent(_arg1);
            };
        }

        private function mouseLeaveHandler(_arg1:Event):void
        {
            dispatchEvent(new SandboxMouseEvent(SandboxMouseEvent.MOUSE_UP_SOMEWHERE));
        }


    }
}//package mx.managers
