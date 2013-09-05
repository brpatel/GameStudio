package com.adobe.gamebuilder.editor.core
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    
    import flash.display.BitmapData;
    import flash.system.Capabilities;
    
    import mx.resources.ResourceManager;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Stage;
    import starling.text.TextField;

    public class Common 
    {

        public static var appStep:String = "room";
        public static var networkState:Boolean;
        public static var presentationMode:String = "off";


        public static function log(_arg1:Object, _arg2:String="DEBUG"):void
        {
        }

        public static function getScreenshot(_arg1:Stage, _arg2:uint, _arg3:uint):BitmapData
        {
            var _local4:Number = Starling.contentScaleFactor;
            var _local5:RenderSupport = new RenderSupport();
            _local5.pushMatrix();
            RenderSupport.clear(0xFFFFFF, 1);
            _local5.setOrthographicProjection((_arg2 / _local4), (_arg3 / _local4));
            var _local6:BitmapData = new BitmapData((_arg2 * _local4), (_arg3 * _local4), false);
            _arg1.render(_local5, 1);
            _local5.popMatrix();
            _local5.finishQuadBatch();
            Starling.context.drawToBitmapData(_local6);
            return (_local6);
        }

        public static function getResourceString(_arg1:String, _arg2:String="iLabels", _arg3:Array=null):String
        {
            return (ResourceManager.getInstance().getString(_arg2, _arg1, _arg3));
        }

        public static function get isAndroid():Boolean
        {
            return ((Capabilities.manufacturer.indexOf("Android") > -1));
        }

        public static function labelField(_arg1:uint, _arg2:uint, _arg3:String="", _arg4:uint=16, _arg5:String="left", _arg6:String="top", _arg7:Boolean=false, _arg8:String="defaultFont", _arg9:uint=0x333333):TextField
        {
            var _local10:TextField = new TextField(_arg1, _arg2, _arg3, _arg8, _arg4, _arg9);
            _local10.autoScale = _arg7;
            _local10.hAlign = _arg5;
            _local10.vAlign = _arg6;
            return (_local10);
        }

        public static function nbsp(_arg1:uint):String
        {
            var _local2 = "";
            var _local3:int;
            while (_local3 < _arg1)
            {
                _local2 = (_local2 + " ");
                _local3++;
            };
            return (_local2);
        }

        public static function separator(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:String="overlay"):Image
        {
            var _local5:Image = new Image(Assets.getTextureAtlas("Interface").getTexture((((_arg4)=="overlay") ? "division_line" : "sidebar_division_line")));
            _local5.x = _arg1;
            _local5.y = _arg2;
            _local5.width = _arg3;
            return (_local5);
        }


    }
}//package at.polypex.badplaner.core
