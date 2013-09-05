package com.adobe.gamebuilder.editor.view.mediator
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.model.ProjectModel;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.model.vo.ObjectInstanceParam;
    import com.adobe.gamebuilder.editor.model.vo.PropertyUpdateVO;
    import com.adobe.gamebuilder.editor.view.bars.CreativeCloudPopUp;
    import com.adobe.gamebuilder.editor.view.bars.PropertyInspector;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    
    import flash.display.Loader;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MediaEvent;
    import flash.filesystem.File;
    import flash.media.CameraUI;
    import flash.media.MediaPromise;
    import flash.media.MediaType;
    import flash.net.FileFilter;
    
    import org.josht.starling.foxhole.controls.Slider;
    import org.josht.starling.foxhole.controls.TextInput;
    import org.josht.starling.foxhole.core.PopUpManager;
    import org.robotlegs.mvcs.StarlingMediator;
    
    import starling.text.TextField;
    

    public class PropertyInspectorMediator extends StarlingMediator  
    {

        [Inject]
        public var view:PropertyInspector;
        [Inject]
        public var gameState:GameState;
        [Inject]
        public var projectModel:ProjectModel;
        private var _itemToBrowseFor:Object;
		

		
        override public function onRegister():void
        {
            /*this.view.list.addEventListenerToButtons("changeProperty", this.changePropertyOnModel);
            this.view.list.addEventListenerToButtons("browse", this.handlePropertyBrowse);
			this.view.list.addEventListenerToButtons("camera", this.handleCamera);
            this.view.nameField.addEventListener(FocusEvent.FOCUS_OUT, this.handleNameFieldBlur);*/
			this.view.addEventListener("added", this.addedToStage);
            eventMap.mapListener(eventDispatcher, UpdateObjectPropertyEvent.OBJECT_PROPERTY_UPDATED, this.changePropertyOnView);
            eventMap.mapListener(eventDispatcher, ObjectInstanceEvent.OBJECT_SELECTED, this.handleObjectSelected, ObjectInstanceEvent);
		
        }
		
		private function addedToStage(event:*):void
		{
			
		}		
		
		
        private function changePropertyOnModel(e:Event):void
        {
            var selectedIndex:int = 0;//this.view.list.getIndexOfButton((e.target as LAListItem));
			/*if(this.view.list.items !=null && this.view.list.items.length > 0){
            	var newValue:String = (this.view.list.items[selectedIndex].value as String);
	            var updates:Array = new Array();
	            updates.push(new PropertyUpdateVO(this.gameState.selectedObject, this.gameState.selectedObject.params[selectedIndex].name, newValue));
	            dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			}*/
        }

        private function handlePropertyBrowse(e:Event):void
        {
            var file:File = new File(); //this.projectModel.getSWFFile();
            this._itemToBrowseFor =0;// this.view.list.getItemByButton((e.target as LAListItem));
            file.addEventListener(Event.SELECT, this.handlePropertyBrowseSelect);
            file.browseForOpen((((this._itemToBrowseFor.label + " for ") + this.gameState.selectedObject.name) + "..."), [new FileFilter("Compatible Graphics", "*.png;")]);
        }
		
		private function handleCamera(e:Event):void
		{
			var deviceCameraApp:CameraUI = new CameraUI();
			var imageLoader:Loader;
			
	//		this._itemToBrowseFor = this.view.list.getItemByButton((e.target as LAListItem));
			
			
			deviceCameraApp.addEventListener( MediaEvent.COMPLETE, imageCaptured );
			deviceCameraApp.addEventListener( Event.CANCEL, captureCanceled );
			deviceCameraApp.addEventListener( ErrorEvent.ERROR, cameraError );
			deviceCameraApp.launch( MediaType.IMAGE );
			
		}

        private function changePropertyOnView(e:UpdateObjectPropertyEvent):void
        {
            var update:PropertyUpdateVO;
            var param:ObjectInstanceParam;
            var index:int;
            if (((e.updates[0]) && (!((e.updates[0].objectInstance == this.gameState.selectedObject)))))
            {
                return;
            };
            var i:int;
            while (i < e.updates.length)
            {
                update = e.updates[i];
                param = update.objectInstance.getParamByName(update.property);
                index = update.objectInstance.params.indexOf(param);
             //   this.view.list.items[index].value = update.value.toString();
				
				Object(this.view.propertiesSprite.getChildAt(3*index + 1)).text = update.value.toString();
                i++;
            };
       //     this.view.list.update();
			
		/*	if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode && e.updates.length<=2)
				GameBuilderApp.frameReRun(e.updates);*/
        }

        private function handleNameFieldBlur(e:FocusEvent):void
        {
            var newName:String = this.view.nameField.text;
            if (this.gameState.selectedObject !=null && this.gameState.selectedObject.name != newName)
            {
                this.gameState.renameObject(this.gameState.selectedObject, newName);
            };
        }

        private function handlePropertyBrowseSelect(e:Event):void
        {
			var file:File = (e.target as File);
			var selectedIndex:int = 3;//this.view.list.items.indexOf(this._itemToBrowseFor);
            var newValue:String =  file.url; //file.nativePath; //this.projectModel.getSWFFile().parent.getRelativePath(file, true);
            var updates:Array = new Array();
            updates.push(new PropertyUpdateVO(this.gameState.selectedObject, this.gameState.selectedObject.params[selectedIndex].name, newValue));
            dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
            this._itemToBrowseFor = null;
        }
		
		

        private function handleObjectSelected(e:ObjectInstanceEvent):void
        {
            var items:Array;
            var param:ObjectInstanceParam;
            var item:Object;
            var i:int;
            if (this.gameState.selectedObject)
            {
                this.view.nameField.text = this.gameState.selectedObject.name;
                this.view.classField.text = this.gameState.selectedObject.className;
				
				
				
				
				this.view.propertiesSprite.removeChildren(0,this.view.propertiesSprite.numChildren-1);
				
				
                items = new Array();
                i = 0;
                while (i < this.gameState.selectedObject.params.length)
                {
					param = this.gameState.selectedObject.params[i];
					
					
					var textField:TextField  = Common.labelField(200, 30, param.name);
					textField.color=0xFFFFFF;
					textField.x = 10;
					textField.y = 5 + (50 *i);
					this.view.propertiesSprite.addChild(textField);
					
					if(param.name == "view"){
						var _local1:ImageButton = new ImageButton("icon_plus", 25, 25, true);
						_local1.x = 210;
						_local1.y = -10
						_local1.onRelease.add(this.iconBtBrowseReleaseHandler);
						textField.addChild(_local1);
						
						var _local2:ImageButton = new ImageButton("icon_resize", 25, 25, true);
						_local2.x = 170;
						_local2.y = -10
						_local2.onRelease.add(this.iconBtCreativeCloudReleaseHandler);
						textField.addChild(_local2);
						
						
					}
					
					var textD:TextInput = new TextInput();
					textD.text = String(param.value);
					textD.name = param.name;
					//textD.
					textD.width = 80;
					textD.x=180;
					textD.y = (50*i);
					textD.onChangeComplete.add(textInputChangeHandler);
					this.view.propertiesSprite.addChild(textD);
					
					
						var _slider:Slider = new Slider();
						_slider.x = 100;
						_slider.y = (50*i);
						_slider.width = 80;
						_slider.minimum = 0;
						if(param.name == "force"){
							_slider.maximum = 10;
						}else{
							_slider.maximum = param.value > 0 ?Number(param.value) + 200:200;
							}
						_slider.value = Number(param.value);
						_slider.step = 1;
						_slider.page = 10;
						_slider.direction = Slider.DIRECTION_HORIZONTAL;
						_slider.liveDragging = true;
						_slider.name = "slider_"+param.name;
						_slider.onChange.add(slider_onChange);
						this.view.propertiesSprite.addChild(_slider);
						
						if(param.name == "view"){
							_slider.visible = false;
							textD.x=100;
						}
					
					
					
					//	inputD
					//	inputD.addEventListener(Event.,onInputChange);
					//this.view.propertiesSprite.addChild(textD);
					
					/*var inputD:InputField = new InputField(80, "111", "", 4);
					inputD.text = String(param.value);
					inputD.name = param.name;
					inputD.x=100;
					inputD.y = (50*i);
					inputD.enabled = true;
				//	inputD
				//	inputD.addEventListener(Event.,onInputChange);
					this.view.propertiesSprite.addChild(inputD);*/
					
					
                    
                    item = {};
                    item.inherited = param.inherited;
                    item.label = param.getReadableName();
                    item.value = param.value;
                    item.evenIndex = ((i % 2) == 0);
                    item.state = "normal";
                    item.browse = (param.options.browse == "true") ; //(((((param.options.browse == "true")) && (this.projectModel.getSWFFile()))) && (this.projectModel.getSWFFile().exists));
                    items.push(item);
                    i++;
                };
        //        this.view.list.items = items;
         //       this.view.nameField.visible = true;
            }
            else
            {
				this.view.propertiesSprite.removeChildren(0,this.view.propertiesSprite.numChildren-1);
				
                this.view.nameField.text = "";
                this.view.classField.text = "";
              /*  this.view.list.items = [];
                this.view.nameField.visible = false;*/
            };
        }
		
		private function slider_onChange(slider:Slider):void
		{
			if(slider.name.slice(7) == "force"){
				slider.maximum = Number(slider.value) + 5;
			}else{
				slider.maximum = Number(slider.value) + 100;
			}
			Object(this.view.propertiesSprite.getChildByName(slider.name.slice(7))).text = slider.value;
			var newValue:String =  slider.value.toString();
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(this.gameState.selectedObject, slider.name.slice(7), newValue));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
			if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode)
				GameBuilderApp.frameReRun(updates);
		}
		
		private function textInputChangeHandler(textInput:TextInput):void
		{
			//var selectedIndex:int = 3;//this.view.list.items.indexOf(this._itemToBrowseFor);
			var newValue:String =  textInput.text;
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(this.gameState.selectedObject, textInput.name, newValue));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
			if(GameBuilderApp.game!=null && GameBuilderApp.game.state != null && GameBuilderApp.game.state.isReplayMode)
				GameBuilderApp.frameReRun(updates);
		}
		
		private function onInputChange(e:Event):void
		{
			
			
			var selectedIndex:int = 3;//this.view.list.items.indexOf(this._itemToBrowseFor);
			var newValue:String =  e.target.text;
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(this.gameState.selectedObject, this.gameState.selectedObject.params[selectedIndex].name, newValue));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			
		}
		
		private function iconBtCreativeCloudReleaseHandler(_arg1:ImageButton):void
		{
			var popUp:CreativeCloudPopUp = new CreativeCloudPopUp();
			PopUpManager.addPopUp(popUp);
			PopUpManager.centerPopUp(popUp);
		}
		
		private function iconBtBrowseReleaseHandler(_arg1:ImageButton):void
		{
			var file:File = new File(); //this.projectModel.getSWFFile();
			this._itemToBrowseFor =this.view.propertiesSprite.getChildAt(6);// this.view.list.getItemByButton((e.target as LAListItem));
			file.addEventListener(Event.SELECT, this.handlePropertyBrowseSelect);
			file.browseForOpen((((this._itemToBrowseFor.text + " for ") + this.gameState.selectedObject.name) + "..."), [new FileFilter("Compatible Graphics", "*.png")]);
			
		}
		
		private function imageCaptured( event:MediaEvent ):void
		{
			trace( "Media captured..." );
			
			var imagePromise:MediaPromise = event.data;
			
			var file:File = (imagePromise.file as File);
			var selectedIndex:int = 0;//this.view.indexOf(this._itemToBrowseFor);
			var newValue:String =  file.url; //file.nativePath; //this.projectModel.getSWFFile().parent.getRelativePath(file, true);
			var updates:Array = new Array();
			updates.push(new PropertyUpdateVO(this.gameState.selectedObject, this.gameState.selectedObject.params[selectedIndex].name, newValue));
			dispatch(new UpdateObjectPropertyEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, updates));
			this._itemToBrowseFor = null;
			
			/*if( imagePromise.isAsync )
			{
				trace( "Asynchronous media promise." );
			
			}
			else
			{
				trace( "Synchronous media promise." );
				
			}*/
		}
		
		private function captureCanceled( event:Event ):void
		{
			trace( "Media capture canceled." );
		
		}
		
		private function asyncImageLoaded( event:Event ):void
		{
			trace( "Media loaded in memory." );
			//showMedia( imageLoader );    
			
		}
		
		private function showMedia( loader:Loader ):void
		{
			//this.addChild( loader );
		}
		
		private function cameraError( error:ErrorEvent ):void
		{
			trace( "Error:" + error.text );
			
		}


    }
}//package mediators
