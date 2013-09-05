//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.themes
{
    import com.adobe.gamebuilder.editor.assets.Assets;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.lists.CategoryListRenderer;
    import com.adobe.gamebuilder.editor.view.comps.lists.DefaultPickerListRenderer;
    import com.adobe.gamebuilder.editor.view.comps.lists.ProductListRenderer;
    import com.adobe.gamebuilder.editor.view.overlays.InputOverlay;
    
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    
    import org.josht.starling.display.Image;
    import org.josht.starling.display.Scale3Image;
    import org.josht.starling.display.Scale9Image;
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.Callout;
    import org.josht.starling.foxhole.controls.Check;
    import org.josht.starling.foxhole.controls.PickerList;
    import org.josht.starling.foxhole.controls.SimpleScrollBar;
    import org.josht.starling.foxhole.controls.TextInput;
    import org.josht.starling.foxhole.controls.popups.CalloutPopUpContentManager;
    import org.josht.starling.foxhole.controls.popups.VerticalCenteredPopUpContentManager;
    import org.josht.starling.foxhole.controls.renderers.BaseDefaultItemRenderer;
    import org.josht.starling.foxhole.controls.renderers.DefaultGroupedListItemRenderer;
    import org.josht.starling.foxhole.controls.renderers.DefaultListItemRenderer;
    import org.josht.starling.foxhole.controls.text.BitmapFontTextRenderer;
    import org.josht.starling.foxhole.core.AddedWatcher;
    import org.josht.starling.foxhole.layout.VerticalLayout;
    import org.josht.starling.foxhole.text.BitmapFontTextFormat;
    import org.josht.starling.textures.Scale3Textures;
    import org.josht.starling.textures.Scale9Textures;
    import org.josht.system.PhysicalCapabilities;
    
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;
    import starling.utils.VAlign;

    public class GameEditorTheme extends AddedWatcher implements IFoxholeTheme 
    {

        protected static var INTERFACE:TextureAtlas ;
        protected static const PROGRESS_BAR_SCALE_3_FIRST_REGION:Number = 12;
        protected static const PROGRESS_BAR_SCALE_3_SECOND_REGION:Number = 12;
        protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(4, 4, 32, 32);
        protected static const SLIDER_FIRST:Number = 16;
        protected static const SLIDER_SECOND:Number = 8;
        protected static const CALLOUT_SCALE_9_GRID:Rectangle = new Rectangle(8, 24, 15, 33);
        protected static const SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(1, 2, 2, 3);
        protected static const TEXTINPUT_SCALE_9_GRID:Rectangle = new Rectangle(4, 5, 27, 27);
        protected static const PICKER_BG_SCALE_9_GRID:Rectangle = new Rectangle(20, 16, 12, 12);
        protected static const BACKGROUND_COLOR:uint = 0xF6F6F6;
        protected static const PRIMARY_TEXT_COLOR:uint = 0xE5E5E5;
        protected static const SELECTED_TEXT_COLOR:uint = 0xFFFFFF;
        protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
        protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
        protected static var BUTTON_UP_SKIN_TEXTURES:Scale9Textures ;
        protected static var BUTTON_DOWN_SKIN_TEXTURES:Scale9Textures;
        protected static var BUTTON_DISABLED_SKIN_TEXTURES:Scale9Textures;
        protected static var BLACK_BUTTON_UP_SKIN_TEXTURES:Scale9Textures ;
        protected static var BLACK_BUTTON_DOWN_SKIN_TEXTURES:Scale9Textures;
        protected static var BLACK_BUTTON_DISABLED_SKIN_TEXTURES:Scale9Textures;
        protected static var SCROLL_BAR_THUMB_SKIN_TEXTURES:Scale9Textures;
        protected static var INSET_BACKGROUND_SKIN_TEXTURES:Scale9Textures ; 
        protected static var INSET_BACKGROUND_DISABLED_SKIN_TEXTURES:Scale9Textures;
        protected static var PICKER_ICON_TEXTURE:Texture ;
        protected static var LIST_ITEM_UP_TEXTURE:Texture;
        protected static var LIST_ITEM_DOWN_TEXTURE:Texture ;
        protected static var LIST_CATEGORY_UP_TEXTURE:Texture;
        protected static var LIST_CATEGORY_DOWN_TEXTURE:Texture ;
        protected static var LIST_PICKER_UP_TEXTURE:Texture;
        protected static var LIST_PICKER_DOWN_TEXTURE:Texture ;
        protected static var LIST_PRODUCT_UP_TEXTURE:Texture ;
        protected static var LIST_PRODUCT_DOWN_TEXTURE:Texture ;
        protected static var CALLOUT_BACKGROUND_SKIN_TEXTURES:Scale9Textures ;
        protected static var CALLOUT_TOP_ARROW_SKIN_TEXTURE:Texture ;
        protected static var CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE:Texture;
        protected static var CALLOUT_LEFT_ARROW_SKIN_TEXTURE:Texture;
        protected static var CALLOUT_RIGHT_ARROW_SKIN_TEXTURE:Texture ;
        protected static var CHECK_UP_ICON_TEXTURE:Texture ;
        protected static var CHECK_DOWN_ICON_TEXTURE:Texture ;
        protected static var CHECK_DISABLED_ICON_TEXTURE:Texture ;
        protected static var CHECK_SELECTED_UP_ICON_TEXTURE:Texture ;
        protected static var CHECK_SELECTED_DOWN_ICON_TEXTURE:Texture ;
        protected static var CHECK_SELECTED_DISABLED_ICON_TEXTURE:Texture ;
        protected static var TEXTINPUT_SELECTED_TEXTURES:Scale9Textures;
        protected static var TEXTINPUT_TEXTURES:Scale9Textures;
		
		[Embed(source="/../../../../../textures/DEFAULT_FONT_ATLAS_XML.xml",mimeType="application/octet-stream")]
		protected static const DEFAULT_FONT_ATLAS_XML:Class;
		
		[Embed(source="/../../../../../textures/BOLD_FONT_ATLAS_XML.xml",mimeType="application/octet-stream")]
        protected static const BOLD_FONT_ATLAS_XML:Class;
		
		[Embed(source="/../../../../../textures/WHITE_SHADOW_FONT_ATLAS_XML.xml",mimeType="application/octet-stream")]
        protected static const WHITE_SHADOW_FONT_ATLAS_XML:Class;
		
        public static var BITMAP_FONT:BitmapFont;
        public static var BOLD_FONT:BitmapFont;
        public static var WHITE_SHADOW_FONT:BitmapFont;

        protected var _originalDPI:int;
        protected var _scaleToDPI:Boolean;
        protected var _scale:Number;
        protected var _fontSize:int;

        public function GameEditorTheme(_arg1:DisplayObject, _arg2:Boolean=true)
        {
            super(_arg1);
            Starling.current.nativeStage.color = BACKGROUND_COLOR;
            if (_arg1.stage)
            {
                _arg1.stage.color = BACKGROUND_COLOR;
            }
            else
            {
                _arg1.addEventListener(Event.ADDED_TO_STAGE, this.root_addedToStageHandler);
            };
            this._scaleToDPI = _arg2;
            this.initialize();
        }

        public function get originalDPI():int
        {
            return (this._originalDPI);
        }

        public function get scaleToDPI():Boolean
        {
            return (this._scaleToDPI);
        }

        protected function initialize():void
        {
            if (this._scaleToDPI)
            {
                if ((Capabilities.screenDPI % (ORIGINAL_DPI_IPAD_RETINA / 2)) == 0)
                {
                    this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
                }
                else
                {
                    this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
                };
            }
            else
            {
                this._originalDPI = Capabilities.screenDPI;
            };
			//initialize all static vars
			INTERFACE = Assets.getTextureAtlas("Interface");
			BUTTON_UP_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_blue_up"), BUTTON_SCALE_9_GRID);
			BUTTON_DOWN_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_blue_down"), BUTTON_SCALE_9_GRID);
			BUTTON_DISABLED_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_blue_up"), BUTTON_SCALE_9_GRID);
			BLACK_BUTTON_UP_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_black_up"), BUTTON_SCALE_9_GRID);
			BLACK_BUTTON_DOWN_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_black_down"), BUTTON_SCALE_9_GRID);
			 BLACK_BUTTON_DISABLED_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("default_btn_bg_black_up"), BUTTON_SCALE_9_GRID);
			 SCROLL_BAR_THUMB_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("scroll-bar-thumb"), SCROLL_BAR_THUMB_SCALE_9_GRID);
			 INSET_BACKGROUND_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("picker_bg"), PICKER_BG_SCALE_9_GRID);
			 INSET_BACKGROUND_DISABLED_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("picker_bg"), PICKER_BG_SCALE_9_GRID);
			 PICKER_ICON_TEXTURE = INTERFACE.getTexture("picker_arrow_down");
			 LIST_ITEM_UP_TEXTURE = INTERFACE.getTexture("list_cell_up");
			 LIST_ITEM_DOWN_TEXTURE = INTERFACE.getTexture("list_cell_down");
			 LIST_CATEGORY_UP_TEXTURE = INTERFACE.getTexture("list_cell_up");
			 LIST_CATEGORY_DOWN_TEXTURE = INTERFACE.getTexture("list_cell_down");
			 LIST_PICKER_UP_TEXTURE = INTERFACE.getTexture("picker_list_item_bg_up");
			 LIST_PICKER_DOWN_TEXTURE = INTERFACE.getTexture("picker_list_item_bg_down");
			 LIST_PRODUCT_UP_TEXTURE = INTERFACE.getTexture("product_list_cell_up");
			 LIST_PRODUCT_DOWN_TEXTURE = INTERFACE.getTexture("product_list_cell_down");
			 CALLOUT_BACKGROUND_SKIN_TEXTURES = new Scale9Textures(INTERFACE.getTexture("picker_bg"), PICKER_BG_SCALE_9_GRID);
			 CALLOUT_TOP_ARROW_SKIN_TEXTURE = INTERFACE.getTexture("picker_arrow");
			 CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE = INTERFACE.getTexture("picker_arrow");
			 CALLOUT_LEFT_ARROW_SKIN_TEXTURE = INTERFACE.getTexture("picker_arrow");
			 CALLOUT_RIGHT_ARROW_SKIN_TEXTURE = INTERFACE.getTexture("picker_arrow");
			 CHECK_UP_ICON_TEXTURE = INTERFACE.getTexture("checkbox_up_deselected");
			 CHECK_DOWN_ICON_TEXTURE = INTERFACE.getTexture("checkbox_down_deselected");
			 CHECK_DISABLED_ICON_TEXTURE = INTERFACE.getTexture("checkbox_up_deselected");
			 CHECK_SELECTED_UP_ICON_TEXTURE = INTERFACE.getTexture("checkbox_up_selected");
			 CHECK_SELECTED_DOWN_ICON_TEXTURE = INTERFACE.getTexture("checkbox_down_selected");
			 CHECK_SELECTED_DISABLED_ICON_TEXTURE = INTERFACE.getTexture("checkbox_up_selected");
			 TEXTINPUT_SELECTED_TEXTURES = new Scale9Textures(INTERFACE.getTexture("textinput_skin_selected"), new Rectangle(4, 5, 27, 27));
			 TEXTINPUT_TEXTURES = new Scale9Textures(INTERFACE.getTexture("textinput_skin_up"), new Rectangle(4, 5, 27, 27));
			
			  BITMAP_FONT = new BitmapFont(INTERFACE.getTexture("helvetica_medium"), XML(new DEFAULT_FONT_ATLAS_XML()));
			 BOLD_FONT = new BitmapFont(INTERFACE.getTexture("helvetica_bold"), XML(new BOLD_FONT_ATLAS_XML()));
			 WHITE_SHADOW_FONT = new BitmapFont(INTERFACE.getTexture("helvetica_medium_white_shadow"), XML(new WHITE_SHADOW_FONT_ATLAS_XML()));
			
            this._scale = 1;
            this._fontSize = (14 * this._scale);
            this.setInitializerForClass(BitmapFontTextRenderer, this.labelInitializer);
            this.setInitializerForClass(Button, this.buttonInitializer);
            this.setInitializerForClass(BlackButton, this.buttonInitializer);
            this.setInitializerForClass(BlueButton, this.buttonInitializer);
            this.setInitializerForClass(SimpleScrollBar, this.scrollBarInitializer);
            this.setInitializerForClass(Check, this.checkInitializer);
            this.setInitializerForClass(DefaultListItemRenderer, this.itemRendererInitializer);
            this.setInitializerForClass(DefaultPickerListRenderer, this.defaultPickerListRendererInitializer);
            this.setInitializerForClass(ProductListRenderer, this.productRendererInitializer);
            this.setInitializerForClass(CategoryListRenderer, this.categoryRendererInitializer);
            this.setInitializerForClass(DefaultGroupedListItemRenderer, this.itemRendererInitializer);
            this.setInitializerForClass(PickerList, this.pickerListInitializer);
            this.setInitializerForClass(TextInput, this.textInputInitializer);
            this.setInitializerForClass(InputOverlay, this.textInputInitializer);
            this.setInitializerForClass(Callout, this.calloutInitializer);
        }

        protected function labelInitializer(_arg1:BitmapFontTextRenderer):void
        {
            if (_arg1.name)
            {
                return;
            };
            _arg1.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
        }

        protected function buttonInitializer(_arg1:Button):void
        {
            var _local2:Scale9Image;
            var _local3:Scale9Image;
            var _local4:Scale9Image;
            var _local5:Scale9Image;
            var _local6:Scale9Image;
            var _local7:Scale9Image;
            var _local8:Scale9Image;
            var _local9:Scale9Image;
            var _local10:Scale9Image;
            var _local11:Scale9Image;
            var _local12:Scale9Image;
            var _local13:Scale9Image;
            var _local14:Image;
            _arg1.minTouchWidth = (_arg1.minTouchHeight = (88 * this._scale));
            if (_arg1.nameList.contains("foxhole-header-item"))
            {
                _local2 = new Scale9Image(BUTTON_UP_SKIN_TEXTURES, this._scale);
                _local2.width = (60 * this._scale);
                _local2.height = (60 * this._scale);
                _arg1.defaultSkin = _local2;
                _local3 = new Scale9Image(BUTTON_DOWN_SKIN_TEXTURES, this._scale);
                _local3.width = (60 * this._scale);
                _local3.height = (60 * this._scale);
                _arg1.downSkin = _local3;
                _local4 = new Scale9Image(BUTTON_DISABLED_SKIN_TEXTURES, this._scale);
                _local4.width = (60 * this._scale);
                _local4.height = (60 * this._scale);
                _arg1.disabledSkin = _local4;
                _arg1.defaultSelectedSkin = _local3;
                _arg1.selectedDownSkin = _local3;
                _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(WHITE_SHADOW_FONT, this._fontSize, 0xFFFFFF);
                _arg1.paddingTop = (_arg1.paddingBottom = (8 * this._scale));
                _arg1.paddingLeft = (_arg1.paddingRight = (16 * this._scale));
                _arg1.gap = (12 * this._scale);
                _arg1.minWidth = (66 * this._scale);
                _arg1.minHeight = (66 * this._scale);
            }
            else
            {
                if (_arg1.nameList.contains("foxhole-simple-scroll-bar-thumb"))
                {
                    _local5 = new Scale9Image(SCROLL_BAR_THUMB_SKIN_TEXTURES, this._scale);
                    _local5.width = (4 * this._scale);
                    _local5.height = (7 * this._scale);
                    _arg1.defaultSkin = _local5;
                    _arg1.minTouchWidth = (4 * this._scale);
                    _arg1.minTouchHeight = (12 * this._scale);
                }
                else
                {
                    if (!((_arg1.nameList.contains("foxhole-slider-minimum-track")) || (_arg1.nameList.contains("foxhole-slider-maximum-track"))))
                    {
                        if (_arg1.nameList.contains("badplanerBlackButton"))
                        {
                            _local6 = new Scale9Image(BLACK_BUTTON_UP_SKIN_TEXTURES, this._scale);
                            _local6.width = (34 * this._scale);
                            _local6.height = (34 * this._scale);
                            _arg1.defaultSkin = _local6;
                            _local7 = new Scale9Image(BLACK_BUTTON_DOWN_SKIN_TEXTURES, this._scale);
                            _local7.width = (34 * this._scale);
                            _local7.height = (34 * this._scale);
                            _arg1.downSkin = _local7;
                            _local8 = new Scale9Image(BLACK_BUTTON_DISABLED_SKIN_TEXTURES, this._scale);
                            _local8.width = (34 * this._scale);
                            _local8.height = (34 * this._scale);
                            _arg1.disabledSkin = _local8;
                            _arg1.defaultSelectedSkin = _local7;
                            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(WHITE_SHADOW_FONT, this._fontSize, 0xFFFFFF);
                            _arg1.verticalAlign = VAlign.TOP;
                            _arg1.paddingTop = (10 * this._scale);
                            _arg1.paddingLeft = (_arg1.paddingRight = (8 * this._scale));
                            _arg1.minWidth = (34 * this._scale);
                            _arg1.minHeight = (34 * this._scale);
                        }
                        else
                        {
                            if (_arg1.nameList.contains("foxhole-picker-list-button"))
                            {
                                _local9 = new Scale9Image(TEXTINPUT_TEXTURES, this._scale);
                                _local9.width = (35 * this._scale);
                                _local9.height = (35 * this._scale);
                                _arg1.defaultSkin = _local9;
                                _local10 = new Scale9Image(TEXTINPUT_SELECTED_TEXTURES, this._scale);
                                _local10.width = (35 * this._scale);
                                _local10.height = (35 * this._scale);
                                _arg1.downSkin = _local10;
                                _arg1.disabledSkin = _local9;
                                _arg1.defaultSelectedSkin = _local10;
                                _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, 16, Constants.DEFAULT_FONT_COLOR);
                                _arg1.verticalAlign = VAlign.TOP;
                                _arg1.paddingTop = (7 * this._scale);
                                _arg1.paddingLeft = (_arg1.paddingRight = (8 * this._scale));
                                _arg1.minWidth = (34 * this._scale);
                                _arg1.minHeight = (34 * this._scale);
                            }
                            else
                            {
                                _local11 = new Scale9Image(BUTTON_UP_SKIN_TEXTURES, this._scale);
                                _local11.width = (34 * this._scale);
                                _local11.height = (34 * this._scale);
                                _arg1.defaultSkin = _local11;
                                _local12 = new Scale9Image(BUTTON_DOWN_SKIN_TEXTURES, this._scale);
                                _local12.width = (34 * this._scale);
                                _local12.height = (34 * this._scale);
                                _arg1.downSkin = _local12;
                                _local13 = new Scale9Image(BUTTON_DISABLED_SKIN_TEXTURES, this._scale);
                                _local13.width = (34 * this._scale);
                                _local13.height = (34 * this._scale);
                                _arg1.disabledSkin = _local13;
                                _arg1.defaultSelectedSkin = _local12;
                                _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(WHITE_SHADOW_FONT, this._fontSize, 0xFFFFFF);
                                _arg1.verticalAlign = VAlign.TOP;
                                _arg1.paddingTop = (10 * this._scale);
                                _arg1.paddingLeft = (_arg1.paddingRight = (8 * this._scale));
                                _arg1.minWidth = (34 * this._scale);
                                _arg1.minHeight = (34 * this._scale);
                            };
                        };
                    };
                };
            };
            if (_arg1.nameList.contains("foxhole-picker-list-button"))
            {
                _local14 = new Image(PICKER_ICON_TEXTURE);
                _local14.scaleX = (_local14.scaleY = this._scale);
                _arg1.defaultIcon = _local14;
                _arg1.gap = Number.POSITIVE_INFINITY;
                _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
                _arg1.iconPosition = Button.ICON_POSITION_RIGHT;
            };
        }

        protected function scrollBarInitializer(_arg1:SimpleScrollBar):void
        {
            _arg1.paddingTop = (_arg1.paddingRight = (_arg1.paddingBottom = (_arg1.paddingLeft = (2 * this._scale))));
        }

        protected function checkInitializer(_arg1:Check):void
        {
            var _local2:Image = new Image(CHECK_UP_ICON_TEXTURE);
            _local2.scaleX = (_local2.scaleY = this._scale);
            _arg1.defaultIcon = _local2;
            var _local3:Image = new Image(CHECK_DOWN_ICON_TEXTURE);
            _local3.scaleX = (_local3.scaleY = this._scale);
            _arg1.downIcon = _local3;
            var _local4:Image = new Image(CHECK_SELECTED_DOWN_ICON_TEXTURE);
            _local4.scaleX = (_local4.scaleY = this._scale);
            _arg1.selectedDownIcon = _local4;
            var _local5:Image = new Image(CHECK_DISABLED_ICON_TEXTURE);
            _local5.scaleX = (_local5.scaleY = this._scale);
            _arg1.disabledIcon = _local5;
            var _local6:Image = new Image(CHECK_SELECTED_UP_ICON_TEXTURE);
            _local6.scaleX = (_local6.scaleY = this._scale);
            _arg1.defaultSelectedIcon = _local6;
            var _local7:Image = new Image(CHECK_SELECTED_DISABLED_ICON_TEXTURE);
            _local7.scaleX = (_local7.scaleY = this._scale);
            _arg1.selectedDisabledIcon = _local7;
            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
            _arg1.minTouchWidth = (_arg1.minTouchHeight = (34 * this._scale));
            _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            _arg1.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
        }

        protected function productRendererInitializer(_arg1:ProductListRenderer):void
        {
            var _local2:Scale3Image = new Scale3Image(new Scale3Textures(LIST_PRODUCT_UP_TEXTURE, 1, 2));
            _local2.smoothing = TextureSmoothing.NONE;
            _local2.width = (50 * this._scale);
            _local2.height = (50 * this._scale);
            _local2.blendMode = BlendMode.NONE;
            _arg1.defaultSkin = _local2;
            var _local3:Scale3Image = new Scale3Image(new Scale3Textures(LIST_PRODUCT_DOWN_TEXTURE, 1, 2));
            _local3.smoothing = TextureSmoothing.NONE;
            _local3.width = (50 * this._scale);
            _local3.height = (50 * this._scale);
            _local3.blendMode = BlendMode.NONE;
            _arg1.downSkin = _local3;
            _arg1.defaultSelectedSkin = _local3;
            _arg1.paddingTop = (_arg1.paddingBottom = (11 * this._scale));
            _arg1.paddingLeft = (_arg1.paddingRight = (20 * this._scale));
            _arg1.minWidth = (50 * this._scale);
            _arg1.minHeight = (50 * this._scale);
            _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, 14, Constants.DEFAULT_FONT_COLOR);
        }

        protected function categoryRendererInitializer(_arg1:CategoryListRenderer):void
        {
            var _local2:Scale3Image = new Scale3Image(new Scale3Textures(LIST_CATEGORY_UP_TEXTURE, 1, 2));
            _local2.smoothing = TextureSmoothing.NONE;
            _local2.width = (50 * this._scale);
            _local2.height = (50 * this._scale);
            _local2.blendMode = BlendMode.NONE;
            _arg1.defaultSkin = _local2;
            var _local3:Scale3Image = new Scale3Image(new Scale3Textures(LIST_CATEGORY_DOWN_TEXTURE, 1, 2));
            _local3.smoothing = TextureSmoothing.NONE;
            _local3.width = (50 * this._scale);
            _local3.height = (50 * this._scale);
            _local3.blendMode = BlendMode.NONE;
            _arg1.downSkin = _local3;
            _arg1.defaultSelectedSkin = _local3;
            _arg1.paddingTop = (_arg1.paddingBottom = (11 * this._scale));
            _arg1.paddingLeft = (_arg1.paddingRight = (20 * this._scale));
            _arg1.minWidth = (50 * this._scale);
            _arg1.minHeight = (50 * this._scale);
            _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, 16, Constants.DEFAULT_FONT_COLOR);
        }

        protected function itemRendererInitializer(_arg1:BaseDefaultItemRenderer):void
        {
            var _local2:Image = new Image(LIST_ITEM_UP_TEXTURE);
            _local2.width = (88 * this._scale);
            _local2.height = (35 * this._scale);
            _local2.blendMode = BlendMode.NONE;
            _arg1.defaultSkin = _local2;
            var _local3:Image = new Image(LIST_ITEM_DOWN_TEXTURE);
            _local3.width = (88 * this._scale);
            _local3.height = (35 * this._scale);
            _local3.blendMode = BlendMode.NONE;
            _arg1.downSkin = _local3;
            _arg1.defaultSelectedSkin = _local3;
            _arg1.paddingTop = (_arg1.paddingBottom = (11 * this._scale));
            _arg1.paddingLeft = (_arg1.paddingRight = (20 * this._scale));
            _arg1.minWidth = (88 * this._scale);
            _arg1.minHeight = (35 * this._scale);
            _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
        }

        protected function defaultPickerListRendererInitializer(_arg1:DefaultPickerListRenderer):void
        {
            var _local2:Image = new Image(LIST_PICKER_UP_TEXTURE);
            _local2.smoothing = TextureSmoothing.NONE;
            _local2.width = (36 * this._scale);
            _local2.height = (36 * this._scale);
            _local2.blendMode = BlendMode.NONE;
            _arg1.defaultSkin = _local2;
            var _local3:Image = new Image(LIST_PICKER_DOWN_TEXTURE);
            _local3.smoothing = TextureSmoothing.NONE;
            _local3.width = (36 * this._scale);
            _local3.height = (36 * this._scale);
            _local3.blendMode = BlendMode.NONE;
            _arg1.downSkin = _local3;
            _arg1.defaultSelectedSkin = _local3;
            _arg1.paddingTop = (_arg1.paddingBottom = (6 * this._scale));
            _arg1.paddingLeft = (_arg1.paddingRight = (10 * this._scale));
            _arg1.minWidth = (36 * this._scale);
            _arg1.minHeight = (36 * this._scale);
            _arg1.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
            _arg1.defaultLabelProperties.textFormat = new BitmapFontTextFormat(BITMAP_FONT, Constants.DEFAULT_FONT_SIZE, Constants.DEFAULT_FONT_COLOR);
        }

        protected function pickerListInitializer(_arg1:PickerList):void
        {
            var _local3:VerticalCenteredPopUpContentManager;
            if (PhysicalCapabilities.isTablet(Starling.current.nativeStage))
            {
                _arg1.popUpContentManager = new CalloutPopUpContentManager();
            }
            else
            {
                _local3 = new VerticalCenteredPopUpContentManager();
                _local3.marginRight = (_local3.marginLeft = (_local3.marginTop = (_local3.marginBottom = (16 * this._scale))));
                _arg1.popUpContentManager = _local3;
            };
            var _local2:VerticalLayout = new VerticalLayout();
            _local2.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
            _local2.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
            _local2.useVirtualLayout = true;
            _local2.gap = -2;
            _local2.paddingTop = (_local2.paddingBottom = (_local2.paddingRight = (_local2.paddingLeft = 0)));
            _arg1.listProperties.layout = _local2;
            _arg1.listProperties.itemRendererType = DefaultPickerListRenderer;
            _arg1.listProperties.@itemRendererProperties.height = DefaultPickerListRenderer.RENDERER_HEIGHT;
            if (PhysicalCapabilities.isTablet(Starling.current.nativeStage))
            {
                _arg1.listProperties.minWidth = (264 * this._scale);
                _arg1.listProperties.maxHeight = (352 * this._scale);
            };
            _arg1.listProperties.paddingTop = -2;
            _arg1.listProperties.paddingBottom = 6;
            _arg1.listProperties.paddingRight = (_arg1.listProperties.paddingLeft = 2);
        }

        protected function textInputInitializer(_arg1:TextInput):void
        {
            _arg1.minWidth = (35 * this._scale);
            _arg1.minHeight = (35 * this._scale);
            _arg1.paddingTop = (6 * this._scale);
            _arg1.paddingBottom = (8 * this._scale);
            _arg1.paddingRight = (_arg1.paddingLeft = (6 * this._scale));
            _arg1.stageTextProperties.fontFamily = "Helvetica Neue Medium, Helvetica Neue, Helvetica, Arial, sans-serif";
            _arg1.stageTextProperties.fontSize = (14 * this._scale);
            _arg1.stageTextProperties.color = Constants.DEFAULT_FONT_COLOR;
            var _local2:Scale9Image = new Scale9Image(TEXTINPUT_SELECTED_TEXTURES, this._scale);
            _local2.width = (35 * this._scale);
            _local2.height = (35 * this._scale);
            _arg1.backgroundSkin = _local2;
            var _local3:Scale9Image = new Scale9Image(TEXTINPUT_SELECTED_TEXTURES, this._scale);
            _local3.width = (35 * this._scale);
            _local3.height = (35 * this._scale);
            _arg1.backgroundDisabledSkin = _local3;
        }

        protected function calloutInitializer(_arg1:Callout):void
        {
            _arg1.paddingTop = (9 * this._scale);
            _arg1.paddingBottom = (23 * this._scale);
            _arg1.paddingRight = (_arg1.paddingLeft = (16 * this._scale));
            var _local2:Scale9Image = new Scale9Image(CALLOUT_BACKGROUND_SKIN_TEXTURES, this._scale);
            _local2.width = (48 * this._scale);
            _local2.height = (48 * this._scale);
            _local2.pivotY = 7;
            _arg1.backgroundSkin = _local2;
            var _local3:Image = new Image(CALLOUT_TOP_ARROW_SKIN_TEXTURE);
            _local3.scaleX = (_local3.scaleY = this._scale);
            _arg1.topArrowSkin = _local3;
            _arg1.topArrowGap = (0 * this._scale);
            var _local4:Image = new Image(CALLOUT_BOTTOM_ARROW_SKIN_TEXTURE);
            _local4.scaleX = (_local4.scaleY = this._scale);
            _arg1.bottomArrowSkin = _local4;
            _arg1.bottomArrowGap = (-1 * this._scale);
            var _local5:Image = new Image(CALLOUT_LEFT_ARROW_SKIN_TEXTURE);
            _local5.scaleX = (_local5.scaleY = this._scale);
            _arg1.leftArrowSkin = _local5;
            _arg1.leftArrowGap = (0 * this._scale);
            var _local6:Image = new Image(CALLOUT_RIGHT_ARROW_SKIN_TEXTURE);
            _local6.scaleX = (_local6.scaleY = this._scale);
            _arg1.rightArrowSkin = _local6;
            _arg1.rightArrowGap = (-1 * this._scale);
        }

        protected function root_addedToStageHandler(_arg1:Event):void
        {
            DisplayObject(_arg1.currentTarget).stage.color = BACKGROUND_COLOR;
        }


    }
}//package org.josht.starling.foxhole.themes
