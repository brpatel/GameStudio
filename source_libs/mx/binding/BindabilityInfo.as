//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.binding
{
    import mx.core.mx_internal;
    import mx.events.PropertyChangeEvent;

    use namespace mx_internal;

    public class BindabilityInfo 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const BINDABLE:String = "Bindable";
        public static const MANAGED:String = "Managed";
        public static const CHANGE_EVENT:String = "ChangeEvent";
        public static const NON_COMMITTING_CHANGE_EVENT:String = "NonCommittingChangeEvent";
        public static const ACCESSOR:String = "accessor";
        public static const METHOD:String = "method";

        private var typeDescription:XML;
        private var classChangeEvents:Object;
        private var childChangeEvents:Object;

        public function BindabilityInfo(_arg1:XML)
        {
            this.childChangeEvents = {};
            super();
            this.typeDescription = _arg1;
        }

        public function getChangeEvents(_arg1:String):Object
        {
            var childDesc:XMLList;
            var numChildren:int;
            var childName:String = _arg1;
            var changeEvents:Object = this.childChangeEvents[childName];
            if (!changeEvents)
            {
                changeEvents = this.copyProps(this.getClassChangeEvents(), {});
                childDesc = (this.typeDescription.accessor.(@name == childName) + this.typeDescription.method.(@name == childName));
                numChildren = childDesc.length();
                if (numChildren == 0)
                {
                    if (!this.typeDescription.@dynamic)
                    {
                        trace((((("warning: no describeType entry for '" + childName) + "' on non-dynamic type '") + this.typeDescription.@name) + "'"));
                    };
                }
                else
                {
                    if (numChildren > 1)
                    {
                        trace(((((("warning: multiple describeType entries for '" + childName) + "' on type '") + this.typeDescription.@name) + "':\n") + childDesc));
                    };
                    this.addBindabilityEvents(childDesc.metadata, changeEvents);
                };
                this.childChangeEvents[childName] = changeEvents;
            };
            return (changeEvents);
        }

        private function getClassChangeEvents():Object
        {
            if (!this.classChangeEvents)
            {
                this.classChangeEvents = {};
                this.addBindabilityEvents(this.typeDescription.metadata, this.classChangeEvents);
                if (this.typeDescription.metadata.(@name == MANAGED).length() > 0)
                {
                    this.classChangeEvents[PropertyChangeEvent.PROPERTY_CHANGE] = true;
                };
            };
            return (this.classChangeEvents);
        }

        private function addBindabilityEvents(_arg1:XMLList, _arg2:Object):void
        {
            var metadata:XMLList = _arg1;
            var eventListObj:Object = _arg2;
            this.addChangeEvents(metadata.(@name == BINDABLE), eventListObj, true);
            this.addChangeEvents(metadata.(@name == CHANGE_EVENT), eventListObj, true);
            this.addChangeEvents(metadata.(@name == NON_COMMITTING_CHANGE_EVENT), eventListObj, false);
        }

        private function addChangeEvents(_arg1:XMLList, _arg2:Object, _arg3:Boolean):void
        {
            var _local4:XML;
            var _local5:XMLList;
            var _local6:String;
            for each (_local4 in _arg1)
            {
                _local5 = _local4.arg;
                if (_local5.length() > 0)
                {
                    _local6 = _local5[0].@value;
                    _arg2[_local6] = _arg3;
                }
                else
                {
                    trace((("warning: unconverted Bindable metadata in class '" + this.typeDescription.@name) + "'"));
                };
            };
        }

        private function copyProps(_arg1:Object, _arg2:Object):Object
        {
            var _local3:String;
            for (_local3 in _arg1)
            {
                _arg2[_local3] = _arg1[_local3];
            };
            return (_arg2);
        }


    }
}//package mx.binding
