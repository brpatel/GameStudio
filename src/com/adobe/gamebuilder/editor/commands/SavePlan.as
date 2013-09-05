package com.adobe.gamebuilder.editor.commands
{
    import com.adobe.gamebuilder.editor.core.Common;
    import com.adobe.gamebuilder.editor.core.Constants;
    import com.adobe.gamebuilder.editor.core.events.CommandEvent;
    import com.adobe.gamebuilder.editor.core.events.ContextEvent;
    import com.adobe.gamebuilder.editor.storage.StoreUtils;
    import com.adobe.gamebuilder.editor.storage.StoredRoom;
    import com.adobe.gamebuilder.editor.view.Room;
    
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    
    import org.robotlegs.mvcs.StarlingCommand;

    public class SavePlan extends StarlingCommand 
    {

        [Inject]
        public var event:CommandEvent;


        override public function execute():void
        {
            var storedRoom:StoredRoom;
            var file:File;
            var fs:FileStream;
            var counter:uint;
            storedRoom = StoreUtils.roomToStoredRoom(this.event.data.room);
            storedRoom.version = Constants.PLAN_VERSION;
            storedRoom.baseRoomID = this.event.data.baseRoomID;
            storedRoom.name = this.event.data.planName;
            storedRoom.thumbnail = (this.event.data.room as Room).getThumbnail();
            var compressedPlan:ByteArray = StoreUtils.compressPlan(storedRoom);
            var planName:String = this.event.data.planName;
            try
            {
                file = File.documentsDirectory.resolvePath((planName + ".badplan"));
                if (this.event.data.overwrite == false)
                {
                    counter = 1;
                    while (file.exists)
                    {
                        file = File.documentsDirectory.resolvePath((((planName + "-") + String(counter)) + ".badplan"));
                        counter = (counter + 1);
                    };
                };
                fs = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeBytes(compressedPlan);
                fs.close();
                dispatch(new ContextEvent(ContextEvent.SAVE_PLAN_COMPLETE, {
                    success:true,
                    planName:this.event.data.planName
                }));
            }
            catch(e:Error)
            {
                Common.log(e.message, "ERROR");
                dispatch(new ContextEvent(ContextEvent.SAVE_PLAN_COMPLETE, {
                    success:false,
                    planName:event.data.planName
                }));
            };
        }


    }
}//package at.polypex.badplaner.commands
