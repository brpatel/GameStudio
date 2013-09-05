package com.adobe.gamebuilder.editor.model.vo
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ObjectInstance 
    {

        public var name:String;
        public var id:int;
        public var className:String;
        public var superClassName:String;
        public var params:Vector.<ObjectInstanceParam>;
        public var customSize:Boolean = false;

        public function ObjectInstance(newID:int, className:String, superClassName:String, params:Vector.<ObjectInstanceParam>, customSize:Boolean, name:String=null)
        {
            this.id = newID;
            this.className = className;
            this.superClassName = superClassName;
            this.params = params;
            this.customSize = customSize;
            if (name)
            {
                this.name = name;
            }
            else
            {
                this.name = (this.getUnqualifiedClassName() + newID.toString());
            };
        }

        public function copy(newID:int):ObjectInstance
        {
            var instanceParam:ObjectInstanceParam;
            var newParams:Vector.<ObjectInstanceParam> = new Vector.<ObjectInstanceParam>();
            for each (instanceParam in this.params)
            {
                newParams.push(instanceParam.copy());
            };
            return (new ObjectInstance(newID, this.className, this.superClassName, newParams, this.customSize));
        }

        public function getParamByName(name:String):ObjectInstanceParam
        {
            var param:ObjectInstanceParam;
            for each (param in this.params)
            {
                if (param.name == name)
                {
                    return (param);
                };
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


    }
}//package model.vo
