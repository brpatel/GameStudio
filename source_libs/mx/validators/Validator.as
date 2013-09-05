//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.validators
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import flash.events.IEventDispatcher;
    import mx.resources.ResourceManager;
    import flash.events.Event;
    import mx.events.ValidationResultEvent;
    import mx.core.*;

    use namespace mx_internal;

    public class Validator extends EventDispatcher implements IMXMLObject, IValidator 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        protected static const ROMAN_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        protected static const DECIMAL_DIGITS:String = "0123456789";

        private var document:Object;
        private var _enabled:Boolean = true;
        private var _listener:Object;
        private var _property:String;
        public var required:Boolean = true;
        private var _resourceManager:IResourceManager;
        private var _source:Object;
        protected var subFields:Array;
        private var _trigger:IEventDispatcher;
        private var _triggerEvent:String = "valueCommit";
        private var _requiredFieldError:String;
        private var requiredFieldErrorOverride:String;

        public function Validator()
        {
            this._resourceManager = ResourceManager.getInstance();
            this.subFields = [];
            super();
            this.resourceManager.addEventListener(Event.CHANGE, this.resourceManager_changeHandler, false, 0, true);
            this.resourcesChanged();
        }

        public static function validateAll(_arg1:Array):Array
        {
            var _local5:IValidator;
            var _local6:ValidationResultEvent;
            var _local2:Array = [];
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = (_arg1[_local4] as IValidator);
                if (((_local5) && (_local5.enabled)))
                {
                    _local6 = _local5.validate();
                    if (_local6.type != ValidationResultEvent.VALID)
                    {
                        _local2.push(_local6);
                    };
                };
                _local4++;
            };
            return (_local2);
        }

        private static function findObjectFromString(_arg1:Object, _arg2:String):Object
        {
            var resourceManager:IResourceManager;
            var message:String;
            var doc:Object = _arg1;
            var value:String = _arg2;
            var obj:Object = doc;
            var parts:Array = value.split(".");
            var n:int = parts.length;
            var i:int;
            while (i < n)
            {
                try
                {
                    obj = obj[parts[i]];
                    if (obj == null)
                    {
                    };
                }
                catch(error:Error)
                {
                    if ((((error is TypeError)) && (!((error.message.indexOf("null has no properties") == -1)))))
                    {
                        resourceManager = ResourceManager.getInstance();
                        message = resourceManager.getString("validators", "fieldNotFound", [value]);
                        throw (new Error(message));
                    };
                    throw (error);
                };
                i = (i + 1);
            };
            return (obj);
        }

        private static function trimString(_arg1:String):String
        {
            var _local2:int;
            while (_arg1.indexOf(" ", _local2) == _local2)
            {
                _local2++;
            };
            var _local3:int = (_arg1.length - 1);
            while (_arg1.lastIndexOf(" ", _local3) == _local3)
            {
                _local3--;
            };
            return ((((_local3 >= _local2)) ? _arg1.slice(_local2, (_local3 + 1)) : ""));
        }


        protected function get actualTrigger():IEventDispatcher
        {
            if (this._trigger)
            {
                return (this._trigger);
            };
            if (this._source)
            {
                return ((this._source as IEventDispatcher));
            };
            return (null);
        }

        protected function get actualListeners():Array
        {
            var _local1:Array = [];
            if (this._listener)
            {
                _local1.push(this._listener);
            }
            else
            {
                if (this._source)
                {
                    _local1.push(this._source);
                };
            };
            return (_local1);
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg1:Boolean):void
        {
            this._enabled = _arg1;
        }

        public function get listener():Object
        {
            return (this._listener);
        }

        public function set listener(_arg1:Object):void
        {
            this.removeListenerHandler();
            this._listener = _arg1;
            this.addListenerHandler();
        }

        public function get property():String
        {
            return (this._property);
        }

        public function set property(_arg1:String):void
        {
            this._property = _arg1;
        }

        [Bindable("unused")]
        protected function get resourceManager():IResourceManager
        {
            return (this._resourceManager);
        }

        public function get source():Object
        {
            return (this._source);
        }

        public function set source(_arg1:Object):void
        {
            var _local2:String;
            if (this._source == _arg1)
            {
                return;
            };
            if ((_arg1 is String))
            {
                _local2 = this.resourceManager.getString("validators", "SAttribute", [_arg1]);
                throw (new Error(_local2));
            };
            this.removeTriggerHandler();
            this.removeListenerHandler();
            this._source = _arg1;
            this.addTriggerHandler();
            this.addListenerHandler();
        }

        public function get trigger():IEventDispatcher
        {
            return (this._trigger);
        }

        public function set trigger(_arg1:IEventDispatcher):void
        {
            this.removeTriggerHandler();
            this._trigger = _arg1;
            this.addTriggerHandler();
        }

        public function get triggerEvent():String
        {
            return (this._triggerEvent);
        }

        public function set triggerEvent(_arg1:String):void
        {
            if (this._triggerEvent == _arg1)
            {
                return;
            };
            this.removeTriggerHandler();
            this._triggerEvent = _arg1;
            this.addTriggerHandler();
        }

        public function get requiredFieldError():String
        {
            return (this._requiredFieldError);
        }

        public function set requiredFieldError(_arg1:String):void
        {
            this.requiredFieldErrorOverride = _arg1;
            this._requiredFieldError = (((_arg1)!=null) ? _arg1 : this.resourceManager.getString("validators", "requiredFieldError"));
        }

        public function initialized(_arg1:Object, _arg2:String):void
        {
            this.document = _arg1;
        }

        protected function resourcesChanged():void
        {
            this.requiredFieldError = this.requiredFieldErrorOverride;
        }

        private function addTriggerHandler():void
        {
            if (this.actualTrigger)
            {
                this.actualTrigger.addEventListener(this._triggerEvent, this.triggerHandler);
            };
        }

        private function removeTriggerHandler():void
        {
            if (this.actualTrigger)
            {
                this.actualTrigger.removeEventListener(this._triggerEvent, this.triggerHandler);
            };
        }

        protected function addListenerHandler():void
        {
            var _local1:Object;
            var _local2:Array = this.actualListeners;
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local1 = _local2[_local4];
                if ((_local1 is IValidatorListener))
                {
                    addEventListener(ValidationResultEvent.VALID, IValidatorListener(_local1).validationResultHandler);
                    addEventListener(ValidationResultEvent.INVALID, IValidatorListener(_local1).validationResultHandler);
                };
                _local4++;
            };
        }

        protected function removeListenerHandler():void
        {
            var _local1:Object;
            var _local2:Array = this.actualListeners;
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3)
            {
                _local1 = _local2[_local4];
                if ((_local1 is IValidatorListener))
                {
                    removeEventListener(ValidationResultEvent.VALID, IValidatorListener(_local1).validationResultHandler);
                    removeEventListener(ValidationResultEvent.INVALID, IValidatorListener(_local1).validationResultHandler);
                };
                _local4++;
            };
        }

        protected function isRealValue(_arg1:Object):Boolean
        {
            return (!((_arg1 == null)));
        }

        public function validate(_arg1:Object=null, _arg2:Boolean=false):ValidationResultEvent
        {
            var _local3:ValidationResultEvent;
            if (_arg1 == null)
            {
                _arg1 = this.getValueFromSource();
            };
            if (((this.isRealValue(_arg1)) || (this.required)))
            {
                return (this.processValidation(_arg1, _arg2));
            };
            _local3 = new ValidationResultEvent(ValidationResultEvent.VALID);
            if (((!(_arg2)) && (this._enabled)))
            {
                dispatchEvent(_local3);
            };
            return (_local3);
        }

        protected function getValueFromSource():Object
        {
            var _local1:String;
            if (((this._source) && (this._property)))
            {
                return (this._source[this._property]);
            };
            if (((!(this._source)) && (this._property)))
            {
                _local1 = this.resourceManager.getString("validators", "SAttributeMissing");
                throw (new Error(_local1));
            };
            if (((this._source) && (!(this._property))))
            {
                _local1 = this.resourceManager.getString("validators", "PAttributeMissing");
                throw (new Error(_local1));
            };
            return (null);
        }

        private function processValidation(_arg1:Object, _arg2:Boolean):ValidationResultEvent
        {
            var _local3:ValidationResultEvent;
            var _local4:Array;
            if (this._enabled)
            {
                _local4 = this.doValidation(_arg1);
                _local3 = this.handleResults(_local4);
            }
            else
            {
                _arg2 = true;
            };
            if (!_arg2)
            {
                dispatchEvent(_local3);
            };
            return (_local3);
        }

        protected function doValidation(_arg1:Object):Array
        {
            var _local2:Array = [];
            var _local3:ValidationResult = this.validateRequired(_arg1);
            if (_local3)
            {
                _local2.push(_local3);
            };
            return (_local2);
        }

        private function validateRequired(_arg1:Object):ValidationResult
        {
            var _local2:String;
            if (this.required)
            {
                _local2 = (((_arg1)!=null) ? String(_arg1) : "");
                _local2 = trimString(_local2);
                if (_local2.length == 0)
                {
                    return (new ValidationResult(true, "", "requiredField", this.requiredFieldError));
                };
            };
            return (null);
        }

        protected function handleResults(_arg1:Array):ValidationResultEvent
        {
            var _local2:ValidationResultEvent;
            var _local3:Object;
            var _local4:String;
            var _local5:int;
            var _local6:int;
            if (_arg1.length > 0)
            {
                _local2 = new ValidationResultEvent(ValidationResultEvent.INVALID);
                _local2.results = _arg1;
                if (this.subFields.length > 0)
                {
                    _local3 = {};
                    _local5 = _arg1.length;
                    _local6 = 0;
                    while (_local6 < _local5)
                    {
                        _local4 = _arg1[_local6].subField;
                        if (_local4)
                        {
                            _local3[_local4] = true;
                        };
                        _local6++;
                    };
                    _local5 = this.subFields.length;
                    _local6 = 0;
                    while (_local6 < _local5)
                    {
                        if (!_local3[this.subFields[_local6]])
                        {
                            _arg1.push(new ValidationResult(false, this.subFields[_local6]));
                        };
                        _local6++;
                    };
                };
            }
            else
            {
                _local2 = new ValidationResultEvent(ValidationResultEvent.VALID);
            };
            return (_local2);
        }

        private function triggerHandler(_arg1:Event):void
        {
            this.validate();
        }

        private function resourceManager_changeHandler(_arg1:Event):void
        {
            this.resourcesChanged();
        }


    }
}//package mx.validators
