//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.controls.List;

    public class DefaultListItemRenderer extends BaseDefaultItemRenderer implements IListItemRenderer 
    {

        private var _index:int = -1;


        public function get index():int
        {
            return (this._index);
        }

        public function set index(_arg1:int):void
        {
            this._index = _arg1;
        }

        public function get owner():List
        {
            return (List(this._owner));
        }

        public function set owner(_arg1:List):void
        {
            if (this._owner == _arg1)
            {
                return;
            };
            if (this._owner)
            {
                List(this._owner).onScroll.remove(this.owner_onScroll);
            };
            this._owner = _arg1;
            if (this._owner)
            {
                List(this._owner).onScroll.add(this.owner_onScroll);
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function owner_onScroll(_arg1:List):void
        {
            this.handleOwnerScroll();
        }


    }
}//package org.josht.starling.foxhole.controls.renderers
