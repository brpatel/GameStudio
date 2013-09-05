//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class CSSSelector 
    {

        private var _ancestor:CSSSelector;
        private var _conditions:Array;
        private var _subject:String;

        public function CSSSelector(_arg1:String, _arg2:Array=null, _arg3:CSSSelector=null)
        {
            this._subject = _arg1;
            this._conditions = _arg2;
            this._ancestor = _arg3;
        }

        public function get ancestor():CSSSelector
        {
            return (this._ancestor);
        }

        public function get conditions():Array
        {
            return (this._conditions);
        }

        public function get specificity():int
        {
            var _local2:CSSCondition;
            var _local1:int;
            if (((((!(("*" == this.subject))) && (!(("global" == this.subject))))) && (!(("" == this.subject)))))
            {
                _local1 = 1;
            };
            if (this.conditions != null)
            {
                for each (_local2 in this.conditions)
                {
                    _local1 = (_local1 + _local2.specificity);
                };
            };
            if (this.ancestor != null)
            {
                _local1 = (_local1 + this.ancestor.specificity);
            };
            return (_local1);
        }

        public function get subject():String
        {
            return (this._subject);
        }

        public function matchesStyleClient(_arg1:IAdvancedStyleClient):Boolean
        {
            var _local4:IAdvancedStyleClient;
            var _local2:Boolean;
            var _local3:CSSCondition;
            if (this.ancestor)
            {
                if (this.conditions)
                {
                    for each (_local3 in this.conditions)
                    {
                        _local2 = _local3.matchesStyleClient(_arg1);
                        if (!_local2)
                        {
                            return (false);
                        };
                    };
                };
                _local2 = false;
                _local4 = _arg1.styleParent;
                while (_local4 != null)
                {
                    if (((_local4.matchesCSSType(this.ancestor.subject)) || (("*" == this.ancestor.subject))))
                    {
                        _local2 = this.ancestor.matchesStyleClient(_local4);
                        if (_local2) break;
                    };
                    _local4 = _local4.styleParent;
                };
            }
            else
            {
                if ((((((this.subject == "*")) || ((this.subject == "")))) || (_arg1.matchesCSSType(this.subject))))
                {
                    _local2 = true;
                };
                if (((_local2) && (!((this.conditions == null)))))
                {
                    for each (_local3 in this.conditions)
                    {
                        _local2 = _local3.matchesStyleClient(_arg1);
                        if (!_local2)
                        {
                            return (false);
                        };
                    };
                };
            };
            return (_local2);
        }

        mx_internal function getPseudoCondition():String
        {
            var _local2:CSSCondition;
            var _local1:String;
            if (this.conditions)
            {
                for each (_local2 in this.conditions)
                {
                    if (_local2.kind == CSSConditionKind.PSEUDO)
                    {
                        _local1 = _local2.value;
                        break;
                    };
                };
            };
            return (_local1);
        }

        public function toString():String
        {
            var _local1:String;
            var _local2:CSSCondition;
            if (this.ancestor != null)
            {
                _local1 = ((this.ancestor.toString() + " ") + this.subject);
            }
            else
            {
                _local1 = this.subject;
            };
            if (this.conditions != null)
            {
                for each (_local2 in this.conditions)
                {
                    _local1 = (_local1 + _local2.toString());
                };
            };
            return (_local1);
        }


    }
}//package mx.styles
