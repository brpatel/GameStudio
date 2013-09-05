//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import starling.display.DisplayObject;
    import flash.utils.Dictionary;
    import starling.events.Event;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import starling.display.DisplayObjectContainer;

    public class AddedWatcher 
    {

        public var requiredBaseClass:Class;
        public var exactTypeMatching:Boolean = true;
        public var processRecursively:Boolean = true;
        private var _root:DisplayObject;
        private var _noNameTypeMap:Dictionary;
        private var _nameTypeMap:Dictionary;

        public function AddedWatcher(_arg1:DisplayObject)
        {
            this.requiredBaseClass = FoxholeControl;
            this._noNameTypeMap = new Dictionary(true);
            this._nameTypeMap = new Dictionary(true);
            super();
            this._root = _arg1;
            this._root.addEventListener(Event.ADDED, this.addedHandler);
        }

        public function setInitializerForClass(_arg1:Class, _arg2:Function, _arg3:String=null):void
        {
            if (!_arg3)
            {
                this._noNameTypeMap[_arg1] = _arg2;
            };
            var _local4:Object = this._nameTypeMap[_arg1];
            if (!_local4)
            {
                _local4 = {};
                this._nameTypeMap[_arg1] = _local4;
            };
            _local4[_arg3] = _arg2;
        }

        public function getInitializerForClass(_arg1:Class, _arg2:String=null):Function
        {
            if (!_arg2)
            {
                return ((this._noNameTypeMap[_arg1] as Function));
            };
            var _local3:Object = this._nameTypeMap[_arg1];
            if (!_local3)
            {
                return (null);
            };
            return ((_local3[_arg2] as Function));
        }

        public function clearInitializerForClass(_arg1:Class, _arg2:String=null):void
        {
            if (!_arg2)
            {
                delete this._noNameTypeMap[_arg1];
                return;
            };
            var _local3:Object = this._nameTypeMap[_arg1];
            if (!_local3)
            {
                return;
            };
            delete _local3[_arg2];
        }

        protected function applyAllStyles(_arg1:DisplayObject):void
        {
            var _local2:XML;
            var _local3:XMLList;
            var _local4:int;
            var _local5:XML;
            var _local6:String;
            var _local7:Class;
            if (!this.exactTypeMatching)
            {
                _local2 = describeType(_arg1);
                _local3 = _local2.extendsClass;
                _local4 = (_local3.length() - 1);
                while (_local4 >= 0)
                {
                    _local5 = _local3[_local4];
                    _local6 = _local5.attribute("type").toString();
                    _local7 = Class(getDefinitionByName(_local6));
                    this.applyAllStylesForType(_arg1, _local7);
                    _local4--;
                };
            };
            _local7 = Object(_arg1).constructor;
            this.applyAllStylesForType(_arg1, _local7);
        }

        protected function applyAllStylesForType(_arg1:DisplayObject, _arg2:Class):void
        {
            var _local3:Function;
            var _local5:FoxholeControl;
            var _local6:String;
            var _local4:Object = this._nameTypeMap[_arg2];
            if (_local4)
            {
                if ((_arg1 is FoxholeControl))
                {
                    _local5 = FoxholeControl(_arg1);
                    for (_local6 in _local4)
                    {
                        if (_local5.nameList.contains(_local6))
                        {
                            _local3 = (_local4[_local6] as Function);
                            if (_local3 != null)
                            {
                                (_local3(_arg1));
                                return;
                            };
                        };
                    };
                };
            };
            _local3 = (this._noNameTypeMap[_arg2] as Function);
            if (_local3 != null)
            {
                (_local3(_arg1));
            };
        }

        protected function addObject(_arg1:DisplayObject):void
        {
            var _local3:DisplayObjectContainer;
            var _local4:int;
            var _local5:int;
            var _local6:DisplayObject;
            var _local2:DisplayObject = DisplayObject((_arg1 as this.requiredBaseClass));
            if (_local2)
            {
                this.applyAllStyles(_arg1);
            };
            if (this.processRecursively)
            {
                _local3 = (_arg1 as DisplayObjectContainer);
                if (_local3)
                {
                    _local4 = _local3.numChildren;
                    _local5 = 0;
                    while (_local5 < _local4)
                    {
                        _local6 = _local3.getChildAt(_local5);
                        this.addObject(_local6);
                        _local5++;
                    };
                };
            };
        }

        protected function addedHandler(_arg1:Event):void
        {
            this.addObject((_arg1.target as DisplayObject));
        }


    }
}//package org.josht.starling.foxhole.core
