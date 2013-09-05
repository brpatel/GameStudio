package com.adobe.gamebuilder.editor.commands
{
	import com.adobe.gamebuilder.editor.model.vo.GameState;
	
	import org.robotlegs.mvcs.StarlingCommand;
    

    public class CreateNewLevelCommand extends StarlingCommand 
    {

        [Inject]
        public var gameState:GameState;
  //      [Inject]
  //      public var history:CommandHistory;


        override public function execute():void
        {
            this.gameState.createGameState("Untitled Level");
        }


    }
}//package commands
