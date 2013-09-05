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

    public class HelpPage1_3 extends HelpPage 
    {

        public function HelpPage1_3()
        {
            mainStep = 1;
            nextMainStep = 1;
            nextSubStep = 4;
            previousMainStep = 1;
            previousSubStep = 2;
            totalPage = 4;
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
            _local6 = Common.labelField(WIDTH, 120, Common.getResourceString("help1_3_1_text"), 18, "left", "top", false, Constants.BOLD_FONT);
            _local6.x = 0;
            _local6.y = _local2;
            _local5.addChild(_local6);
            var _local7:uint = Math.ceil(((_local6.textBounds.width + 3) / 4));
            _local6 = Common.labelField(WIDTH, 120, (Common.nbsp(_local7) + Common.getResourceString("help1_3_2_text")));
            _local6.x = 0;
            _local6.y = (_local2 + 2);
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.textBounds.height) + 24);
            var _local8:Image = new Image(Assets.getTextureAtlas("Tutorial").getTexture("schritt1_3_1"));
            _local8.x = int(((WIDTH - _local8.width) >> 1));
            _local8.y = _local2;
            _local5.addChild(_local8);
            _local2 = ((_local8.y + _local8.height) + 24);
            _local6 = Common.labelField(WIDTH, 120, Common.getResourceString("help1_3_3_text"), 18, "left", "top", false, Constants.BOLD_FONT);
            _local6.x = 0;
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local7 = Math.ceil(((_local6.textBounds.width + 3) / 4));
            _local6 = Common.labelField(WIDTH, 120, (Common.nbsp(_local7) + Common.getResourceString("help1_3_4_text")));
            _local6.x = 0;
            _local6.y = (_local2 + 2);
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.textBounds.height) + 24);
            _local8 = new Image(Assets.getTextureAtlas("Tutorial").getTexture((((Locale.currentLang)=="en") ? "schritt1_3_2_en" : "schritt1_3_2")));
            _local8.x = int(((WIDTH - _local8.width) >> 1));
            _local8.y = _local2;
            _local5.addChild(_local8);
        }


    }
}//package at.polypex.badplaner.view.pages
