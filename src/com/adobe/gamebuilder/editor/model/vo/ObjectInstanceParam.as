package com.adobe.gamebuilder.editor.model.vo
{
    public class ObjectInstanceParam 
    {

        public var name:String;
        public var type:String;
        public var inherited:Boolean;
        public var options:Object;

        public function ObjectInstanceParam(name:String, type:String, inherited:Boolean, options:Object)
        {
            var a:String;
            this.options = {};
            super();
            this.name = name;
            this.type = type;
            this.inherited = inherited;
            for (a in options)
            {
                this.options[a] = options[a];
            };
        }

        public function copy():ObjectInstanceParam
        {
            var instanceParamCopy:ObjectInstanceParam = new ObjectInstanceParam(this.name, this.type, this.inherited, this.options);
            return (instanceParamCopy);
        }

        public function getReadableName():String
        {
            var regex:RegExp = /(\w)/;
            var readableName:String = this.name.replace(regex, this.makeFirstLetterUppercase);
            regex = /([a-z])([A-Z0-9])/g;
            readableName = readableName.replace(regex, this.insertSpaceBetweenWords);
            return (readableName);
        }

        public function get value():Object
        {
            if (((!((this.options.value == null))) && (!((this.options.value == "")))))
            {
                return (this.options.value);
            };
            if (this.options.value == "")
            {
                return ("");
            };
            if (this.options.value == 0)
            {
                return (0);
            };
            return (undefined);
        }

        public function set value(v:Object):void
        {
            this.options.value = v;
        }

        public function toString():String
        {
            return (((this.name + ":") + this.type));
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
