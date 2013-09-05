//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.skins
{
    import flash.utils.Dictionary;
    import org.josht.starling.foxhole.core.IToggle;

    public class StateWithToggleValueSelector 
    {

        protected var stateToValue:Dictionary;
        protected var stateToSelectedValue:Dictionary;
        public var defaultValue:Object;
        public var defaultSelectedValue:Object;

        public function StateWithToggleValueSelector()
        {
            this.stateToValue = new Dictionary(true);
            this.stateToSelectedValue = new Dictionary(true);
            super();
        }

        public function setValueForState(_arg1:Object, _arg2:Object, _arg3:Boolean=false):void
        {
            if (_arg3)
            {
                this.stateToSelectedValue[_arg2] = _arg1;
            }
            else
            {
                this.stateToValue[_arg2] = _arg1;
            };
        }

        public function clearValueForState(_arg1:Object, _arg2:Boolean=false):Object
        {
            var _local3:Object;
            if (_arg2)
            {
                _local3 = this.stateToSelectedValue[_arg1];
                delete this.stateToSelectedValue[_arg1];
            }
            else
            {
                _local3 = this.stateToValue[_arg1];
                delete this.stateToValue[_arg1];
            };
            return (_local3);
        }

        public function getValueForState(_arg1:Object, _arg2:Boolean=false):Object
        {
            if (_arg2)
            {
                return (this.stateToSelectedValue[_arg1]);
            };
            return (this.stateToValue[_arg1]);
        }

        public function updateValue(_arg1:Object, _arg2:Object, _arg3:Object=null):Object
        {
            var _local4:Object;
            if ((((_arg1 is IToggle)) && (IToggle(_arg1).isSelected)))
            {
                _local4 = this.stateToSelectedValue[_arg2];
                if (!_local4)
                {
                    _local4 = this.defaultSelectedValue;
                };
            }
            else
            {
                _local4 = this.stateToValue[_arg2];
            };
            if (!_local4)
            {
                _local4 = this.defaultValue;
            };
            return (_local4);
        }


    }
}//package org.josht.starling.foxhole.skins
