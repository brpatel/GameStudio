package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.model.ApplicationModel;
    import com.adobe.gamebuilder.editor.model.ProjectModel;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class UpdateLastOpenProjectPath extends StarlingCommand
	{

        [Inject]
        public var projectModel:ProjectModel;
        [Inject]
        public var appModel:ApplicationModel;


        override public function execute():void
        {
            this.appModel.setLastOpenProjectPath(this.projectModel.projectFile);
        }


    }
}//package commands
