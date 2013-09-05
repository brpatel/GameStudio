//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.core.FoxholeControl;
    import starling.display.Image;
    import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
    import starling.display.DisplayObject;
    import org.josht.starling.foxhole.controls.GroupedList;
    import starling.textures.Texture;

    public class DefaultGroupedListHeaderOrFooterRenderer extends FoxholeControl implements IGroupedListHeaderOrFooterRenderer 
    {

        protected var contentImage:Image;
        protected var contentLabel:BitmapFontTextRenderer;
        protected var content:DisplayObject;
        private var _data:Object;
        private var _groupIndex:int = -1;
        protected var _owner:GroupedList;
        private var _contentField:String = "content";
        private var _contentFunction:Function;
        private var _contentTextureField:String = "texture";
        private var _contentTextureFunction:Function;
        private var _contentLabelField:String = "label";
        private var _contentLabelFunction:Function;
        protected var _contentImageFactory:Function;
        protected var _contentLabelFactory:Function;
        protected var originalBackgroundWidth:Number = NaN;
        protected var originalBackgroundHeight:Number = NaN;
        protected var currentBackgroundSkin:DisplayObject;
        private var _backgroundSkin:DisplayObject;
        private var _backgroundDisabledSkin:DisplayObject;
        protected var _paddingTop:Number = 0;
        protected var _paddingRight:Number = 0;
        protected var _paddingBottom:Number = 0;
        protected var _paddingLeft:Number = 0;

        public function DefaultGroupedListHeaderOrFooterRenderer()
        {
            this._contentImageFactory = defaultImageFactory;
            this._contentLabelFactory = defaultLabelFactory;
            super();
        }

        protected static function defaultImageFactory(_arg1:Texture):Image
        {
            return (new Image(_arg1));
        }

        protected static function defaultLabelFactory():BitmapFontTextRenderer
        {
            return (new BitmapFontTextRenderer());
        }


        public function get data():Object
        {
            return (this._data);
        }

        public function set data(_arg1:Object):void
        {
            if (this._data == _arg1)
            {
                return;
            };
            this._data = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get groupIndex():int
        {
            return (this._groupIndex);
        }

        public function set groupIndex(_arg1:int):void
        {
            this._groupIndex = _arg1;
        }

        public function get owner():GroupedList
        {
            return (this._owner);
        }

        public function set owner(_arg1:GroupedList):void
        {
            if (this._owner == _arg1)
            {
                return;
            };
            this._owner = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentField():String
        {
            return (this._contentField);
        }

        public function set contentField(_arg1:String):void
        {
            if (this._contentField == _arg1)
            {
                return;
            };
            this._contentField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentFunction():Function
        {
            return (this._contentFunction);
        }

        public function set contentFunction(_arg1:Function):void
        {
            if (this._contentFunction == _arg1)
            {
                return;
            };
            this._contentFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentTextureField():String
        {
            return (this._contentTextureField);
        }

        public function set contentTextureField(_arg1:String):void
        {
            if (this._contentTextureField == _arg1)
            {
                return;
            };
            this._contentTextureField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentTextureFunction():Function
        {
            return (this._contentTextureFunction);
        }

        public function set contentTextureFunction(_arg1:Function):void
        {
            if (this.contentTextureFunction == _arg1)
            {
                return;
            };
            this._contentTextureFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentLabelField():String
        {
            return (this._contentLabelField);
        }

        public function set contentLabelField(_arg1:String):void
        {
            if (this._contentLabelField == _arg1)
            {
                return;
            };
            this._contentLabelField = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        public function get contentLabelFunction():Function
        {
            return (this._contentLabelFunction);
        }

        public function set contentLabelFunction(_arg1:Function):void
        {
            if (this._contentLabelFunction == _arg1)
            {
                return;
            };
            this._contentLabelFunction = _arg1;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function itemToContent(_arg1:Object):DisplayObject
        {
            var _local2:Texture;
            var _local3:String;
            if (this._contentTextureFunction != null)
            {
                _local2 = (this._contentTextureFunction(_arg1) as Texture);
                this.refreshContentTexture(_local2);
                return (this.contentImage);
            };
            if (((((!((this._contentTextureField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._contentTextureField))))
            {
                _local2 = (_arg1[this._contentTextureField] as Texture);
                this.refreshContentTexture(_local2);
                return (this.contentImage);
            };
            if (this._contentLabelFunction != null)
            {
                _local3 = (this._contentLabelFunction(_arg1) as String);
                this.refreshContentLabel(_local3);
                return (this.contentLabel);
            };
            if (((((!((this._contentLabelField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._contentLabelField))))
            {
                _local3 = (_arg1[this._contentLabelField] as String);
                this.refreshContentLabel(_local3);
                return (this.contentLabel);
            };
            if (this._contentFunction != null)
            {
                return ((this._contentFunction(_arg1) as DisplayObject));
            };
            if (((((!((this._contentField == null))) && (_arg1))) && (_arg1.hasOwnProperty(this._contentField))))
            {
                return ((_arg1[this._contentField] as DisplayObject));
            };
            if (_arg1)
            {
                this.refreshContentLabel(_arg1.toString());
                return (this.contentLabel);
            };
            return (null);
        }

        public function get contentImageFactory():Function
        {
            return (this._contentImageFactory);
        }

        public function set contentImageFactory(_arg1:Function):void
        {
            if (this._contentImageFactory == _arg1)
            {
                return;
            };
            this._contentImageFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get contentLabelFactory():Function
        {
            return (this._contentLabelFactory);
        }

        public function set contentLabelFactory(_arg1:Function):void
        {
            if (this._contentLabelFactory == _arg1)
            {
                return;
            };
            this._contentLabelFactory = _arg1;
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get backgroundSkin():DisplayObject
        {
            return (this._backgroundSkin);
        }

        public function set backgroundSkin(_arg1:DisplayObject):void
        {
            if (this._backgroundSkin == _arg1)
            {
                return;
            };
            if (((this._backgroundSkin) && (!((this._backgroundSkin == this._backgroundDisabledSkin)))))
            {
                this.removeChild(this._backgroundSkin);
            };
            this._backgroundSkin = _arg1;
            if (((this._backgroundSkin) && (!((this._backgroundSkin.parent == this)))))
            {
                this._backgroundSkin.visible = false;
                this.addChildAt(this._backgroundSkin, 0);
            };
            this.invalidate(INVALIDATION_FLAG_STYLES);
        }

        public function get backgroundDisabledSkin():DisplayObject
        {
            return (this._backgroundDisabledSkin);
        }

        public function set backgroundDisabledSkin(_arg1:DisplayObject):void
        {
            if (this._backgroundDisabledSkin == _arg1)
            {
                return;
            };
            if (((this._backgroundDisabledSkin) && (!((this._backgroundDisabledSkin == this._backgroundSkin)))))
            {
                this.removeChild(this._backgroundDisabledSkin);
            };
            this._backgroundDisabledSkin = _arg1;
            if (((this._backgroundDisabledSkin) && (!((this._backgroundDisabledSkin.parent == this)))))
            {
                this._backgroundDisabledSkin.visible = false;
                this.addChildAt(this._backgroundDisabledSkin, 0);
            };
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

        override public function dispose():void
        {
            if (this.content)
            {
                this.content.removeFromParent();
            };
            if (this.contentImage)
            {
                this.contentImage.dispose();
                this.contentImage = null;
            };
            if (this.contentLabel)
            {
                this.contentLabel.dispose();
                this.contentLabel = null;
            };
            super.dispose();
        }

        override protected function draw():void
        {
            var _local1:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
            var _local2:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
            var _local3:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
            var _local4:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
            if (((_local2) || (_local3)))
            {
                this.refreshBackgroundSkin();
            };
            if (_local1)
            {
                this.commitData();
            };
            _local4 = ((this.autoSizeIfNeeded()) || (_local4));
            if (_local1)
            {
                if (this.content)
                {
                    this.content.x = this._paddingLeft;
                    this.content.y = this._paddingTop;
                };
            };
            if (((((_local4) || (_local2))) || (_local3)))
            {
                if (this.currentBackgroundSkin)
                {
                    this.currentBackgroundSkin.width = this.actualWidth;
                    this.currentBackgroundSkin.height = this.actualHeight;
                };
            };
        }

        protected function autoSizeIfNeeded():Boolean
        {
            var _local1:Boolean = isNaN(this.explicitWidth);
            var _local2:Boolean = isNaN(this.explicitHeight);
            if (((!(_local1)) && (!(_local2))))
            {
                return (false);
            };
            if ((this.content is FoxholeControl))
            {
                FoxholeControl(this.content).validate();
            };
            if (!this.content)
            {
                return (this.setSizeInternal(0, 0, false));
            };
            var _local3:Number = this.explicitWidth;
            var _local4:Number = this.explicitHeight;
            if (_local1)
            {
                _local3 = ((this.content.width + this._paddingLeft) + this._paddingRight);
                if (!isNaN(this.originalBackgroundWidth))
                {
                    _local3 = Math.max(_local3, this.originalBackgroundWidth);
                };
            };
            if (_local2)
            {
                _local4 = ((this.content.height + this._paddingTop) + this._paddingBottom);
                if (!isNaN(this.originalBackgroundHeight))
                {
                    _local4 = Math.max(_local4, this.originalBackgroundHeight);
                };
            };
            return (this.setSizeInternal(_local3, _local4, false));
        }

        protected function refreshBackgroundSkin():void
        {
            this.currentBackgroundSkin = this._backgroundSkin;
            if (((!(this._isEnabled)) && (this._backgroundDisabledSkin)))
            {
                if (this._backgroundSkin)
                {
                    this._backgroundSkin.visible = false;
                };
                this.currentBackgroundSkin = this._backgroundDisabledSkin;
            }
            else
            {
                if (this._backgroundDisabledSkin)
                {
                    this._backgroundDisabledSkin.visible = false;
                };
            };
            if (this.currentBackgroundSkin)
            {
                if (isNaN(this.originalBackgroundWidth))
                {
                    this.originalBackgroundWidth = this.currentBackgroundSkin.width;
                };
                if (isNaN(this.originalBackgroundHeight))
                {
                    this.originalBackgroundHeight = this.currentBackgroundSkin.height;
                };
                this.currentBackgroundSkin.visible = true;
            };
        }

        protected function commitData():void
        {
            var _local1:DisplayObject;
            if (this._owner)
            {
                _local1 = this.itemToContent(this._data);
                if (_local1 != this.content)
                {
                    if (this.content)
                    {
                        this.content.removeFromParent();
                    };
                    this.content = _local1;
                    if (this.content)
                    {
                        this.addChild(this.content);
                    };
                };
            }
            else
            {
                if (this.content)
                {
                    this.content.removeFromParent();
                    this.content = null;
                };
            };
        }

        protected function refreshContentTexture(_arg1:Texture):void
        {
            if (_arg1)
            {
                if (!this.contentImage)
                {
                    this.contentImage = this._contentImageFactory(_arg1);
                }
                else
                {
                    this.contentImage.texture = _arg1;
                    this.contentImage.readjustSize();
                };
            }
            else
            {
                if (this.contentImage)
                {
                    this.contentImage.removeFromParent(true);
                    this.contentImage = null;
                };
            };
        }

        protected function refreshContentLabel(_arg1:String):void
        {
            if (_arg1 !== null)
            {
                if (!this.contentLabel)
                {
                    this.contentLabel = this._contentLabelFactory();
                };
                this.contentLabel.text = _arg1;
            }
            else
            {
                if (this.contentLabel)
                {
                    this.contentLabel.removeFromParent(true);
                    this.contentLabel = null;
                };
            };
        }


    }
}//package org.josht.starling.foxhole.controls.renderers
