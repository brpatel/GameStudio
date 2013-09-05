package com.adobe.gamebuilder.editor.model
{
	import com.adobe.gamebuilder.editor.view.events.ProjectEvent;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ProjectModel extends Actor 
	{
		
		private var _projectFile:File;
		private var _rootPath:String = "..";
		private var _swfPath:String;
		
		
		public function get projectFilePath():String
		{
			return (this._projectFile.url);
		}
		
		public function get rootPath():String
		{
			return (this._rootPath);
		}
		
		public function set rootPath(value:String):void
		{
			this._rootPath = value;
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_ROOT_UPDATED));
		}
		
		public function get swfPath():String
		{
			return (this._swfPath);
		}
		
		public function set swfPath(value:String):void
		{
			var swfFile:File;
			if (this._swfPath == value)
			{
				return;
			};
			this._swfPath = value;
			if (this._swfPath != null)
			{
				swfFile = this.getSWFFile();
				if (((!(swfFile)) || (!(swfFile.exists))))
				{
					this._swfPath = null;
					dispatch(new ProjectEvent(ProjectEvent.SWF_PATH_BROKEN));
				};
			};
			dispatch(new ProjectEvent(ProjectEvent.SWF_PATH_UPDATED));
		}
		
		public function get projectFile():File
		{
			return (this._projectFile);
		}
		
		public function getProjectRootDirectory():File
		{
			if (this._projectFile)
			{
				if(this._rootPath !=null)
					return (this._projectFile.resolvePath(this._rootPath));
				else
					return (this._projectFile.resolvePath("../../../../../Adobe Flash Builder 4.6/PopeyeCitrusAir/bin-debug/editor/assets/engine"));
			};
			return (null);
		}
		
		public function getSWFFile():File
		{
			var rootDirectory:File = this.getProjectRootDirectory();
			if (((rootDirectory) && (this._swfPath)))
			{
				return (rootDirectory.resolvePath(this._swfPath));
			};
			return (null);
		}
		
		public function createNewProject():void
		{
			
			var file:File = new File();
			file.browseForSave("Choose a location for your new Citrus Engine project");
			file.addEventListener(Event.SELECT, this.handleSelectNewProjectLocation);
		}
		
		public function openProject(file:File=null):void
		{
			/*		var originalFile:File = File.applicationDirectory.resolvePath("editor/assets/engine/com/citrusengine/objects/platformer/Platform.as");
			// open and “READ” the content of the file
			var fileStream:FileStream = new FileStream();
			fileStream.open(originalFile, FileMode.READ);
			var fileContent:String = fileStream.readUTF();
			fileStream.close();
			
			// create the new file  
			var applicationStorageDirectoryPath:File = File.applicationStorageDirectory;
			var nativePathToApplicationStorageDirectory:String = applicationStorageDirectoryPath.nativePath.toString();
			nativePathToApplicationStorageDirectory += "/editor/assets/engine/com/citrusengine/objects/platformer/Platform.as";
			file = new File(nativePathToApplicationStorageDirectory);
			
			// write the contents from the other file to the new file
			var writeStream:FileStream = new FileStream();
			writeStream.open(file, FileMode.WRITE);
			writeStream.writeUTF(fileContent);
			writeStream.close();
			
			var fileStream1:FileStream = new FileStream();
			fileStream1.open(file, FileMode.READ);
			var fileData:Object = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable)); //decode
			fileStream1.close();*/
			
			if (file)
			{
				this._projectFile = file;
				dispatch(new ProjectEvent(ProjectEvent.PROJECT_OPENED));
				this.readProjectFile();
			}
			else
			{
				file = new File();
				file.browseForOpen("Open Citrus Engine Project", [new FileFilter("Citrus Engine Project", "*.ce")]);
				file.addEventListener(Event.SELECT, this.handleFileOpen, false, 0, true);
			};
		}
		
		public function saveProject(fallBackToSaveAs:Boolean=true):void
		{
			var fileStream:FileStream;
			var serializedProjectData:Object;
			if (this._projectFile)
			{
				fileStream = new FileStream();
				serializedProjectData = this.serializeData();
				fileStream.open(this._projectFile, FileMode.WRITE);
				fileStream.writeUTFBytes(JSON.stringify(serializedProjectData)); //encode
				fileStream.close();
				dispatch(new ProjectEvent(ProjectEvent.PROJECT_SAVED));
			}
			else
			{
				if (fallBackToSaveAs)
				{
					this.saveProjectAs();
				};
			};
		}
		
		public function saveProjectAs():void
		{
			var file:File = new File();
			file.browseForSave("Save Project");
			file.addEventListener(Event.SELECT, this.handleFileSaveAs, false, 0, true);
		}
		
		public function chooseRoot():void
		{
			var file:File = this._projectFile.clone();
			file.browseForDirectory("Choose Project Root Folder");
			file.addEventListener(Event.SELECT, this.handleRootChosen);
		}
		
		public function chooseSWF():void
		{
			var file:File = this.getProjectRootDirectory();
			file.browseForOpen("Locate your game's SWF");
			file.addEventListener(Event.SELECT, this.handleSWFChosen);
		}
		
		public function launchSWF():void
		{
			var file:File = this.getSWFFile();
			file.openWithDefaultApplication();
		}
		
		private function serializeData():Object
		{
			var object:Object = {};
			if (this._rootPath)
			{
				object.rootPath = this._rootPath;
			};
			if (this._swfPath)
			{
				object.swfPath = this._swfPath;
			};
			return (object);
		}
		
		private function deserializeData(fileData:Object):void
		{
			this.rootPath = fileData.rootPath;
			this.swfPath = fileData.swfPath;
		}
		
		private function handleFileOpen(e:Event):void
		{
			this._projectFile = File(e.target);
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_OPENED));
			this.readProjectFile();
		}
		
		private function handleFileSaveAs(e:Event):void
		{
			this._projectFile = File(e.target);
			if (((!(this._projectFile.extension)) || (!((this._projectFile.extension == "ce")))))
			{
				this._projectFile.nativePath = (this._projectFile.nativePath + ".ce");
			};
			this.saveProject();
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_ROOT_UPDATED));
		}
		
		private function handleSelectNewProjectLocation(e:Event):void
		{
			this._projectFile = File(e.target);
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_CREATED));
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_OPENED));
			if (((!(this._projectFile.extension)) || (!((this._projectFile.extension == "ce")))))
			{
				this._projectFile.nativePath = (this._projectFile.nativePath + ".ce");
			};
			this.rootPath = "..";
			this.swfPath = null;
			this.saveProject();
		}
		
		private function handleRootChosen(e:Event):void
		{
			this.rootPath = this.projectFile.getRelativePath(File(e.target), true);
			this.saveProject(false);
		}
		
		private function handleSWFChosen(e:Event):void
		{
			this.swfPath = this.getProjectRootDirectory().getRelativePath(File(e.target), true);
			this.saveProject(false);
		}
		
		private function readProjectFile():void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(this._projectFile, FileMode.READ);
			var fileData:Object = JSON.parse(fileStream.readUTFBytes(fileStream.bytesAvailable)); //decode
			fileStream.close();
			this.deserializeData(fileData);
		}
		
		// modified for first project
		public function openProjectForFirstRun():void
		{
			
			this._projectFile = File.applicationStorageDirectory.resolvePath("SampleProject.ce");
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_CREATED));
			dispatch(new ProjectEvent(ProjectEvent.PROJECT_OPENED));
			if (((!(this._projectFile.extension)) || (!((this._projectFile.extension == "ce")))))
			{
				this._projectFile.nativePath = (this._projectFile.nativePath + ".ce");
			};
			//	saveASFiles();
			this.rootPath =  File.applicationStorageDirectory.nativePath; //"../../../../../Adobe Flash Builder 4.6/PopeyeCitrusAir/bin-debug/editor/assets/engine";
			this.swfPath = null;
			this.saveProject();
		}
		
		/*public function saveASFiles():void{
		
		var physicsClassText:String = "package com.citrusengine.objects { import com.citrusengine.core.CitrusObject; public class PhysicsObject extends CitrusObject implements ISpriteView {" +
		"[Property(value=\"0\")] 		public function set x(value:Number):void " +
		"[Property(value=\"0\")] 		public function set y(value:Number):void";
		
		writeFile("PhysicsObject.as", physicsClassText);
		
		var citrusSpriteClassText:String = "package com.citrusengine.objects { import com.citrusengine.core.CitrusObject; public class CitrusSprite extends CitrusObject implements ISpriteView {" +
		"[Property(value=\"0\")] 		public function set x(value:Number):void " +
		"[Property(value=\"0\")] 		public function set y(value:Number):void";
		
		writeFile("CitrusSprite.as", citrusSpriteClassText);
		
		var platformClassText:String = "package com.citrusengine.objects.platformer.box2d { import com.citrusengine.objects.PhysicsObject;" +
		"public class Platform extends PhysicsObject	{		[Property(value=\"platform.png\")] 		public var iconImage:String = \"platform.png\"; ";
		
		writeFile("Platform.as", platformClassText);
		
		var heroClassText:String = "package com.citrusengine.objects.platformer.box2d { import com.citrusengine.objects.PhysicsObject;" +
		"public class Hero extends PhysicsObject	{		[Property(value=\"1\")] 		public var acceleration:Number = 1; ";
		
		writeFile("Hero.as", heroClassText);
		
		var popeyeClassText:String = "package objects  { import com.citrusengine.objects.PhysicsObject;" +
		"public class Popeye extends Hero	{		[Property(value=\"Popeye.png\")] 		public var iconImage:String = \"Popeye.png\"; ";
		
		
		writeFile("Popeye.as", popeyeClassText);
		
		
		
		
		}
		
		private function readFile(ARG_file:String):String {
		// get the file that we included with the application   
		var file:File = File.applicationStorageDirectory.resolvePath("data/" + ARG_file);
		
		// open and “READ” the content of the file
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		var fileContent:String = fileStream.readUTF();
		fileStream.close();
		return fileContent;
		}
		
		private function writeFile(ARG_file:String, ARG_content:String):void {
		// find the file    
		var applicationStorageDirectoryPath:File = File.applicationStorageDirectory;
		var nativePathToApplicationStorageDirectory:String = applicationStorageDirectoryPath.nativePath.toString();
		nativePathToApplicationStorageDirectory += "/data/" + ARG_file;
		var file:File  = new File(nativePathToApplicationStorageDirectory);
		
		// write the contents parameter
		var writeStream:FileStream = new FileStream();
		writeStream.open(file, FileMode.WRITE);
		writeStream.writeUTFBytes(ARG_content);
		writeStream.close();
		}
		*/
		
		
	}
}