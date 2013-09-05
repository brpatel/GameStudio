package com.adobe.gamebuilder.editor.core
{
    import com.adobe.gamebuilder.editor.core.data.ContactFormVO;
    import com.adobe.gamebuilder.editor.core.data.MailFormVO;
    import com.adobe.gamebuilder.editor.core.data.PartnerVO;
    import com.adobe.gamebuilder.editor.core.data.ProductVO;
    import com.adobe.gamebuilder.editor.storage.StoredBlock;
    import com.adobe.gamebuilder.editor.storage.StoredProduct;
    import com.adobe.gamebuilder.editor.storage.StoredRoom;
    import com.adobe.gamebuilder.editor.storage.StoredRoomPoint;
    import com.adobe.gamebuilder.editor.storage.StoredRoomSite;
    import com.adobe.gamebuilder.editor.storage.StoredThumbnail;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;
    import mx.messaging.config.ConfigMap;
    import mx.messaging.messages.AcknowledgeMessage;
    import mx.messaging.messages.AcknowledgeMessageExt;
    import mx.messaging.messages.CommandMessage;
    import mx.messaging.messages.CommandMessageExt;
    import mx.messaging.messages.ErrorMessage;
    import mx.messaging.messages.RemotingMessage;
    import mx.utils.ObjectProxy;

    public class Bootstrap 
    {

        public function Bootstrap()
        {
            registerClassAlias("flex.messaging.messages.CommandMessage", CommandMessage);
            registerClassAlias("flex.messaging.messages.CommandMessageExt", CommandMessageExt);
            registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);
            registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
            registerClassAlias("flex.messaging.messages.AcknowledgeMessageExt", AcknowledgeMessageExt);
            registerClassAlias("flex.messaging.messages.ErrorMessage", ErrorMessage);
            registerClassAlias("DSC", CommandMessageExt);
            registerClassAlias("DSK", AcknowledgeMessageExt);
            registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
            registerClassAlias("flex.messaging.config.ConfigMap", ConfigMap);
            registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
            registerClassAlias("flex.messaging.io.ObjectProxy", ObjectProxy);
            registerClassAlias("MailFormVO", MailFormVO);
            registerClassAlias("PartnerVO", PartnerVO);
            registerClassAlias("ContactFormVO", ContactFormVO);
            registerClassAlias("Point", Point);
            registerClassAlias("Rectangle", Rectangle);
            registerClassAlias("ByteArray", ByteArray);
            registerClassAlias("ProductVO", ProductVO);
            registerClassAlias("StoredThumbnail", StoredThumbnail);
            registerClassAlias("StoredBlock", StoredBlock);
            registerClassAlias("StoredProduct", StoredProduct);
            registerClassAlias("StoredRoomPoint", StoredRoomPoint);
            registerClassAlias("StoredRoomSite", StoredRoomSite);
            registerClassAlias("StoredRoom", StoredRoom);
        }

    }
}//package at.polypex.badplaner.core
