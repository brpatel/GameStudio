//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import mx.core.mx_internal;
    import mx.utils.StringUtil;

    use namespace mx_internal;

    public class StringValidator extends Validator 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var _maxLength:Object;
        private var maxLengthOverride:Object;
        private var _minLength:Object;
        private var minLengthOverride:Object;
        private var _tooLongError:String;
        private var tooLongErrorOverride:String;
        private var _tooShortError:String;
        private var tooShortErrorOverride:String;


        public static function validateString(_arg1:StringValidator, _arg2:Object, _arg3:String=null):Array
        {
            var _local4:Array = [];
            var _local5:Number = Number(_arg1.maxLength);
            var _local6:Number = Number(_arg1.minLength);
            var _local7:String = (((_arg2)!=null) ? String(_arg2) : "");
            if (((!(isNaN(_local5))) && ((_local7.length > _local5))))
            {
                _local4.push(new ValidationResult(true, _arg3, "tooLong", StringUtil.substitute(_arg1.tooLongError, _local5)));
                return (_local4);
            };
            if (((!(isNaN(_local6))) && ((_local7.length < _local6))))
            {
                _local4.push(new ValidationResult(true, _arg3, "tooShort", StringUtil.substitute(_arg1.tooShortError, _local6)));
                return (_local4);
            };
            return (_local4);
        }


        public function get maxLength():Object
        {
            return (this._maxLength);
        }

        public function set maxLength(_arg1:Object):void
        {
            this.maxLengthOverride = _arg1;
            this._maxLength = (((_arg1)!=null) ? Number(_arg1) : resourceManager.getNumber("validators", "maxLength"));
        }

        public function get minLength():Object
        {
            return (this._minLength);
        }

        public function set minLength(_arg1:Object):void
        {
            this.minLengthOverride = _arg1;
            this._minLength = (((_arg1)!=null) ? Number(_arg1) : resourceManager.getNumber("validators", "minLength"));
        }

        public function get tooLongError():String
        {
            return (this._tooLongError);
        }

        public function set tooLongError(_arg1:String):void
        {
            this.tooLongErrorOverride = _arg1;
            this._tooLongError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "tooLongError"));
        }

        public function get tooShortError():String
        {
            return (this._tooShortError);
        }

        public function set tooShortError(_arg1:String):void
        {
            this.tooShortErrorOverride = _arg1;
            this._tooShortError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "tooShortError"));
        }

        override protected function resourcesChanged():void
        {
            super.resourcesChanged();
            this.maxLength = this.maxLengthOverride;
            this.minLength = this.minLengthOverride;
            this.tooLongError = this.tooLongErrorOverride;
            this.tooShortError = this.tooShortErrorOverride;
        }

        override protected function doValidation(_arg1:Object):Array
        {
            var _local2:Array = super.doValidation(_arg1);
            var _local3:String = ((_arg1) ? String(_arg1) : "");
            if ((((_local2.length > 0)) || ((((_local3.length == 0)) && (!(required))))))
            {
                return (_local2);
            };
            return (StringValidator.validateString(this, _arg1, null));
        }


    }
}//package mx.validators
