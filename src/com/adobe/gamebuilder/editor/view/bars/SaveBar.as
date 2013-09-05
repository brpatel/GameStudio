package com.adobe.gamebuilder.editor.view.bars
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlackButton;
    import com.adobe.gamebuilder.editor.view.comps.buttons.BlueButton;
    
    import org.josht.starling.foxhole.controls.Button;
    import org.osflash.signals.Signal;

    public class SaveBar extends ActionBar 
    {

        private var _btnRelease:Signal;
        private var btnSave:BlueButton;
        private var btnSaveAs:BlueButton;
        private var btnLoad:BlackButton;
        private var btnNew:BlueButton;

        public function SaveBar()
        {
            this._btnRelease = new Signal(String);
            super();
        }

        public function get btnRelease():Signal
        {
            return (this._btnRelease);
        }

        override protected function init():void
        {
            super.init();
            this.btnNew = new BlueButton();
            this.btnNew.width = 145;
            this.btnNew.label = Common.getResourceString("btnNewPlanLabel");
            this.btnNew.onRelease.add(this.btnNewOnRelease);
            this.btnNew.onLayoutComplete.add(this.layoutContent);
            addChild(this.btnNew);
            this.btnSave = new BlueButton();
            this.btnSave.width = 145;
            this.btnSave.label = Common.getResourceString("btnSaveLabel");
            this.btnSave.onRelease.add(this.btnSaveOnRelease);
            this.btnSave.onLayoutComplete.add(this.layoutContent);
            addChild(this.btnSave);
            this.btnSaveAs = new BlueButton();
            this.btnSaveAs.width = 145;
            this.btnSaveAs.label = Common.getResourceString("btnSaveAsLabel");
            this.btnSaveAs.onLayoutComplete.add(this.layoutContent);
            this.btnSaveAs.onRelease.add(this.btnSaveAsOnRelease);
            addChild(this.btnSaveAs);
            this.btnLoad = new BlackButton();
            this.btnLoad.width = 145;
            this.btnLoad.label = Common.getResourceString("btnLoadLabel");
            this.btnLoad.onLayoutComplete.add(this.layoutContent);
            this.btnLoad.onRelease.add(this.btnLoadOnRelease);
            addChild(this.btnLoad);
        }

        private function layoutContent(_arg1:Button):void
        {
            if (((((((((((this.btnSave) && ((this.btnSave.width > 0)))) && (this.btnLoad))) && ((this.btnLoad.width > 0)))) && (this.btnSaveAs))) && ((this.btnSaveAs.width > 0))))
            {
                this.btnSave.x = ((stage.stageWidth - 15) - this.btnSave.width);
                this.btnSave.y = int(((ActionBar.HEIGHT - this.btnSave.height) >> 1));
                this.btnSaveAs.x = ((this.btnSave.x - 15) - this.btnSaveAs.width);
                this.btnSaveAs.y = int(((ActionBar.HEIGHT - this.btnSaveAs.height) >> 1));
                this.btnLoad.x = ((this.btnSaveAs.x - 15) - this.btnLoad.width);
                this.btnLoad.y = int(((ActionBar.HEIGHT - this.btnLoad.height) >> 1));
                this.btnNew.x = 93;
                this.btnNew.y = int(((ActionBar.HEIGHT - this.btnNew.height) >> 1));
            };
        }

        private function btnLoadOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("load");
        }

        private function btnSaveAsOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("saveAs");
        }

        private function btnSaveOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("save");
        }

        private function btnNewOnRelease(_arg1:Button):void
        {
            this._btnRelease.dispatch("new");
        }


    }
}//package at.polypex.badplaner.view.bars
