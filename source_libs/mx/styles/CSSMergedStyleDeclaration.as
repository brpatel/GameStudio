//Created by Action Script Viewer - http://www.buraks.com/asv
package mx.styles
{
    import mx.core.mx_internal;
    import flash.display.DisplayObject;

    use namespace mx_internal;

    public class CSSMergedStyleDeclaration extends CSSStyleDeclaration 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var style:CSSStyleDeclaration;
        private var parentStyle:CSSStyleDeclaration;
        private var updateOverrides:Boolean;
        private var _defaultFactory:Function;
        private var _factory:Function;

        public function CSSMergedStyleDeclaration(_arg1:CSSStyleDeclaration, _arg2:CSSStyleDeclaration, _arg3:Object=null, _arg4:IStyleManager2=null, _arg5:Boolean=false)
        {
            var _local6:uint;
            var _local7:uint;
            var _local8:Array;
            super(_arg3, _arg4, _arg5);
            this.style = _arg1;
            this.parentStyle = _arg2;
            if (((_arg1) && (_arg1.effects)))
            {
                effects = [];
                _local8 = _arg1.effects;
                _local7 = _local8.length;
                _local6 = 0;
                while (_local6 < _local7)
                {
                    effects[_local6] = _local8[_local6];
                    _local6++;
                };
            };
            if (((_arg2) && (_arg2.effects)))
            {
                if (!effects)
                {
                    effects = [];
                };
                _local8 = _arg2.effects;
                _local7 = _local8.length;
                _local6 = 0;
                while (_local6 < _local7)
                {
                    effects[_local6] = _local8[_local6];
                    if (effects.indexOf(_local8[_local6]) == -1)
                    {
                        effects[_local6] = _local8[_local6];
                    };
                    _local6++;
                };
            };
            this.updateOverrides = true;
        }

        override public function get defaultFactory():Function
        {
            if (this._defaultFactory != null)
            {
                return (this._defaultFactory);
            };
            if (((((!((this.style == null))) && (!((this.style.defaultFactory == null))))) || (((!((this.parentStyle == null))) && (!((this.parentStyle.defaultFactory == null)))))))
            {
                this._defaultFactory = function ():void
                {
                    if (((parentStyle) && (!((parentStyle.defaultFactory == null)))))
                    {
                        parentStyle.defaultFactory.apply(this);
                    };
                    if (((style) && (!((style.defaultFactory == null)))))
                    {
                        style.defaultFactory.apply(this);
                    };
                };
            };
            return (this._defaultFactory);
        }

        override public function set defaultFactory(_arg1:Function):void
        {
        }

        override public function get factory():Function
        {
            if (this._factory != null)
            {
                return (this._factory);
            };
            if (((((!((this.style == null))) && (!((this.style.factory == null))))) || (((!((this.parentStyle == null))) && (!((this.parentStyle.factory == null)))))))
            {
                this._factory = function ():void
                {
                    if (((parentStyle) && (!((parentStyle.factory == null)))))
                    {
                        parentStyle.factory.apply(this);
                    };
                    if (((style) && (!((style.factory == null)))))
                    {
                        style.factory.apply(this);
                    };
                };
            };
            return (this._factory);
        }

        override public function set factory(_arg1:Function):void
        {
        }

        override public function get overrides():Object
        {
            var _local1:Object;
            var _local3:Object;
            var _local4:Object;
            if (!this.updateOverrides)
            {
                return (super.overrides);
            };
            var _local2:Object;
            if (((this.style) && (this.style.overrides)))
            {
                _local2 = [];
                _local3 = this.style.overrides;
                for (_local1 in _local3)
                {
                    _local2[_local1] = _local3[_local1];
                };
            };
            if (((this.parentStyle) && (this.parentStyle.overrides)))
            {
                if (!_local2)
                {
                    _local2 = [];
                };
                _local4 = this.parentStyle.overrides;
                for (_local1 in _local4)
                {
                    if (_local2[_local1] === undefined)
                    {
                        _local2[_local1] = _local4[_local1];
                    };
                };
            };
            super.overrides = _local2;
            this.updateOverrides = false;
            return (_local2);
        }

        override public function set overrides(_arg1:Object):void
        {
        }

        override public function setStyle(_arg1:String, _arg2):void
        {
        }

        override mx_internal function addStyleToProtoChain(_arg1:Object, _arg2:DisplayObject, _arg3:Object=null):Object
        {
            if (this.style)
            {
                return (this.style.addStyleToProtoChain(_arg1, _arg2, _arg3));
            };
            if (this.parentStyle)
            {
                return (this.parentStyle.addStyleToProtoChain(_arg1, _arg2, _arg3));
            };
            return (_arg1);
        }


    }
}//package mx.styles
