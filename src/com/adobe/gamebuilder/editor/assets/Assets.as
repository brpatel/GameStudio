package com.adobe.gamebuilder.editor.assets
{
    import flash.utils.Dictionary;
    import starling.textures.TextureAtlas;
    import flash.display.Bitmap;
    import starling.textures.Texture;
    import flash.utils.ByteArray;

    public class Assets 
    {

        private static var sTextures:Dictionary = new Dictionary();
        private static var atlasTextures:Dictionary = new Dictionary();
        private static var sTextureAtlas:TextureAtlas;


        public static function getTexture(_arg1:String):Texture
        {
            var _local2:Object;
            if (sTextures[_arg1] == undefined)
            {
                _local2 = create(_arg1);
                if ((_local2 is Bitmap))
                {
                    sTextures[_arg1] = Texture.fromBitmap((_local2 as Bitmap), true, false, 1);
                }
                else
                {
                    if ((_local2 is ByteArray))
                    {
                        sTextures[_arg1] = Texture.fromAtfData((_local2 as ByteArray), 1);
                    };
                };
            };
            return (sTextures[_arg1]);
        }

        public static function getTextureAtlas(_arg1:String):TextureAtlas
        {
            var _local2:Texture;
            var _local3:XML;
            if (atlasTextures[_arg1] == undefined)
            {
                _local2 = getTexture((_arg1 + "Texture"));
                _local3 = XML(create((_arg1 + "Xml")));
                atlasTextures[_arg1] = new TextureAtlas(_local2, _local3);
            };
            return (atlasTextures[_arg1]);
        }

        private static function create(_arg1:String):Object
        {
            var _local2:Class = Embeds;
            return (new (_local2[_arg1])());
        }


    }
}//package at.polypex.badplaner.assets
