//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import flash.events.EventDispatcher;
    import mx.core.mx_internal;
    import mx.utils.MediaQueryParser;
    import mx.resources.IResourceManager;
    import mx.core.IFlexModuleFactory;
    import mx.events.Request;
    import mx.resources.ResourceManager;
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    import mx.events.FlexChangeEvent;
    import mx.managers.SystemManagerGlobals;
    import mx.core.FlexVersion;
    import mx.managers.ISystemManager;
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import mx.modules.IModuleInfo;
    import flash.utils.Timer;
    import mx.modules.ModuleManager;
    import mx.events.ModuleEvent;
    import mx.events.StyleEvent;
    import flash.events.TimerEvent;
    import flash.events.Event;

    use namespace mx_internal;

    public class StyleManagerImpl extends EventDispatcher implements IStyleManager2 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private static var instance:IStyleManager2;
        private static var _qualifiedTypeSelectors:Boolean = true;
        private static var propNames:Array = ["class", "id", "pseudo", "unconditional"];

        private var selectorIndex:int = 0;
        private var mqp:MediaQueryParser;
        private var inheritingTextFormatStyles:Object;
        private var sizeInvalidatingStyles:Object;
        private var parentSizeInvalidatingStyles:Object;
        private var parentDisplayListInvalidatingStyles:Object;
        private var colorNames:Object;
        private var _hasAdvancedSelectors:Boolean;
        private var _pseudoCSSStates:Object;
        private var _selectors:Object;
        private var styleModules:Object;
        private var _subjects:Object;
        private var resourceManager:IResourceManager;
        private var mergedInheritingStylesCache:Object;
        private var moduleFactory:IFlexModuleFactory;
        private var _parent:IStyleManager2;
        private var _stylesRoot:Object;
        private var _inheritingStyles:Object;
        private var _typeHierarchyCache:Object;
        private var _typeSelectorCache:Object;

        public function StyleManagerImpl(_arg1:IFlexModuleFactory)
        {
            var _local2:Request;
            var _local3:IFlexModuleFactory;
            this.inheritingTextFormatStyles = {
                align:true,
                bold:true,
                color:true,
                font:true,
                indent:true,
                italic:true,
                size:true
            };
            this.sizeInvalidatingStyles = {
                alignmentBaseline:true,
                baselineShift:true,
                blockProgression:true,
                borderStyle:true,
                borderThickness:true,
                breakOpportunity:true,
                cffHinting:true,
                columnCount:true,
                columnGap:true,
                columnWidth:true,
                digitCase:true,
                digitWidth:true,
                direction:true,
                dominantBaseline:true,
                firstBaselineOffset:true,
                fontAntiAliasType:true,
                fontFamily:true,
                fontGridFitType:true,
                fontLookup:true,
                fontSharpness:true,
                fontSize:true,
                fontStyle:true,
                fontThickness:true,
                fontWeight:true,
                headerHeight:true,
                horizontalAlign:true,
                horizontalGap:true,
                justificationRule:true,
                justificationStyle:true,
                kerning:true,
                leading:true,
                leadingModel:true,
                letterSpacing:true,
                ligatureLevel:true,
                lineBreak:true,
                lineHeight:true,
                lineThrough:true,
                listAutoPadding:true,
                listStylePosition:true,
                listStyleType:true,
                locale:true,
                marginBottom:true,
                marginLeft:true,
                marginRight:true,
                marginTop:true,
                paddingBottom:true,
                paddingLeft:true,
                paddingRight:true,
                paddingTop:true,
                paragraphEndIndent:true,
                paragraphStartIndent:true,
                paragraphSpaceAfter:true,
                paragraphSpaceBefore:true,
                renderingMode:true,
                strokeWidth:true,
                tabHeight:true,
                tabWidth:true,
                tabStops:true,
                textAlign:true,
                textAlignLast:true,
                textDecoration:true,
                textIndent:true,
                textJustify:true,
                textRotation:true,
                tracking:true,
                trackingLeft:true,
                trackingRight:true,
                typographicCase:true,
                verticalAlign:true,
                verticalGap:true,
                wordSpacing:true,
                whitespaceCollapse:true
            };
            this.parentSizeInvalidatingStyles = {
                baseline:true,
                bottom:true,
                horizontalCenter:true,
                left:true,
                right:true,
                top:true,
                verticalCenter:true
            };
            this.parentDisplayListInvalidatingStyles = {
                baseline:true,
                bottom:true,
                horizontalCenter:true,
                left:true,
                right:true,
                top:true,
                verticalCenter:true
            };
            this.colorNames = {
                transparent:"transparent",
                black:0,
                blue:0xFF,
                green:0x8000,
                gray:0x808080,
                silver:0xC0C0C0,
                lime:0xFF00,
                olive:0x808000,
                white:0xFFFFFF,
                yellow:0xFFFF00,
                maroon:0x800000,
                navy:128,
                red:0xFF0000,
                purple:0x800080,
                teal:0x8080,
                fuchsia:0xFF00FF,
                aqua:0xFFFF,
                magenta:0xFF00FF,
                cyan:0xFFFF,
                halogreen:8453965,
                haloblue:40447,
                haloorange:0xFFB600,
                halosilver:11455193
            };
            this._selectors = {};
            this.styleModules = {};
            this._subjects = {};
            this.resourceManager = ResourceManager.getInstance();
            this._inheritingStyles = {};
            super();
            this.moduleFactory = _arg1;
            this.moduleFactory.registerImplementation("mx.styles::IStyleManager2", this);
            if ((_arg1 is DisplayObject))
            {
                _local2 = new Request(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST);
                DisplayObject(_arg1).dispatchEvent(_local2);
                _local3 = (_local2.value as IFlexModuleFactory);
                if (_local3)
                {
                    this._parent = IStyleManager2(_local3.getImplementation("mx.styles::IStyleManager2"));
                    if ((this._parent is IEventDispatcher))
                    {
                        IEventDispatcher(this._parent).addEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE, this.styleManagerChangeHandler, false, 0, true);
                    };
                };
            };
        }

        public static function getInstance():IStyleManager2
        {
            if (!instance)
            {
                instance = IStyleManager2(IFlexModuleFactory(SystemManagerGlobals.topLevelSystemManagers[0]).getImplementation("mx.styles::IStyleManager2"));
                if (!instance)
                {
                    instance = new StyleManagerImpl(SystemManagerGlobals.topLevelSystemManagers[0]);
                };
            };
            return (instance);
        }


        public function get parent():IStyleManager2
        {
            return (this._parent);
        }

        public function get qualifiedTypeSelectors():Boolean
        {
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                return (false);
            };
            if (_qualifiedTypeSelectors)
            {
                return (_qualifiedTypeSelectors);
            };
            if (this.parent)
            {
                return (this.parent.qualifiedTypeSelectors);
            };
            return (false);
        }

        public function set qualifiedTypeSelectors(_arg1:Boolean):void
        {
            _qualifiedTypeSelectors = _arg1;
        }

        public function get stylesRoot():Object
        {
            return (this._stylesRoot);
        }

        public function set stylesRoot(_arg1:Object):void
        {
            this._stylesRoot = _arg1;
        }

        public function get inheritingStyles():Object
        {
            var _local2:Object;
            var _local3:Object;
            if (this.mergedInheritingStylesCache)
            {
                return (this.mergedInheritingStylesCache);
            };
            var _local1:Object = this._inheritingStyles;
            if (this.parent)
            {
                _local2 = this.parent.inheritingStyles;
                for (_local3 in _local2)
                {
                    if (_local1[_local3] === undefined)
                    {
                        _local1[_local3] = _local2[_local3];
                    };
                };
            };
            this.mergedInheritingStylesCache = _local1;
            return (_local1);
        }

        public function set inheritingStyles(_arg1:Object):void
        {
            this._inheritingStyles = _arg1;
            this.mergedInheritingStylesCache = null;
            if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
            {
                this.dispatchInheritingStylesChangeEvent();
            };
        }

        public function get typeHierarchyCache():Object
        {
            if (this._typeHierarchyCache == null)
            {
                this._typeHierarchyCache = {};
            };
            return (this._typeHierarchyCache);
        }

        public function set typeHierarchyCache(_arg1:Object):void
        {
            this._typeHierarchyCache = _arg1;
        }

        public function get typeSelectorCache():Object
        {
            if (this._typeSelectorCache == null)
            {
                this._typeSelectorCache = {};
            };
            return (this._typeSelectorCache);
        }

        public function set typeSelectorCache(_arg1:Object):void
        {
            this._typeSelectorCache = _arg1;
        }

        public function initProtoChainRoots():void
        {
            var _local1:CSSStyleDeclaration;
            if (!this.stylesRoot)
            {
                _local1 = this.getMergedStyleDeclaration("global");
                if (_local1 != null)
                {
                    this.stylesRoot = _local1.addStyleToProtoChain({}, null);
                };
            };
        }

        public function get selectors():Array
        {
            var _local2:String;
            var _local3:Array;
            var _local1:Array = [];
            for (_local2 in this._selectors)
            {
                _local1.push(_local2);
            };
            if (this.parent)
            {
                _local3 = this.parent.selectors;
                for (_local2 in _local3)
                {
                    _local1.push(_local2);
                };
            };
            return (_local1);
        }

        public function hasAdvancedSelectors():Boolean
        {
            if (this._hasAdvancedSelectors)
            {
                return (true);
            };
            if (this.parent)
            {
                return (this.parent.hasAdvancedSelectors());
            };
            return (false);
        }

        public function hasPseudoCondition(_arg1:String):Boolean
        {
            if (((!((this._pseudoCSSStates == null))) && (!((this._pseudoCSSStates[_arg1] == null)))))
            {
                return (true);
            };
            if (this.parent)
            {
                return (this.parent.hasPseudoCondition(_arg1));
            };
            return (false);
        }

        public function getStyleDeclarations(_arg1:String):Object
        {
            var _local4:int;
            var _local5:Object;
            var _local6:String;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                if (_arg1.charAt(0) != ".")
                {
                    _local4 = _arg1.lastIndexOf(".");
                    if (_local4 != -1)
                    {
                        _arg1 = _arg1.substr((_local4 + 1));
                    };
                };
            };
            var _local2:Object;
            if (this.parent)
            {
                _local2 = this.parent.getStyleDeclarations(_arg1);
            };
            var _local3:Object = this._subjects[_arg1];
            if (!_local2)
            {
                if (_local3)
                {
                    _local2 = _local3;
                };
            }
            else
            {
                if (_local3)
                {
                    _local5 = {};
                    for each (_local6 in propNames)
                    {
                        _local5[_local6] = _local3[_local6];
                    };
                    _local5.parent = _local2;
                    _local2 = _local5;
                };
            };
            return (_local2);
        }

        private function isUnique(_arg1, _arg2:int, _arg3:Array):Boolean
        {
            return ((_arg3.indexOf(_arg1) >= 0));
        }

        public function getStyleDeclaration(_arg1:String):CSSStyleDeclaration
        {
            var _local2:int;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                if (_arg1.charAt(0) != ".")
                {
                    _local2 = _arg1.lastIndexOf(".");
                    if (_local2 != -1)
                    {
                        _arg1 = _arg1.substr((_local2 + 1));
                    };
                };
            };
            return (this._selectors[_arg1]);
        }

        public function getMergedStyleDeclaration(_arg1:String):CSSStyleDeclaration
        {
            var _local2:CSSStyleDeclaration = this.getStyleDeclaration(_arg1);
            var _local3:CSSStyleDeclaration;
            if (this.parent)
            {
                _local3 = this.parent.getMergedStyleDeclaration(_arg1);
            };
            if (((_local2) || (_local3)))
            {
                _local2 = new CSSMergedStyleDeclaration(_local2, _local3, ((_local2) ? _local2.selectorString : _local3.selectorString), this, false);
            };
            return (_local2);
        }

        public function setStyleDeclaration(_arg1:String, _arg2:CSSStyleDeclaration, _arg3:Boolean):void
        {
            var _local6:int;
            var _local7:String;
            var _local8:String;
            var _local9:Object;
            var _local10:Array;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
            {
                if (_arg1.charAt(0) != ".")
                {
                    _local6 = _arg1.lastIndexOf(".");
                    if (_local6 != -1)
                    {
                        _arg1 = _arg1.substr((_local6 + 1));
                    };
                };
            };
            _arg2.selectorRefCount++;
            _arg2.selectorIndex = this.selectorIndex++;
            this._selectors[_arg1] = _arg2;
            var _local4:String = _arg2.subject;
            if (_arg1)
            {
                if (!_arg2.subject)
                {
                    _arg2.selectorString = _arg1;
                    _local4 = _arg2.subject;
                }
                else
                {
                    if (_arg1 != _arg2.selectorString)
                    {
                        _local7 = _arg1.charAt(0);
                        if ((((((_local7 == ".")) || ((_local7 == ":")))) || ((_local7 == "#"))))
                        {
                            _local4 = "*";
                        }
                        else
                        {
                            _local4 = _arg1;
                        };
                        _arg2.selectorString = _arg1;
                    };
                };
            };
            if (_local4 != null)
            {
                _local8 = ((_arg2.selector.conditions) ? _arg2.selector.conditions[0].kind : "unconditional");
                _local9 = this._subjects[_local4];
                if (_local9 == null)
                {
                    _local9 = {};
                    _local9[_local8] = [_arg2];
                    this._subjects[_local4] = _local9;
                }
                else
                {
                    _local10 = (_local9[_local8] as Array);
                    if (_local10 == null)
                    {
                        _local9[_local8] = [_arg2];
                    }
                    else
                    {
                        _local10.push(_arg2);
                    };
                };
            };
            var _local5:String = _arg2.getPseudoCondition();
            if (_local5 != null)
            {
                if (this._pseudoCSSStates == null)
                {
                    this._pseudoCSSStates = {};
                };
                this._pseudoCSSStates[_local5] = true;
            };
            if (_arg2.isAdvanced())
            {
                this._hasAdvancedSelectors = true;
            };
            if (this._typeSelectorCache)
            {
                this._typeSelectorCache = {};
            };
            if (_arg3)
            {
                this.styleDeclarationsChanged();
            };
        }

        public function clearStyleDeclaration(_arg1:String, _arg2:Boolean):void
        {
            var _local4:Array;
            var _local5:int;
            var _local6:CSSStyleDeclaration;
            var _local7:Boolean;
            var _local3:CSSStyleDeclaration = this.getStyleDeclaration(_arg1);
            if (((_local3) && ((_local3.selectorRefCount > 0))))
            {
                _local3.selectorRefCount--;
            };
            delete this._selectors[_arg1];
            if (((_local3) && (_local3.subject)))
            {
                _local4 = (this._subjects[_local3.subject] as Array);
                if (_local4)
                {
                    _local5 = (_local4.length - 1);
                    while (_local5 >= 0)
                    {
                        _local6 = _local4[_local5];
                        if (((_local6) && ((_local6.selectorString == _arg1))))
                        {
                            if (_local4.length == 1)
                            {
                                delete this._subjects[_local3.subject];
                            }
                            else
                            {
                                _local4.splice(_local5, 1);
                            };
                        };
                        _local5--;
                    };
                };
            }
            else
            {
                _local7 = false;
                for each (_local4 in this._subjects)
                {
                    if (_local4)
                    {
                        _local5 = (_local4.length - 1);
                        while (_local5 >= 0)
                        {
                            _local6 = _local4[_local5];
                            if (((_local6) && ((_local6.selectorString == _arg1))))
                            {
                                _local7 = true;
                                if (_local4.length == 1)
                                {
                                    delete this._subjects[_local6.subject];
                                }
                                else
                                {
                                    _local4.splice(_local5, 1);
                                };
                            };
                            _local5--;
                        };
                        if (_local7) break;
                    };
                };
            };
            if (_arg2)
            {
                this.styleDeclarationsChanged();
            };
        }

        public function styleDeclarationsChanged():void
        {
            var _local4:ISystemManager;
            var _local5:Object;
            var _local1:Array = SystemManagerGlobals.topLevelSystemManagers;
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                _local4 = _local1[_local3];
                _local5 = _local4.getImplementation("mx.managers::ISystemManagerChildManager");
                Object(_local5).regenerateStyleCache(true);
                Object(_local5).notifyStyleChangeInChildren(null, true);
                _local3++;
            };
        }

        public function registerInheritingStyle(_arg1:String):void
        {
            if (this._inheritingStyles[_arg1] != true)
            {
                this._inheritingStyles[_arg1] = true;
                this.mergedInheritingStylesCache = null;
                if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
                {
                    this.dispatchInheritingStylesChangeEvent();
                };
            };
        }

        public function isInheritingStyle(_arg1:String):Boolean
        {
            if (this.mergedInheritingStylesCache)
            {
                return ((this.mergedInheritingStylesCache[_arg1] == true));
            };
            if (this._inheritingStyles[_arg1] == true)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isInheritingStyle(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function isInheritingTextFormatStyle(_arg1:String):Boolean
        {
            if (this.inheritingTextFormatStyles[_arg1] == true)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isInheritingTextFormatStyle(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function registerSizeInvalidatingStyle(_arg1:String):void
        {
            this.sizeInvalidatingStyles[_arg1] = true;
        }

        public function isSizeInvalidatingStyle(_arg1:String):Boolean
        {
            if (this.sizeInvalidatingStyles[_arg1] == true)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isSizeInvalidatingStyle(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function registerParentSizeInvalidatingStyle(_arg1:String):void
        {
            this.parentSizeInvalidatingStyles[_arg1] = true;
        }

        public function isParentSizeInvalidatingStyle(_arg1:String):Boolean
        {
            if (this.parentSizeInvalidatingStyles[_arg1] == true)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isParentSizeInvalidatingStyle(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function registerParentDisplayListInvalidatingStyle(_arg1:String):void
        {
            this.parentDisplayListInvalidatingStyles[_arg1] = true;
        }

        public function isParentDisplayListInvalidatingStyle(_arg1:String):Boolean
        {
            if (this.parentDisplayListInvalidatingStyles[_arg1] == true)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isParentDisplayListInvalidatingStyle(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function registerColorName(_arg1:String, _arg2:uint):void
        {
            this.colorNames[_arg1.toLowerCase()] = _arg2;
        }

        public function isColorName(_arg1:String):Boolean
        {
            if (this.colorNames[_arg1.toLowerCase()] !== undefined)
            {
                return (true);
            };
            if (((this.parent) && (this.parent.isColorName(_arg1))))
            {
                return (true);
            };
            return (false);
        }

        public function getColorName(_arg1:Object):uint
        {
            var _local2:Number;
            var _local3:*;
            if ((_arg1 is String))
            {
                if (_arg1.charAt(0) == "#")
                {
                    _local2 = Number(("0x" + _arg1.slice(1)));
                    return (((isNaN(_local2)) ? StyleManager.NOT_A_COLOR : uint(_local2)));
                };
                if ((((_arg1.charAt(1) == "x")) && ((_arg1.charAt(0) == "0"))))
                {
                    _local2 = Number(_arg1);
                    return (((isNaN(_local2)) ? StyleManager.NOT_A_COLOR : uint(_local2)));
                };
                _local3 = this.colorNames[_arg1.toLowerCase()];
                if (_local3 === undefined)
                {
                    if (this.parent)
                    {
                        _local3 = this.parent.getColorName(_arg1);
                    };
                };
                if (_local3 === undefined)
                {
                    return (StyleManager.NOT_A_COLOR);
                };
                return (uint(_local3));
            };
            return (uint(_arg1));
        }

        public function getColorNames(_arg1:Array):void
        {
            var _local4:uint;
            if (!_arg1)
            {
                return;
            };
            var _local2:int = _arg1.length;
            var _local3:int;
            while (_local3 < _local2)
            {
                if (((!((_arg1[_local3] == null))) && (isNaN(_arg1[_local3]))))
                {
                    _local4 = this.getColorName(_arg1[_local3]);
                    if (_local4 != StyleManager.NOT_A_COLOR)
                    {
                        _arg1[_local3] = _local4;
                    };
                };
                _local3++;
            };
        }

        public function isValidStyleValue(_arg1):Boolean
        {
            if (_arg1 !== undefined)
            {
                return (true);
            };
            if (this.parent)
            {
                return (this.parent.isValidStyleValue(_arg1));
            };
            return (false);
        }

        public function loadStyleDeclarations(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false, _arg4:ApplicationDomain=null, _arg5:SecurityDomain=null):IEventDispatcher
        {
            return (this.loadStyleDeclarations2(_arg1, _arg2, _arg4, _arg5));
        }

        public function loadStyleDeclarations2(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher
        {
            var module:IModuleInfo;
            var thisStyleManager:IStyleManager2;
            var styleEventDispatcher:StyleEventDispatcher;
            var timer:Timer;
            var timerHandler:Function;
            var url:String = _arg1;
            var update:Boolean = _arg2;
            var applicationDomain = _arg3;
            var securityDomain = _arg4;
            module = ModuleManager.getModule(url);
            thisStyleManager = this;
            var readyHandler:Function = function (_arg1:ModuleEvent):void
            {
                var _local2:IStyleModule = IStyleModule(_arg1.module.factory.create());
                _arg1.module.factory.registerImplementation("mx.styles::IStyleManager2", thisStyleManager);
                _local2.setStyleDeclarations(thisStyleManager);
                styleModules[_arg1.module.url].styleModule = _local2;
                if (update)
                {
                    styleDeclarationsChanged();
                };
            };
            module.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            styleEventDispatcher = new StyleEventDispatcher(module);
            var errorHandler:Function = function (_arg1:ModuleEvent):void
            {
                var _local3:StyleEvent;
                var _local2:String = resourceManager.getString("styles", "unableToLoad", [_arg1.errorText, url]);
                if (styleEventDispatcher.willTrigger(StyleEvent.ERROR))
                {
                    _local3 = new StyleEvent(StyleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
                    _local3.bytesLoaded = 0;
                    _local3.bytesTotal = 0;
                    _local3.errorText = _local2;
                    styleEventDispatcher.dispatchEvent(_local3);
                }
                else
                {
                    throw (new Error(_local2));
                };
            };
            module.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            this.styleModules[url] = new StyleModuleInfo(module, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (_arg1:TimerEvent):void
            {
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                module.load(applicationDomain, securityDomain);
            };
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return (styleEventDispatcher);
        }

        public function unloadStyleDeclarations(_arg1:String, _arg2:Boolean=true):void
        {
            var _local4:IModuleInfo;
            var _local3:StyleModuleInfo = this.styleModules[_arg1];
            if (_local3)
            {
                _local3.styleModule.unload();
                _local4 = _local3.module;
                _local4.unload();
                _local4.removeEventListener(ModuleEvent.READY, _local3.readyHandler);
                _local4.removeEventListener(ModuleEvent.ERROR, _local3.errorHandler);
                this.styleModules[_arg1] = null;
            };
            if (_arg2)
            {
                this.styleDeclarationsChanged();
            };
        }

        private function dispatchInheritingStylesChangeEvent():void
        {
            var _local1:Event = new FlexChangeEvent(FlexChangeEvent.STYLE_MANAGER_CHANGE, false, false, {property:"inheritingStyles"});
            dispatchEvent(_local1);
        }

        public function acceptMediaList(_arg1:String):Boolean
        {
            if (!this.mqp)
            {
                this.mqp = MediaQueryParser.instance;
                if (!this.mqp)
                {
                    this.mqp = new MediaQueryParser(this.moduleFactory);
                    MediaQueryParser.instance = this.mqp;
                };
            };
            return (this.mqp.parse(_arg1));
        }

        private function styleManagerChangeHandler(_arg1:FlexChangeEvent):void
        {
            if (!_arg1.data)
            {
                return;
            };
            var _local2:String = _arg1.data["property"];
            if (_local2 == "inheritingStyles")
            {
                this.mergedInheritingStylesCache = null;
            };
            if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
            {
                dispatchEvent(_arg1);
            };
        }


    }
}//package mx.styles

import flash.events.EventDispatcher;
import mx.events.ModuleEvent;
import mx.modules.IModuleInfo;
import mx.events.StyleEvent;
import mx.styles.IStyleModule;

class StyleEventDispatcher extends EventDispatcher 
{

    public function StyleEventDispatcher(_arg1:IModuleInfo)
    {
        _arg1.addEventListener(ModuleEvent.PROGRESS, this.moduleInfo_progressHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, this.moduleInfo_readyHandler, false, 0, true);
    }

    private function moduleInfo_progressHandler(_arg1:ModuleEvent):void
    {
        var _local2:StyleEvent = new StyleEvent(StyleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }

    private function moduleInfo_readyHandler(_arg1:ModuleEvent):void
    {
        var _local2:StyleEvent = new StyleEvent(StyleEvent.COMPLETE);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }


}
class StyleModuleInfo 
{

    public var errorHandler:Function;
    public var readyHandler:Function;
    public var styleModule:IStyleModule;
    public var module:IModuleInfo;

    public function StyleModuleInfo(_arg1:IModuleInfo, _arg2:Function, _arg3:Function)
    {
        this.module = _arg1;
        this.readyHandler = _arg2;
        this.errorHandler = _arg3;
    }

}
