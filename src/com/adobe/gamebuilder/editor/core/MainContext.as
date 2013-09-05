package com.adobe.gamebuilder.editor.core
{
    import com.adobe.gamebuilder.editor.GameEditor;
    import com.adobe.gamebuilder.editor.commands.ClearCommandHistory;
    import com.adobe.gamebuilder.editor.commands.CopyObjectInstanceCommand;
    import com.adobe.gamebuilder.editor.commands.CreateNewLevelCommand;
    import com.adobe.gamebuilder.editor.commands.CreateObjectInstanceCommand;
    import com.adobe.gamebuilder.editor.commands.DeleteObjectInstanceCommand;
    import com.adobe.gamebuilder.editor.commands.GetQuote;
    import com.adobe.gamebuilder.editor.commands.OpenLevelCommand;
    import com.adobe.gamebuilder.editor.commands.ProductLoading;
    import com.adobe.gamebuilder.editor.commands.SavePlan;
    import com.adobe.gamebuilder.editor.commands.SendPlan;
    import com.adobe.gamebuilder.editor.commands.SetupApplication;
    import com.adobe.gamebuilder.editor.commands.UpdateLastOpenProjectPath;
    import com.adobe.gamebuilder.editor.commands.UpdateObjectPropertyCommand;
    import com.adobe.gamebuilder.editor.core.events.CommandEvent;
    import com.adobe.gamebuilder.editor.model.AppModel;
    import com.adobe.gamebuilder.editor.model.ApplicationModel;
    import com.adobe.gamebuilder.editor.model.AssetModel;
    import com.adobe.gamebuilder.editor.model.ProjectModel;
    import com.adobe.gamebuilder.editor.model.vo.GameState;
    import com.adobe.gamebuilder.editor.view.ActionBarContainer;
    import com.adobe.gamebuilder.editor.view.Container;
    import com.adobe.gamebuilder.editor.view.LeftPanel;
    import com.adobe.gamebuilder.editor.view.Room;
    import com.adobe.gamebuilder.editor.view.bars.ModeBar;
    import com.adobe.gamebuilder.editor.view.bars.PropertyBar;
    import com.adobe.gamebuilder.editor.view.bars.PropertyInspector;
    import com.adobe.gamebuilder.editor.view.bars.PropertyTab;
    import com.adobe.gamebuilder.editor.view.bars.SaveBar;
    import com.adobe.gamebuilder.editor.view.bars.TopBar;
    import com.adobe.gamebuilder.editor.view.events.CreateObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.GameStateEvent;
    import com.adobe.gamebuilder.editor.view.events.ObjectInstanceEvent;
    import com.adobe.gamebuilder.editor.view.events.ProjectEvent;
    import com.adobe.gamebuilder.editor.view.events.UpdateObjectPropertyEvent;
    import com.adobe.gamebuilder.editor.view.mediator.ActionBarContainerMediator;
    import com.adobe.gamebuilder.editor.view.mediator.ContainerMediator;
    import com.adobe.gamebuilder.editor.view.mediator.FinalizeScreenMediator;
    import com.adobe.gamebuilder.editor.view.mediator.GameEditorMediator;
    import com.adobe.gamebuilder.editor.view.mediator.GameSetupScreenMediator;
    import com.adobe.gamebuilder.editor.view.mediator.LeftPanelMediator;
    import com.adobe.gamebuilder.editor.view.mediator.ModeBarMediator;
    import com.adobe.gamebuilder.editor.view.mediator.ModelScreenMediator;
    import com.adobe.gamebuilder.editor.view.mediator.ProductMediator;
    import com.adobe.gamebuilder.editor.view.mediator.ProductScreenMediator;
    import com.adobe.gamebuilder.editor.view.mediator.PropertyBarMediator;
    import com.adobe.gamebuilder.editor.view.mediator.PropertyInspectorMediator;
    import com.adobe.gamebuilder.editor.view.mediator.PropertyTabMediator;
    import com.adobe.gamebuilder.editor.view.mediator.RoomMediator;
    import com.adobe.gamebuilder.editor.view.mediator.RoomScreenMediator;
    import com.adobe.gamebuilder.editor.view.mediator.RoomSideMediator;
    import com.adobe.gamebuilder.editor.view.mediator.SaveBarMediator;
    import com.adobe.gamebuilder.editor.view.mediator.TopBarMediator;
    import com.adobe.gamebuilder.editor.view.parts.Product;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    import com.adobe.gamebuilder.editor.view.screens.FinalizeScreen;
    import com.adobe.gamebuilder.editor.view.screens.GameSetupScreen;
    import com.adobe.gamebuilder.editor.view.screens.ModelScreen;
    import com.adobe.gamebuilder.editor.view.screens.ProductScreen;
    import com.adobe.gamebuilder.editor.view.screens.RoomScreen;
    
    import flash.events.Event;
    
    import org.robotlegs.mvcs.StarlingContext;
    
    import starling.display.DisplayObjectContainer;

    public class MainContext extends StarlingContext 
    {

        public function MainContext(_arg1:DisplayObjectContainer=null, _arg2:Boolean=true)
        {
            super(_arg1, _arg2);
        }

        override public function startup():void
        {
            commandMap.mapEvent(CommandEvent.LOAD_PRODUCTS, ProductLoading, CommandEvent, true);
            commandMap.mapEvent(CommandEvent.SAVE_PLAN, SavePlan, CommandEvent);
            commandMap.mapEvent(CommandEvent.SEND_PLAN, SendPlan, CommandEvent);
            commandMap.mapEvent(CommandEvent.GET_QUOTE, GetQuote, CommandEvent);
            injector.mapSingleton(AppModel);
			injector.mapSingleton(ProjectModel);
			injector.mapSingleton(AssetModel);
			injector.mapSingleton(GameState);
			injector.mapSingleton(ApplicationModel);
			
            mediatorMap.mapView(LeftPanel, LeftPanelMediator);
            mediatorMap.mapView(TopBar, TopBarMediator);
            mediatorMap.mapView(ModeBar, ModeBarMediator);
            mediatorMap.mapView(ActionBarContainer, ActionBarContainerMediator);
            mediatorMap.mapView(SaveBar, SaveBarMediator);
            mediatorMap.mapView(RoomScreen, RoomScreenMediator);
            mediatorMap.mapView(ProductScreen, ProductScreenMediator);
            mediatorMap.mapView(FinalizeScreen, FinalizeScreenMediator);
            mediatorMap.mapView(Container, ContainerMediator);
            mediatorMap.mapView(Room, RoomMediator);
            mediatorMap.mapView(RoomSide, RoomSideMediator);
            mediatorMap.mapView(GameEditor, GameEditorMediator);
			
			// Screen Mediators
			mediatorMap.mapView(GameSetupScreen, GameSetupScreenMediator);
			mediatorMap.mapView(ModelScreen, ModelScreenMediator);
			mediatorMap.mapView(PropertyTab, PropertyTabMediator);
			mediatorMap.mapView(PropertyBar, PropertyBarMediator);
			
			// Required for Level Editor
			commandMap.mapEvent("setup", SetupApplication);
			commandMap.mapEvent(ProjectEvent.PROJECT_OPENED, CreateNewLevelCommand);
			commandMap.mapEvent(CreateObjectInstanceEvent.CREATE_OBJECT_INSTANCE, CreateObjectInstanceCommand, CreateObjectInstanceEvent);
			commandMap.mapEvent(UpdateObjectPropertyEvent.UPDATE_OBJECT_PROPERTY, UpdateObjectPropertyCommand, UpdateObjectPropertyEvent);
			commandMap.mapEvent(ObjectInstanceEvent.DELETE_OBJECT, DeleteObjectInstanceCommand, ObjectInstanceEvent);
			commandMap.mapEvent(ObjectInstanceEvent.COPY_OBJECT, CopyObjectInstanceCommand, ObjectInstanceEvent);
			commandMap.mapEvent(ProjectEvent.PROJECT_ROOT_UPDATED, UpdateLastOpenProjectPath);
			commandMap.mapEvent(GameStateEvent.ALL_OBJECTS_CLEARED, ClearCommandHistory);
			commandMap.mapEvent(GameStateEvent.GAME_STATE_OPENED, ClearCommandHistory);
			commandMap.mapEvent(GameStateEvent.OPEN_GAME_STATE, OpenLevelCommand);
			
			
			mediatorMap.mapView(Product, ProductMediator);
			mediatorMap.mapView(PropertyInspector, PropertyInspectorMediator);
			/*mediatorMap.mapView(Propertybar, PropertybarMediator);
			mediatorMap.mapView(PropertyInspector, PropertyInspectorMediator);*/
		
	//		mediatorMap.mapView(LevelEditor, LAMediator);
			dispatchEvent(new Event("setup"));
            super.startup();
        }


    }
}
