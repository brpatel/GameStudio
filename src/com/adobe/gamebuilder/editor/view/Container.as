package com.adobe.gamebuilder.editor.view
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.RoomMeasure;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.view.comps.ProductAvatar;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.RoomPoint;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import __AS3__.vec.Vector;
    
    import org.josht.starling.display.TiledImage;
    import org.josht.starling.foxhole.dragDrop.DragData;
    import org.josht.starling.foxhole.dragDrop.DragDropManager;
    import org.josht.starling.foxhole.dragDrop.IDropTarget;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class Container extends Sprite implements IDropTarget 
    {

        private var INITIAL_ROOM_X:int = 0;//245;
        private var INITIAL_ROOM_Y:int = 0;//142;
        private var INITIAL_BG_X:int;
        private var INITIAL_BG_Y:int;
        private var _onDragEnter:Signal;
        private var _onDragMove:Signal;
        private var _onDragExit:Signal;
        private var _onDragDrop:Signal;
        private var _zoomChange:Signal;
        private var _areaChange:Signal;
        private var _bg:TiledImage;
        private var _room:Room;
        private var _drawArea:DrawArea;
        public var moving:Boolean = false;
        private var _delta:Point;
        private var _touchPhase:String;
        private var _touchEnded:Signal;
        private var _productDrop:Signal;

        public function Container()
        {
            this._touchEnded = new Signal();
			this._productDrop = new Signal(Product,Point);
            this._zoomChange = new Signal(Number);
            this._areaChange = new Signal(Number);
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get areaChange():Signal
        {
            return (this._areaChange);
        }

        public function get touchEnded():Signal
        {
            return (this._touchEnded);
        }

		public function get productDrop():Signal
		{
			return (this._productDrop);
		}
		
        public function get zoomChange():Signal
        {
            return (this._zoomChange);
        }

        public function get room():Room
        {
            return (this._room);
        }
		
        private function init(_arg1:Event):void
        {
            this.INITIAL_ROOM_X = 0; //Constants.PANEL_WIDTH + 50; // (int((((stage.stageWidth - Constants.PANEL_WIDTH) - RoomMeasure.cm2px(350)) / 2)) + Constants.PANEL_WIDTH);
            this.INITIAL_ROOM_Y = 0;//Constants.TOPBAR_HEIGHT + 50;; //((int((((stage.stageHeight - Constants.TOPBAR_HEIGHT) - RoomMeasure.cm2px(300)) / 2)) - 15) + Constants.TOPBAR_HEIGHT);
            this._bg = new TiledImage(Assets.getTextureAtlas("Interface").getTexture("main_grid"));
            this._bg.width = (stage.stageWidth * 4);
            this._bg.height = (stage.stageHeight * 4);
            this._bg.x = (this.INITIAL_BG_X = (this.INITIAL_ROOM_X - (Constants.BG_TILE_SIZE * Math.ceil((stage.stageWidth / Constants.BG_TILE_SIZE)))));
            this._bg.y = (this.INITIAL_BG_Y = (this.INITIAL_ROOM_Y - (Constants.BG_TILE_SIZE * Math.ceil((stage.stageHeight / Constants.BG_TILE_SIZE)))));
            this._bg.addEventListener(TouchEvent.TOUCH, this.onTouch);
            addChild(this._bg);
            this._drawArea = new DrawArea();
            this._drawArea.x = this.INITIAL_ROOM_X;
            this._drawArea.y = this.INITIAL_ROOM_Y;
            this._drawArea.touchable = false;
            addChild(this._drawArea);
            this._room = new Room();
            this._room.x = this.INITIAL_ROOM_X;
            this._room.y = this.INITIAL_ROOM_Y;
            this._room.drawSignal.add(this.drawMeasure);
            this._room.resetSignal.add(this.resetMeasure);
            addChild(this._room);
            this._onDragEnter = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragMove = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragExit = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragDrop = new Signal(IDropTarget, DragData, Number, Number);
            this._onDragEnter.add(this.onDragEnterHandler);
            this._onDragExit.add(this.onDragExitHandler);
            this._onDragDrop.add(this.onDragDropHandler);
        }

        public function get onDragEnter():ISignal
        {
            return (this._onDragEnter);
        }

        public function get onDragMove():ISignal
        {
            return (this._onDragMove);
        }

        public function get onDragExit():ISignal
        {
            return (this._onDragExit);
        }

        public function get onDragDrop():ISignal
        {
            return (this._onDragDrop);
        }

        private function onDragExitHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            if (_arg2.hasDataForFormat("product"))
            {
                (_arg2.getDataForFormat("product")["avatar"] as ProductAvatar).hideIcon();
            };
        }

        private function onDragEnterHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            if (_arg2.hasDataForFormat("product"))
            {
                DragDropManager.acceptDrag(_arg1);
                (_arg2.getDataForFormat("product")["avatar"] as ProductAvatar).showIcon();
            };
        }

        public function onDragDropHandler(_arg1:IDropTarget, _arg2:DragData, _arg3:Number, _arg4:Number):void
        {
            var _local5:Point;
            if (_arg2.hasDataForFormat("product"))
            {
                _local5 = this._room.globalToLocal(this.localToGlobal(new Point(_arg3, _arg4)));
                this.room.addProduct((_arg2.getDataForFormat("product")["product"] as MobileProductVO), _local5, _arg2.getDataForFormat("product")["offsetX"], _arg2.getDataForFormat("product")["offsetY"]);
		//		var productVo:MobileProductVO = (_arg2.getDataForFormat("product")["product"] as MobileProductVO);
				this._productDrop.dispatch(this.room.productManager.getItemAt(this.room.productManager.length-1), _local5);
            };
        }

        private function resetMeasure():void
        {
            this._drawArea.reset();
        }

        private function drawMeasure():void
        {
            this._drawArea.drawMeasure(this._room);
            this.calcArea();
        }

        private function calcArea():void
        {
            var _local2:RoomPoint;
            var _local3:RoomPoint;
            var _local1:Number = 0;
            var _local4:uint = this._room.pointManager.length;
            var _local5:int;
            while (_local5 < _local4)
            {
                _local2 = this._room.pointManager.getItemAt(_local5);
                _local3 = (((_local5)<(_local4 - 1)) ? this._room.pointManager.getItemAt((_local5 + 1)) : this._room.pointManager.getItemAt(0));
                _local1 = (_local1 + (RoomMeasure.px2cm((_local2.my + _local3.my), false) * RoomMeasure.px2cm((_local2.mx - _local3.mx), false)));
                _local5++;
            };
            this._areaChange.dispatch((Math.abs(_local1) / 20000));
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local6:Number;
            var _local7:Touch;
            var _local8:Touch;
            var _local9:Point;
            var _local10:Point;
            var _local11:Point;
            var _local12:Point;
            var _local13:Point;
            var _local14:Point;
            var _local15:Point;
            var _local16:Point;
            var _local17:Number;
            var _local18:Number;
            var _local19:Number;
            var _local2:Touch = _arg1.getTouch(stage);
            if (_local2 != null)
            {
                if (_local2.phase == TouchPhase.BEGAN)
                {
                    this._touchPhase = TouchPhase.BEGAN;
                }
                else
                {
                    if (_local2.phase == TouchPhase.ENDED)
                    {
                        if (this._touchPhase == TouchPhase.MOVED)
                        {
                            _local6 = ((100 * this._bg.scaleX) % Constants.ZOOM_SNAP_MODAL);
                            if (_local6 <= Constants.ZOOM_SNAP_MARGIN)
                            {
                                this._bg.scaleX = (((100 * this._bg.scaleX) - _local6) / 100);
                                this._bg.scaleY = this._bg.scaleX;
                                this.syncRoom();
                            }
                            else
                            {
                                if (_local6 >= (Constants.ZOOM_SNAP_MODAL - Constants.ZOOM_SNAP_MARGIN))
                                {
                                    this._bg.scaleX = (((100 * this._bg.scaleX) + (Constants.ZOOM_SNAP_MODAL - _local6)) / 100);
                                    this._bg.scaleY = this._bg.scaleX;
                                    this.syncRoom();
                                };
                            };
                        };
                        this._touchPhase = TouchPhase.ENDED;
                        this._touchEnded.dispatch();
                    };
                };
            };
            var _local3:Vector.<Touch> = _arg1.getTouches(this, TouchPhase.MOVED);
            var _local4:Number = this._bg.x;
            var _local5:Number = this._bg.y;
            if (_local3.length >= 2)
            {
                this.moving = true;
            }
            else
            {
                this.moving = false;
            };
            if (_local3.length == 1)
            {
                this._delta = _local3[0].getMovement(this);
                _local4 = (this._bg.x + this._delta.x);
                _local5 = (this._bg.y + this._delta.y);
            }
            else
            {
                if (_local3.length == 2)
                {
                    _local7 = _local3[0];
                    _local8 = _local3[1];
                    _local9 = _local7.getLocation(this);
                    _local10 = _local7.getPreviousLocation(this);
                    _local11 = _local8.getLocation(this);
                    _local12 = _local8.getPreviousLocation(this);
                    _local13 = _local9.subtract(_local11);
                    _local14 = _local10.subtract(_local12);
                    _local15 = _local7.getPreviousLocation(this._bg);
                    _local16 = _local8.getPreviousLocation(this._bg);
                    this._bg.pivotX = ((_local15.x + _local16.x) >> 1);
                    this._bg.pivotY = ((_local15.y + _local16.y) >> 1);
                    _local17 = (_local13.length / _local14.length);
                    _local18 = Math.min(Constants.MAX_ZOOM, Math.max(Constants.MIN_ZOOM, (this._bg.scaleX * _local17)));
                    _local19 = Math.min(Constants.MAX_ZOOM, Math.max(Constants.MIN_ZOOM, (this._bg.scaleY * _local17)));
                    this._bg.scaleX = _local18;
                    this._bg.scaleY = _local19;
                    _local4 = ((_local9.x + _local11.x) >> 1);
                    _local5 = ((_local9.y + _local11.y) >> 1);
                };
            };
            if (_local3.length > 0)
            {
                this._bg.x = ((isNaN(_local4)) ? this._bg.x : Math.max(((this._bg.pivotX - (1.5 * stage.stageWidth)) * this._bg.scaleX), Math.min(_local4, (this._bg.pivotX * this._bg.scaleX))));
                this._bg.y = ((isNaN(_local5)) ? this._bg.y : Math.max(((this._bg.pivotY - (1.5 * stage.stageHeight)) * this._bg.scaleY), Math.min(_local5, (this._bg.pivotY * this._bg.scaleY))));
                this.syncRoom();
                this._touchPhase = TouchPhase.MOVED;
            };
        }

        private function syncRoom():void
        {
            var _local1:Point = this._bg.localToGlobal(new Point((this.INITIAL_ROOM_X - this.INITIAL_BG_X), (this.INITIAL_ROOM_Y - this.INITIAL_BG_Y)));
            _local1 = this.globalToLocal(_local1);
            this._room.x = _local1.x;
            this._room.y = _local1.y;
            this._room.scaleX = this._bg.scaleX;
            this._room.scaleY = this._bg.scaleY;
            this._drawArea.x = this._room.x;
            this._drawArea.y = this._room.y;
            this._drawArea.scaleX = this._bg.scaleX;
            this._drawArea.scaleY = this._bg.scaleY;
            this._zoomChange.dispatch((100 * this._bg.scaleX));
        }

        public function setPosition(_arg1:String):void
        {
            var _local2:Rectangle;
            var _local3:int;
            var _local4:int;
            if (((!((this._bg == null))) && (!((this._room == null)))))
            {
                if (_arg1 == "zero")
                {
                    this._bg.pivotX = (this._bg.pivotY = 0);
                    this._bg.scaleX = (this._bg.scaleY = 1);
                    this._bg.x = this.INITIAL_BG_X;
                    this._bg.y = this.INITIAL_BG_Y;
                    this.syncRoom();
                }
                else
                {
                    if (_arg1 == "center")
                    {
                        this._room.scaleX = (this._room.scaleY = 1);
                        _local2 = this.room.getBounds(this.room.root);
                        if ((((_local2.width > stage.stageWidth)) || ((_local2.height > stage.stageHeight))))
                        {
                            this._bg.scaleX = (this._bg.scaleY = Math.min((stage.stageWidth / _local2.width), (stage.stageHeight / _local2.height)));
                        }
                        else
                        {
                            this._bg.scaleX = (this._bg.scaleY = 1);
                        };
                        this.syncRoom();
                        _local2 = this.room.getBounds(this.room.root);
                        _local3 = ((stage.stageWidth - _local2.width) >> 1);
                        _local4 = ((stage.stageHeight - _local2.height) >> 1);
                        this._bg.x = (this._bg.x + (_local3 - _local2.x));
                        this._bg.y = (this._bg.y + (_local4 - _local2.y));
                        this.syncRoom();
                    };
                };
            };
        }

        public function resetZoom():void
        {
            this._bg.scaleX = (this._bg.scaleY = 1);
            this.syncRoom();
        }


    }
}//package at.polypex.badplaner.view
