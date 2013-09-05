package com.adobe.gamebuilder.editor.model.vo
{
    import com.adobe.gamebuilder.editor.model.AssetModel;
    import com.adobe.gamebuilder.editor.view.events.GameStateEvent;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.net.FileFilter;
    import flash.utils.setTimeout;
    
    import __AS3__.vec.Vector;
    
    import org.osflash.signals.Signal;
    import org.robotlegs.mvcs.Actor;

    public class GameState extends Actor
    {

        [Inject]
        public var assetModel:AssetModel;
        public var lastGroupUsed:int = 0;
        private var _name:String = "Untitled Level";
        private var _objects:Vector.<ObjectInstance>;
        private var _gameStateFile:File;
        private var _isFileOutOfDate:Boolean = false;
        private var _selectedObject:ObjectInstance;
        private var _clipboard:ObjectInstance;
		//Changed from private to public
        public var _lastObjectID:int = -1;
		private var _objectSelected:Signal;

        public function GameState()
        {
            this._objects = new Vector.<ObjectInstance>();
			this._objectSelected = new Signal();
            super();
        }
		public function get objectSelected():Signal
		{
			return (this._objectSelected);
		}

        public function get name():String
        {
            return (this._name);
        }

        public function set name(value:String):void
        {
            this._name = value;
            dispatch(new GameStateEvent(GameStateEvent.GAME_STATE_RENAMED));
        }

        public function get objects():Vector.<ObjectInstance>
        {
            return (this._objects);
        }

        public function get gameStateFile():File
        {
            return (this._gameStateFile);
        }

        public function get isFileOutOfDate():Boolean
        {
            return (this._isFileOutOfDate);
        }

        public function set isFileOutOfDate(value:Boolean):void
        {
            this._isFileOutOfDate = value;
        }

        public function get selectedObject():ObjectInstance
        {
            return (this._selectedObject);
        }

        public function set selectedObject(value:ObjectInstance):void
        {
            if (this._selectedObject == value)
            {
                return;
            };
            this._selectedObject = value;
            dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_SELECTED, this._selectedObject));
        }

        public function get clipboard():ObjectInstance
        {
            return (this._clipboard);
        }

        public function getObjectByID(id:uint):ObjectInstance
        {
            var objectInstance:ObjectInstance;
            for each (objectInstance in this._objects)
            {
                if (objectInstance.id == id)
                {
                    return (objectInstance);
                };
            };
            return (null);
        }

        public function createObject(object:ObjectAsset, x:Number, y:Number, group:int, dispatchIt:Boolean=true, customSize:Boolean=false, name:String=null,imported:Boolean=false):ObjectInstance
        {
            var item:ObjectAssetParam;
            var newParams:Vector.<ObjectInstanceParam> = new Vector.<ObjectInstanceParam>();
            var i:int;
            while (i < object.params.length)
            {
                item = object.params[i];
                if (item.name == "x")
                {
                    item.value = x;
                }
                else
                {
                    if (item.name == "y")
                    {
                        item.value = y;
                    }
                    else
                    {
                        if (item.name == "group")
                        {
                            item.value = group.toString();
                        };
                    };
                };
                newParams.push(new ObjectInstanceParam(item.name, item.type, item.inherited, item.options));
                i++;
            };
            this._lastObjectID++;
            var objectInstance:ObjectInstance = new ObjectInstance(this._lastObjectID, object.className, object.superClassName, newParams, customSize, name);
            this._objects.push(objectInstance);
            this._isFileOutOfDate = true;
            if (dispatchIt)
            {
                dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_CREATED, objectInstance));
            };
            return (objectInstance);
        }

        public function copyToClipboard(objectInstance:ObjectInstance):void
        {
            this._clipboard = objectInstance.copy(-1);
            dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.ADDED_TO_CLIPBOARD, this._clipboard));
        }

        public function pasteFromClipboard(newPosition:Point=null):void
        {
            var updates:Array;
            var newObject:ObjectInstance;
            if (this._clipboard)
            {
                dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.COPY_OBJECT, this._clipboard));
                if (newPosition)
                {
                    updates = [];
                    newObject = this._objects[(this._objects.length - 1)];
                    updates.push(new PropertyUpdateVO(newObject, "x", newPosition.x));
                    updates.push(new PropertyUpdateVO(newObject, "y", newPosition.y));
                    dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
                };
            };
        }

        public function deleteObject(object:ObjectInstance):void
        {
            this._objects.splice(this._objects.indexOf(object), 1);
            this._isFileOutOfDate = true;
            dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_DELETED, object));
        }

        public function restoreObject(object:ObjectInstance):void
        {
            this._objects.push(object);
            this._isFileOutOfDate = true;
            dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_CREATED, object));
        }

        public function copyObject(object:ObjectInstance, dispatchIt:Boolean=true):ObjectInstance
        {
            var objectInstance:ObjectInstance;
            var object:ObjectInstance = object;
            var dispatchIt:Boolean = dispatchIt;
            this._lastObjectID++;
            objectInstance = object.copy(this._lastObjectID);
            this._objects.push(objectInstance);
            this._isFileOutOfDate = true;
            if (dispatchIt)
            {
                dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_CREATED, objectInstance));
            };
            this.selectedObject = null;
            setTimeout(function ():void
            {
                selectedObject = objectInstance;
            }, 1);
            return (objectInstance);
        }

        public function renameObject(object:ObjectInstance, name:String):void
        {
            object.name = name;
            dispatch(new ObjectInstanceEvent(ObjectInstanceEvent.OBJECT_RENAMED, object));
        }

        public function createGameState(name:String):void
        {
            this._name = name;
            this.lastGroupUsed = 0;
            this._lastObjectID = -1;
            this._objects.length = 0;
            this.selectedObject = null;
            dispatch(new GameStateEvent(GameStateEvent.ALL_OBJECTS_CLEARED));
            this._isFileOutOfDate = false;
            this._gameStateFile = null;
        }

        public function openGameState(file:File=null):void
        {
            var fileStream:FileStream;
            if (((!(file)) || (!(file.exists))))
            {
                file = new File();
                file.browseForOpen("Open Level File", [new FileFilter("Citrus Engine Level", "*.lev")]);
                file.addEventListener(Event.SELECT, this.handleFileOpen, false, 0, true);
            }
            else
            {
                this._gameStateFile = file;
                fileStream = new FileStream();
                fileStream.open(this._gameStateFile, FileMode.READ);
                this.deserializeFromXML(XML(fileStream.readUTFBytes(fileStream.bytesAvailable)));
                fileStream.close();
                this._isFileOutOfDate = false;
                dispatch(new GameStateEvent(GameStateEvent.GAME_STATE_OPENED));
            };
        }

        public function saveGameState():void
        {
            var fileStream:FileStream;
            var serializedGameStateData:XML;
			
			// Modified to get the sampleLevel.lev file
			if(this._gameStateFile == null){
				var dir:File = File.applicationStorageDirectory; 
				var gameName:String="Game";
				var i:int=1;
				while(dir.exists){
					dir = File.applicationStorageDirectory; 
					dir = dir.resolvePath(gameName+i+".lev"); 
					i++
				}
				
				this._gameStateFile = dir;
				trace(dir.url);
				
				
			}
			
            if (this._gameStateFile)
            {
                fileStream = new FileStream();
                serializedGameStateData = this.serializeToXML();
                fileStream.open(this._gameStateFile, FileMode.WRITE);
                fileStream.writeUTFBytes(serializedGameStateData.toString());
                fileStream.close();
                this._isFileOutOfDate = false;
                dispatch(new GameStateEvent(GameStateEvent.GAME_STATE_SAVED));
            }
            else
            {
                this.saveGameStateAs();
            };
        }

        public function saveGameStateAs():void
        {
            var file:File = new File();
            file.browseForSave("Save Level To...");
            file.addEventListener(Event.SELECT, this.handleGameStateSaveAs);
        }

        public function deleteObjectsOfClass(className:String):void
        {
            var object:ObjectInstance;
            for each (object in this.objects)
            {
                if (object.className == className)
                {
                    this.deleteObject(object);
                };
            };
        }

        private function handleGameStateSaveAs(e:Event):void
        {
            this._gameStateFile = (e.target as File);
            if (((!(this._gameStateFile.extension)) || (!((this._gameStateFile.extension == "lev")))))
            {
                this._gameStateFile.nativePath = (this._gameStateFile.nativePath + ".lev");
            };
            this.saveGameState();
        }

        private function handleFileOpen(e:Event):void
        {
            this.openGameState(File(e.target));
        }

        private function serializeToXML():XML
        {
            var item:ObjectInstance;
            var objectXML:XML;
            var j:int;
            var property:ObjectInstanceParam;
            var propertyXML:XML;
            var xml:XML = new XML(<GameState/>
            );
            xml.@name = this.name;
            var i:int;
            while (i < this._objects.length)
            {
                item = this._objects[i];
                objectXML = new XML(<CitrusObject/>
                );
                objectXML.@name = item.name;
                objectXML.@className = item.className;
                j = 0;
                while (j < item.params.length)
                {
                    property = item.params[j];
                    if (property.value != null)
                    {
                        propertyXML = new XML(<Property/>
                        );
                        propertyXML.@name = property.name;
                        propertyXML.appendChild(property.value);
                        objectXML.appendChild(propertyXML);
                    };
                    j++;
                };
                xml.appendChild(objectXML);
                i++;
            };
            return (xml);
        }

        private function deserializeFromXML(value:XML):void
        {
            var objectXML:XML;
            var objectAsset:ObjectAsset;
            var params:Vector.<ObjectInstanceParam>;
            var instance:ObjectInstance;
            var propertyUpdates:Array;
            var j:int;
            var paramXML:XML;
            var param:ObjectInstanceParam;
            this._name = value.@name;
            this.selectedObject = null;
            this._objects.length = 0;
            dispatch(new GameStateEvent(GameStateEvent.ALL_OBJECTS_CLEARED));
            var i:int;
            while (i < value.CitrusObject.length())
            {
                objectXML = value.CitrusObject[i];
                objectAsset = this.assetModel.getAssetByName(objectXML.@className.toString());
                params = new Vector.<ObjectInstanceParam>();
                if (!(objectAsset))
                {
                    trace((((("Object " + objectXML.@name.toString()) + ":") + objectXML.@className.toString()) + " not found in asset list.\nThis object will not be saved."));
                }
                else
                {
                    instance = this.createObject(objectAsset, 0, 0, 0, true, true, objectXML.@name);
                    propertyUpdates = new Array();
                    j = 0;
                    while (j < objectXML.Property.length())
                    {
                        paramXML = objectXML.Property[j];
                        param = instance.getParamByName(paramXML.@name);
                        if (!(param))
                        {
                            trace((((((("A property named " + paramXML.@name) + " was not found on the class of ") + instance.name) + ":") + instance.className) + " and will not be saved."));
                        }
                        else
                        {
                            param.value = paramXML.toString();
                            propertyUpdates.push(new PropertyUpdateVO(instance, param.name, param.value));
                        };
                        j++;
                    };
                    if (propertyUpdates.length > 0)
                    {
                        dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.OBJECT_PROPERTY_UPDATED, propertyUpdates));
                    };
                };
                i++;
            };
        }


    }
}//package model.vo
