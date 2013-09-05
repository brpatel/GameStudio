package com.adobe.gamebuilder.game.preview
{
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.URLRequest;

    public class OverlayInstance extends Sprite 
    {

        public var graphic:Loader;
        private var _offsetX:Number = 0;
        private var _offsetY:Number = 0;
        private var _registration:String = "topLeft";
        private var _view:String = "";

        public function OverlayInstance()
        {
            mouseEnabled = false;
            mouseChildren = false;
            this.graphic = new Loader();
            addChild(this.graphic);
            this.graphic.contentLoaderInfo.addEventListener(Event.COMPLETE, this.handleGraphicLoaded);
			//this.view = "editor/assets/Olive.png";
        }

        public function get offsetX():Number
        {
            return (this._offsetX);
        }

        public function set offsetX(value:Number):void
        {
            this._offsetX = value;
            this.updateGraphicPosition();
        }

        public function get offsetY():Number
        {
            return (this._offsetY);
        }

        public function set offsetY(value:Number):void
        {
            this._offsetY = value;
            this.updateGraphicPosition();
        }

        public function get registration():String
        {
            return (this._registration);
        }

        public function set registration(value:String):void
        {
            this._registration = value;
            this.updateGraphicPosition();
        }

        public function get view():String
        {
            return (this._view);
        }

        public function set view(value:String):void
        {
            this._view = value;
			if(value!=""){
				/*var _local2:File = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH + value) + ".png"));
				if (!_local2.exists)
				{
					_local2 = File.applicationDirectory.resolvePath(((Constants.PRODUCT_PATH_DEV + value) + ".png"));
				};
				var _local3:URLRequest = new URLRequest(_local2.url);
            	this.graphic.load(_local3);*/
				
				var _local3:URLRequest = new URLRequest(value);
				this.graphic.load(_local3);
			}
        }

        private function handleGraphicLoaded(e:Event):void
        {
            this.updateGraphicPosition();
        }

        private function updateGraphicPosition():void
        {
            if (this._registration == "topLeft")
            {
                this.graphic.x = this._offsetX;
                this.graphic.y = this._offsetY;
            }
            else
            {
                this.graphic.x = (-((this.graphic.width / 2)) + this._offsetX);
                this.graphic.y = (-((this.graphic.height / 2)) + this._offsetY);
            };
        }


    }
}//package components
