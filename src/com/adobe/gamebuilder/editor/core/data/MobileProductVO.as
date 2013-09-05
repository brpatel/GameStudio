
package com.adobe.gamebuilder.editor.core.data
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    
    import starling.textures.Texture;

    public class MobileProductVO 
    {

        public var id:int;
        public var name:String;
        public var url_title:String;
        public var artnr:int;
        public var category:int;
        public var subcats:String;
        private var _file_id:String;
        public var sort_index:int;
        public var scaleable:Boolean;
        public var info:Boolean;
        public var iconTexture:Texture;
        public var accessoryTexture:Texture;
		
		// For level editor
		public var className:String;
		public var superClassName:String;
		public var objectAsset:ObjectAsset;


        public static function fromProductVO(_arg1:Object):MobileProductVO
        {
            var _local2:MobileProductVO = new (MobileProductVO)();
            _local2.file_id = String(_arg1.filepath).substring(0, String(_arg1.filepath).indexOf("."));
            _local2.scaleable = _arg1.scaleable;
            return (_local2);
        }

        public static function toProductVO(_arg1:MobileProductVO):ProductVO
        {
            var _local2:ProductVO = new ProductVO();
            _local2.scaleable = _arg1.scaleable;
            _local2.filepath = (_arg1.file_id + ".swf");
            return (_local2);
        }


        public function get file_id():String
        {
            return (this._file_id);
        }

        public function set file_id(_arg1:String):void
        {
            this._file_id = _arg1;
            this.iconTexture = Assets.getTextureAtlas("ProductThumbs").getTexture(this._file_id);
            this.accessoryTexture = Assets.getTextureAtlas("Interface").getTexture("list_info_icon_up");
        }

        public function cloneForStorage():MobileProductVO
        {
            var _local1:MobileProductVO = new MobileProductVO();
            _local1.file_id = this.file_id;
            _local1.scaleable = this.scaleable;
            return (_local1);
        }


    }
}//package at.polypex.badplaner.core.data
