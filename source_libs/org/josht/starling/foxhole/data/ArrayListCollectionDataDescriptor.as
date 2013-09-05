//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.data
{
    import flash.errors.IllegalOperationError;

    public class ArrayListCollectionDataDescriptor implements IListCollectionDataDescriptor 
    {


        public function getLength(_arg1:Object):int
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Array).length);
        }

        public function getItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Array)[_arg2]);
        }

        public function setItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            this.checkForCorrectDataType(_arg1);
            (_arg1 as Array)[_arg3] = _arg2;
        }

        public function addItemAt(_arg1:Object, _arg2:Object, _arg3:int):void
        {
            this.checkForCorrectDataType(_arg1);
            (_arg1 as Array).splice(_arg3, 0, _arg2);
        }

        public function removeItemAt(_arg1:Object, _arg2:int):Object
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Array).splice(_arg2, 1)[0]);
        }

        public function getItemIndex(_arg1:Object, _arg2:Object):int
        {
            this.checkForCorrectDataType(_arg1);
            return ((_arg1 as Array).indexOf(_arg2));
        }

        protected function checkForCorrectDataType(_arg1:Object):void
        {
            if (!(_arg1 is Array))
            {
                throw (new IllegalOperationError((("Expected Array. Received " + Object(_arg1).constructor) + " instead.")));
            };
        }


    }
}//package org.josht.starling.foxhole.data
