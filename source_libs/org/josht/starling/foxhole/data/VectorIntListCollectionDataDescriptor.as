//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import flash.errors.IllegalOperationError;
    import __AS3__.vec.*;

    public class VectorIntListCollectionDataDescriptor implements IListCollectionDataDescriptor 
    {


        public function getLength(_arg1:Object):int
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Vector.<int>).length);
        }

        public function getItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Vector.<int>)[_arg2]);
        }

        public function setItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            this.checkForCorrectDataType(_arg1);
            (_arg1 as Vector.<int>)[_arg3] = (_arg2 as int);
        }

        public function addItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            this.checkForCorrectDataType(_arg1);
            (_arg1 as Vector.<int>).splice(_arg3, 0, _arg2);
        }

        public function removeItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Vector.<int>).splice(_arg2, 1)[0]);
        }

        public function getItemIndex(_arg1:Object, _arg2:Object):int
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Vector.<int>).indexOf(_arg2 as int));
        }

        protected function checkForCorrectDataType(_arg1:Object):void
        {
            if (!(_arg1 is Vector.<int>))
            {
                throw (new IllegalOperationError((("Expected Vector.<int>. Received " + Object(_arg1).constructor) + " instead.")));
            };
        }


    }
}//package org.josht.starling.foxhole.data
