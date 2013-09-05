//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.messaging
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.events.PropertyChangeEvent;

    use namespace mx_internal;

    public class FlexClient extends EventDispatcher 
    {

        mx_internal static const NULL_FLEXCLIENT_ID:String = "nil";

        private static var _instance:FlexClient;

        private var _id:String;
        private var _waitForFlexClientId:Boolean = false;


        public static function getInstance():FlexClient
        {
            if (_instance == null)
            {
                _instance = new (FlexClient)();
            };
            return (_instance);
        }


        [Bindable(event="propertyChange")]
        public function get id():String
        {
            return (this._id);
        }

        public function set id(_arg1:String):void
        {
            var _local2:PropertyChangeEvent;
            if (this._id != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "id", this._id, _arg1);
                this._id = _arg1;
                dispatchEvent(_local2);
            };
        }

        [Bindable(event="propertyChange")]
        mx_internal function get waitForFlexClientId():Boolean
        {
            return (this._waitForFlexClientId);
        }

        mx_internal function set waitForFlexClientId(_arg1:Boolean):void
        {
            var _local2:PropertyChangeEvent;
            if (this._waitForFlexClientId != _arg1)
            {
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "waitForFlexClientId", this._waitForFlexClientId, _arg1);
                this._waitForFlexClientId = _arg1;
                dispatchEvent(_local2);
            };
        }


    }
}//package mx.messaging
