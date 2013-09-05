//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import flash.errors.IllegalOperationError;

    public class XMLListListCollectionDataDescriptor implements IListCollectionDataDescriptor 
    {


        public function getLength(_arg1:Object):int
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as XMLList).length());
        }

        public function getItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            return (_arg1[_arg2]);
        }

        public function setItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            this.checkForCorrectDataType(_arg1);
            _arg1[_arg3] = XML(_arg2);
        }

        public function addItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            var _local4:XMLList;
            this.checkForCorrectDataType(_arg1);
            _local4 = (_arg1 as XMLList).copy();
            _arg1[_arg3] = _arg2;
            var _local5:int = _local4.length();
            var _local6:int = _arg3;
            while (_local6 < _local5)
            {
                _arg1[(_local6 + 1)] = _local4[_local6];
                _local6++;
            };
        }

        public function removeItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            var _local3:XML = _arg1[_arg2];
            delete _arg1[_arg2];
            return (_local3);
        }

        public function getItemIndex(_arg1:Object, _arg2:Object):int
        {
            var _local3:XMLList;
            var _local6:XML;
            this.checkForCorrectDataType(_arg1);
            _local3 = (_arg1 as XMLList);
            var _local4:int = _local3.length();
            var _local5:int;
            while (_local5 < _local4)
            {
                _local6 = _local3[_local5];
                if (_local6 == _arg2)
                {
                    return (_local5);
                };
                _local5++;
            };
            return (-1);
        }

        protected function checkForCorrectDataType(_arg1:Object):void
        {
            if (!(_arg1 is XMLList))
            {
                throw (new IllegalOperationError((("Expected XMLList. Received " + Object(_arg1).constructor) + " instead.")));
            };
        }


    }
}//package org.josht.starling.foxhole.data
