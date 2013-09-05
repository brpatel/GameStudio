//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import flash.utils.Dictionary;
    import mx.core.Singleton;
    import mx.utils.ObjectUtil;
    import mx.managers.ISystemManager;
    import mx.managers.SystemManagerGlobals;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    use namespace mx_internal;

    public class CSSStyleDeclaration extends EventDispatcher 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static const NOT_A_COLOR:uint = 0xFFFFFFFF;
        private static const FILTERMAP_PROP:String = "__reserved__filterMap";

        private var clones:Dictionary;
        mx_internal var selectorRefCount:int = 0;
        public var selectorIndex:int = 0;
        mx_internal var effects:Array;
        private var styleManager:IStyleManager2;
        private var _defaultFactory:Function;
        private var _factory:Function;
        private var _overrides:Object;
        private var _selector:CSSSelector;
        private var _selectorString:String;

        public function CSSStyleDeclaration(_arg1:Object=null, _arg2:IStyleManager2=null, _arg3:Boolean=true)
        {
            this.clones = new Dictionary(true);
            super();
            if (!_arg2)
            {
                _arg2 = (Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2);
            };
            this.styleManager = _arg2;
            if (_arg1)
            {
                if ((_arg1 is CSSSelector))
                {
                    this.selector = (_arg1 as CSSSelector);
                }
                else
                {
                    this.selectorString = _arg1.toString();
                };
                if (_arg3)
                {
                    _arg2.setStyleDeclaration(this.selectorString, this, false);
                };
            };
        }

        public function get defaultFactory():Function
        {
            return (this._defaultFactory);
        }

        public function set defaultFactory(_arg1:Function):void
        {
            this._defaultFactory = _arg1;
        }

        public function get factory():Function
        {
            return (this._factory);
        }

        public function set factory(_arg1:Function):void
        {
            this._factory = _arg1;
        }

        public function get overrides():Object
        {
            return (this._overrides);
        }

        public function set overrides(_arg1:Object):void
        {
            this._overrides = _arg1;
        }

        public function get selector():CSSSelector
        {
            return (this._selector);
        }

        public function set selector(_arg1:CSSSelector):void
        {
            this._selector = _arg1;
            this._selectorString = null;
        }

        mx_internal function get selectorString():String
        {
            if ((((this._selectorString == null)) && (!((this._selector == null)))))
            {
                this._selectorString = this._selector.toString();
            };
            return (this._selectorString);
        }

        mx_internal function set selectorString(_arg1:String):void
        {
            var _local2:CSSCondition;
            if (_arg1.charAt(0) == ".")
            {
                _local2 = new CSSCondition(CSSConditionKind.CLASS, _arg1.substr(1));
                this._selector = new CSSSelector("", [_local2]);
            }
            else
            {
                this._selector = new CSSSelector(_arg1);
            };
            this._selectorString = _arg1;
        }

        public function get specificity():int
        {
            return (((this._selector) ? this._selector.specificity : 0));
        }

        public function get subject():String
        {
            if (this._selector != null)
            {
                if ((((this._selector.subject == "")) && (this._selector.conditions)))
                {
                    return ("*");
                };
                return (this._selector.subject);
            };
            return (null);
        }

        mx_internal function getPseudoCondition():String
        {
            return ((((this.selector)!=null) ? this.selector.getPseudoCondition() : null));
        }

        mx_internal function isAdvanced():Boolean
        {
            var _local1:CSSCondition;
            if (this.selector != null)
            {
                if (this.selector.ancestor)
                {
                    return (true);
                };
                if (this.selector.conditions)
                {
                    if (((!((this.subject == "*"))) && (!((this.subject == "global")))))
                    {
                        return (true);
                    };
                    for each (_local1 in this.selector.conditions)
                    {
                        if (_local1.kind != CSSConditionKind.CLASS)
                        {
                            return (true);
                        };
                    };
                };
            };
            return (false);
        }

        public function matchesStyleClient(_arg1:IAdvancedStyleClient):Boolean
        {
            return ((((this.selector)!=null) ? this.selector.matchesStyleClient(_arg1) : false));
        }

        mx_internal function equals(_arg1:CSSStyleDeclaration):Boolean
        {
            var _local2:Object;
            if (_arg1 == null)
            {
                return (false);
            };
            if (ObjectUtil.compare(this.overrides, _arg1.overrides) != 0)
            {
                return (false);
            };
            if ((((((this.factory == null)) && (!((_arg1.factory == null))))) || (((!((this.factory == null))) && ((_arg1.factory == null))))))
            {
                return (false);
            };
            if (this.factory != null)
            {
                if (ObjectUtil.compare(new this.factory(), new _arg1.factory()) != 0)
                {
                    return (false);
                };
            };
            if ((((((this.defaultFactory == null)) && (!((_arg1.defaultFactory == null))))) || (((!((this.defaultFactory == null))) && ((_arg1.defaultFactory == null))))))
            {
                return (false);
            };
            if (this.defaultFactory != null)
            {
                if (ObjectUtil.compare(new this.defaultFactory(), new _arg1.defaultFactory()) != 0)
                {
                    return (false);
                };
            };
            if (ObjectUtil.compare(this.effects, _arg1.effects))
            {
                return (false);
            };
            return (true);
        }

        public function getStyle(_arg1:String)
        {
            var _local2:*;
            var _local3:*;
            if (this.overrides)
            {
                if ((((_arg1 in this.overrides)) && ((this.overrides[_arg1] === undefined))))
                {
                    return (undefined);
                };
                _local3 = this.overrides[_arg1];
                if (_local3 !== undefined)
                {
                    return (_local3);
                };
            };
            if (this.factory != null)
            {
                this.factory.prototype = {};
                _local2 = new this.factory();
                _local3 = _local2[_arg1];
                if (_local3 !== undefined)
                {
                    return (_local3);
                };
            };
            if (this.defaultFactory != null)
            {
                this.defaultFactory.prototype = {};
                _local2 = new this.defaultFactory();
                _local3 = _local2[_arg1];
                if (_local3 !== undefined)
                {
                    return (_local3);
                };
            };
            return (undefined);
        }

        public function setStyle(_arg1:String, _arg2):void
        {
            var _local7:int;
            var _local8:ISystemManager;
            var _local9:Object;
            var _local3:Object = this.getStyle(_arg1);
            var _local4:Boolean;
            if ((((((((((this.selectorRefCount > 0)) && ((this.factory == null)))) && ((this.defaultFactory == null)))) && (!(this.overrides)))) && (!((_local3 === _arg2)))))
            {
                _local4 = true;
            };
            if (_arg2 !== undefined)
            {
                this.setLocalStyle(_arg1, _arg2);
            }
            else
            {
                if (_arg2 == _local3)
                {
                    return;
                };
                this.setLocalStyle(_arg1, _arg2);
            };
            var _local5:Array = SystemManagerGlobals.topLevelSystemManagers;
            var _local6:int = _local5.length;
            if (_local4)
            {
                _local7 = 0;
                while (_local7 < _local6)
                {
                    _local8 = _local5[_local7];
                    _local9 = _local8.getImplementation("mx.managers::ISystemManagerChildManager");
                    _local9.regenerateStyleCache(true);
                    _local7++;
                };
            };
            _local7 = 0;
            while (_local7 < _local6)
            {
                _local8 = _local5[_local7];
                _local9 = _local8.getImplementation("mx.managers::ISystemManagerChildManager");
                _local9.notifyStyleChangeInChildren(_arg1, true);
                _local7++;
            };
        }

        mx_internal function setLocalStyle(_arg1:String, _arg2):void
        {
            var _local4:Object;
            var _local5:Number;
            var _local3:Object = this.getStyle(_arg1);
            if (_arg2 === undefined)
            {
                this.clearStyleAttr(_arg1);
                return;
            };
            if ((_arg2 is String))
            {
                if (!this.styleManager)
                {
                    this.styleManager = (Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2);
                };
                _local5 = this.styleManager.getColorName(_arg2);
                if (_local5 != NOT_A_COLOR)
                {
                    _arg2 = _local5;
                };
            };
            if (this.defaultFactory != null)
            {
                _local4 = new this.defaultFactory();
                if (_local4[_arg1] !== _arg2)
                {
                    if (!this.overrides)
                    {
                        this.overrides = {};
                    };
                    this.overrides[_arg1] = _arg2;
                }
                else
                {
                    if (this.overrides)
                    {
                        delete this.overrides[_arg1];
                    };
                };
            };
            if (this.factory != null)
            {
                _local4 = new this.factory();
                if (_local4[_arg1] !== _arg2)
                {
                    if (!this.overrides)
                    {
                        this.overrides = {};
                    };
                    this.overrides[_arg1] = _arg2;
                }
                else
                {
                    if (this.overrides)
                    {
                        delete this.overrides[_arg1];
                    };
                };
            };
            if ((((this.defaultFactory == null)) && ((this.factory == null))))
            {
                if (!this.overrides)
                {
                    this.overrides = {};
                };
                this.overrides[_arg1] = _arg2;
            };
            this.updateClones(_arg1, _arg2);
        }

        public function clearStyle(_arg1:String):void
        {
            this.setStyle(_arg1, undefined);
        }

        mx_internal function createProtoChainRoot():Object
        {
            var _local1:Object = {};
            if (this.defaultFactory != null)
            {
                this.defaultFactory.prototype = _local1;
                _local1 = new this.defaultFactory();
            };
            if (this.factory != null)
            {
                this.factory.prototype = _local1;
                _local1 = new this.factory();
            };
            this.clones[_local1] = 1;
            return (_local1);
        }

        mx_internal function addStyleToProtoChain(_arg1:Object, _arg2:DisplayObject, _arg3:Object=null):Object
        {
            var style:CSSStyleDeclaration;
            var inChain:Object;
            var parentStyle:CSSStyleDeclaration;
            var emptyObjectFactory:Function;
            var chain:Object = _arg1;
            var target:DisplayObject = _arg2;
            var filterMap = _arg3;
            var nodeAddedToChain:Boolean;
            var originalChain:Object = chain;
            var parentStyleDeclarations:Vector.<CSSStyleDeclaration> = new Vector.<CSSStyleDeclaration>();
            var styleParent:IStyleManager2 = this.styleManager.parent;
            while (styleParent)
            {
                parentStyle = styleParent.getStyleDeclaration(this.selectorString);
                if (parentStyle)
                {
                    parentStyleDeclarations.unshift(parentStyle);
                };
                styleParent = styleParent.parent;
            };
            for each (style in parentStyleDeclarations)
            {
                if (style.defaultFactory != null)
                {
                    chain = style.addDefaultStyleToProtoChain(chain, target, filterMap);
                };
            };
            if (this.defaultFactory != null)
            {
                chain = this.addDefaultStyleToProtoChain(chain, target, filterMap);
            };
            var addedParentStyleToProtoChain:Boolean;
            for each (style in parentStyleDeclarations)
            {
                if (((!((style.factory == null))) || (!((style.overrides == null)))))
                {
                    chain = style.addFactoryAndOverrideStylesToProtoChain(chain, target, filterMap);
                    addedParentStyleToProtoChain = true;
                };
            };
            inChain = chain;
            if (((!((this.factory == null))) || (!((this.overrides == null)))))
            {
                chain = this.addFactoryAndOverrideStylesToProtoChain(chain, target, filterMap);
                if (inChain != chain)
                {
                    nodeAddedToChain = true;
                };
            };
            if (((!((this.defaultFactory == null))) && (!(nodeAddedToChain))))
            {
                if (addedParentStyleToProtoChain)
                {
                    emptyObjectFactory = function ():void
                    {
                    };
                    emptyObjectFactory.prototype = chain;
                    chain = new (emptyObjectFactory)();
                    emptyObjectFactory.prototype = null;
                };
                nodeAddedToChain = true;
            };
            if (nodeAddedToChain)
            {
                this.clones[chain] = 1;
            };
            return (chain);
        }

        mx_internal function addDefaultStyleToProtoChain(_arg1:Object, _arg2:DisplayObject, _arg3:Object=null):Object
        {
            var _local4:Object;
            if (this.defaultFactory != null)
            {
                _local4 = _arg1;
                if (_arg3)
                {
                    _arg1 = {};
                };
                this.defaultFactory.prototype = _arg1;
                _arg1 = new this.defaultFactory();
                this.defaultFactory.prototype = null;
                if (_arg3)
                {
                    _arg1 = this.applyFilter(_local4, _arg1, _arg3);
                };
            };
            return (_arg1);
        }

        mx_internal function addFactoryAndOverrideStylesToProtoChain(_arg1:Object, _arg2:DisplayObject, _arg3:Object=null):Object
        {
            var p:String;
            var emptyObjectFactory:Function;
            var chain:Object = _arg1;
            var target:DisplayObject = _arg2;
            var filterMap = _arg3;
            var originalChain:Object = chain;
            if (filterMap)
            {
                chain = {};
            };
            var objectFactory:Object;
            if (this.factory != null)
            {
                objectFactory = new this.factory();
                this.factory.prototype = chain;
                chain = new this.factory();
                this.factory.prototype = null;
            };
            if (this.overrides)
            {
                if (this.factory == null)
                {
                    emptyObjectFactory = function ():void
                    {
                    };
                    emptyObjectFactory.prototype = chain;
                    chain = new (emptyObjectFactory)();
                    emptyObjectFactory.prototype = null;
                };
                for (p in this.overrides)
                {
                    if (this.overrides[p] === undefined)
                    {
                        delete chain[p];
                    }
                    else
                    {
                        chain[p] = this.overrides[p];
                    };
                };
            };
            if (filterMap)
            {
                if (((!((this.factory == null))) || (this.overrides)))
                {
                    chain = this.applyFilter(originalChain, chain, filterMap);
                }
                else
                {
                    chain = originalChain;
                };
            };
            if (((!((this.factory == null))) || (this.overrides)))
            {
                this.clones[chain] = 1;
            };
            return (chain);
        }

        mx_internal function applyFilter(_arg1:Object, _arg2:Object, _arg3:Object):Object
        {
            var i:String;
            var originalChain:Object = _arg1;
            var chain:Object = _arg2;
            var filterMap:Object = _arg3;
            var filteredChain:Object = {};
            var filterObjectFactory:Function = function ():void
            {
            };
            filterObjectFactory.prototype = originalChain;
            filteredChain = new (filterObjectFactory)();
            filterObjectFactory.prototype = null;
            for (i in chain)
            {
                if (filterMap[i] != null)
                {
                    filteredChain[filterMap[i]] = chain[i];
                };
            };
            chain = filteredChain;
            chain[FILTERMAP_PROP] = filterMap;
            return (chain);
        }

        mx_internal function clearOverride(_arg1:String):void
        {
            if (((this.overrides) && (!((this.overrides[_arg1] === undefined)))))
            {
                delete this.overrides[_arg1];
            };
        }

        private function clearStyleAttr(_arg1:String):void
        {
            var _local2:*;
            if (!this.overrides)
            {
                this.overrides = {};
            };
            this.overrides[_arg1] = undefined;
            for (_local2 in this.clones)
            {
                delete _local2[_arg1];
            };
        }

        mx_internal function updateClones(_arg1:String, _arg2):void
        {
            var _local3:*;
            var _local4:Object;
            for (_local3 in this.clones)
            {
                _local4 = _local3[FILTERMAP_PROP];
                if (_local4)
                {
                    if (_local4[_arg1] != null)
                    {
                        _local3[_local4[_arg1]] = _arg2;
                    };
                }
                else
                {
                    _local3[_arg1] = _arg2;
                };
            };
        }


    }
}//package mx.styles
