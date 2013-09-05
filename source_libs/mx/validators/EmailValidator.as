//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class EmailValidator extends Validator 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static const DISALLOWED_LOCALNAME_CHARS:String = "()<>,;:\\\"[] `~!#$%^&*={}|/?'";
        private static const DISALLOWED_DOMAIN_CHARS:String = "()<>,;:\\\"[] `~!#$%^&*+={}|/?'";

        private var _invalidCharError:String;
        private var invalidCharErrorOverride:String;
        private var _invalidDomainError:String;
        private var invalidDomainErrorOverride:String;
        private var _invalidIPDomainError:String;
        private var invalidIPDomainErrorOverride:String;
        private var _invalidPeriodsInDomainError:String;
        private var invalidPeriodsInDomainErrorOverride:String;
        private var _missingAtSignError:String;
        private var missingAtSignErrorOverride:String;
        private var _missingPeriodInDomainError:String;
        private var missingPeriodInDomainErrorOverride:String;
        private var _missingUsernameError:String;
        private var missingUsernameErrorOverride:String;
        private var _tooManyAtSignsError:String;
        private var tooManyAtSignsErrorOverride:String;


        public static function validateEmail(_arg1:EmailValidator, _arg2:Object, _arg3:String):Array
        {
            var _local8:int;
            var _local9:int;
            var _local13:int;
            var _local14:int;
            var _local15:String;
            var _local4:Array = [];
            var _local5:String = String(_arg2);
            var _local6 = "";
            var _local7 = "";
            var _local10:int = _local5.indexOf("@");
            if (_local10 == -1)
            {
                _local4.push(new ValidationResult(true, _arg3, "missingAtSign", _arg1.missingAtSignError));
                return (_local4);
            };
            if (_local5.indexOf("@", (_local10 + 1)) != -1)
            {
                _local4.push(new ValidationResult(true, _arg3, "tooManyAtSigns", _arg1.tooManyAtSignsError));
                return (_local4);
            };
            _local6 = _local5.substring(0, _local10);
            _local7 = _local5.substring((_local10 + 1));
            var _local11:int = _local6.length;
            if (_local11 == 0)
            {
                _local4.push(new ValidationResult(true, _arg3, "missingUsername", _arg1.missingUsernameError));
                return (_local4);
            };
            _local9 = 0;
            while (_local9 < _local11)
            {
                if (DISALLOWED_LOCALNAME_CHARS.indexOf(_local6.charAt(_local9)) != -1)
                {
                    _local4.push(new ValidationResult(true, _arg3, "invalidChar", _arg1.invalidCharError));
                    return (_local4);
                };
                _local9++;
            };
            var _local12:int = _local7.length;
            if ((((_local7.charAt(0) == "[")) && ((_local7.charAt((_local12 - 1)) == "]"))))
            {
                if (!isValidIPAddress(_local7.substring(1, (_local12 - 1))))
                {
                    _local4.push(new ValidationResult(true, _arg3, "invalidIPDomain", _arg1.invalidIPDomainError));
                    return (_local4);
                };
            }
            else
            {
                _local13 = _local7.indexOf(".");
                _local14 = 0;
                _local15 = "";
                if (_local13 == -1)
                {
                    _local4.push(new ValidationResult(true, _arg3, "missingPeriodInDomain", _arg1.missingPeriodInDomainError));
                    return (_local4);
                };
                while (true)
                {
                    _local14 = _local7.indexOf(".", (_local13 + 1));
                    if (_local14 == -1)
                    {
                        _local15 = _local7.substring((_local13 + 1));
                        if (((((((!((_local15.length == 3))) && (!((_local15.length == 2))))) && (!((_local15.length == 4))))) && (!((_local15.length == 6)))))
                        {
                            _local4.push(new ValidationResult(true, _arg3, "invalidDomain", _arg1.invalidDomainError));
                            return (_local4);
                        };
                        break;
                    };
                    if (_local14 == (_local13 + 1))
                    {
                        _local4.push(new ValidationResult(true, _arg3, "invalidPeriodsInDomain", _arg1.invalidPeriodsInDomainError));
                        return (_local4);
                    };
                    _local13 = _local14;
                };
                _local9 = 0;
                while (_local9 < _local12)
                {
                    if (DISALLOWED_DOMAIN_CHARS.indexOf(_local7.charAt(_local9)) != -1)
                    {
                        _local4.push(new ValidationResult(true, _arg3, "invalidChar", _arg1.invalidCharError));
                        return (_local4);
                    };
                    _local9++;
                };
                if (_local7.charAt(0) == ".")
                {
                    _local4.push(new ValidationResult(true, _arg3, "invalidDomain", _arg1.invalidDomainError));
                    return (_local4);
                };
            };
            return (_local4);
        }

        private static function isValidIPAddress(_arg1:String):Boolean
        {
            var _local5:Number;
            var _local6:int;
            var _local7:int;
            var _local8:Boolean;
            var _local9:Boolean;
            var _local2:Array = [];
            var _local3:int;
            var _local4:int;
            if (_arg1.indexOf(":") != -1)
            {
                _local8 = !((_arg1.indexOf("::") == -1));
                if (_local8)
                {
                    _arg1 = _arg1.replace(/^::/, "");
                    _arg1 = _arg1.replace(/::/g, ":");
                };
                while (true)
                {
                    _local4 = _arg1.indexOf(":", _local3);
                    if (_local4 != -1)
                    {
                        _local2.push(_arg1.substring(_local3, _local4));
                    }
                    else
                    {
                        _local2.push(_arg1.substring(_local3));
                        break;
                    };
                    _local3 = (_local4 + 1);
                };
                _local6 = _local2.length;
                _local9 = !((_local2[(_local6 - 1)].indexOf(".") == -1));
                if (_local9)
                {
                    if (((((!((_local2.length == 7))) && (!(_local8)))) || ((_local2.length > 7))))
                    {
                        return (false);
                    };
                    _local7 = 0;
                    while (_local7 < _local6)
                    {
                        if (_local7 == (_local6 - 1))
                        {
                            return (isValidIPAddress(_local2[_local7]));
                        };
                        _local5 = parseInt(_local2[_local7], 16);
                        if (_local5 != 0)
                        {
                            return (false);
                        };
                        _local7++;
                    };
                }
                else
                {
                    if (((((!((_local2.length == 8))) && (!(_local8)))) || ((_local2.length > 8))))
                    {
                        return (false);
                    };
                    _local7 = 0;
                    while (_local7 < _local6)
                    {
                        _local5 = parseInt(_local2[_local7], 16);
                        if (((((isNaN(_local5)) || ((_local5 < 0)))) || ((_local5 > 0xFFFF))))
                        {
                            return (false);
                        };
                        _local7++;
                    };
                };
                return (true);
            };
            if (_arg1.indexOf(".") != -1)
            {
                while (true)
                {
                    _local4 = _arg1.indexOf(".", _local3);
                    if (_local4 != -1)
                    {
                        _local2.push(_arg1.substring(_local3, _local4));
                    }
                    else
                    {
                        _local2.push(_arg1.substring(_local3));
                        break;
                    };
                    _local3 = (_local4 + 1);
                };
                if (_local2.length != 4)
                {
                    return (false);
                };
                _local6 = _local2.length;
                _local7 = 0;
                while (_local7 < _local6)
                {
                    _local5 = Number(_local2[_local7]);
                    if (((((isNaN(_local5)) || ((_local5 < 0)))) || ((_local5 > 0xFF))))
                    {
                        return (false);
                    };
                    _local7++;
                };
                return (true);
            };
            return (false);
        }


        public function get invalidCharError():String
        {
            return (this._invalidCharError);
        }

        public function set invalidCharError(_arg1:String):void
        {
            this.invalidCharErrorOverride = _arg1;
            this._invalidCharError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "invalidCharErrorEV"));
        }

        public function get invalidDomainError():String
        {
            return (this._invalidDomainError);
        }

        public function set invalidDomainError(_arg1:String):void
        {
            this.invalidDomainErrorOverride = _arg1;
            this._invalidDomainError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "invalidDomainErrorEV"));
        }

        public function get invalidIPDomainError():String
        {
            return (this._invalidIPDomainError);
        }

        public function set invalidIPDomainError(_arg1:String):void
        {
            this.invalidIPDomainErrorOverride = _arg1;
            this._invalidIPDomainError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "invalidIPDomainError"));
        }

        public function get invalidPeriodsInDomainError():String
        {
            return (this._invalidPeriodsInDomainError);
        }

        public function set invalidPeriodsInDomainError(_arg1:String):void
        {
            this.invalidPeriodsInDomainErrorOverride = _arg1;
            this._invalidPeriodsInDomainError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "invalidPeriodsInDomainError"));
        }

        public function get missingAtSignError():String
        {
            return (this._missingAtSignError);
        }

        public function set missingAtSignError(_arg1:String):void
        {
            this.missingAtSignErrorOverride = _arg1;
            this._missingAtSignError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "missingAtSignError"));
        }

        public function get missingPeriodInDomainError():String
        {
            return (this._missingPeriodInDomainError);
        }

        public function set missingPeriodInDomainError(_arg1:String):void
        {
            this.missingPeriodInDomainErrorOverride = _arg1;
            this._missingPeriodInDomainError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "missingPeriodInDomainError"));
        }

        public function get missingUsernameError():String
        {
            return (this._missingUsernameError);
        }

        public function set missingUsernameError(_arg1:String):void
        {
            this.missingUsernameErrorOverride = _arg1;
            this._missingUsernameError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "missingUsernameError"));
        }

        public function get tooManyAtSignsError():String
        {
            return (this._tooManyAtSignsError);
        }

        public function set tooManyAtSignsError(_arg1:String):void
        {
            this.tooManyAtSignsErrorOverride = _arg1;
            this._tooManyAtSignsError = (((_arg1)!=null) ? _arg1 : resourceManager.getString("validators", "tooManyAtSignsError"));
        }

        override protected function resourcesChanged():void
        {
            super.resourcesChanged();
            this.invalidCharError = this.invalidCharErrorOverride;
            this.invalidDomainError = this.invalidDomainErrorOverride;
            this.invalidIPDomainError = this.invalidIPDomainErrorOverride;
            this.invalidPeriodsInDomainError = this.invalidPeriodsInDomainErrorOverride;
            this.missingAtSignError = this.missingAtSignErrorOverride;
            this.missingPeriodInDomainError = this.missingPeriodInDomainErrorOverride;
            this.missingUsernameError = this.missingUsernameErrorOverride;
            this.tooManyAtSignsError = this.tooManyAtSignsErrorOverride;
        }

        override protected function doValidation(_arg1:Object):Array
        {
            var _local2:Array = super.doValidation(_arg1);
            var _local3:String = ((_arg1) ? String(_arg1) : "");
            if ((((_local2.length > 0)) || ((((_local3.length == 0)) && (!(required))))))
            {
                return (_local2);
            };
            return (EmailValidator.validateEmail(this, _arg1, null));
        }


    }
}//package mx.validators
