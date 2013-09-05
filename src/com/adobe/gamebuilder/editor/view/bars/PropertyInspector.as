package com.adobe.gamebuilder.editor.view.bars
{
    
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.Screen;
    
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;
    
  
    public class PropertyInspector extends Screen
    {

         public var nameField:TextField;
        public var classField:TextField;
		public var  propertiesSprite:Sprite;
		
		
		private var _bg1:Scale9Image;
		private var _bg2:Scale9Image;
		private var _bg3:Scale9Image;
		private var btnProperties:ImageButton;

        public function PropertyInspector()
        {
			
           dispatchEvent(new Event("added"));
           
        }
		
		override protected function initialize():void
		{
			
			nameField  = Common.labelField(200, 30, "");
			nameField.color=0xFFFFFF;
			nameField.x = 10;
			nameField.y = 50;
			addChild(nameField);
			
			classField  = Common.labelField(200, 30, "");
			classField.color=0xFFFFFF;
			classField.x = 10;
			classField.y = 100;
			addChild(classField);
			
			propertiesSprite = new Sprite();
			
			propertiesSprite.x = 10;
			propertiesSprite.y = 150;
			addChild(propertiesSprite);
			
			
			
		}
		

      

       

     
      


    }
}//package components
