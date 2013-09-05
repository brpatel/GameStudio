package com.adobe.gamebuilder.editor.model
{
    import com.adobe.gamebuilder.editor.model.vo.ObjectAsset;
    
    import __AS3__.vec.Vector;
    
    import org.robotlegs.mvcs.Actor;

    public class AssetModel extends Actor 
    {

 /*       [Inject]
        public var assetParamParser:IAssetParamParser;
  */      [Inject]
        public var projectModel:ProjectModel;
        private var _assets:Vector.<ObjectAsset>;


        public function updateAssets():void
        {
            if (!(this.projectModel.getProjectRootDirectory()))
            {
                return;
            };
			
	//		if(this.assets ==null)
     //       	this._assets = this.assetParamParser.makeAssetsFromDirectory(this.projectModel.getProjectRootDirectory());
			
  //          dispatch(new AssetListUpdatedEvent());
        }

        public function get assets():Vector.<ObjectAsset>
        {
            return (this._assets);
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

		public function set assets(value:Vector.<ObjectAsset>):void
		{
			_assets = value;
		}


    }
}//package model
