package com.adobe.gamebuilder.editor.view.comps.buttons
{
    import com.adobe.gamebuilder.editor.core.Constants;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.osflash.signals.Signal;

    public class BlueButton extends Button 
    {

        private var _onLayoutComplete:Signal;

        public function BlueButton()
        {
            this._onLayoutComplete = new Signal(Button);
            this.name = "badplanerBlueButton";
            this.height = Constants.DEFAULT_BUTTON_HEIGHT;
        }

        public function get onLayoutComplete():Signal
        {
            return (this._onLayoutComplete);
        }

        override protected function draw():void
        {
            super.draw();
            if (width > 0)
            {
                this._onLayoutComplete.dispatch(this);
            };
        }


    }
}//package at.polypex.badplaner.view.comps.buttons
