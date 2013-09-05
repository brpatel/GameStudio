//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.core
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class TokenList 
    {

        protected var names:Vector.<String>;

        public function TokenList()
        {
            this.names = new <String>[];
            super();
        }

        public function get value():String
        {
            return (this.names.join(" "));
        }

        public function set value(_arg1:String):void
        {
            this.names.length = 0;
            this.names = Vector.<String>(_arg1.split(" "));
        }

        public function get length():int
        {
            return (this.names.length);
        }

        public function item(_arg1:int):String
        {
            if ((((_arg1 < 0)) || ((_arg1 >= this.names.length))))
            {
                return (null);
            };
            return (this.names[_arg1]);
        }

        public function add(_arg1:String):void
        {
            var _local2:int = this.names.indexOf(_arg1);
            if (_local2 >= 0)
            {
                return;
            };
            this.names.push(_arg1);
        }

        public function remove(_arg1:String):void
        {
            var _local2:int = this.names.indexOf(_arg1);
            if (_local2 < 0)
            {
                return;
            };
            this.names.splice(_local2, 1);
        }

        public function toggle(_arg1:String):void
        {
            var _local2:int = this.names.indexOf(_arg1);
            if (_local2 < 0)
            {
                this.names.push(_arg1);
            }
            else
            {
                this.names.splice(_local2, 1);
            };
        }

        public function contains(_arg1:String):Boolean
        {
            return ((this.names.indexOf(_arg1) >= 0));
        }


    }
}//package org.josht.starling.foxhole.core
