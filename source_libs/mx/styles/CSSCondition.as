//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    public class CSSCondition 
    {

        private var _kind:String;
        private var _value:String;

        public function CSSCondition(_arg1:String, _arg2:String)
        {
            this._kind = _arg1;
            this._value = _arg2;
        }

        public function get kind():String
        {
            return (this._kind);
        }

        public function get specificity():int
        {
            if (this.kind == CSSConditionKind.ID)
            {
                return (100);
            };
            if (this.kind == CSSConditionKind.CLASS)
            {
                return (10);
            };
            if (this.kind == CSSConditionKind.PSEUDO)
            {
                return (10);
            };
            return (0);
        }

        public function get value():String
        {
            return (this._value);
        }

        public function matchesStyleClient(_arg1:IAdvancedStyleClient):Boolean
        {
            var _local3:Array;
            var _local4:uint;
            var _local2:Boolean;
            if (this.kind == CSSConditionKind.CLASS)
            {
                if (((!((_arg1.styleName == null))) && ((_arg1.styleName is String))))
                {
                    _local3 = _arg1.styleName.split(/\s+/);
                    _local4 = 0;
                    while (_local4 < _local3.length)
                    {
                        if (_local3[_local4] == this.value)
                        {
                            _local2 = true;
                            break;
                        };
                        _local4++;
                    };
                };
            }
            else
            {
                if (this.kind == CSSConditionKind.ID)
                {
                    if (_arg1.id == this.value)
                    {
                        _local2 = true;
                    };
                }
                else
                {
                    if (this.kind == CSSConditionKind.PSEUDO)
                    {
                        if (_arg1.matchesCSSState(this.value))
                        {
                            _local2 = true;
                        };
                    };
                };
            };
            return (_local2);
        }

        public function toString():String
        {
            var _local1:String;
            if (this.kind == CSSConditionKind.CLASS)
            {
                _local1 = ("." + this.value);
            }
            else
            {
                if (this.kind == CSSConditionKind.ID)
                {
                    _local1 = ("#" + this.value);
                }
                else
                {
                    if (this.kind == CSSConditionKind.PSEUDO)
                    {
                        _local1 = (":" + this.value);
                    }
                    else
                    {
                        _local1 = "";
                    };
                };
            };
            return (_local1);
        }


    }
}//package mx.styles
