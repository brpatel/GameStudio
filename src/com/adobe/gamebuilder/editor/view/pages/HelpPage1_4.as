package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.view.overlays.HelpOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.Overlay;
    
    import org.josht.starling.foxhole.controls.ScrollContainer;
    
    import starling.display.Image;
    import starling.text.TextField;

    public class HelpPage1_4 extends HelpPage 
    {

        public function HelpPage1_4()
        {
            mainStep = 1;
            nextMainStep = 2;
            nextSubStep = 1;
            previousMainStep = 1;
            previousSubStep = 3;
            totalPage = 5;
        }

        override protected function init():void
        {
            var _local5:ScrollContainer;
            var _local1:int = int(((stage.stageWidth - WIDTH) >> 1));
            var _local2:int = 30;
            var _local3:TextField = Common.labelField(WIDTH, 30, Common.getResourceString("help1_header"), 18, "center", "top", false, Constants.BOLD_FONT);
            _local3.x = _local1;
            _local3.y = _local2;
            addChild(_local3);
            _local2 = 75;
            var _local4:Image = Common.separator(_local1, _local2, WIDTH);
            addChild(_local4);
            _local5 = Overlay.scrollContainer(_local1, (_local4.y + 22), (WIDTH + 20), (((parent as HelpOverlay).config.height - 85) - (_local4.y + 22)));
            addChild(_local5);
            _local2 = 8;
            var _local6:TextField = Common.labelField(WIDTH, 30, Common.getResourceString("help1_1_1_text"), 18, "left", "top", false, Constants.BOLD_FONT);
            _local6.x = 0;
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.textBounds.height) + 24);
            var _local7:Image = new Image(Assets.getTextureAtlas("Tutorial").getTexture("schritt1_4_1"));
            _local7.x = 3;
            _local7.y = _local2;
            _local5.addChild(_local7);
            _local2 = _local7.y;
            _local6 = Common.labelField(375, 90, Common.getResourceString("help1_4_1_text"), 18, "left", "top", false, Constants.BOLD_FONT);
            _local6.x = ((_local7.x + _local7.width) + 25);
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local2 = _local7.y;
            var _local8:uint = Math.ceil(((_local6.textBounds.width + 3) / 4));
            _local6 = Common.labelField(375, 60, (Common.nbsp(_local8) + Common.getResourceString("help1_4_2_text")));
            _local6.x = ((_local7.x + _local7.width) + 25);
            _local6.y = (_local2 + 2);
            _local5.addChild(_local6);
            _local2 = (_local7.y + 310);
            _local6 = Common.labelField(375, 120, Common.getResourceString("help1_4_3_text"));
            _local6.x = ((_local7.x + _local7.width) + 25);
            _local6.y = _local2;
            _local5.addChild(_local6);
        }


    }
}//package at.polypex.badplaner.view.pages
