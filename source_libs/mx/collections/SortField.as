//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.collections
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import flash.events.Event;
    import mx.utils.ObjectUtil;
    import mx.collections.errors.SortError;

    use namespace mx_internal;

    public class SortField extends EventDispatcher implements ISortField 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var resourceManager:IResourceManager;
        private var _caseInsensitive:Boolean;
        private var _compareFunction:Function;
        private var _descending:Boolean;
        private var _name:String;
        private var _numeric:Object;
        private var _usingCustomCompareFunction:Boolean;

        public function SortField(_arg1:String=null, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Object=null)
        {
            this.resourceManager = ResourceManager.getInstance();
            super();
            this._name = _arg1;
            this._caseInsensitive = _arg2;
            this._descending = _arg3;
            this._numeric = _arg4;
            this._compareFunction = this.stringCompare;
        }

        public function get arraySortOnOptions():int
        {
            if (((((((this.usingCustomCompareFunction) || ((this.name == null)))) || ((this._compareFunction == this.xmlCompare)))) || ((this._compareFunction == this.dateCompare))))
            {
                return (-1);
            };
            var _local1:int;
            if (this.caseInsensitive)
            {
                _local1 = (_local1 | Array.CASEINSENSITIVE);
            };
            if (this.descending)
            {
                _local1 = (_local1 | Array.DESCENDING);
            };
            if ((((this.numeric == true)) || ((this._compareFunction == this.numericCompare))))
            {
                _local1 = (_local1 | Array.NUMERIC);
            };
            return (_local1);
        }

        [Bindable("caseInsensitiveChanged")]
        public function get caseInsensitive():Boolean
        {
            return (this._caseInsensitive);
        }

        public function set caseInsensitive(_arg1:Boolean):void
        {
            if (_arg1 != this._caseInsensitive)
            {
                this._caseInsensitive = _arg1;
                dispatchEvent(new Event("caseInsensitiveChanged"));
            };
        }

        public function get compareFunction():Function
        {
            return (this._compareFunction);
        }

        public function set compareFunction(_arg1:Function):void
        {
            this._compareFunction = _arg1;
            this._usingCustomCompareFunction = !((_arg1 == null));
        }

        [Bindable("descendingChanged")]
        public function get descending():Boolean
        {
            return (this._descending);
        }

        public function set descending(_arg1:Boolean):void
        {
            if (this._descending != _arg1)
            {
                this._descending = _arg1;
                dispatchEvent(new Event("descendingChanged"));
            };
        }

        [Bindable("nameChanged")]
        public function get name():String
        {
            return (this._name);
        }

        public function set name(_arg1:String):void
        {
            this._name = _arg1;
            dispatchEvent(new Event("nameChanged"));
        }

        [Bindable("numericChanged")]
        public function get numeric():Object
        {
            return (this._numeric);
        }

        public function set numeric(_arg1:Object):void
        {
            if (this._numeric != _arg1)
            {
                this._numeric = _arg1;
                dispatchEvent(new Event("numericChanged"));
            };
        }

        public function get usingCustomCompareFunction():Boolean
        {
            return (this._usingCustomCompareFunction);
        }

        override public function toString():String
        {
            return (ObjectUtil.toString(this));
        }

        public function initializeDefaultCompareFunction(_arg1:Object):void
        {
            var _local2:Object;
            var _local3:String;
            var _local4:String;
            if (!this.usingCustomCompareFunction)
            {
                if (this.numeric == true)
                {
                    this._compareFunction = this.numericCompare;
                }
                else
                {
                    if (((this.caseInsensitive) || ((this.numeric == false))))
                    {
                        this._compareFunction = this.stringCompare;
                    }
                    else
                    {
                        if (this._name)
                        {
                            try
                            {
                                _local2 = _arg1[this._name];
                            }
                            catch(error:Error)
                            {
                            };
                        };
                        if (_local2 == null)
                        {
                            _local2 = _arg1;
                        };
                        _local3 = typeof(_local2);
                        switch (_local3)
                        {
                            case "string":
                                this._compareFunction = this.stringCompare;
                                return;
                            case "object":
                                if ((_local2 is Date))
                                {
                                    this._compareFunction = this.dateCompare;
                                }
                                else
                                {
                                    this._compareFunction = this.stringCompare;
                                    try
                                    {
                                        _local4 = _local2.toString();
                                    }
                                    catch(error2:Error)
                                    {
                                    };
                                    if (((!(_local4)) || ((_local4 == "[object Object]"))))
                                    {
                                        this._compareFunction = this.nullCompare;
                                    };
                                };
                                return;
                            case "xml":
                                this._compareFunction = this.xmlCompare;
                                return;
                            case "boolean":
                            case "number":
                                this._compareFunction = this.numericCompare;
                                return;
                        };
                    };
                };
            };
        }

        public function reverse():void
        {
            this.descending = !(this.descending);
        }

        private function nullCompare(_arg1:Object, _arg2:Object):int
        {
            var _local3:Object;
            var _local4:Object;
            var _local5:Object;
            var _local9:String;
            var _local6:Boolean;
            if ((((_arg1 == null)) && ((_arg2 == null))))
            {
                return (0);
            };
            if (this._name)
            {
                try
                {
                    _local4 = _arg1[this._name];
                }
                catch(error:Error)
                {
                };
                try
                {
                    _local5 = _arg2[this._name];
                }
                catch(error:Error)
                {
                };
            };
            if ((((_local4 == null)) && ((_local5 == null))))
            {
                return (0);
            };
            if ((((_local4 == null)) && (!(this._name))))
            {
                _local4 = _arg1;
            };
            if ((((_local5 == null)) && (!(this._name))))
            {
                _local5 = _arg2;
            };
            var _local7 = typeof(_local4);
            var _local8 = typeof(_local5);
            if ((((_local7 == "string")) || ((_local8 == "string"))))
            {
                _local6 = true;
                this._compareFunction = this.stringCompare;
            }
            else
            {
                if ((((_local7 == "object")) || ((_local8 == "object"))))
                {
                    if ((((_local4 is Date)) || ((_local5 is Date))))
                    {
                        _local6 = true;
                        this._compareFunction = this.dateCompare;
                    };
                }
                else
                {
                    if ((((_local7 == "xml")) || ((_local8 == "xml"))))
                    {
                        _local6 = true;
                        this._compareFunction = this.xmlCompare;
                    }
                    else
                    {
                        if ((((((((_local7 == "number")) || ((_local8 == "number")))) || ((_local7 == "boolean")))) || ((_local8 == "boolean"))))
                        {
                            _local6 = true;
                            this._compareFunction = this.numericCompare;
                        };
                    };
                };
            };
            if (_local6)
            {
                return (this._compareFunction(_local4, _local5));
            };
            _local9 = this.resourceManager.getString("collections", "noComparatorSortField", [this.name]);
            throw (new SortError(_local9));
        }

        private function numericCompare(_arg1:Object, _arg2:Object):int
        {
            var _local3:Number;
            var _local4:Number;
            try
            {
                _local3 = (((this._name == null)) ? Number(_arg1) : Number(_arg1[this._name]));
            }
            catch(error:Error)
            {
            };
            try
            {
                _local4 = (((this._name == null)) ? Number(_arg2) : Number(_arg2[this._name]));
            }
            catch(error:Error)
            {
            };
            return (ObjectUtil.numericCompare(_local3, _local4));
        }

        private function dateCompare(_arg1:Object, _arg2:Object):int
        {
            var _local3:Date;
            var _local4:Date;
            try
            {
                _local3 = (((this._name == null)) ? (_arg1 as Date) : (_arg1[this._name] as Date));
            }
            catch(error:Error)
            {
            };
            try
            {
                _local4 = (((this._name == null)) ? (_arg2 as Date) : (_arg2[this._name] as Date));
            }
            catch(error:Error)
            {
            };
            return (ObjectUtil.dateCompare(_local3, _local4));
        }

        private function stringCompare(_arg1:Object, _arg2:Object):int
        {
            var _local3:String;
            var _local4:String;
            try
            {
                _local3 = (((this._name == null)) ? String(_arg1) : String(_arg1[this._name]));
            }
            catch(error:Error)
            {
            };
            try
            {
                _local4 = (((this._name == null)) ? String(_arg2) : String(_arg2[this._name]));
            }
            catch(error:Error)
            {
            };
            return (ObjectUtil.stringCompare(_local3, _local4, this._caseInsensitive));
        }

        private function xmlCompare(_arg1:Object, _arg2:Object):int
        {
            var _local3:String;
            var _local4:String;
            try
            {
                _local3 = (((this._name == null)) ? _arg1.toString() : _arg1[this._name].toString());
            }
            catch(error:Error)
            {
            };
            try
            {
                _local4 = (((this._name == null)) ? _arg2.toString() : _arg2[this._name].toString());
            }
            catch(error:Error)
            {
            };
            if (this.numeric == true)
            {
                return (ObjectUtil.numericCompare(parseFloat(_local3), parseFloat(_local4)));
            };
            return (ObjectUtil.stringCompare(_local3, _local4, this._caseInsensitive));
        }


    }
}//package mx.collections
