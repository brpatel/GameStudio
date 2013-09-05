//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.events
{
    import flash.events.Event;
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class PropertyChangeEvent extends Event 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const PROPERTY_CHANGE:String = "propertyChange";

        public var kind:String;
        public var newValue:Object;
        public var oldValue:Object;
        public var property:Object;
        public var source:Object;

        public function PropertyChangeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Object=null, _arg6:Object=null, _arg7:Object=null, _arg8:Object=null)
        {
            super(_arg1, _arg2, _arg3);
            this.kind = _arg4;
            this.property = _arg5;
            this.oldValue = _arg6;
            this.newValue = _arg7;
            this.source = _arg8;
        }

        public static function createUpdateEvent(_arg1:Object, _arg2:Object, _arg3:Object, _arg4:Object):PropertyChangeEvent
        {
            var _local5:PropertyChangeEvent = new PropertyChangeEvent(PROPERTY_CHANGE);
            _local5.kind = PropertyChangeEventKind.UPDATE;
            _local5.oldValue = _arg3;
            _local5.newValue = _arg4;
            _local5.source = _arg1;
            _local5.property = _arg2;
            return (_local5);
        }


        override public function clone():Event
        {
            return (new PropertyChangeEvent(type, bubbles, cancelable, this.kind, this.property, this.oldValue, this.newValue, this.source));
        }


    }
}//package mx.events
