//Created by Action Script Viewer - http://www.buraks.com/asv
package org.robotlegs.base
{
    import flash.utils.getDefinitionByName;
    import flash.events.IEventDispatcher;
    import flash.events.Event;
    import org.robotlegs.core.*;

    public class MediatorBase implements IMediator 
    {

        protected static const flexAvailable:Boolean = checkFlex();

        protected static var UIComponentClass:Class;

        protected var viewComponent:Object;
        protected var removed:Boolean;


        protected static function checkFlex():Boolean
        {
            try
            {
                UIComponentClass = (getDefinitionByName("mx.core::UIComponent") as Class);
            }
            catch(error:Error)
            {
            };
            return (!((UIComponentClass == null)));
        }


        public function preRegister():void
        {
            this.removed = false;
            if (((((flexAvailable) && ((this.viewComponent is UIComponentClass)))) && (!(this.viewComponent["initialized"]))))
            {
                IEventDispatcher(this.viewComponent).addEventListener("creationComplete", this.onCreationComplete, false, 0, true);
            }
            else
            {
                this.onRegister();
            };
        }

        public function onRegister():void
        {
        }

        public function preRemove():void
        {
            this.removed = true;
            this.onRemove();
        }

        public function onRemove():void
        {
        }

        public function getViewComponent():Object
        {
            return (this.viewComponent);
        }

        public function setViewComponent(_arg1:Object):void
        {
            this.viewComponent = _arg1;
        }

        protected function onCreationComplete(_arg1:Event):void
        {
            IEventDispatcher(_arg1.target).removeEventListener("creationComplete", this.onCreationComplete);
            if (!this.removed)
            {
                this.onRegister();
            };
        }


    }
}//package org.robotlegs.base
