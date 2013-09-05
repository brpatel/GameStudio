package com.adobe.gamebuilder.editor.view.screens
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.IGameEditor;
    import com.adobe.gamebuilder.editor.core.manager.AlertManager;
    import com.adobe.gamebuilder.editor.view.comps.InputField;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.ImageToggle;
    import com.adobe.gamebuilder.editor.view.layout.ReflectionAxis;
    import com.adobe.gamebuilder.editor.view.overlays.InputOverlay;
    import com.adobe.gamebuilder.editor.view.parts.RoomSide;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.josht.starling.foxhole.controls.Screen;
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.text.TextField;

    public class RoomScreen extends Screen 
    {

        public static const FIELD_WIDTH:int = 142;

        private var _btnBaseRoom1:ImageToggle;
        private var _btnBaseRoom2:ImageToggle;
        private var _btnBaseRoom3:ImageToggle;
        private var _inputA:InputField;
        private var _inputB:InputField;
        private var _inputC:InputField;
        private var _inputD:InputField;
        private var _btnAssume:Button;
        private var _btnReset:Button;
        private var _valueA:int;
        private var _valueB:int;
        private var _valueC:int;
        private var _valueD:int;
        private var _initialComplete:Signal;
        private var _measureRequest:Signal;
        private var _sideMeasureInputChange:Signal;
        private var _sidesUpdate:Signal;
        private var _roomChange:Signal;
        private var _roomReflection:Signal;
        private var _selectedRoom:int = 1;
        private var _btnReflectHor:ImageButton;
        private var _btnReflectVer:ImageButton;
        private var _textInput:InputOverlay;

        public function RoomScreen()
        {
            this._sidesUpdate = new Signal();
            this._initialComplete = new Signal();
            this._measureRequest = new Signal();
            this._sideMeasureInputChange = new Signal(String, uint);
            this._roomChange = new Signal(uint);
            this._roomReflection = new Signal(String);
        }

        public function get selectedRoom():int
        {
            return (this._selectedRoom);
        }

        public function set selectedRoom(_arg1:int):void
        {
            this._selectedRoom = _arg1;
            this.updateButtonStates();
        }

        public function get initialComplete():Signal
        {
            return (this._initialComplete);
        }

        public function get measureRequest():Signal
        {
            return (this._measureRequest);
        }

        public function get sidesUpdate():Signal
        {
            return (this._sidesUpdate);
        }

        public function get roomReflection():Signal
        {
            return (this._roomReflection);
        }

        public function get roomChange():Signal
        {
            return (this._roomChange);
        }

        public function get sideMeasureInputChange():Signal
        {
            return (this._sideMeasureInputChange);
        }

        public function updateButtonStates():void
        {
            if (this._inputD)
            {
                this._btnBaseRoom1.isSelected = (this.selectedRoom == 1);
                this._btnBaseRoom2.isSelected = (this.selectedRoom == 2);
                this._btnBaseRoom3.isSelected = (this.selectedRoom == 3);
                this.enableFields();
            };
        }

        private function roomButton(_arg1:uint):ImageToggle
        {
            var btn:ImageToggle;
            var nr:uint = _arg1;
            btn = new ImageToggle(("basic_room_icon" + nr), true);
            btn.isSelected = (this.selectedRoom == nr);
            btn.y = 67;
            btn.onRelease.add(function (_arg1:ImageToggle):void
            {
                roomButton_onRelease(_arg1, nr);
            });
            addChild(btn);
            return (btn);
        }

        override protected function initialize():void
        {
            var textField:TextField = Common.labelField(120, 30, Common.getResourceString("label_base_form"));
            textField.x = 22;
            textField.y = 30;
            addChild(textField);
            var roomBtnWidth:uint = 64;
            var roomBtnGap:uint = 11;
            var roomBtnMargin:uint = 24;
            this._btnBaseRoom1 = this.roomButton(1);
            this._btnBaseRoom1.x = roomBtnMargin;
            this._btnBaseRoom2 = this.roomButton(2);
            this._btnBaseRoom2.x = ((roomBtnMargin + roomBtnWidth) + roomBtnGap);
            this._btnBaseRoom3 = this.roomButton(3);
            this._btnBaseRoom3.x = ((roomBtnMargin + (2 * roomBtnWidth)) + (2 * roomBtnGap));
            var separator:Image = Common.separator(14, 151, 232, "sidebar");
            addChild(separator);
            textField = Common.labelField(150, 30, Common.getResourceString("label_room_reflection"));
            textField.x = 22;
            textField.y = 170;
            addChild(textField);
            this._btnReflectHor = new ImageButton("reflection_icon_hor", 0, 0, false);
            this._btnReflectHor.x = 50;
            this._btnReflectHor.y = 208;
            this._btnReflectHor.onRelease.add(function (_arg1:ImageButton):void
            {
                reflectButton_onRelease(ReflectionAxis.HORIZONTAL);
            });
            this.addChild(this._btnReflectHor);
            this._btnReflectVer = new ImageButton("reflection_icon_ver", 0, 0, false);
            this._btnReflectVer.x = 146;
            this._btnReflectVer.y = 208;
            this._btnReflectVer.onRelease.add(function (_arg1:ImageButton):void
            {
                reflectButton_onRelease(ReflectionAxis.VERTICAL);
            });
            this.addChild(this._btnReflectVer);
            separator = Common.separator(14, 291, 232, "sidebar");
            addChild(separator);
            textField = Common.labelField(200, 30, Common.getResourceString("label_base_measure"));
            textField.x = 22;
            textField.y = 310;
            addChild(textField);
            textField = Common.labelField(30, 30, (RoomSide.SIDE_A + ":"));
            textField.x = 25;
            textField.y = 352;
            addChild(textField);
            textField = Common.labelField(30, 30, "cm");
            textField.x = 200;
            textField.y = 352;
            addChild(textField);
            this._inputA = new InputField(FIELD_WIDTH, "", "0-9", 4);
            this._inputA.text = this._valueA.toString();
            this._inputA.name = RoomSide.SIDE_A;
            this._inputA.x = 48;
            this._inputA.y = 344;
            this._inputA.enabled = true;
            addChild(this._inputA);
            textField = Common.labelField(30, 30, (RoomSide.SIDE_B + ":"));
            textField.x = 25;
            textField.y = 393;
            addChild(textField);
            textField = Common.labelField(30, 30, "cm");
            textField.x = 200;
            textField.y = 393;
            addChild(textField);
            this._inputB = new InputField(FIELD_WIDTH, "", "0-9", 4);
            this._inputB.text = this._valueB.toString();
            this._inputB.name = RoomSide.SIDE_B;
            this._inputB.x = 48;
            this._inputB.y = 385;
            this._inputB.enabled = true;
            addChild(this._inputB);
            textField = Common.labelField(30, 30, (RoomSide.SIDE_C + ":"));
            textField.x = 25;
            textField.y = 434;
            addChild(textField);
            textField = Common.labelField(30, 30, "cm");
            textField.x = 200;
            textField.y = 434;
            addChild(textField);
            this._inputC = new InputField(FIELD_WIDTH, "", "0-9", 4);
            this._inputC.text = this._valueC.toString();
            this._inputC.name = RoomSide.SIDE_C;
            this._inputC.x = 48;
            this._inputC.y = 426;
            this._inputC.enabled = !((this.selectedRoom == 1));
            addChild(this._inputC);
            textField = Common.labelField(30, 30, (RoomSide.SIDE_D + ":"));
            textField.x = 25;
            textField.y = 475;
            addChild(textField);
            textField = Common.labelField(30, 30, "cm");
            textField.x = 200;
            textField.y = 475;
            addChild(textField);
            this._inputD = new InputField(FIELD_WIDTH, "", "0-9", 4);
            this._inputD.text = this._valueD.toString();
            this._inputD.name = RoomSide.SIDE_D;
            this._inputD.x = 48;
            this._inputD.y = 467;
            this._inputD.enabled = !((this.selectedRoom == 1));
            addChild(this._inputD);
            this._btnAssume = new BlueButton();
            this._btnAssume.label = Common.getResourceString("btnAssumeLabel");
            this._btnAssume.width = 187;
            this._btnAssume.x = 23;
            this._btnAssume.y = 538;
            this._btnAssume.onRelease.add(this.btnAssume_onRelease);
            this.addChild(this._btnAssume);
            this._btnReset = new BlackButton();
            this._btnReset.label = Common.getResourceString("btnResetToBaseRoomLabel");
            this._btnReset.width = 187;
            this._btnReset.x = 23;
            this._btnReset.y = 584;
            this._btnReset.onRelease.add(this.btnReset_onRelease);
            this.addChild(this._btnReset);
            this._initialComplete.dispatch();
        }

        private function reflectButton_onRelease(_arg1:String):void
        {
            this._roomReflection.dispatch(_arg1);
        }

        private function btnAssume_onRelease(_arg1:Button):void
        {
            if (this._valueA != parseInt(this._inputA.text))
            {
                this._valueA = parseInt(this._inputA.text);
                this._sideMeasureInputChange.dispatch(this._inputA.name, parseInt(this._inputA.text));
            };
            if (this._valueB != parseInt(this._inputB.text))
            {
                this._valueB = parseInt(this._inputB.text);
                this._sideMeasureInputChange.dispatch(this._inputB.name, parseInt(this._inputB.text));
            };
            if (this.selectedRoom != 1)
            {
                if (this._valueC != parseInt(this._inputC.text))
                {
                    this._valueC = parseInt(this._inputC.text);
                    this._sideMeasureInputChange.dispatch(this._inputC.name, parseInt(this._inputC.text));
                };
                if (this._valueD != parseInt(this._inputD.text))
                {
                    this._valueD = parseInt(this._inputD.text);
                    this._sideMeasureInputChange.dispatch(this._inputD.name, parseInt(this._inputD.text));
                };
            };
            this._sidesUpdate.dispatch();
            this._measureRequest.dispatch();
        }

        private function btnReset_onRelease(_arg1:Button):void
        {
            this._roomChange.dispatch(this.selectedRoom);
            this.enableFields();
        }

        public function sideMeasureInitHandler(_arg1:Object):void
        {
            this._valueA = int((_arg1[RoomSide.SIDE_A] as RoomSide).measure);
            this._valueB = int((_arg1[RoomSide.SIDE_B] as RoomSide).measure);
            this._valueC = int((_arg1[RoomSide.SIDE_C] as RoomSide).measure);
            this._valueD = int((_arg1[RoomSide.SIDE_D] as RoomSide).measure);
            if (this._inputA)
            {
                this._inputA.text = this._valueA.toString();
                this._inputB.text = this._valueB.toString();
                this._inputC.text = this._valueC.toString();
                this._inputD.text = this._valueD.toString();
            };
        }

        public function sideEnableChangeHandler(_arg1:RoomSide):void
        {
            if ((((_arg1.id == RoomSide.SIDE_A)) || ((_arg1.id == RoomSide.SIDE_B))))
            {
                this[("_input" + _arg1.id)].enabled = _arg1.enabled;
            }
            else
            {
                if ((((_arg1.id == RoomSide.SIDE_C)) || ((_arg1.id == RoomSide.SIDE_D))))
                {
                    this[("_input" + _arg1.id)].enabled = ((_arg1.enabled) && (!((this.selectedRoom == 1))));
                };
            };
        }

        public function sideMeasureChangeHandler(_arg1:RoomSide):void
        {
            if (_arg1.id == RoomSide.SIDE_A)
            {
                this._valueA = int(_arg1.measure);
                this._inputA.text = this._valueA.toString();
            }
            else
            {
                if (_arg1.id == RoomSide.SIDE_B)
                {
                    this._valueB = int(_arg1.measure);
                    this._inputB.text = this._valueB.toString();
                }
                else
                {
                    if (_arg1.id == RoomSide.SIDE_C)
                    {
                        this._valueC = int(_arg1.measure);
                        this._inputC.text = this._valueC.toString();
                    }
                    else
                    {
                        if (_arg1.id == RoomSide.SIDE_D)
                        {
                            this._valueD = int(_arg1.measure);
                            this._inputD.text = this._valueD.toString();
                        };
                    };
                };
            };
        }

        private function roomButton_onRelease(_arg1:ImageToggle, _arg2:int):void
        {
            if (((((this.root as IGameEditor).container.room.openingManager.length > 0)) || (((this.root as IGameEditor).container.room.productManager.length > 0))))
            {
                AlertManager.instance.show(Common.getResourceString("alert_base_form_text"), Common.getResourceString("alert_base_form_header"), (AlertManager.YES | AlertManager.CANCEL), this.baseFormAlertHandler, {
                    roomNr:_arg2,
                    button:_arg1
                });
            }
            else
            {
                this.changeBaseRoom(_arg2);
            };
        }

        private function changeBaseRoom(_arg1:int):void
        {
            this.selectedRoom = _arg1;
            if (this.selectedRoom != 1)
            {
                this._btnBaseRoom1.isSelected = false;
            };
            if (this.selectedRoom != 2)
            {
                this._btnBaseRoom2.isSelected = false;
            };
            if (this.selectedRoom != 3)
            {
                this._btnBaseRoom3.isSelected = false;
            };
            this.enableFields();
            this._roomChange.dispatch(this.selectedRoom);
        }

        private function baseFormAlertHandler(_arg1:Object, _arg2:Object):void
        {
            if (_arg1 == AlertManager.YES)
            {
                this.changeBaseRoom(_arg2.roomNr);
            }
            else
            {
                (_arg2.button as ImageToggle).isSelected = false;
            };
        }

        private function enableFields():void
        {
            this._inputA.enabled = true;
            this._inputB.enabled = true;
            this._inputC.enabled = !((this.selectedRoom == 1));
            this._inputD.enabled = !((this.selectedRoom == 1));
        }

        override public function dispose():void
        {
            super.dispose();
            this._sideMeasureInputChange.removeAll();
            this._roomChange.removeAll();
        }


    }
}//package at.polypex.badplaner.view.screens
