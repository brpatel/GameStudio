package com.adobe.gamebuilder.editor
{
    import com.adobe.gamebuilder.editor.core.Bootstrap;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.IGameEditor;
    import com.adobe.gamebuilder.editor.core.MainContext;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.bars.ModeBar;
    import com.adobe.gamebuilder.editor.view.bars.PropertyTab;
    import com.adobe.gamebuilder.editor.view.bars.TopBar;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.overlays.SystemMessageOverlay;
    import com.adobe.gamebuilder.editor.view.states.ViewMode;
    import com.adobe.gamebuilder.starter.Main;
    
    import org.josht.starling.foxhole.controls.Screen;
    import org.josht.starling.foxhole.themes.GameEditorTheme;
    import org.josht.starling.foxhole.themes.IFoxholeTheme;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.robotlegs.mvcs.StarlingContext;
    
    import starling.events.Event;
    import starling.text.TextField;

    public class GameEditor extends Screen implements IGameEditor 
    {

        private var _theme:IFoxholeTheme;
        private var _mainContext:StarlingContext;
        private var _container:Container;
        public var _topBar:TopBar;
        private var _modeBar:ModeBar;
		private var _propertyBar:PropertyTab;
        public var _actionBar:ActionBarContainer;
        private var _leftPanel:LeftPanel;
        private var _systemMessage:SystemMessageOverlay;
		private var _onBack:Signal = new Signal(GameEditor);
		private var btnBack:ImageButton;
		private var _onImport:Signal = new Signal(String);
		public var mainScreen:Main;
		public static var levelName:String="Game1.lev";

        public function GameEditor()
        {
			
            this._mainContext = new MainContext(this);
            var _local1:Bootstrap = new Bootstrap();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            TextField.registerBitmapFont(GameEditorTheme.WHITE_SHADOW_FONT, Constants.WHITE_SHADOW_FONT);
            TextField.registerBitmapFont(GameEditorTheme.BITMAP_FONT, Constants.DEFAULT_FONT);
            TextField.registerBitmapFont(GameEditorTheme.BOLD_FONT, Constants.BOLD_FONT);
			
			// For external use
			GameBuilderApp.editor = this;
			
        }
		
		public function get leftPanel():LeftPanel
		{
			return _leftPanel;
		}

		public function set leftPanel(value:LeftPanel):void
		{
			_leftPanel = value;
		}

		private function addedToStageHandler(event:Event):void
		{
			initApp();
		}
		
		override protected function initialize():void
		{
			this.stage.color=0xFFFFFF;
			
			// handles the back hardware key on android
			this.backButtonHandler = this.onBackButton;
		
			
		}

		public function get onBack():ISignal
		{
			return this._onBack;
		}
		
		public function get onImport():ISignal
		{
			return this._onImport;
		}
		
        public function get systemMessage():SystemMessageOverlay
        {
            return (this._systemMessage);
        }

        public function get container():Container
        {
            return (this._container);
        }

        public function initApp():void
        {
    //        var _local1:Boolean = Mouse.supportsCursor;
    //        this._theme = new GameEditorTheme(this.stage, !(_local1));
			/*this.stage.color=0xFFFFFF;
			*/
            this._container = new Container();
            this._container.x = 0;
            this._container.y = 0;
            addChild(this._container);
            this._leftPanel = new LeftPanel();
            this._leftPanel.x = 0;
            this._leftPanel.y = Constants.TOPBAR_HEIGHT;
            addChild(this._leftPanel);
           this._actionBar = new ActionBarContainer();
            this._actionBar.x = 0;
            this._actionBar.y = Constants.TOPBAR_HEIGHT;
            addChild(this._actionBar);
            this._topBar = new TopBar();
            this._topBar.x = 0;
            this._topBar.y = 0;
            addChild(this._topBar);
            this._modeBar = new ModeBar();
			this._modeBar.x = int((stage.stageWidth >> 1));
			this._modeBar.y = int(((stage.stageHeight) - Constants.TOPBAR_HEIGHT));
           
            addChild(this._modeBar);
           
            this._systemMessage = new SystemMessageOverlay();
            this._systemMessage.x = stage.stageWidth;
            this._systemMessage.y = (Constants.TOPBAR_HEIGHT + 10);
            this._systemMessage.visible = false;
            addChild(this._systemMessage);
			
			// Added for level Editor
			this._propertyBar = new PropertyTab();
			this._propertyBar.x = (stage.stageWidth - PropertyTab.WIDTH);
			this._propertyBar.y = int((((stage.stageHeight - 160) - Constants.TOPBAR_HEIGHT) >> 2));
			addChild(this._propertyBar);
			
			// Back button
			this.btnBack = new ImageButton("list_back_btn_icon", 0, 0, false);
			this.btnBack.x = 5;
			this.btnBack.y = 5;
			this.btnBack.name = "topBarBtnBack";
			this.btnBack.onRelease.add(this.backButton_onRelease);
			addChild(this.btnBack);

			
			/*if(levelName!=null){
				onImport.dispatch(levelName);
			}*/
			if(mainScreen!=null){
				levelName= mainScreen.currentLevelName;
			}else{
				levelName=null;
			}
			onImport.dispatch(levelName);
        }

        public function barsToFront():void
        {
            this.setChildIndex(this._actionBar, (numChildren - 1));
            this.setChildIndex(this._topBar, (numChildren - 1));
        }

        public function switchViewMode(_arg1:String):void
        {
            this._topBar.visible = (_arg1 == ViewMode.NORMAL);
            this._actionBar.visible = (_arg1 == ViewMode.NORMAL);
            this._leftPanel.visible = (_arg1 == ViewMode.NORMAL);
		//	this._propertyBar.visible = (_arg1 == ViewMode.NORMAL);
			this.btnBack.visible = (_arg1 == ViewMode.NORMAL);
           this._modeBar.switchViewMode(_arg1);
            if (_arg1 == ViewMode.SCREENSHOT)
            {
                this._systemMessage.hideImmediate();
            };
        }
		
		private function onBackButton():void
		{
			this._onBack.dispatch(this);
		}
		
		private function backButton_onRelease(button:ImageButton):void
		{
			this.onBackButton();
		}


    }
}//package at.polypex.badplaner
