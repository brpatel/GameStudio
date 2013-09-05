package com.adobe.gamebuilder.editor.model.vo
{
    public class ObjectAssetParam 
    {

        public var name:String;
        public var type:String;
        public var inherited:Boolean = false;
        public var options:Object;

        public function ObjectAssetParam(name:String, type:String, inherited:Boolean, options:Object)
        {
            this.name = name;
            this.type = type;
            this.inherited = inherited;
            this.options = options;
        }

        public function getReadableName():String
        {
            var regex:RegExp = /(\w)/;
            var readableName:String = this.name.replace(regex, this.makeFirstLetterUppercase);
            regex = /([a-z])([A-Z0-9])/g;
            readableName = readableName.replace(regex, this.insertSpaceBetweenWords);
            return (readableName);
        }

        public function toString():String
        {
            return (((this.name + ":") + this.type));
        }

        public function get value():Object
        {
            if (((!((this.options.value == undefined))) && (!((this.options.value == "")))))
            {
                return (this.options.value);
            };
            return (undefined);
        }

        public function set value(v:Object):void
        {
            this.options.value = v;
        }

        private function makeFirstLetterUppercase():String
        {
            return (arguments[1].toUpperCase());
        }

        private function insertSpaceBetweenWords():String
        {
            return (((arguments[1] + " ") + arguments[2]));
        }


    }
}//package model.vo
