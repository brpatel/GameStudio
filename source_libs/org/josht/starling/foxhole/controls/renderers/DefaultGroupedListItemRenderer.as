//Created by Action Script Viewer - http://www.buraks.com/asv
package org.josht.starling.foxhole.controls.renderers
{
    import org.josht.starling.foxhole.controls.GroupedList;

    public class DefaultGroupedListItemRenderer extends BaseDefaultItemRenderer implements IGroupedListItemRenderer 
    {

        private var _groupIndex:int = -1;
        private var _itemIndex:int = -1;


        public function get groupIndex():int
        {
            return (this._groupIndex);
        }

        public function set groupIndex(_arg1:int):void
        {
            this._groupIndex = _arg1;
        }

        public function get itemIndex():int
        {
            return (this._itemIndex);
        }

        public function set itemIndex(_arg1:int):void
        {
            this._itemIndex = _arg1;
        }

        public function get owner():GroupedList
        {
            return (GroupedList(this._owner));
        }

        public function set owner(_arg1:GroupedList):void
        {
            if (this._owner == _arg1)
            {
                return;
            };
            if (this._owner)
            {
                GroupedList(this._owner).onScroll.remove(this.owner_onScroll);
            };
            this._owner = _arg1;
            if (this._owner)
            {
                GroupedList(this._owner).onScroll.add(this.owner_onScroll);
            };
            this.invalidate(INVALIDATION_FLAG_DATA);
        }

        protected function owner_onScroll(_arg1:GroupedList):void
        {
            this.handleOwnerScroll();
        }


    }
}//package org.josht.starling.foxhole.controls.renderers
