//Created by Action Script Viewer - http://www.buraks.com/asv
package org.swiftsuspenders.injectionpoints
{
    import org.swiftsuspenders.Injector;

    public class PostConstructInjectionPoint extends InjectionPoint 
    {

        protected var methodName:String;
        protected var orderValue:int;

        public function PostConstructInjectionPoint(_arg1:XML, _arg2:Injector=null)
        {
            super(_arg1, _arg2);
        }

        public function get order():int
        {
            return (this.orderValue);
        }

        override public function applyInjection(_arg1:Object, _arg2:Injector):Object
        {
            var _local3 = _arg1;
            (_local3[this.methodName]());
            return (_arg1);
        }

        override protected function initializeInjection(_arg1:XML):void
        {
            var orderArg:XMLList;
            var methodNode:XML;
            var node:XML = _arg1;
            orderArg = node.arg.(@key == "order");
            methodNode = node.parent();
            this.orderValue = int(orderArg.@value);
            this.methodName = methodNode.@name.toString();
        }


    }
}//package org.swiftsuspenders.injectionpoints
