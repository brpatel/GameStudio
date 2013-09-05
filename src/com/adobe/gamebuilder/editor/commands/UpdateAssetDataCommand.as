package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.AssetModel;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class UpdateAssetDataCommand extends StarlingCommand 
    {

        [Inject]
        public var assetModel:AssetModel;


        override public function execute():void
        {
            this.assetModel.updateAssets();
        }


    }
}//package commands
