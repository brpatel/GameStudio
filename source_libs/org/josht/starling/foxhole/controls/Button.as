//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import flash.geom.Point;
    import org.josht.starling.foxhole.core.ITextRenderer;
    import starling.display.DisplayObject;
    import __AS3__.vec.Vector;
    import org.josht.starling.foxhole.skins.StateWithToggleValueSelector;
    import org.osflash.signals.Signal;
    import starling.events.TouchEvent;
    import starling.events.Event;
    import org.josht.starling.foxhole.core.PropertyProxy;
    import org.osflash.signals.ISignal;
    import starling.events.Touch;
    import org.josht.starling.display.ScrollRectManager;
    import starling.events.TouchPhase;
    import __AS3__.vec.*;
    import org.josht.starling.foxhole.core.*;

    public class Button extends FoxholeControl implements IToggle 
    {

        private static const helperPoint:Point = new Point();
        public static const STATE_UP:String = "up";
        public static const STATE_DOWN:String = "down";
        public static const STATE_HOVER:String = "hover";
        public static const STATE_DISABLED:String = "disabled";
        public static const ICON_POSITION_TOP:String = "top";
        public static const ICON_POSITION_RIGHT:String = "right";
        public static const ICON_POSITION_BOTTOM:String = "bottom";
        public static const ICON_POSITION_LEFT:String = "left";
        public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";
        public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";
        public static const HORIZONTAL_ALIGN_LEFT:String = "left";
        public static const HORIZONTAL_ALIGN_CENTER:String = "center";
        public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
        public static const VERTICAL_ALIGN_TOP:String = "top";
        public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
        public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";

        protected var defaultLabelName:String = "foxhole-button-label";
        protected var labelControl:ITextRenderer;
        protected var currentSkin:DisplayObject;
        protected var currentIcon:DisplayObject;
        protected var _touchPointID:int = -1;
        protected var _isHoverSupported:Boolean = false;
        protected var _currentState:String = "up";
        protected var _label:String = "";
        protected var _isToggle:Boolean = false;
        protected var _isSelected:Boolean = false;
        protected var _iconPosition:String = "left";
        protected var _gap:Number = 10;
        protected var _horizontalAlign:String = "center";
        protected var _verticalAlign:String = "middle";
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;
        public var keepDownStateOnRollOut:Boolean = false;
        protected var _stateNames:Vector.<String>;
        protected var _originalSkinWidth:Number = NaN;
        protected var _originalSkinHeight:Number = NaN;
        protected var _stateToSkinFunction:Function;
        protected var _stateToIconFunction:Function;
        protected var _stateToLabelPropertiesFunction:Function;
        protected var _skinSelector:StateWithToggleValueSelector;
        protected var _labelFactory:Function;
        protected var _labelPropertiesSelector:StateWithToggleValueSelector;
        protected var _iconSelector:StateWithToggleValueSelector;
        private var _autoFlatten:Boolean = false;
        protected var _onPress:Signal;
        protected var _onRelease:Signal;
        protected var _onChange:Signal;

        public function Button()
        {
            this._stateNames = new <String>[STATE_UP, STATE_DOWN, STATE_HOVER, STATE_DISABLED];
            this._skinSelector = new StateWithToggleValueSelector();
            this._labelPropertiesSelector = new StateWithToggleValueSelector();
            this._iconSelector = new StateWithToggleValueSelector();
            this._onPress = new Signal(Button);
            this._onRelease = new Signal(Button);
            this._onChange = new Signal(Button);
            super();
            this.isQuickHitAreaEnabled = true;
            this.addEventListener(TouchEvent.TOUCH, this.touchHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
        }

        override public function set isEnabled(_arg1:Boolean):void
        {
            if (this._isEnabled == _arg1)
            {
                return;
            };
            super.isEnabled = _arg1;
            if (!this._isEnabled)
            {
                this.touchable = false;
                this.currentState = STATE_DISABLED;
                this._touchPointID = -1;
            }
            else
            {
                if (this.currentState == STATE_DISABLED)
                {
                    this.currentState = STATE_UP;
                };
                this.touchable = true;
            };
        }

        protected function get currentState():String
        {
            return (this._currentState);
        }

        protected function set currentState(_arg1:String):void
        {
            if (this._currentState == _arg1)
            {
                return;
            };
            if (this.stateNames.indexOf(_arg1) < 0)
            {
                throw (new ArgumentError((("Invalid state: " + _arg1) + ".")));
            };
            this._currentState = _arg1;
            this.invalidate(INVALIDATION_FLAG_STATE);
        }

        public function get label():String
        {
            return (this._label);
        }

        public function set label(_arg1:String):void
        {
            if (!_arg1)
            {
                _arg1 = "";
            };
            if (this._label == _arg1)
            {
                return;
            };
            this._label = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get isToggle():Boolean
        {
            return (this._isToggle);
        }

        public function set isToggle(_arg1:Boolean):void
        {
            this._isToggle = _arg1;
        }

        public function get isSelected():Boolean
        {
            return (this._isSelected);
        }

        public function set isSelected(_arg1:Boolean):void
        {
            if (this._isSelected == _arg1)
            {
                return;
            };
            this._isSelected = _arg1;
            this.currentState = this.currentState;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this._onChange.dispatch(this);
        }

        public function get iconPosition():String
        {
            return (this._iconPosition);
        }

        public function set iconPosition(_arg1:String):void
        {
            if (this._iconPosition == _arg1)
            {
                return;
            };
            this._iconPosition = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get gap():Number
        {
            return (this._gap);
        }

        public function set gap(_arg1:Number):void
        {
            if (this._gap == _arg1)
            {
                return;
            };
            this._gap = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get horizontalAlign():String
        {
            return (this._horizontalAlign);
        }

        public function set horizontalAlign(_arg1:String):void
        {
            if (this._horizontalAlign == _arg1)
            {
                return;
            };
            this._horizontalAlign = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get verticalAlign():String
        {
            return (this._verticalAlign);
        }

        public function set verticalAlign(_arg1:String):void
        {
            if (this._verticalAlign == _arg1)
            {
                return;
            };
            this._verticalAlign = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingTop():Number
        {
            return (this._paddingTop);
        }

        public function set paddingTop(_arg1:Number):void
        {
            if (this._paddingTop == _arg1)
            {
                return;
            };
            this._paddingTop = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingRight():Number
        {
            return (this._paddingRight);
        }

        public function set paddingRight(_arg1:Number):void
        {
            if (this._paddingRight == _arg1)
            {
                return;
            };
            this._paddingRight = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingBottom():Number
        {
            return (this._paddingBottom);
        }

        public function set paddingBottom(_arg1:Number):void
        {
            if (this._paddingBottom == _arg1)
            {
                return;
            };
            this._paddingBottom = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get paddingLeft():Number
        {
            return (this._paddingLeft);
        }

        public function set paddingLeft(_arg1:Number):void
        {
            if (this._paddingLeft == _arg1)
            {
                return;
            };
            this._paddingLeft = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function get stateNames():Vector.<String>
        {
            return (this._stateNames);
        }

        public function get stateToSkinFunction():Function
        {
            return (this._stateToSkinFunction);
        }

        public function set stateToSkinFunction(_arg1:Function):void
        {
            if (this._stateToSkinFunction == _arg1)
            {
                return;
            };
            this._stateToSkinFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get stateToIconFunction():Function
        {
            return (this._stateToIconFunction);
        }

        public function set stateToIconFunction(_arg1:Function):void
        {
            if (this._stateToIconFunction == _arg1)
            {
                return;
            };
            this._stateToIconFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get stateToLabelPropertiesFunction():Function
        {
            return (this._stateToLabelPropertiesFunction);
        }

        public function set stateToLabelPropertiesFunction(_arg1:Function):void
        {
            if (this._stateToLabelPropertiesFunction == _arg1)
            {
                return;
            };
            this._stateToLabelPropertiesFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get defaultSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.defaultValue));
        }

        public function set defaultSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.defaultValue == _arg1)
            {
                return;
            };
            this._skinSelector.defaultValue = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get defaultSelectedSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.defaultSelectedValue));
        }

        public function set defaultSelectedSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.defaultSelectedValue == _arg1)
            {
                return;
            };
            this._skinSelector.defaultSelectedValue = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get upSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_UP, false)));
        }

        public function set upSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_UP, false) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_UP, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get downSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_DOWN, false)));
        }

        public function set downSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_DOWN, false) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_DOWN, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get hoverSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_HOVER, false)));
        }

        public function set hoverSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_HOVER, false) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_HOVER, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get disabledSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED, false)));
        }

        public function set disabledSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_DISABLED, false) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_DISABLED, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedUpSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_UP, true)));
        }

        public function set selectedUpSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_UP, true) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_UP, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDownSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_DOWN, true)));
        }

        public function set selectedDownSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_DOWN, true) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_DOWN, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedHoverSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_HOVER, true)));
        }

        public function set selectedHoverSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_HOVER, true) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_HOVER, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDisabledSkin():DisplayObject
        {
            return (DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED, true)));
        }

        public function set selectedDisabledSkin(_arg1:DisplayObject):void
        {
            if (this._skinSelector.getValueForState(STATE_DISABLED, true) == _arg1)
            {
                return;
            };
            this._skinSelector.setValueForState(_arg1, STATE_DISABLED, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get labelFactory():Function
        {
            return (this._labelFactory);
        }

        public function set labelFactory(_arg1:Function):void
        {
            if (this._labelFactory == _arg1)
            {
                return;
            };
            this._labelFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
        }

        public function get defaultLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultValue);
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.defaultValue = _local1;
            };
            return (_local1);
        }

        public function set defaultLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultValue);
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.defaultValue = _arg1;
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get upLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, false));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_UP, false);
            };
            return (_local1);
        }

        public function set upLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, false));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_UP, false);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get downLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, false));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_DOWN, false);
            };
            return (_local1);
        }

        public function set downLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, false));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_DOWN, false);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get hoverLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, false));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_HOVER, false);
            };
            return (_local1);
        }

        public function set hoverLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, false));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_HOVER, false);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get disabledLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, false));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_DISABLED, false);
            };
            return (_local1);
        }

        public function set disabledLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, false));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_DISABLED, false);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get defaultSelectedLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.defaultSelectedValue = _local1;
            };
            return (_local1);
        }

        public function set defaultSelectedLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.defaultSelectedValue = _arg1;
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedUpLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, true));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_UP, true);
            };
            return (_local1);
        }

        public function set selectedUpLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, true));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_UP, true);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDownLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, true));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_DOWN, true);
            };
            return (_local1);
        }

        public function set selectedDownLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, true));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_DOWN, true);
            if (_arg1)
            {
                PropertyProxy(_arg1).onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedHoverLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, true));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_HOVER, true);
            };
            return (_local1);
        }

        public function set selectedHoverLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, true));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_HOVER, true);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDisabledLabelProperties():Object
        {
            var _local1:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, true));
            if (!_local1)
            {
                _local1 = new PropertyProxy(this.labelProperties_onChange);
                this._labelPropertiesSelector.setValueForState(_local1, STATE_DISABLED, true);
            };
            return (_local1);
        }

        public function set selectedDisabledLabelProperties(_arg1:Object):void
        {
            if (!(_arg1 is PropertyProxy))
            {
                _arg1 = PropertyProxy.fromObject(_arg1);
            };
            var _local2:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, true));
            if (_local2)
            {
                _local2.onChange.remove(this.labelProperties_onChange);
            };
            this._labelPropertiesSelector.setValueForState(_arg1, STATE_DISABLED, true);
            if (_arg1)
            {
                _arg1.onChange.add(this.labelProperties_onChange);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get defaultIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.defaultValue));
        }

        public function set defaultIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.defaultValue == _arg1)
            {
                return;
            };
            this._iconSelector.defaultValue = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get defaultSelectedIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.defaultSelectedValue));
        }

        public function set defaultSelectedIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.defaultSelectedValue == _arg1)
            {
                return;
            };
            this._iconSelector.defaultSelectedValue = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get upIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_UP, false)));
        }

        public function set upIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_UP, false) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_UP, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get downIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_DOWN, false)));
        }

        public function set downIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_DOWN, false) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_DOWN, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get hoverIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_HOVER, false)));
        }

        public function set hoverIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_HOVER, false) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_HOVER, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get disabledIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED, false)));
        }

        public function set disabledIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_DISABLED, false) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_DISABLED, false);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedUpIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_UP, true)));
        }

        public function set selectedUpIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_UP, true) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_UP, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDownIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_DOWN, true)));
        }

        public function set selectedDownIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_DOWN, true) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_DOWN, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedHoverIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_HOVER, true)));
        }

        public function set selectedHoverIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_HOVER, true) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_HOVER, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get selectedDisabledIcon():DisplayObject
        {
            return (DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED, true)));
        }

        public function set selectedDisabledIcon(_arg1:DisplayObject):void
        {
            if (this._iconSelector.getValueForState(STATE_DISABLED, true) == _arg1)
            {
                return;
            };
            this._iconSelector.setValueForState(_arg1, STATE_DISABLED, true);
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get autoFlatten():Boolean
        {
            return (this._autoFlatten);
        }

        public function set autoFlatten(_arg1:Boolean):void
        {
            if (this._autoFlatten == _arg1)
            {
                return;
            };
            this._autoFlatten = _arg1;
            this.unflatten();
            if (this._autoFlatten)
            {
                this.flatten();
            };
        }

        public function get onPress():ISignal
        {
            return (this._onPress);
        }

        public function get onRelease():ISignal
        {
            return (this._onRelease);
        }

        public function get onChange():ISignal
        {
            return (this._onChange);
        }

        override public function dispose():void
        {
            this._onPress.removeAll();
            this._onRelease.removeAll();
            this._onChange.removeAll();
            super.dispose();
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            var _local5:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
            var _local6:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
            if (_local6)
            {
                this.createLabel();
            };
            if (((_local6) || (_local1)))
            {
                this.refreshLabelData();
            };
            if (((((_local2) || (_local4))) || (_local5)))
            {
                this.refreshSkin();
                if (((this.currentSkin) && (isNaN(this._originalSkinWidth))))
                {
                    this._originalSkinWidth = this.currentSkin.width;
                };
                if (((this.currentSkin) && (isNaN(this._originalSkinHeight))))
                {
                    this._originalSkinHeight = this.currentSkin.height;
                };
                this.refreshIcon();
            };
            if (((((((_local6) || (_local2))) || (_local4))) || (_local5)))
            {
                this.refreshLabelStyles();
            };
            _local3 = ((this.autoSizeIfNeeded()) || (_local3));
            if (((((((_local2) || (_local4))) || (_local5))) || (_local3)))
            {
                this.scaleSkin();
            };
            if (((((((((((_local6) || (_local2))) || (_local4))) || (_local5))) || (_local1))) || (_local3)))
            {
                if ((this.currentSkin is FoxholeControl))
                {
                    FoxholeControl(this.currentSkin).validate();
                };
                if ((this.currentIcon is FoxholeControl))
                {
                    FoxholeControl(this.currentIcon).validate();
                };
                this.layoutContent();
            };
            if (this._autoFlatten)
            {
                this.unflatten();
                this.flatten();
            };
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local5:Number;
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            this.labelControl.measureText(helperPoint);
            var _local3:Number = this.explicitWidth;
            if (_local1)
            {
                if (((this.currentIcon) && (this.label)))
                {
                    if (((!((this._iconPosition == ICON_POSITION_TOP))) && (!((this._iconPosition == ICON_POSITION_BOTTOM)))))
                    {
                        _local5 = (((this._gap == Number.POSITIVE_INFINITY)) ? Math.min(this._paddingLeft, this._paddingRight) : this._gap);
                        _local3 = ((this.currentIcon.width + _local5) + helperPoint.x);
                    }
                    else
                    {
                        _local3 = Math.max(this.currentIcon.width, helperPoint.x);
                    };
                }
                else
                {
                    if (this.currentIcon)
                    {
                        _local3 = this.currentIcon.width;
                    }
                    else
                    {
                        if (this.label)
                        {
                            _local3 = helperPoint.x;
                        };
                    };
                };
                _local3 = (_local3 + (this._paddingLeft + this._paddingRight));
                if (isNaN(_local3))
                {
                    _local3 = this._originalSkinWidth;
                }
                else
                {
                    if (!isNaN(this._originalSkinWidth))
                    {
                        _local3 = Math.max(_local3, this._originalSkinWidth);
                    };
                };
            };
            var _local4:Number = this.explicitHeight;
            if (_local2)
            {
                if (((this.currentIcon) && (this.label)))
                {
                    if ((((this._iconPosition == ICON_POSITION_TOP)) || ((this._iconPosition == ICON_POSITION_BOTTOM))))
                    {
                        _local5 = (((this._gap == Number.POSITIVE_INFINITY)) ? Math.min(this._paddingTop, this._paddingBottom) : this._gap);
                        _local4 = ((this.currentIcon.height + _local5) + helperPoint.y);
                    }
                    else
                    {
                        _local4 = Math.max(this.currentIcon.height, helperPoint.y);
                    };
                }
                else
                {
                    if (this.currentIcon)
                    {
                        _local4 = this.currentIcon.height;
                    }
                    else
                    {
                        if (this.label)
                        {
                            _local4 = helperPoint.y;
                        };
                    };
                };
                _local4 = (_local4 + (this._paddingTop + this._paddingBottom));
                if (isNaN(_local4))
                {
                    _local4 = this._originalSkinHeight;
                }
                else
                {
                    if (!isNaN(this._originalSkinHeight))
                    {
                        _local4 = Math.max(_local4, this._originalSkinHeight);
                    };
                };
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function createLabel():void
        {
            if (this.labelControl)
            {
                this.removeChild(FoxholeControl(this.labelControl), true);
                this.labelControl = null;
            };
            var _local1:Function = (((this._labelFactory)!=null) ? this._labelFactory : FoxholeControl.defaultTextRendererFactory);
            this.labelControl = _local1();
            var _local2:FoxholeControl = FoxholeControl(this.labelControl);
            _local2.nameList.add(this.defaultLabelName);
			
            this.addChild(_local2);
        }

        protected function refreshLabelData():void
        {
            this.labelControl.text = this._label;
            DisplayObject(this.labelControl).visible = !((this._label == null));
        }

        protected function refreshSkin():void
        {
            var _local1:DisplayObject = this.currentSkin;
            if (this._stateToSkinFunction != null)
            {
                this.currentSkin = DisplayObject(this._stateToSkinFunction(this, this._currentState, _local1));
            }
            else
            {
                this.currentSkin = DisplayObject(this._skinSelector.updateValue(this, this._currentState, this.currentSkin));
            };
            if (this.currentSkin != _local1)
            {
                if (_local1)
                {
                    this.removeChild(_local1, false);
                };
                if (this.currentSkin)
                {
                    this.addChildAt(this.currentSkin, 0);
                };
            };
        }

        protected function refreshIcon():void
        {
            var _local1:DisplayObject = this.currentIcon;
            if (this._stateToIconFunction != null)
            {
                this.currentIcon = DisplayObject(this._stateToIconFunction(this, this._currentState, _local1));
            }
            else
            {
                this.currentIcon = DisplayObject(this._iconSelector.updateValue(this, this._currentState, this.currentIcon));
            };
            if (this.currentIcon != _local1)
            {
                if (_local1)
                {
                    this.removeChild(_local1, false);
                };
                if (this.currentIcon)
                {
                    this.addChild(this.currentIcon);
                };
            };
        }

        protected function refreshLabelStyles():void
        {
            var _local2:String;
            var _local3:Object;
            var _local4:Object;
            if (this._stateToLabelPropertiesFunction != null)
            {
                _local3 = this._stateToLabelPropertiesFunction(this, this._currentState);
            }
            else
            {
                _local3 = this._labelPropertiesSelector.updateValue(this, this._currentState);
            };
            var _local1:FoxholeControl = FoxholeControl(this.labelControl);
            for (_local2 in _local3)
            {
                if (_local1.hasOwnProperty(_local2))
                {
                    _local4 = _local3[_local2];
                    _local1[_local2] = _local4;
                };
            };
        }

        protected function scaleSkin():void
        {
            if (!this.currentSkin)
            {
                return;
            };
            if (this.currentSkin.width != this.actualWidth)
            {
                this.currentSkin.width = this.actualWidth;
            };
            if (this.currentSkin.height != this.actualHeight)
            {
                this.currentSkin.height = this.actualHeight;
            };
        }

        protected function layoutContent():void
        {
            var _local2:Number;
            var _local1:FoxholeControl = FoxholeControl(this.labelControl);
            if (((this.label) && (this.currentIcon)))
            {
                if ((((((((this._iconPosition == ICON_POSITION_LEFT)) || ((this._iconPosition == ICON_POSITION_LEFT_BASELINE)))) || ((this._iconPosition == ICON_POSITION_RIGHT)))) || ((this._iconPosition == ICON_POSITION_RIGHT_BASELINE))))
                {
                    _local2 = (((this._gap == Number.POSITIVE_INFINITY)) ? Math.min(this._paddingLeft, this._paddingRight) : this._gap);
                    _local1.maxWidth = ((((this.actualWidth - this._paddingLeft) - this._paddingRight) - this.currentIcon.width) - _local2);
                };
                _local1.validate();
                this.positionLabelOrIcon(_local1);
                this.positionLabelAndIcon();
            }
            else
            {
                if (((this.label) && (!(this.currentIcon))))
                {
                    _local1.maxWidth = ((this.actualWidth - this._paddingLeft) - this._paddingRight);
                    _local1.validate();
                    this.positionLabelOrIcon(_local1);
                }
                else
                {
                    if (((!(this.label)) && (this.currentIcon)))
                    {
                        this.positionLabelOrIcon(this.currentIcon);
                    };
                };
            };
        }

        protected function positionLabelOrIcon(_arg1:DisplayObject):void
        {
            if (this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
            {
                _arg1.x = this._paddingLeft;
            }
            else
            {
                if (this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
                {
                    _arg1.x = ((this.actualWidth - this._paddingRight) - _arg1.width);
                }
                else
                {
                    _arg1.x = ((this.actualWidth - _arg1.width) / 2);
                };
            };
            if (this._verticalAlign == VERTICAL_ALIGN_TOP)
            {
                _arg1.y = this._paddingTop;
            }
            else
            {
                if (this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
                {
                    _arg1.y = ((this.actualHeight - this._paddingBottom) - _arg1.height);
                }
                else
                {
                    _arg1.y = ((this.actualHeight - _arg1.height) / 2);
                };
            };
        }

        protected function positionLabelAndIcon():void
        {
            var _local1:FoxholeControl = FoxholeControl(this.labelControl);
            if (this._iconPosition == ICON_POSITION_TOP)
            {
                if (this._gap == Number.POSITIVE_INFINITY)
                {
                    this.currentIcon.y = this._paddingTop;
                    _local1.y = ((this.actualHeight - this._paddingBottom) - _local1.height);
                }
                else
                {
                    if (this._verticalAlign == VERTICAL_ALIGN_TOP)
                    {
                        _local1.y = (_local1.y + (this.currentIcon.height + this._gap));
                    }
                    else
                    {
                        if (this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
                        {
                            _local1.y = (_local1.y + ((this.currentIcon.height + this._gap) / 2));
                        };
                    };
                    this.currentIcon.y = ((_local1.y - this.currentIcon.height) - this._gap);
                };
            }
            else
            {
                if ((((this._iconPosition == ICON_POSITION_RIGHT)) || ((this._iconPosition == ICON_POSITION_RIGHT_BASELINE))))
                {
                    if (this._gap == Number.POSITIVE_INFINITY)
                    {
                        _local1.x = this._paddingLeft;
                        this.currentIcon.x = ((this.actualWidth - this._paddingRight) - this.currentIcon.width);
                    }
                    else
                    {
                        if (this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
                        {
                            _local1.x = (_local1.x - (this.currentIcon.width + this._gap));
                        }
                        else
                        {
                            if (this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
                            {
                                _local1.x = (_local1.x - ((this.currentIcon.width + this._gap) / 2));
                            };
                        };
                        this.currentIcon.x = ((_local1.x + _local1.width) + this._gap);
                    };
                }
                else
                {
                    if (this._iconPosition == ICON_POSITION_BOTTOM)
                    {
                        if (this._gap == Number.POSITIVE_INFINITY)
                        {
                            _local1.y = this._paddingTop;
                            this.currentIcon.y = ((this.actualHeight - this._paddingBottom) - this.currentIcon.height);
                        }
                        else
                        {
                            if (this._verticalAlign == VERTICAL_ALIGN_BOTTOM)
                            {
                                _local1.y = (_local1.y - (this.currentIcon.height + this._gap));
                            }
                            else
                            {
                                if (this._verticalAlign == VERTICAL_ALIGN_MIDDLE)
                                {
                                    _local1.y = (_local1.y - ((this.currentIcon.height + this._gap) / 2));
                                };
                            };
                            this.currentIcon.y = ((_local1.y + _local1.height) + this._gap);
                        };
                    }
                    else
                    {
                        if ((((this._iconPosition == ICON_POSITION_LEFT)) || ((this._iconPosition == ICON_POSITION_LEFT_BASELINE))))
                        {
                            if (this._gap == Number.POSITIVE_INFINITY)
                            {
                                this.currentIcon.x = this._paddingLeft;
                                _local1.x = ((this.actualWidth - this._paddingRight) - _local1.width);
                            }
                            else
                            {
                                if (this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
                                {
                                    _local1.x = (_local1.x + (this._gap + this.currentIcon.width));
                                }
                                else
                                {
                                    if (this._horizontalAlign == HORIZONTAL_ALIGN_CENTER)
                                    {
                                        _local1.x = (_local1.x + ((this._gap + this.currentIcon.width) / 2));
                                    };
                                };
                                this.currentIcon.x = ((_local1.x - this._gap) - this.currentIcon.width);
                            };
                        };
                    };
                };
            };
            if ((((this._iconPosition == ICON_POSITION_LEFT)) || ((this._iconPosition == ICON_POSITION_RIGHT))))
            {
                this.currentIcon.y = (_local1.y + ((_local1.height - this.currentIcon.height) / 2));
            }
            else
            {
                if ((((this._iconPosition == ICON_POSITION_LEFT_BASELINE)) || ((this._iconPosition == ICON_POSITION_RIGHT_BASELINE))))
                {
                    this.currentIcon.y = ((_local1.y + this.labelControl.baseline) - this.currentIcon.height);
                }
                else
                {
                    if (this._horizontalAlign == HORIZONTAL_ALIGN_LEFT)
                    {
                        this.currentIcon.x = _local1.x;
                    }
                    else
                    {
                        if (this._horizontalAlign == HORIZONTAL_ALIGN_RIGHT)
                        {
                            this.currentIcon.x = ((_local1.x + _local1.width) - this.currentIcon.width);
                        }
                        else
                        {
                            this.currentIcon.x = (_local1.x + ((_local1.width - this.currentIcon.width) / 2));
                        };
                    };
                };
            };
        }

        protected function labelProperties_onChange(_arg1:PropertyProxy, _arg2:Object):void
        {
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        protected function removedFromStageHandler(_arg1:Event):void
        {
            this._touchPointID = -1;
            this.currentState = ((this._isEnabled) ? STATE_UP : STATE_DISABLED);
        }

        private function touchHandler(_arg1:TouchEvent):void
        {
            var _local3:Touch;
            var _local4:Touch;
            var _local5:Boolean;
            if (!this._isEnabled)
            {
                return;
            };
            var _local2:Vector.<Touch> = _arg1.getTouches(this);
            if (_local2.length == 0)
            {
                this.currentState = STATE_UP;
                return;
            };
            if (this._touchPointID >= 0)
            {
                for each (_local4 in _local2)
                {
                    if (_local4.id == this._touchPointID)
                    {
                        _local3 = _local4;
                        break;
                    };
                };
                if (!_local3)
                {
                    this.currentState = STATE_UP;
                    return;
                };
                _local3.getLocation(this, helperPoint);
                ScrollRectManager.adjustTouchLocation(helperPoint, this);
                _local5 = !((this.hitTest(helperPoint, true) == null));
                if (_local3.phase == TouchPhase.MOVED)
                {
                    if (((_local5) || (this.keepDownStateOnRollOut)))
                    {
                        this.currentState = STATE_DOWN;
                    }
                    else
                    {
                        this.currentState = STATE_UP;
                    };
                    return;
                };
                if (_local3.phase == TouchPhase.ENDED)
                {
                    this._touchPointID = -1;
                    if (_local5)
                    {
                        if (this._isHoverSupported)
                        {
                            _local3.getLocation(this, helperPoint);
                            this.localToGlobal(helperPoint, helperPoint);
                            _local5 = (this.stage.hitTest(helperPoint, true) == this);
                            this.currentState = ((((_local5) && (this._isHoverSupported))) ? STATE_HOVER : STATE_UP);
                        }
                        else
                        {
                            this.currentState = STATE_UP;
                        };
                        this._onRelease.dispatch(this);
                        if (this._isToggle)
                        {
                            this.isSelected = !(this._isSelected);
                        };
                    }
                    else
                    {
                        this.currentState = STATE_UP;
                    };
                    return;
                };
            }
            else
            {
                for each (_local3 in _local2)
                {
                    if (_local3.phase == TouchPhase.BEGAN)
                    {
                        this.currentState = STATE_DOWN;
                        this._touchPointID = _local3.id;
                        this._onPress.dispatch(this);
                        return;
                    };
                    if (_local3.phase == TouchPhase.HOVER)
                    {
                        this.currentState = STATE_HOVER;
                        this._isHoverSupported = true;
                        return;
                    };
                };
            };
        }


    }
}//package org.josht.starling.foxhole.controls
