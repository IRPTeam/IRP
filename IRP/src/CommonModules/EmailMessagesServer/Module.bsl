// @strict-types

#Region Public

// Get message description.
// 
// Returns:
//  Structure - Get message description:
// * MailAccount - CatalogRef.IntegrationSettings - 
// * Subject - String - 
// * Texts - Array of String - 
// * To - Array of String - 
// * Cc - Array of String - 
// * Bcc - Array of String - 
// * Attachments - Array of See GetMessageAttachmentDescription 
// * Importance - InternetMailMessageImportance - 
// * RequestDeliveryReceipt - Boolean - 
// * RequestReadReceipt - Boolean - 
Function GetMessageDescription() Export
	
	Description = New Structure;
	
	Description.Insert("MailAccount", Catalogs.IntegrationSettings.EmptyRef());
	Description.Insert("Subject", "");
	Description.Insert("Texts", New Array);
	Description.Insert("To", New Array);
	Description.Insert("Cc", New Array);
	Description.Insert("Bcc", New Array);
	Description.Insert("Attachments", New Array);
	Description.Insert("Importance", InternetMailMessageImportance.Normal);
	Description.Insert("RequestDeliveryReceipt", False);
	Description.Insert("RequestReadReceipt", False);
	
	Return Description;
	
EndFunction

// Get message attachment description.
// 
// Returns:
//  Structure - Get message attachment description:
// * Name - String - 
// * Description - String - 
// * CID - String - 
// * MIMEType - String - 
// * BinaryData - BinaryData - 
Function GetMessageAttachmentDescription() Export
	
	Description = New Structure;
	
	Description.Insert("Name", "");
	Description.Insert("Description", "");
	Description.Insert("CID", "");
	Description.Insert("MIMEType", "");
	Description.Insert("BinaryData", Undefined);
	
	Return Description;
	
EndFunction

// Send message.
// 
// Parameters:
//  Message - See GetMessageDescription
//  ConnectionSetting - See IntegrationServer.ConnectionSettingTemplate
// 
// Returns:
//  String - Send message
Function SendMessage(Message, ConnectionSetting = Undefined) Export
	
	If ConnectionSetting = Undefined Then
		ConnectionSetting = IntegrationClientServer.ConnectionSetting(Message.MailAccount).Value; // See IntegrationServer.ConnectionSettingTemplate
	EndIf;
	
	eMail = New InternetMailMessage();
	
	eMail.Subject = Message.Subject;
	
	eMail.Importance = Message.Importance;
	eMail.RequestDeliveryReceipt = Message.RequestDeliveryReceipt;
	eMail.RequestReadReceipt = Message.RequestReadReceipt;
	
	For Each AddressItem In Message.To Do
		eMail.To.Add(AddressItem);
	EndDo;
	For Each AddressItem In Message.Cc Do
		eMail.Cc.Add(AddressItem);
	EndDo;
	For Each AddressItem In Message.Bcc Do
		eMail.Bcc.Add(AddressItem);
	EndDo;
	
	For Each AttachmentItem In Message.Attachments Do
		MailAttachment = eMail.Attachments.Add(
			AttachmentItem.BinaryData, AttachmentItem.Description);
		MailAttachment.CID = AttachmentItem.CID;
		MailAttachment.Name = AttachmentItem.Name;
		MailAttachment.MIMEType = AttachmentItem.MIMEType;
	EndDo;
	
	For Each MailText In Message.Texts Do
		eMail.Texts.Add(MailText, InternetMailTextType.HTML);
	EndDo;
	
	Answer = IntegrationClientServer.SendEmail(ConnectionSetting, eMail);
	If Answer.Count() > 0 Then
		Return CommonFunctionsServer.SerializeJSON(Answer);
	EndIf;
	
	Return "";
	
EndFunction

// Send test message.
// 
// Parameters:
//  ConnectionSetting - See IntegrationServer.ConnectionSettingTemplate
Procedure SendTestMessage(ConnectionSetting) Export

	MessageDescription = GetMessageDescription();
	
	MessageDescription.Subject = "Test";
	MessageDescription.Texts.Add("<h1> Test </h1>");
	//@skip-check property-return-type, invocation-parameter-type-intersect
	MessageDescription.To.Add(ConnectionSetting.eMailForTest);
	
	Answer = SendMessage(MessageDescription, ConnectionSetting);
	
	If IsBlankString(Answer) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().S_028);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(Answer);
	EndIf;
	
EndProcedure

#EndRegion