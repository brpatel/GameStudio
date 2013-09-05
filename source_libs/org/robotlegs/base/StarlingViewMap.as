//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import flash.utils.Dictionary;
    import starling.display.DisplayObjectContainer;
    import org.robotlegs.core.IInjector;
    import starling.events.Event;
    import starling.display.DisplayObject;
    import flash.utils.getQualifiedClassName;
    import org.robotlegs.core.*;

    public class StarlingViewMap extends StarlingViewMapBase implements IStarlingViewMap 
    {

        protected var mappedPackages:Array;
        protected var mappedTypes:Dictionary;
        protected var injectedViews:Dictionary;

        public function StarlingViewMap(_arg1:DisplayObjectContainer, _arg2:IInjector)
        {
            super(_arg1, _arg2);
            this.mappedPackages = new Array();
            this.mappedTypes = new Dictionary(false);
            this.injectedViews = new Dictionary(true);
        }

        public function mapPackage(_arg1:String):void
        {
            if (this.mappedPackages.indexOf(_arg1) == -1)
            {
                this.mappedPackages.push(_arg1);
                viewListenerCount++;
                if (viewListenerCount == 1)
                {
                    this.addListeners();
                };
            };
        }

        public function unmapPackage(_arg1:String):void
        {
            var _local2:int = this.mappedPackages.indexOf(_arg1);
            if (_local2 > -1)
            {
                this.mappedPackages.splice(_local2, 1);
                viewListenerCount--;
                if (viewListenerCount == 0)
                {
                    this.removeListeners();
                };
            };
        }

        public function mapType(_arg1:Class):void
        {
            if (this.mappedTypes[_arg1])
            {
                return;
            };
            this.mappedTypes[_arg1] = _arg1;
            viewListenerCount++;
            if (viewListenerCount == 1)
            {
                this.addListeners();
            };
            if (((contextView) && ((contextView is _arg1))))
            {
                this.injectInto(contextView);
            };
        }

        public function unmapType(_arg1:Class):void
        {
            var _local2:Class = this.mappedTypes[_arg1];
            delete this.mappedTypes[_arg1];
            if (_local2)
            {
                viewListenerCount--;
                if (viewListenerCount == 0)
                {
                    this.removeListeners();
                };
            };
        }

        public function hasType(_arg1:Class):Boolean
        {
            return (!((this.mappedTypes[_arg1] == null)));
        }

        public function hasPackage(_arg1:String):Boolean
        {
            return ((this.mappedPackages.indexOf(_arg1) > -1));
        }

        override protected function addListeners():void
        {
            if (((contextView) && (enabled)))
            {
                contextView.addEventListener(Event.ADDED, this.onViewAdded);
            };
        }

        override protected function removeListeners():void
        {
            if (contextView)
            {
                contextView.removeEventListener(Event.ADDED, this.onViewAdded);
            };
        }

        override protected function onViewAdded(_arg1:Event):void
        {
            var _local3:Class;
            var _local4:int;
            var _local5:String;
            var _local6:int;
            var _local7:String;
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            if (this.injectedViews[_local2])
            {
                return;
            };
            for each (_local3 in this.mappedTypes)
            {
                if ((_local2 is _local3))
                {
                    this.injectInto(_local2);
                    return;
                };
            };
            _local4 = this.mappedPackages.length;
            if (_local4 > 0)
            {
                _local5 = getQualifiedClassName(_local2);
                _local6 = 0;
                while (_local6 < _local4)
                {
                    _local7 = this.mappedPackages[_local6];
                    if (_local5.indexOf(_local7) == 0)
                    {
                        this.injectInto(_local2);
                        return;
                    };
                    _local6++;
                };
            };
        }

        protected function injectInto(_arg1:DisplayObject):void
        {
            injector.injectInto(_arg1);
            this.injectedViews[_arg1] = true;
        }


    }
}//package org.robotlegs.base
