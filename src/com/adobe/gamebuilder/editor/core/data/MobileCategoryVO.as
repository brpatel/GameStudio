
package com.adobe.gamebuilder.editor.core.data
{
    public class MobileCategoryVO 
    {

        public var id:int;
        public var name:String;
        public var name_en:String;
        public var url_title:String;
        public var sort_index:int;
        public var parent_id:int;


        public function toString():String
        {
            return ((((((((((("[CategoryVO (id:" + this.id) + ", name:") + this.name) + ", url_title:") + this.url_title) + ", sort_index:") + this.sort_index) + ", parent_id:") + this.parent_id) + ")]"));
        }


    }
}
