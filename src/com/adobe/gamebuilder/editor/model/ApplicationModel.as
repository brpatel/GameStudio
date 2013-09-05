package com.adobe.gamebuilder.editor.model
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import org.robotlegs.mvcs.Actor;

    public class ApplicationModel extends Actor 
    {

       
        [Inject]
        public var projectModel:ProjectModel;
        private var _lastOpenProjectFile:File;
        private var _firstRun:Boolean = false;
        private var currCodeFileIndex:uint = 0;
        private var _zipCodeProcessing:Boolean = false;
        private var _zipCodeWriteInterval:uint;
        private var _codeDirectory:File;
        private var _resizeBoundsToGraphic:Boolean = true;


        public function get lastOpenProjectFile():File
        {
            return (this._lastOpenProjectFile);
        }

        public function get zipCodeProcessing():Boolean
        {
            return (this._zipCodeProcessing);
        }

        public function get resizeBoundsToGraphic():Boolean
        {
            return (this._resizeBoundsToGraphic);
        }

        public function set resizeBoundsToGraphic(value:Boolean):void
        {
            this._resizeBoundsToGraphic = value;
            this.writeToAppFile();
        }

        public function openApplicationFile():void
        {
            var file:File;
            var stream:FileStream;
            var data:Object;
            file = File.applicationStorageDirectory.resolvePath("AppData.fuck");
			
			// Modified to get the SampleProject.ce file on first run
			if (!file.exists)
			{
				var dir:File = File.applicationStorageDirectory; 
				dir = dir.resolvePath("SampleProject.ce"); 
				setLastOpenProjectPath(dir);
			}
				
			
            if (file.exists)
            {
                stream = new FileStream();
                stream.open(file, FileMode.READ);
                try
                {
                    data = stream.readObject();
                    stream.close();
                    if (!(this.deserialize(data)))
                    {
                        file.deleteFile();
                    };
                }
                catch(e:Error)
                {
                    trace(("Error: " + e.message));
                    stream.close();
                    file.deleteFile();
                };
            }
            else
            {
                this._firstRun = true;				
				
            };
        }

        public function setLastOpenProjectPath(file:File):void
        {
            this._lastOpenProjectFile = file;
            this.writeToAppFile();
        }

       

        public function checkForFirstRun():Boolean
        {
            return (this._firstRun);
        }

       
        private function deserialize(data:Object):Boolean
        {
            var data:Object = data;
            try
            {
                this._lastOpenProjectFile = new File(data.lastOpenProjectPath);
            }
            catch(e:Error)
            {
                trace(("Error: " + e.message));
                return (false);
            };
            this._resizeBoundsToGraphic = data.resizeBoundsToGraphic;
            return (true);
        }

        private function serialize():Object
        {
            var data:Object = {};
            data.lastOpenProjectPath = this._lastOpenProjectFile.nativePath;
            data.resizeBoundsToGraphic = this._resizeBoundsToGraphic;
            return (data);
        }

        private function writeToAppFile():void
        {
            var file:File = File.applicationStorageDirectory.resolvePath("AppData.fuck");
            var data:Object = this.serialize();
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeObject(data);
            stream.close();
        }

       


    }
}//package model
