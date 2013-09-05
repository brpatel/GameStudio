//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.managers
{
    import mx.core.mx_internal;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import mx.core.*;

    use namespace mx_internal;

    public class SystemChildrenList implements IChildList 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var owner:SystemManager;
        private var lowerBoundReference:QName;
        private var upperBoundReference:QName;

        public function SystemChildrenList(_arg1:SystemManager, _arg2:QName, _arg3:QName)
        {
            this.owner = _arg1;
            this.lowerBoundReference = _arg2;
            this.upperBoundReference = _arg3;
        }

        public function get numChildren():int
        {
            return ((this.owner[this.upperBoundReference] - this.owner[this.lowerBoundReference]));
        }

        public function addChild(_arg1:DisplayObject):DisplayObject
        {
            this.owner.rawChildren_addChildAt(_arg1, this.owner[this.upperBoundReference]);
            var _local2 = this.owner;
            var _local3 = this.upperBoundReference;
            var _local4 = (_local2[_local3] + 1);
            _local2[_local3] = _local4;
            return (_arg1);
        }

        public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject
        {
            this.owner.rawChildren_addChildAt(_arg1, (this.owner[this.lowerBoundReference] + _arg2));
            var _local3 = this.owner;
            var _local4 = this.upperBoundReference;
            var _local5 = (_local3[_local4] + 1);
            _local3[_local4] = _local5;
            return (_arg1);
        }

        public function removeChild(_arg1:DisplayObject):DisplayObject
        {
            var _local2:int = this.owner.rawChildren_getChildIndex(_arg1);
            if ((((this.owner[this.lowerBoundReference] <= _local2)) && ((_local2 < this.owner[this.upperBoundReference]))))
            {
                this.owner.rawChildren_removeChild(_arg1);
                var _local3 = this.owner;
                var _local4 = this.upperBoundReference;
                var _local5 = (_local3[_local4] - 1);
                _local3[_local4] = _local5;
            };
            return (_arg1);
        }

        public function removeChildAt(_arg1:int):DisplayObject
        {
            var _local2:DisplayObject = this.owner.rawChildren_removeChildAt((_arg1 + this.owner[this.lowerBoundReference]));
            var _local3 = this.owner;
            var _local4 = this.upperBoundReference;
            var _local5 = (_local3[_local4] - 1);
            _local3[_local4] = _local5;
            return (_local2);
        }

        public function getChildAt(_arg1:int):DisplayObject
        {
            var _local2:DisplayObject = this.owner.rawChildren_getChildAt((this.owner[this.lowerBoundReference] + _arg1));
            return (_local2);
        }

        public function getChildByName(_arg1:String):DisplayObject
        {
            return (this.owner.rawChildren_getChildByName(_arg1));
        }

        public function getChildIndex(_arg1:DisplayObject):int
        {
            var _local2:int = this.owner.rawChildren_getChildIndex(_arg1);
            _local2 = (_local2 - this.owner[this.lowerBoundReference]);
            return (_local2);
        }

        public function setChildIndex(_arg1:DisplayObject, _arg2:int):void
        {
            this.owner.rawChildren_setChildIndex(_arg1, (this.owner[this.lowerBoundReference] + _arg2));
        }

        public function getObjectsUnderPoint(_arg1:Point):Array
        {
            return (this.owner.rawChildren_getObjectsUnderPoint(_arg1));
        }

        public function contains(_arg1:DisplayObject):Boolean
        {
            var _local2:int;
            if (((!((_arg1 == this.owner))) && (this.owner.rawChildren_contains(_arg1))))
            {
                while (_arg1.parent != this.owner)
                {
                    _arg1 = _arg1.parent;
                };
                _local2 = this.owner.rawChildren_getChildIndex(_arg1);
                if ((((_local2 >= this.owner[this.lowerBoundReference])) && ((_local2 < this.owner[this.upperBoundReference]))))
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}//package mx.managers
