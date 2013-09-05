package com.adobe.gamebuilder.editor.commands
{
	import com.adobe.gamebuilder.editor.model.ApplicationModel;
	import com.adobe.gamebuilder.editor.model.ProjectModel;
	
	import org.robotlegs.mvcs.StarlingCommand;
    

    public class SetupApplication extends StarlingCommand 
    {

        [Inject]
        public var appModel:ApplicationModel;
        [Inject]
        public var projectModel:ProjectModel;


        override public function execute():void
        {
            this.appModel.openApplicationFile();
            if (((this.appModel.lastOpenProjectFile) && (this.appModel.lastOpenProjectFile.exists)))
            {
                this.projectModel.openProject(this.appModel.lastOpenProjectFile);
            };
        }


    }
}//package commands
