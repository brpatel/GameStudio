package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.core.data.MobileCategoryVO;
    import com.adobe.gamebuilder.editor.core.data.MobileProductVO;
    import com.adobe.gamebuilder.editor.core.data.ParamsVO;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.core.manager.DBManager;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.model.AssetModel;
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    import com.adobe.gamebuilder.editor.model.vo.ObjectAssetParam;
    
    import flash.data.SQLResult;
    import flash.data.SQLStatement;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class ProductLoading extends StarlingCommand 
    {

        [Inject]
        public var appModel:AppModel;
		
		[Inject]
		public var assetModel:AssetModel;


        override public function execute():void
        {
            var _local1:SQLResult;
            var _local2:SQLStatement = new SQLStatement();
            _local2.sqlConnection = DBManager.productDBConnection;
            _local2.itemClass = MobileProductVO;
            _local2.text = "SELECT * FROM products ORDER BY sort_index";
            _local2.execute();
            _local1 = _local2.getResult();
            if (((!((_local1 == null))) && (!((_local1.data == null)))))
            {
                this.appModel.initProductList(_local1.data);
            };
			
			// For each product add objectAsset
			for (var i:int = 0; i < _local1.data.length; i++) 
			{
				var paramResult:SQLResult;
				var params:Vector.<ObjectAssetParam> =  new Vector.<ObjectAssetParam>();
				_local2.itemClass = ParamsVO;
				_local2.text = "SELECT * FROM params p, product_to_params pp where p.id = pp.paramID AND  pp.productID="+_local1.data[i]['id']+" ";
				_local2.execute();
				paramResult = _local2.getResult();
				// For each params, construct ObjectAssetParam
				if( paramResult.data !=null){
					for (var j:int = 0; j < paramResult.data.length; j++) 
					{
						var object:Object = new Object();
						object.value = paramResult.data[j]['value'];
						params.push(new ObjectAssetParam(paramResult.data[j]['name'], paramResult.data[j]['type'], paramResult.data[j]['inherited'], object));
					}
				}
				
				this.appModel._assets.push(new ObjectAsset(_local1.data[i]['className'], _local1.data[i]['superClassName'], params));
				this.assetModel.assets = this.appModel._assets;
				
			}
			this.appModel.insertObjectAssetInVO();
            _local2.itemClass = MobileCategoryVO;
            _local2.text = "SELECT * FROM categories ORDER BY sort_index";
            _local2.execute();
            _local1 = _local2.getResult();
            if (((!((_local1 == null))) && (!((_local1.data == null)))))
            {
                this.appModel.initCategoryList(_local1.data);
            };
            dispatch(new ContextEvent(ContextEvent.PRODUCT_LOAD_COMPLETE));
        }


    }
}//package at.polypex.badplaner.commands
