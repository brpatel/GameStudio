package com.adobe.gamebuilder.editor.model.vo
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ObjectAsset 
    {

        public var className:String;
        public var superClassName:String;
        public var params:Vector.<ObjectAssetParam>;

        public function ObjectAsset(className:String, superClassName:String, params:Vector.<ObjectAssetParam>)
        {
            this.params = new Vector.<ObjectAssetParam>();
            super();
            this.className = className;
            this.superClassName = superClassName;
            this.params = params;
        }

        public function toString():String
        {
            var item:ObjectAssetParam;
            var str:String = ((this.className + " : ") + this.superClassName);
            var i:int;
            while (i < this.params.length)
            {
                item = this.params[i];
                str = (str + ((("\n\t" + item.name) + ":") + item.type));
                i++;
            };
            return (str);
        }

        public function getParamByName(name:String):ObjectAssetParam
        {
            var i:int;
            while (i < this.params.length)
            {
                if (this.params[i].name == name)
                {
                    return (this.params[i]);
                };
                i++;
            };
            return (null);
        }

        public function getUnqualifiedClassName():String
        {
            var lastPeriodIndex:int = this.className.lastIndexOf(".");
            if (lastPeriodIndex == -1)
            {
                return (this.className);
            };
            return (this.className.substring((lastPeriodIndex + 1)));
        }

        public function getPackageName():String
        {
            var lastPeriodIndex:int = this.className.lastIndexOf(".");
            if (lastPeriodIndex == -1)
            {
                return ("");
            };
            return (this.className.substring(0, lastPeriodIndex));
        }

        public function getSuperClassPackageName():String
        {
            var lastPeriodIndex:int = this.superClassName.lastIndexOf(".");
            if (lastPeriodIndex == -1)
            {
                return ("");
            };
            return (this.superClassName.substring(0, lastPeriodIndex));
        }


    }
}//package model.vo
