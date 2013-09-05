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

    public class Sort extends EventDispatcher implements ISort 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        public static const ANY_INDEX_MODE:String = "any";
        public static const FIRST_INDEX_MODE:String = "first";
        public static const LAST_INDEX_MODE:String = "last";

        private var resourceManager:IResourceManager;
        private var _compareFunction:Function;
        private var usingCustomCompareFunction:Boolean;
        private var _fields:Array;
        private var fieldList:Array;
        private var _unique:Boolean;
        private var defaultEmptyField:ISortField;
        private var noFieldsDescending:Boolean = false;

        public function Sort()
        {
            this.resourceManager = ResourceManager.getInstance();
            this.fieldList = [];
            super();
        }

        public function get compareFunction():Function
        {
            return (((this.usingCustomCompareFunction) ? this._compareFunction : this.internalCompare));
        }

        public function set compareFunction(_arg1:Function):void
        {
            this._compareFunction = _arg1;
            this.usingCustomCompareFunction = !((this._compareFunction == null));
        }

        [Bindable("fieldsChanged")]
        public function get fields():Array
        {
            return (this._fields);
        }

        public function set fields(_arg1:Array):void
        {
            var _local2:ISortField;
            var _local3:int;
            this._fields = _arg1;
            this.fieldList = [];
            if (this._fields)
            {
                _local3 = 0;
                while (_local3 < this._fields.length)
                {
                    _local2 = ISortField(this._fields[_local3]);
                    this.fieldList.push(_local2.name);
                    _local3++;
                };
            };
            dispatchEvent(new Event("fieldsChanged"));
        }

        public function get unique():Boolean
        {
            return (this._unique);
        }

        public function set unique(_arg1:Boolean):void
        {
            this._unique = _arg1;
        }

        override public function toString():String
        {
            return (ObjectUtil.toString(this));
        }

        public function findItem(_arg1:Array, _arg2:Object, _arg3:String, _arg4:Boolean=false, _arg5:Function=null):int
        {
            var compareForFind:Function;
            var fieldsForCompare:Array;
            var message:String;
            var index:int;
            var fieldName:String;
            var hadPreviousFieldName:Boolean;
            var i:int;
            var hasFieldName:Boolean;
            var objIndex:int;
            var match:Boolean;
            var prevCompare:int;
            var nextCompare:int;
            var items:Array = _arg1;
            var values:Object = _arg2;
            var mode:String = _arg3;
            var returnInsertionIndex:Boolean = _arg4;
            var compareFunction = _arg5;
            if (!items)
            {
                message = this.resourceManager.getString("collections", "noItems");
                throw (new SortError(message));
            };
            if (items.length == 0)
            {
                return (((returnInsertionIndex) ? 1 : -1));
            };
            if (compareFunction == null)
            {
                compareForFind = this.compareFunction;
                if (((values) && ((this.fieldList.length > 0))))
                {
                    fieldsForCompare = [];
                    hadPreviousFieldName = true;
                    i = 0;
                    while (i < this.fieldList.length)
                    {
                        fieldName = this.fieldList[i];
                        if (fieldName)
                        {
                            try
                            {
                                hasFieldName = !((values[fieldName] === undefined));
                            }
                            catch(e:Error)
                            {
                                hasFieldName = false;
                            };
                            if (hasFieldName)
                            {
                                if (!hadPreviousFieldName)
                                {
                                    message = this.resourceManager.getString("collections", "findCondition", [fieldName]);
                                    throw (new SortError(message));
                                };
                                fieldsForCompare.push(fieldName);
                            }
                            else
                            {
                                hadPreviousFieldName = false;
                            };
                        }
                        else
                        {
                            fieldsForCompare.push(null);
                        };
                        i = (i + 1);
                    };
                    if (fieldsForCompare.length == 0)
                    {
                        message = this.resourceManager.getString("collections", "findRestriction");
                        throw (new SortError(message));
                    };
                    try
                    {
                        this.initSortFields(items[0]);
                    }
                    catch(initSortError:SortError)
                    {
                    };
                };
            }
            else
            {
                compareForFind = compareFunction;
            };
            var found:Boolean;
            var objFound:Boolean;
            index = 0;
            var lowerBound:int;
            var upperBound:int = (items.length - 1);
            var obj:Object;
            var direction:int = 1;
            while (((!(objFound)) && ((lowerBound <= upperBound))))
            {
                index = Math.round(((lowerBound + upperBound) / 2));
                obj = items[index];
                direction = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                switch (direction)
                {
                    case -1:
                        upperBound = (index - 1);
                        break;
                    case 0:
                        objFound = true;
                        switch (mode)
                        {
                            case ANY_INDEX_MODE:
                                found = true;
                                break;
                            case FIRST_INDEX_MODE:
                                found = (index == lowerBound);
                                objIndex = (index - 1);
                                match = true;
                                while (((((match) && (!(found)))) && ((objIndex >= lowerBound))))
                                {
                                    obj = items[objIndex];
                                    prevCompare = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                                    match = (prevCompare == 0);
                                    if (((!(match)) || (((match) && ((objIndex == lowerBound))))))
                                    {
                                        found = true;
                                        index = (objIndex + ((match) ? 0 : 1));
                                    };
                                    objIndex = (objIndex - 1);
                                };
                                break;
                            case LAST_INDEX_MODE:
                                found = (index == upperBound);
                                objIndex = (index + 1);
                                match = true;
                                while (((((match) && (!(found)))) && ((objIndex <= upperBound))))
                                {
                                    obj = items[objIndex];
                                    nextCompare = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                                    match = (nextCompare == 0);
                                    if (((!(match)) || (((match) && ((objIndex == upperBound))))))
                                    {
                                        found = true;
                                        index = (objIndex - ((match) ? 0 : 1));
                                    };
                                    objIndex = (objIndex + 1);
                                };
                                break;
                            default:
                                message = this.resourceManager.getString("collections", "unknownMode");
                                throw (new SortError(message));
                        };
                        break;
                    case 1:
                        lowerBound = (index + 1);
                        break;
                };
            };
            if (((!(found)) && (!(returnInsertionIndex))))
            {
                return (-1);
            };
            return ((((direction)>0) ? (index + 1) : index));
        }

        public function propertyAffectsSort(_arg1:String):Boolean
        {
            var _local3:ISortField;
            if (((this.usingCustomCompareFunction) || (!(this.fields))))
            {
                return (true);
            };
            var _local2:int;
            while (_local2 < this.fields.length)
            {
                _local3 = this.fields[_local2];
                if ((((_local3.name == _arg1)) || (_local3.usingCustomCompareFunction)))
                {
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

        public function reverse():void
        {
            var _local1:int;
            if (this.fields)
            {
                _local1 = 0;
                while (_local1 < this.fields.length)
                {
                    ISortField(this.fields[_local1]).reverse();
                    _local1++;
                };
            };
            this.noFieldsDescending = !(this.noFieldsDescending);
        }

        public function sort(_arg1:Array):void
        {
            var fixedCompareFunction:Function;
            var message:String;
            var uniqueRet1:Object;
            var fields:Array;
            var i:int;
            var sortArgs:Object;
            var uniqueRet2:Object;
            var items:Array = _arg1;
            if (((!(items)) || ((items.length <= 1))))
            {
                return;
            };
            if (this.usingCustomCompareFunction)
            {
                fixedCompareFunction = function (_arg1:Object, _arg2:Object):int
                {
                    return (compareFunction(_arg1, _arg2, _fields));
                };
                if (this.unique)
                {
                    uniqueRet1 = items.sort(fixedCompareFunction, Array.UNIQUESORT);
                    if (uniqueRet1 == 0)
                    {
                        message = this.resourceManager.getString("collections", "nonUnique");
                        throw (new SortError(message));
                    };
                }
                else
                {
                    items.sort(fixedCompareFunction);
                };
            }
            else
            {
                fields = this.fields;
                if (((fields) && ((fields.length > 0))))
                {
                    sortArgs = this.initSortFields(items[0], true);
                    if (this.unique)
                    {
                        if (((sortArgs) && ((fields.length == 1))))
                        {
                            uniqueRet2 = items.sortOn(sortArgs.fields[0], (sortArgs.options[0] | Array.UNIQUESORT));
                        }
                        else
                        {
                            uniqueRet2 = items.sort(this.internalCompare, Array.UNIQUESORT);
                        };
                        if (uniqueRet2 == 0)
                        {
                            message = this.resourceManager.getString("collections", "nonUnique");
                            throw (new SortError(message));
                        };
                    }
                    else
                    {
                        if (sortArgs)
                        {
                            items.sortOn(sortArgs.fields, sortArgs.options);
                        }
                        else
                        {
                            items.sort(this.internalCompare);
                        };
                    };
                }
                else
                {
                    items.sort(this.internalCompare);
                };
            };
        }

        private function initSortFields(_arg1:Object, _arg2:Boolean=false):Object
        {
            var _local4:int;
            var _local5:ISortField;
            var _local6:int;
            var _local3:Object;
            _local4 = 0;
            while (_local4 < this.fields.length)
            {
                ISortField(this.fields[_local4]).initializeDefaultCompareFunction(_arg1);
                _local4++;
            };
            if (_arg2)
            {
                _local3 = {
                    fields:[],
                    options:[]
                };
                _local4 = 0;
                while (_local4 < this.fields.length)
                {
                    _local5 = this.fields[_local4];
                    _local6 = _local5.arraySortOnOptions;
                    if (_local6 == -1)
                    {
                        return (null);
                    };
                    _local3.fields.push(_local5.name);
                    _local3.options.push(_local6);
                    _local4++;
                };
            };
            return (_local3);
        }

        private function internalCompare(_arg1:Object, _arg2:Object, _arg3:Array=null):int
        {
            var _local5:int;
            var _local6:int;
            var _local7:ISortField;
            var _local4:int;
            if (!this._fields)
            {
                _local4 = this.noFieldsCompare(_arg1, _arg2);
            }
            else
            {
                _local5 = 0;
                _local6 = ((_arg3) ? _arg3.length : this._fields.length);
                while ((((_local4 == 0)) && ((_local5 < _local6))))
                {
                    _local7 = ISortField(this._fields[_local5]);
                    _local4 = _local7.compareFunction(_arg1, _arg2);
                    if (_local7.descending)
                    {
                        _local4 = (_local4 * -1);
                    };
                    _local5++;
                };
            };
            return (_local4);
        }

        private function noFieldsCompare(_arg1:Object, _arg2:Object, _arg3:Array=null):int
        {
            var message:String;
            var a:Object = _arg1;
            var b:Object = _arg2;
            var fields = _arg3;
            if (!this.defaultEmptyField)
            {
                this.defaultEmptyField = new SortField();
                try
                {
                    this.defaultEmptyField.initializeDefaultCompareFunction(a);
                }
                catch(e:SortError)
                {
                    message = resourceManager.getString("collections", "noComparator", [a]);
                    throw (new SortError(message));
                };
            };
            var result:int = this.defaultEmptyField.compareFunction(a, b);
            if (this.noFieldsDescending)
            {
                result = (result * -1);
            };
            return (result);
        }


    }
}//package mx.collections
