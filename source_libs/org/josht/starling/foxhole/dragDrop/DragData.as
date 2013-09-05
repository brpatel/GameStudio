//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.dragDrop
{
    public class DragData 
    {

        protected var _data:Object;

        public function DragData()
        {
            this._data = {};
            super();
        }

        public function hasDataForFormat(_arg1:String):Boolean
        {
            return (this._data.hasOwnProperty(_arg1));
        }

        public function getDataForFormat(_arg1:String)
        {
            if (this._data.hasOwnProperty(_arg1))
            {
                return (this._data[_arg1]);
            };
            return (undefined);
        }

        public function setDataForFormat(_arg1:String, _arg2):void
        {
            this._data[_arg1] = _arg2;
        }

        public function clearDataForFormat(_arg1:String)
        {
            var _local2:* = undefined;
            if (this._data.hasOwnProperty(_arg1))
            {
                _local2 = this._data[_arg1];
            };
            delete this._data[_arg1];
            return (_local2);
        }


    }
}//package org.josht.starling.foxhole.dragDrop
