//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import starling.display.DisplayObject;
    import org.osflash.signals.Signal;
    import starling.events.Event;
    import org.osflash.signals.ISignal;
    import flash.errors.IllegalOperationError;
    import flash.geom.Rectangle;
    import starling.events.ResizeEvent;

    public class ScreenNavigator extends FoxholeControl 
    {

        private var _activeScreenID:String;
        private var _activeScreen:DisplayObject;
        private var _clipContent:Boolean = false;
        public var transition:Function;
        private var _screens:Object;
        private var _screenEvents:Object;
        public var defaultScreenID:String;
        private var _transitionIsActive:Boolean = false;
        private var _previousScreenInTransitionID:String;
        private var _previousScreenInTransition:DisplayObject;
        private var _nextScreenID:String = null;
        private var _clearAfterTransition:Boolean = false;
        private var _onChange:Signal;
        private var _onClear:Signal;

        public function ScreenNavigator()
        {
            this.transition = this.defaultTransition;
            this._screens = {};
            this._screenEvents = {};
            this._onChange = new Signal(ScreenNavigator);
            this._onClear = new Signal(ScreenNavigator);
            super();
            this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        public function get activeScreenID():String
        {
            return (this._activeScreenID);
        }

        public function get activeScreen():DisplayObject
        {
            return (this._activeScreen);
        }

        public function get clipContent():Boolean
        {
            return (this._clipContent);
        }

        public function set clipContent(_arg1:Boolean):void
        {
            if (this._clipContent == _arg1)
            {
                return;
            };
            this._clipContent = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get onClear():ISignal
        {
            return (this._onClear);
        }

        public function showScreen(_arg1:String):DisplayObject
        {
            var _local2:ScreenNavigatorItem;
            var _local5:String;
            var _local6:ISignal;
            var _local7:Object;
            var _local8:Function;
            if (!this._screens.hasOwnProperty(_arg1))
            {
                throw (new IllegalOperationError((("Screen with id '" + _arg1) + "' cannot be shown because it has not been defined.")));
            };
            if (this._activeScreenID == _arg1)
            {
                return (this._activeScreen);
            };
            if (this._transitionIsActive)
            {
                this._nextScreenID = _arg1;
                this._clearAfterTransition = false;
                return (null);
            };
            this._previousScreenInTransition = this._activeScreen;
            this._previousScreenInTransitionID = this._activeScreenID;
            if (this._activeScreen)
            {
                this.clearScreenInternal(false);
            };
            _local2 = ScreenNavigatorItem(this._screens[_arg1]);
            this._activeScreen = _local2.getScreen();
            this._activeScreenID = _arg1;
            var _local3:Object = _local2.events;
            var _local4:Object = {};
            for (_local5 in _local3)
            {
                _local6 = ((this._activeScreen.hasOwnProperty(_local5)) ? (this._activeScreen[_local5] as ISignal) : null);
                _local7 = _local3[_local5];
                if ((_local7 is Function))
                {
                    if (_local6)
                    {
                        _local6.add((_local7 as Function));
                    }
                    else
                    {
                        this._activeScreen.addEventListener(_local5, (_local7 as Function));
                    };
                }
                else
                {
                    if ((_local7 is String))
                    {
                        _local8 = this.createScreenListener((_local7 as String));
                        if (_local6)
                        {
                            _local6.add(_local8);
                        }
                        else
                        {
                            this._activeScreen.addEventListener(_local5, _local8);
                        };
                        _local4[_local5] = _local8;
                    }
                    else
                    {
                        throw (new TypeError("Unknown event action defined for screen:", _local7.toString()));
                    };
                };
            };
            this._screenEvents[_arg1] = _local4;
            this.addChild(this._activeScreen);
            this._transitionIsActive = true;
            this.transition(this._previousScreenInTransition, this._activeScreen, this.transitionComplete);
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this._onChange.dispatch(this);
            return (this._activeScreen);
        }

        public function showDefaultScreen():DisplayObject
        {
            if (!this.defaultScreenID)
            {
                throw (new IllegalOperationError("Cannot show default screen because the default screen ID has not been defined."));
            };
            return (this.showScreen(this.defaultScreenID));
        }

        public function clearScreen():void
        {
            if (this._transitionIsActive)
            {
                this._nextScreenID = null;
                this._clearAfterTransition = true;
                return;
            };
            this.clearScreenInternal(true);
            this._onClear.dispatch(this);
        }

        private function clearScreenInternal(_arg1:Boolean):void
        {
            var _local2:ScreenNavigatorItem;
            var _local5:String;
            var _local6:ISignal;
            var _local7:Object;
            var _local8:Function;
            if (!this._activeScreen)
            {
                return;
            };
            _local2 = ScreenNavigatorItem(this._screens[this._activeScreenID]);
            var _local3:Object = _local2.events;
            var _local4:Object = this._screenEvents[this._activeScreenID];
            for (_local5 in _local3)
            {
                _local6 = ((this._activeScreen.hasOwnProperty(_local5)) ? (this._activeScreen[_local5] as ISignal) : null);
                _local7 = _local3[_local5];
                if ((_local7 is Function))
                {
                    if (_local6)
                    {
                        _local6.remove((_local7 as Function));
                    }
                    else
                    {
                        this._activeScreen.removeEventListener(_local5, (_local7 as Function));
                    };
                }
                else
                {
                    if ((_local7 is String))
                    {
                        _local8 = (_local4[_local5] as Function);
                        if (_local6)
                        {
                            _local6.remove(_local8);
                        }
                        else
                        {
                            this._activeScreen.removeEventListener(_local5, _local8);
                        };
                    };
                };
            };
            if (_arg1)
            {
                this._transitionIsActive = true;
                this._previousScreenInTransition = this._activeScreen;
                this._previousScreenInTransitionID = this._activeScreenID;
                this.transition(this._previousScreenInTransition, null, this.transitionComplete);
            };
            this._screenEvents[this._activeScreenID] = null;
            this._activeScreen = null;
            this._activeScreenID = null;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
        }

        public function addScreen(_arg1:String, _arg2:ScreenNavigatorItem):void
        {
            if (this._screens.hasOwnProperty(_arg1))
            {
                throw (new IllegalOperationError((("Screen with id '" + _arg1) + "' already defined. Cannot add two screens with the same id.")));
            };
            if (!this.defaultScreenID)
            {
                this.defaultScreenID = _arg1;
            };
            this._screens[_arg1] = _arg2;
        }

        public function removeScreen(_arg1:String):void
        {
            if (!this._screens.hasOwnProperty(_arg1))
            {
                throw (new IllegalOperationError((("Screen '" + _arg1) + "' cannot be removed because it has not been added.")));
            };
            delete this._screens[_arg1];
        }

        override public function dispose():void
        {
            this._onChange.removeAll();
            this._onClear.removeAll();
            super.dispose();
        }

        override protected function draw():void
        {
            var _local4:Rectangle;
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            _local1 = ((this.autoSizeIfNeeded()) || (_local1));
            if (((_local1) || (_local2)))
            {
                if (this.activeScreen)
                {
                    this.activeScreen.width = this.actualWidth;
                    this.activeScreen.height = this.actualHeight;
                };
            };
            if (((_local3) || (_local1)))
            {
                if (this._clipContent)
                {
                    _local4 = this.scrollRect;
                    if (!_local4)
                    {
                        _local4 = new Rectangle();
                    };
                    _local4.width = this.actualWidth;
                    _local4.height = this.actualHeight;
                    this.scrollRect = _local4;
                }
                else
                {
                    this.scrollRect = null;
                };
            };
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            var _local3:Number = this.explicitWidth;
            if (_local1)
            {
                _local3 = this.stage.stageWidth;
            };
            var _local4:Number = this.explicitHeight;
            if (_local2)
            {
                _local4 = this.stage.stageHeight;
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        private function defaultTransition(_arg1:DisplayObject, _arg2:DisplayObject, _arg3:Function):void
        {
            (_arg3());
        }

        private function transitionComplete():void
        {
            var _local1:ScreenNavigatorItem;
            if (this._previousScreenInTransition)
            {
                _local1 = this._screens[this._previousScreenInTransitionID];
                this.removeChild(this._previousScreenInTransition, !((_local1.screen is DisplayObject)));
                this._previousScreenInTransition = null;
                this._previousScreenInTransitionID = null;
            };
            this._transitionIsActive = false;
            if (this._clearAfterTransition)
            {
                this.clearScreen();
            }
            else
            {
                if (this._nextScreenID)
                {
                    this.showScreen(this._nextScreenID);
                };
            };
            this._nextScreenID = null;
            this._clearAfterTransition = false;
        }

        private function createScreenListener(_arg1:String):Function
        {
            var self:ScreenNavigator;
            var screenID:String = _arg1;
            self = this;
            var eventListener:Function = function (... _args):void
            {
                self.showScreen(screenID);
            };
            return (eventListener);
        }

        protected function addedToStageHandler(_arg1:Event):void
        {
            this.stage.addEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            this.stage.removeEventListener(ResizeEvent.RESIZE, this.stage_resizeHandler);
        }

        protected function stage_resizeHandler(_arg1:ResizeEvent):void
        {
            this.invalidate(INVALIDATION_FLAG_SIZE);
        }


    }
}//package org.josht.starling.foxhole.controls
