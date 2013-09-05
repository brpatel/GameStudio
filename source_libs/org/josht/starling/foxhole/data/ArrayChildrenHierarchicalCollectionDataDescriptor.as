//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ArrayChildrenHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor 
    {

        public var childrenField:String = "children";


        public function getLength(_arg1:Object, ... _args):int
        {
            var _local6:int;
            var _local3:Array = (_arg1 as Array);
            var _local4:int = _args.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = (_args[_local5] as int);
                _local3 = (_local3[_local6][this.childrenField] as Array);
                _local5++;
            };
            return (_local3.length);
        }

        public function getItemAt(_arg1:Object, _arg2:int, ... _args):Object
        {
            _args.unshift(_arg2);
            var _local4:Array = (_arg1 as Array);
            var _local5:int = (_args.length - 1);
            var _local6:int;
            while (_local6 < _local5)
            {
                _arg2 = (_args[_local6] as int);
                _local4 = (_local4[_arg2][this.childrenField] as Array);
                _local6++;
            };
            var _local7:int = (_args[_local5] as int);
            return (_local4[_local7]);
        }

        public function setItemAt(_arg1:Object, _arg2:Object, _arg3:int, ... _args):void
        {
            _args.unshift(_arg3);
            var _local5:Array = (_arg1 as Array);
            var _local6:int = (_args.length - 1);
            var _local7:int;
            while (_local7 < _local6)
            {
                _arg3 = (_args[_local7] as int);
                _local5 = (_local5[_arg3][this.childrenField] as Array);
                _local7++;
            };
            var _local8:int = _args[_local6];
            _local5[_local8] = _arg2;
        }

        public function addItemAt(_arg1:Object, _arg2:Object, _arg3:int, ... _args):void
        {
            _args.unshift(_arg3);
            var _local5:Array = (_arg1 as Array);
            var _local6:int = (_args.length - 1);
            var _local7:int;
            while (_local7 < _local6)
            {
                _arg3 = (_args[_local7] as int);
                _local5 = (_local5[_arg3][this.childrenField] as Array);
                _local7++;
            };
            var _local8:int = _args[_local6];
            _local5.splice(_local8, 0, _arg2);
        }

        public function removeItemAt(_arg1:Object, _arg2:int, ... _args):Object
        {
            var _local7:int;
            _args.unshift(_arg2);
            var _local4:Array = (_arg1 as Array);
            var _local5:int = (_args.length - 1);
            var _local6:int;
            while (_local6 < _local5)
            {
                _arg2 = (_args[_local6] as int);
                _local4 = (_local4[_arg2][this.childrenField] as Array);
                _local6++;
            };
            _local7 = _args[_local5];
            var _local8:Object = _local4[_local7];
            _local4.splice(_local7, 1);
            return (_local8);
        }

        public function getItemLocation(_arg1:Object, _arg2:Object, _arg3:Vector.<int>=null, ... _args):Vector.<int>
        {
            var _local9:int;
            if (!_arg3)
            {
                _arg3 = new <int>[];
            }
            else
            {
                _arg3.length = 0;
            };
            var _local5:Array = (_arg1 as Array);
            var _local6:int = _args.length;
            var _local7:int;
            while (_local7 < _local6)
            {
                _local9 = (_args[_local7] as int);
                _arg3[_local7] = _local9;
                _local5 = (_local5[_local9][this.childrenField] as Array);
                _local7++;
            };
            var _local8:Boolean = this.findItemInBranch(_local5, _arg2, _arg3);
            if (!_local8)
            {
                _arg3.length = 0;
            };
            return (_arg3);
        }

        public function isBranch(_arg1:Object):Boolean
        {
            return (((_arg1.hasOwnProperty(this.childrenField)) && ((_arg1[this.childrenField] is Array))));
        }

        protected function findItemInBranch(_arg1:Array, _arg2:Object, _arg3:Vector.<int>):Boolean
        {
            var _local7:Object;
            var _local8:Boolean;
            var _local4:int = _arg1.indexOf(_arg2);
            if (_local4 >= 0)
            {
                _arg3.push(_local4);
                return (true);
            };
            var _local5:int = _arg1.length;
            var _local6:int;
            while (_local6 < _local5)
            {
                _local7 = _arg1[_local6];
                if (this.isBranch(_local7))
                {
                    _arg3.push(_local6);
                    _local8 = this.findItemInBranch((_local7[this.childrenField] as Array), _arg2, _arg3);
                    if (_local8)
                    {
                        return (true);
                    };
                    _arg3.pop();
                };
                _local6++;
            };
            return (false);
        }


    }
}//package org.josht.starling.foxhole.data
