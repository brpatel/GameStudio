package com.adobe.gamebuilder.editor.commands
{
    import org.robotlegs.mvcs.StarlingCommand;
    import com.adobe.gamebuilder.editor.model.vo.GameState;

    public class OpenLevelCommand extends StarlingCommand 
    {

  //      [Inject]
  //      public var history:CommandHistory;
        [Inject]
        public var gameState:GameState;


        override public function execute():void
        {
            this.gameState.openGameState();
        }


    }
}//package commands
