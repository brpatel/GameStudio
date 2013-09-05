package com.adobe.gamebuilder.editor.model
{
    import com.adobe.gamebuilder.editor.core.data.MobileCategoryVO;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.model.data.BasePoint;
    import com.adobe.gamebuilder.editor.model.data.BaseRoom;
    import com.adobe.gamebuilder.editor.model.data.BaseSide;
    import com.adobe.gamebuilder.editor.model.data.Plan;
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    import com.adobe.gamebuilder.editor.view.layout.PointAlign;

    public class AppModel 
    {

        private const BASE_ROOMS:Object = {
            1:BaseRoom.createInstance(1, [BasePoint.createInstance(0, 0, PointAlign.LEFT, PointAlign.TOP), BasePoint.createInstance(1280, 0, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(1280, 800, PointAlign.RIGHT, PointAlign.BOTTOM), BasePoint.createInstance(0, 800, PointAlign.LEFT, PointAlign.BOTTOM)], [BaseSide.createInstance("A", 2, 3), BaseSide.createInstance("B", 1, 2), BaseSide.createInstance("C", 0, 1), BaseSide.createInstance("D", 3, 0)])
            //2:BaseRoom.createInstance(2, [BasePoint.createInstance(0, 0, PointAlign.LEFT, PointAlign.TOP), BasePoint.createInstance(200, 0, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(200, 50, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(350, 50, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(350, 300, PointAlign.RIGHT, PointAlign.BOTTOM), BasePoint.createInstance(0, 300, PointAlign.LEFT, PointAlign.BOTTOM)], [BaseSide.createInstance("A", 4, 5), BaseSide.createInstance("B", 3, 4), BaseSide.createInstance("C", 0, 1), BaseSide.createInstance("D", 5, 0), BaseSide.createInstance("E", 1, 2), BaseSide.createInstance("F", 2, 3)]),
            //3:BaseRoom.createInstance(3, [BasePoint.createInstance(0, 0, PointAlign.LEFT, PointAlign.TOP), BasePoint.createInstance(150, 0, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(300, 150, PointAlign.RIGHT, PointAlign.TOP), BasePoint.createInstance(300, 300, PointAlign.RIGHT, PointAlign.BOTTOM), BasePoint.createInstance(0, 300, PointAlign.LEFT, PointAlign.BOTTOM)], [BaseSide.createInstance("A", 3, 4), BaseSide.createInstance("B", 2, 3), BaseSide.createInstance("C", 0, 1), BaseSide.createInstance("D", 4, 0)])
        };

        public var currentPlan:Plan;
        private var _productList:Array;
        private var _mainCategoryList:Array;
        private var _subCategoryList:Array;
		public var _assets:Vector.<ObjectAsset>;

        public function AppModel()
        {
            this.currentPlan = new Plan();
			this._assets = new Vector.<ObjectAsset>();
        }

        public function get mainCategoryList():Array
        {
            return (this._mainCategoryList);
        }

        public function get subCategoryList():Array
        {
            return (this._subCategoryList);
        }

        public function get productList():Array
        {
            return (this._productList);
        }

        public function getBaseRoom(_arg1:int):BaseRoom
        {
            return ((this.BASE_ROOMS[_arg1] as BaseRoom));
        }

        public function initProductList(_arg1:Array):void
        {
            this._productList = _arg1;
			
			
        }

        public function initCategoryList(_arg1:Array):void
        {
            this._mainCategoryList = new Array();
            this._subCategoryList = new Array();
            var _local2:int;
            while (_local2 < _arg1.length)
            {
                if (MobileCategoryVO(_arg1[_local2]).parent_id == 0)
                {
                    this._mainCategoryList.push(MobileCategoryVO(_arg1[_local2]));
					
                }
                else
                {
                    this._subCategoryList.push(MobileCategoryVO(_arg1[_local2]));
                };
                _local2++;
            };
        }


		public function insertObjectAssetInVO():void
		{
			for (var i:int = 0; i < productList.length; i++) 
			{
				MobileProductVO(productList[i]).objectAsset = _assets[i];
			}
		}
		
		public function getAssetByName(value:String):ObjectAsset
		{
			var asset:ObjectAsset;
			for each (asset in this._assets)
			{
				if (asset.className == value)
				{
					return (asset);
				};
			};
			return (null);
		}
		
		public function getProductByName(value:String):MobileProductVO
		{
			var product:MobileProductVO;
			for each (product in this.productList)
			{
				if (product.className == value)
				{
					return (product);
				};
			};
			return (null);
		}
	}
}//package at.polypex.badplaner.model
