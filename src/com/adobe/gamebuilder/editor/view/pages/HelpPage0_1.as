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

    public class HelpPage0_1 extends HelpPage 
    {

        public function HelpPage0_1()
        {
            mainStep = 0;
            nextMainStep = 1;
            nextSubStep = 1;
            previousMainStep = -1;
            previousSubStep = -1;
            totalPage = 1;
        }

        override protected function init():void
        {
            var _local5:ScrollContainer;
            var _local1:uint = int(((stage.stageWidth - WIDTH) >> 1));
            var _local2:uint = 30;
            var _local3:TextField = Common.labelField(WIDTH, 30, Common.getResourceString("help0_header"), 18, "center", "top", false, Constants.BOLD_FONT);
            _local3.x = _local1;
            _local3.y = _local2;
            addChild(_local3);
            _local2 = 75;
            var _local4:Image = Common.separator(_local1, _local2, WIDTH);
            addChild(_local4);
            _local5 = Overlay.scrollContainer(_local1, (_local4.y + 22), (WIDTH + 20), (((parent as HelpOverlay).config.height - 85) - (_local4.y + 22)));
            addChild(_local5);
            _local2 = 8;
            var _local6:Image = new Image(Assets.getTextureAtlas("Tutorial").getTexture((((Locale.currentLang)=="en") ? "logo_en" : "logo")));
            _local6.x = 3;
            _local6.y = _local2;
            _local5.addChild(_local6);
            _local2 = ((_local6.y + _local6.height) + 3);
            _local4 = Common.separator(0, _local2, WIDTH);
            _local5.addChild(_local4);
            _local2 = (_local4.y + 25);
            var _local7:TextField = Common.labelField(WIDTH, 90, Common.getResourceString("help0_1_text"), 18, "left", "top", false, Constants.BOLD_FONT);
            _local7.x = 0;
            _local7.y = _local2;
            _local5.addChild(_local7);
            _local2 = ((_local7.y + _local7.textBounds.height) + 24);
            _local7 = Common.labelField(WIDTH, 295, Common.getResourceString("help0_2_text"), 16);
            _local7.x = 0;
            _local7.y = _local2;
            _local7.autoScale = true;
            _local5.addChild(_local7);
        }


    }
}//package at.polypex.badplaner.view.pages
