package com.adobe.gamebuilder.editor.view.parts
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.view.Container;
    
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    
    import __AS3__.vec.Vector;
    
    import org.osflash.signals.Signal;
    
    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;

    public class Product extends Image 
    {

        private var _move:Signal;
        private var _moveInit:Signal;
        private var _moveEnded:Signal;
        private var _scaleable:Boolean;
        private var _vo:MobileProductVO;
        private var _originalWidth:Number;
        private var _originalHeight:Number;
        public var startScaleX:Number = 1;
        public var startScaleY:Number = 1;
        private var _delta:Point;
        private var _rotation:Number;
        private var _x:Number;
        private var _y:Number;
        private var _touchID:int;
		private var _productSelect:Signal;
		private var _productDeSelect:Signal;
		private var _productMoveEnded:Signal;
		private var _productRotateEnded:Signal;
		private var _productResize:Signal;
		private var _productDelete:Signal;
		
		public var _instanceID:int;
		private var tempWidth:Number;
		private var tempHeight:Number;

        public function Product(_arg1:MobileProductVO)
        {
            this._vo = _arg1;
            this.smoothing = TextureSmoothing.NONE;
            this.blendMode = BlendMode.NONE;
            this.pivotX = 0;
            this.pivotY = 0;
            super(Assets.getTextureAtlas("Interface").getTexture("icon_plus"));
            this._move = new Signal(Product);
            this._moveInit = new Signal(Product);
            this._moveEnded = new Signal(Product);
			
			_productSelect = new Signal(Product);
			_productMoveEnded = new Signal(Product);
			_productRotateEnded = new Signal(Product);
			_productResize = new Signal(Product);
			_productDelete = new Signal(Product);
			_productDeSelect = new Signal();
			
            this.visible = false;
            this._scaleable = _arg1.scaleable;
			if(this._vo.file_id!= null)
           	 this.loadFile(this._vo.file_id);
            this.addEventListener(starling.events.Event.ADDED_TO_STAGE, this.init);
        }

        public function get originalHeight():Number
        {
            return (this._originalHeight);
        }

        public function get originalWidth():Number
        {
            return (this._originalWidth);
        }

        public function get vo():MobileProductVO
        {
            return (this._vo);
        }

        public function get moveInit():Signal
        {
            return (this._moveInit);
        }

        public function get moveEnded():Signal
        {
            return (this._moveEnded);
        }

        public function get move():Signal
        {
            return (this._move);
        }
		
		public function get productSelect():Signal
		{
			return (this._productSelect);
		}
		
		public function get productMoveEnded():Signal
		{
			return (this._productMoveEnded);
		}
		
		public function get productRotateEnded():Signal
		{
			return (this._productRotateEnded);
		}
		
		public function get productResize():Signal
		{
			return (this._productResize);
		}
		
		public function get productDelete():Signal
		{
			return (this._productDelete);
		}
		
		public function get productDeSelect():Signal
		{
			return (this._productDeSelect);
		}
		
		
        public function setSize(_arg1:Number, _arg2:Number):void
        {
            scaleX = (_arg1 / this.originalWidth);
            scaleY = (_arg2 / this.originalHeight);
			_productResize.dispatch(this);
        }
		
		public function setSizeWithoutDispatch(_arg1:Number, _arg2:Number):void
		{
			tempWidth = _arg1;
			tempHeight = _arg2;
		
			
		}

        public function rotate(_arg1:Number):void
        {
            rotation = RoomMeasure.productAngle(_arg1);
        }

        public function loadFile(_arg1:String):void
        {
            var _local2:File = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH + _arg1) + ".png"));
            if (!_local2.exists)
            {
                _local2 = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH_DEV + _arg1) + ".png"));
            };
            var _local3:URLRequest = new URLRequest(_local2.url);
            var _local4:Loader = new Loader();
            _local4.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.loadFileComplete);
            _local4.load(_local3);
        }
		
		

        private function loadFileComplete(_arg1:flash.events.Event):void
        {
            var _local2:Loader = Loader(_arg1.currentTarget.loader);
            var _local3:* = _local2.content;
            var _local4:BitmapData = new BitmapData(_local3.width, _local3.height, true, 0);
            _local4.draw(_local3, null, null, null, null, true);
            this.texture = Texture.fromBitmapData(_local4);
            this.readjustSize();
            this._originalWidth = _local3.width;
            this._originalHeight = _local3.height;
            this.scaleX = this.startScaleX;
            this.scaleY = this.startScaleY;
            _local4.dispose();
            this.visible = true;
			
			if(!isNaN(tempHeight) && !isNaN(tempWidth) && tempWidth!=50 && tempHeight != 50){
				scaleX = (tempWidth / this.originalWidth);
				scaleY = (tempHeight / this.originalHeight);
			}
            dispatchEvent(new starling.events.Event(flash.events.Event.COMPLETE));
        }

        private function init(_arg1:starling.events.Event):void
        {
            this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, this.init);
            this.addEventListener(TouchEvent.TOUCH, this.onTouch);
        }

        public function finishImport():void
        {
            var _local1:Number = this.rotation;
            var _local2:Number = this.scaleX;
            var _local3:Number = this.scaleY;
            this.rotation = 0;
            this.scaleX = 1;
            this.scaleY = 1;
            this.pivotX = 0;
            this.pivotY = 0;
            var _local4:Point = parent.globalToLocal(this.localToGlobal(new Point(0, 0)));
            this.pivotX = (this.width / 2);
            this.pivotY = (this.height / 2);
            var _local5:Point = parent.globalToLocal(this.localToGlobal(new Point(0, 0)));
            this.rotation = _local1;
            this.x = (this.x + (_local4.x - _local5.x));
            this.y = (this.y + (_local4.y - _local5.y));
            this.scaleX = _local2;
            this.scaleY = _local3;
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local5:Point;
            var _local6:Touch;
            var _local7:Touch;
            var _local8:Point;
            var _local9:Point;
            var _local10:Point;
            var _local11:Point;
            var _local12:Point;
            var _local13:Point;
            var _local14:Number;
            var _local15:Number;
            var _local16:Number;
            var _local17:Point;
            var _local18:Point;
            var _local2:Vector.<Touch> = _arg1.getTouches(this, TouchPhase.MOVED);
			
			// Temp hack to prevent background from moving when in Replay mode
			if(GameBuilderApp.game!=null && GameBuilderApp.game.state!= null && GameBuilderApp.game.state.isReplayMode && this._instanceID==0)
				return;
			
            if (_local2.length == 1)
            {
                if (!(parent.parent as Container).moving)
                {
                    _local5 = _local2[0].getMovement(parent);
                    this._x = (this._x + _local5.x);
                    this._y = (this._y + _local5.y);
                    x = ((isNaN(this._x)) ? x : RoomMeasure.productPos(this._x));
                    y = ((isNaN(this._y)) ? y : RoomMeasure.productPos(this._y));
                };
            }
            else
            {
                if (_local2.length == 2)
                {
                    if (!(parent.parent as Container).moving)
                    {
                        _local6 = _local2[0];
                        _local7 = _local2[1];
                        _local8 = _local6.getLocation(parent);
                        _local9 = _local6.getPreviousLocation(parent);
                        _local10 = _local7.getLocation(parent);
                        _local11 = _local7.getPreviousLocation(parent);
                        _local12 = _local8.subtract(_local10);
                        _local13 = _local9.subtract(_local11);
                        _local14 = Math.atan2(_local12.y, _local12.x);
                        _local15 = Math.atan2(_local13.y, _local13.x);
                        _local16 = (_local14 - _local15);
                        _local17 = _local6.getPreviousLocation(this);
                        _local18 = _local7.getPreviousLocation(this);
                        pivotX = ((_local17.x + _local18.x) * 0.5);
                        pivotY = ((_local17.y + _local18.y) * 0.5);
                        this._x = (x = ((_local8.x + _local10.x) * 0.5));
                        this._y = (y = ((_local8.y + _local10.y) * 0.5));
                        this._rotation = (this._rotation + _local16);
                        rotation = ((isNaN(this._rotation)) ? rotation : RoomMeasure.productAngle(this._rotation));
                    };
                };
            };
            if (_local2.length > 0)
            {
                this._move.dispatch(this);
            };
            var _local3:Vector.<Touch> = _arg1.getTouches(stage);
            var _local4:Touch = _arg1.getTouch(this);
            if (_local4 != null)
            {
                if (_local4.phase == TouchPhase.ENDED)
                {
                    x = RoomMeasure.productPos(x);
                    y = RoomMeasure.productPos(y);
                    this.setPivot("zero");
                    this._moveEnded.dispatch(this);
				//	if(!GameBuilderApp.game.state.isReplayMode && this._instanceID!=0)
						this._productMoveEnded.dispatch(this);
                }
                else
                {
                    if ((((_local4.phase == TouchPhase.BEGAN)) && ((_local3.length < 2))))
                    {
                        if (!(parent.parent as Container).moving)
                        {
                            this._touchID = _local4.id;
                            this._moveInit.dispatch(this);
                            this._rotation = this.rotation;
                            this._x = this.x;
                            this._y = this.y;
							this._productSelect.dispatch(this);
							
                        };
                    };
                };
            };
        }

        public function setPivot(_arg1:String):void
        {
            var _local4:Rectangle;
            var _local2:Point = parent.globalToLocal(this.localToGlobal(new Point(0, 0)));
            if (_arg1 == "center")
            {
                _local4 = getBounds(this);
                pivotX = (_local4.width >> 1);
                pivotY = (_local4.height >> 1);
            }
            else
            {
                if (_arg1 == "zero")
                {
                    pivotX = 0;
                    pivotY = 0;
                };
            };
            var _local3:Point = parent.globalToLocal(this.localToGlobal(new Point(0, 0)));
            x = (x + (_local2.x - _local3.x));
            y = (y + (_local2.y - _local3.y));
        }

        override public function dispose():void
        {
            texture.dispose();
            super.dispose();
        }
		
		public function loadExternalFile(_arg1:String):void
		{
			/*var _local2:File = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH + _arg1) + ".png"));
			if (!_local2.exists)
			{
				_local2 = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH_DEV + _arg1) + ".png"));
			};*/
			// added to support timeline view
			this.vo.file_id = _arg1;
				
				
			var _local3:URLRequest = new URLRequest(_arg1);
			var _local4:Loader = new Loader();
			_local4.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.loadFileComplete);
			_local4.load(_local3);
		}
		
		public function getView():String{
			return (this.vo.file_id);
		}


    }
}//package at.polypex.badplaner.view.parts
