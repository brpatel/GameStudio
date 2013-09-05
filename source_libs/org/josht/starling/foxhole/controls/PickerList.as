//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.data.ListCollection;
    import org.josht.starling.foxhole.controls.popups.IPopUpContentManager;
    import org.osflash.signals.Signal;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import starling.events.Event;
    import org.osflash.signals.ISignal;
    import starling.events.TouchEvent;
    import org.josht.system.PhysicalCapabilities;
    import starling.core.Starling;
    import org.josht.starling.foxhole.controls.popups.CalloutPopUpContentManager;
    import org.josht.starling.foxhole.controls.popups.VerticalCenteredPopUpContentManager;
    import starling.display.DisplayObject;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import __AS3__.vec.Vector;
    import org.josht.starling.display.ScrollRectManager;

    public class PickerList extends FoxholeControl 
    {

        private static const HELPER_POINT:Point = new Point();

        protected var defaultButtonName:String = "foxhole-picker-list-button";
        protected var defaultListName:String = "foxhole-picker-list-list";
        private var _button:Button;
        private var _list:List;
        private var _buttonTouchPointID:int = -1;
        private var _listTouchPointID:int = -1;
        private var _hasBeenScrolled:Boolean = false;
        private var _dataProvider:ListCollection;
        private var _selectedIndex:int = -1;
        private var _labelField:String = "label";
        private var _labelFunction:Function;
        private var _popUpContentManager:IPopUpContentManager;
        protected var _typicalItemWidth:Number = NaN;
        protected var _typicalItemHeight:Number = NaN;
        private var _typicalItem:Object = null;
        protected var _onChange:Signal;
        private var _buttonProperties:PropertyProxy;
        private var _listProperties:PropertyProxy;

        public function PickerList()
        {
            this._onChange = new Signal(PickerList);
            super();
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        public function get dataProvider():ListCollection
        {
            return (this._dataProvider);
        }

        public function set dataProvider(_arg1:ListCollection):void
        {
            if (this._dataProvider == _arg1)
            {
                return;
            };
            this._dataProvider = _arg1;
            if (((!(this._dataProvider)) || ((this._dataProvider.length == 0))))
            {
                this.selectedIndex = -1;
            }
            else
            {
                if (this._selectedIndex < 0)
                {
                    this.selectedIndex = 0;
                };
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get selectedIndex():int
        {
            return (this._selectedIndex);
        }

        public function set selectedIndex(_arg1:int):void
        {
            if (this._selectedIndex == _arg1)
            {
                return;
            };
            this._selectedIndex = _arg1;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this._onChange.dispatch(this);
        }

        public function get selectedItem():Object
        {
            if (!this._dataProvider)
            {
                return (null);
            };
            return (this._dataProvider.getItemAt(this._selectedIndex));
        }

        public function set selectedItem(_arg1:Object):void
        {
            if (!this._dataProvider)
            {
                this.selectedIndex = -1;
                return;
            };
            this.selectedIndex = this._dataProvider.getItemIndex(_arg1);
        }

        public function get labelField():String
        {
            return (this._labelField);
        }

        public function set labelField(_arg1:String):void
        {
            if (this._labelField == _arg1)
            {
                return;
            };
            this._labelField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get labelFunction():Function
        {
            return (this._labelFunction);
        }

        public function set labelFunction(_arg1:Function):void
        {
            this._labelFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get popUpContentManager():IPopUpContentManager
        {
            return (this._popUpContentManager);
        }

        public function set popUpContentManager(_arg1:IPopUpContentManager):void
        {
            if (this._popUpContentManager == _arg1)
            {
                return;
            };
            this._popUpContentManager = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get typicalItem():Object
        {
            return (this._typicalItem);
        }

        public function set typicalItem(_arg1:Object):void
        {
            if (this._typicalItem == _arg1)
            {
                return;
            };
            this._typicalItem = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        public function get buttonProperties():Object
        {
            if (!this._buttonProperties)
            {
                this._buttonProperties = new PropertyProxy(this.buttonProperties_onChange);
            };
            return (this._buttonProperties);
        }

        public function set buttonProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._buttonProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
            };
            if (this._buttonProperties)
            {
                this._buttonProperties.onChange.remove(this.buttonProperties_onChange);
            };
            this._buttonProperties = PropertyProxy(_arg1);
            if (this._buttonProperties)
            {
                this._buttonProperties.onChange.add(this.buttonProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get listProperties():Object
        {
            if (!this._listProperties)
            {
                this._listProperties = new PropertyProxy(this.listProperties_onChange);
            };
            return (this._listProperties);
        }

        public function set listProperties(_arg1:Object):void
        {
            var _local2:PropertyProxy;
            var _local3:String;
            if (this._listProperties == _arg1)
            {
                return;
            };
            if (!_arg1)
            {
                _arg1 = new PropertyProxy();
            };
            if (!(_arg1 is PropertyProxy))
            {
                _local2 = new PropertyProxy();
                for (_local3 in _arg1)
                {
                    _local2[_local3] = _arg1[_local3];
                };
                _arg1 = _local2;
            };
            if (this._listProperties)
            {
                this._listProperties.onChange.remove(this.listProperties_onChange);
            };
            this._listProperties = PropertyProxy(_arg1);
            if (this._listProperties)
            {
                this._listProperties.onChange.add(this.listProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function itemToLabel(_arg1:Object):String
        {
            if (this._labelFunction != null)
            {
                return ((this._labelFunction(_arg1) as String));
            };
            if (((((!((this._labelField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._labelField))))
            {
                return ((_arg1[this._labelField] as String));
            };
            if ((_arg1 is Object))
            {
                return (_arg1.toString());
            };
            return ("");
        }

        override public function dispose():void
        {
            this.closePopUpList();
            this._onChange.removeAll();
            this._list.dispose();
            super.dispose();
        }

        override protected function initialize():void
        {
            if (!this._button)
            {
                this._button = new Button();
                this._button.nameList.add(this.defaultButtonName);
                this._button.onRelease.add(this.button_onRelease);
                this._button.addEventListener(TouchEvent.TOUCH, this.button_touchHandler);
                this.addChild(this._button);
            };
            if (!this._list)
            {
                this._list = new List();
                this._list.nameList.add(this.defaultListName);
                this._list.onScroll.add(this.list_onScroll);
                this._list.onChange.add(this.list_onChange);
                this._list.onItemTouch.add(this.list_onItemTouch);
                this._list.addEventListener(TouchEvent.TOUCH, this.list_touchHandler);
            };
            if (!this._popUpContentManager)
            {
                if (PhysicalCapabilities.isTablet(Starling.current.nativeStage))
                {
                    this.popUpContentManager = new CalloutPopUpContentManager();
                }
                else
                {
                    this.popUpContentManager = new VerticalCenteredPopUpContentManager();
                };
            };
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var _local5:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            if (((_local2) || (_local4)))
            {
                if (isNaN(this.explicitWidth))
                {
                    this._button.width = NaN;
                };
                if (isNaN(this.explicitHeight))
                {
                    this._button.height = NaN;
                };
            };
            if (_local2)
            {
                this._typicalItemWidth = NaN;
                this._typicalItemHeight = NaN;
                this.refreshButtonProperties();
                this.refreshListProperties();
            };
            if (_local1)
            {
                this._list.dataProvider = this._dataProvider;
                this._hasBeenScrolled = false;
            };
            if (_local3)
            {
                this._button.isEnabled = this.isEnabled;
            };
            if (_local4)
            {
                this.refreshButtonLabel();
                this._list.selectedIndex = this._selectedIndex;
            };
            _local5 = ((this.autoSizeIfNeeded()) || (_local5));
            this._button.width = this.actualWidth;
            this._button.height = this.actualHeight;
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            this._button.width = NaN;
            this._button.height = NaN;
            if (this._typicalItem)
            {
                if (((isNaN(this._typicalItemWidth)) || (isNaN(this._typicalItemHeight))))
                {
                    this._button.label = this.itemToLabel(this._typicalItem);
                    this._button.validate();
                    this._typicalItemWidth = this._button.width;
                    this._typicalItemHeight = this._button.height;
                    this.refreshButtonLabel();
                };
            }
            else
            {
                this._button.validate();
                this._typicalItemWidth = this._button.width;
                this._typicalItemHeight = this._button.height;
            };
            var _local3:Number = this.explicitWidth;
            var _local4:Number = this.explicitHeight;
            if (_local1)
            {
                _local3 = this._typicalItemWidth;
            };
            if (_local2)
            {
                _local4 = this._typicalItemHeight;
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function refreshButtonLabel():void
        {
            if (this._selectedIndex >= 0)
            {
                this._button.label = this.itemToLabel(this.selectedItem);
            }
            else
            {
                this._button.label = "";
            };
        }

        protected function refreshButtonProperties():void
        {
            var _local1:String;
            var _local2:Object;
            for (_local1 in this._buttonProperties)
            {
                if (this._button.hasOwnProperty(_local1))
                {
                    _local2 = this._buttonProperties[_local1];
                    this._button[_local1] = _local2;
                };
            };
        }

        protected function refreshListProperties():void
        {
            var _local1:String;
            var _local2:Object;
            for (_local1 in this._listProperties)
            {
                if (this._list.hasOwnProperty(_local1))
                {
                    _local2 = this._listProperties[_local1];
                    this._list[_local1] = _local2;
                };
            };
        }

        protected function closePopUpList():void
        {
            this._list.validate();
            this._popUpContentManager.close();
        }

        protected function buttonProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function listProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function button_onRelease(_arg1:Button):void
        {
            this._popUpContentManager.open(this._list, this);
            this._list.scrollToDisplayIndex(this._selectedIndex);
            this._list.validate();
            this._hasBeenScrolled = false;
        }

        protected function list_onChange(_arg1:List):void
        {
            this.selectedIndex = this._list.selectedIndex;
        }

        protected function list_onScroll(_arg1:List):void
        {
            if (this._listTouchPointID >= 0)
            {
                this._hasBeenScrolled = true;
            };
        }

        protected function list_onItemTouch(_arg1:List, _arg2:Object, _arg3:int, _arg4:TouchEvent):void
        {
            var _local5:DisplayObject;
            var _local7:Touch;
            var _local8:Touch;
            if (((this._hasBeenScrolled) || ((this._listTouchPointID < 0))))
            {
                return;
            };
            _local5 = DisplayObject(_arg4.currentTarget);
            var _local6:Vector.<Touch> = _arg4.getTouches(_local5, TouchPhase.ENDED);
            if (_local6.length == 0)
            {
                return;
            };
            for each (_local8 in _local6)
            {
                if (_local8.id == this._listTouchPointID)
                {
                    _local7 = _local8;
                    break;
                };
            };
            if (!_local7)
            {
                return;
            };
            _local7.getLocation(_local5, HELPER_POINT);
            ScrollRectManager.adjustTouchLocation(HELPER_POINT, _local5);
            if (_local5.hitTest(HELPER_POINT, true))
            {
                this.closePopUpList();
            };
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            this._buttonTouchPointID = -1;
            this._listTouchPointID = -1;
        }

        protected function button_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local2:Vector.<Touch> = _arg1.getTouches(this._button);
            if (_local2.length == 0)
            {
                return;
            };
            if (this._buttonTouchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this._buttonTouchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this._buttonTouchPointID = -1;
                    return;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this._buttonTouchPointID = _local3.id;
                        return;
                    };
                };
            };
        }

        protected function list_touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local2:Vector.<Touch> = _arg1.getTouches(this._list);
            if (_local2.length == 0)
            {
                return;
            };
            if (this._listTouchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this._listTouchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this._listTouchPointID = -1;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this._listTouchPointID = _local3.id;
                        this._hasBeenScrolled = false;
                    };
                };
            };
        }


    }
}//package org.josht.starling.foxhole.controls
