package com.adobe.gamebuilder.starter
{
	import com.adobe.gamebuilder.editor.GameEditor;
	import com.adobe.gamebuilder.editor.core.Constants;
	import com.gskinner.motion.easing.Cubic;
	
	import flash.ui.Mouse;
	
	import org.josht.starling.foxhole.controls.ScreenNavigator;
	import org.josht.starling.foxhole.controls.ScreenNavigatorItem;
	import org.josht.starling.foxhole.themes.GameEditorTheme;
	import org.josht.starling.foxhole.themes.IFoxholeTheme;
	import org.josht.starling.foxhole.transitions.ScreenSlidingStackTransitionManager;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		
	//	public static var instance:Main;
		
		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private var _theme:IFoxholeTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		public var currentLevelName:String=null;
		
		private function addedToStageHandler(event:Event):void
		{
			//instance = this;
			var _local1:Boolean = Mouse.supportsCursor;
			this._theme = new GameEditorTheme(this.stage, !(_local1));			
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen(Constants.DASHBOARD, new ScreenNavigatorItem(Dashboard,
			{
				onEditor: Constants.GAMEEDITOR,
				onPlayGame: Constants.GAMEPLAY
				
			},{
				mainScreen:this
			}));
			

		//	const buttonSettings:ButtonSettings = new ButtonSettings();
			this._navigator.addScreen(Constants.GAMEEDITOR, new ScreenNavigatorItem(GameEditor,
			{
				onBack: Constants.DASHBOARD
				//onSettings: BUTTON_SETTINGS
			},
			{
				mainScreen:this
			}));

		/*	this._navigator.addScreen(BUTTON_SETTINGS, new ScreenNavigatorItem(ButtonSettingsScreen,
			{
				onBack: BUTTON
			},
			{
				settings: buttonSettings
			}));

			this._navigator.addScreen(CALLOUT, new ScreenNavigatorItem(CalloutScreen,
			{
				onBack: EDITOR
			}));
*/
			
			
			this._navigator.showScreen(Constants.DASHBOARD);
			
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
			this._transitionManager.ease = Cubic.easeOut;
		}
	}
}