package com.adobe.gamebuilder.editor.view.pages
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.Locale;
    import com.adobe.gamebuilder.editor.view.overlays.HelpOverlay;
    import com.adobe.gamebuilder.editor.view.overlays.Overlay;
    
    import org.josht.starling.foxhole.controls.ScrollContainer;
    
    import starling.display.Image;
    import starling.text.TextField;

    public class HelpPage1_1 extends HelpPage 
    {

        public function HelpPage1_1()
        {
            mainStep = 1;
            nextMainStep = 1;
            nextSubStep = 2;
            previousMainStep = 0;
            previousSubStep = 1;
            totalPage = 2;
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
            _local2 = ((_local6.y + _local6.textBounds.height) + 22);
            _local6 = Common.labelField(WIDTH, 300, Common.getResourceString("help1_1_2_text"));
            _local6.x = 0;
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.textBounds.height) + 9);
            var _local7:Image = new Image(Assets.getTextureAtlas("Tutorial").getTexture("schritt1_1_1"));
            _local7.x = ((WIDTH - _local7.width) >> 1);
            _local7.y = _local2;
            _local5.addChild(_local7);
            _local2 = ((_local7.y + _local7.height) + 24);
            _local6 = Common.labelField(WIDTH, 40, Common.getResourceString("help1_1_3_text"));
            _local6.x = 0;
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.textBounds.height) + 24);
            _local7 = new Image(Assets.getTextureAtlas("Tutorial").getTexture((((Locale.currentLang)=="en") ? "schritt1_1_2_en" : "schritt1_1_2")));
            _local7.x = 3;
            _local7.y = _local2;
            _local5.addChild(_local7);
            _local2 = _local7.y;
            _local6 = Common.labelField(300, 140, Common.getResourceString("help1_1_4_text"));
            _local6.x = ((_local7.x + _local7.width) + 25);
            _local6.y = _local2;
            _local5.addChild(_local6);
        }


    }
}//package at.polypex.badplaner.view.pages
