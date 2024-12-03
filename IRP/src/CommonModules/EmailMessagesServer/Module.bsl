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

// Get doc outgoing message template.
// 
// Returns:
//  Structure - Get doc outgoing message template:
// * MailAccount - CatalogRef.IntegrationSettings - 
// * Subject - String - 
// * Texts - Array of String 
// * Recipients - Array of String 
// * CopyRecipients - Array of String 
// * HiddenRecipients - Array of String 
// * Attachments - Array of see OutgoingMessageAttachmentStructure() 
// * Importance - InternetMailMessageImportance - 
// * RequestDeliveryReceipt - Boolean - 
// * RequestReadReceipt - Boolean - 
Function GetDocOutgoingMessageTemplate() Export	
	Structure = New Structure;
	
	Structure.Insert("MailAccount", Catalogs.IntegrationSettings.EmptyRef());
	Structure.Insert("Subject", "");
	Structure.Insert("Texts", New Array);
	Structure.Insert("Recipients", New Array);
	Structure.Insert("CopyRecipients", New Array);
	Structure.Insert("HiddenRecipients", New Array);
	Structure.Insert("Attachments", New Array);
	Structure.Insert("Importance", InternetMailMessageImportance.Normal);
	Structure.Insert("RequestDeliveryReceipt", False);
	Structure.Insert("RequestReadReceipt", False);
	
	Return Structure;	
EndFunction

// Outgoing message attachment structure.
// 
// Returns:
//  Structure - Outgoing message attachment structure:
// * File - CatalogRef.Files - 
// * PresentationInLetter - String 
Function OutgoingMessageAttachmentStructure() Export
	Sructure = New Structure();
	Sructure.Insert("File", Catalogs.Files.EmptyRef());
	Sructure.Insert("PresentationInLetter", "");
	
	Return Sructure;
EndFunction

// Create outgoing message doc.
// 
// Parameters:
//  ParametersStructure - See GetDocOutgoingMessageTemplate
// Returns:
//  Structure - Create outgoing message doc:
// * OutgoingMessageRef - DocumentRef.OutgoingMessage - 
// * Result - Boolean 
// * Error - String
Function CreateOutgoingMessageDoc(ParametersStructure) Export		
	Structure = New Structure();
	Structure.Insert("OutgoingMessageRef", Documents.OutgoingMessage.EmptyRef());
	Structure.Insert("Result", True);
	Structure.Insert("Error", "");
	
	OutgoingMessageObject = Documents.OutgoingMessage.CreateDocument();
	OutgoingMessageObject.Date = CurrentSessionDate();
	OutgoingMessageObject.MailAccount = ParametersStructure.MailAccount;
	OutgoingMessageObject.Subject = ParametersStructure.Subject;
	OutgoingMessageObject.MessageType = Enums.MessageTypes.Email;
	OutgoingMessageObject.TextLetterHTML = New ValueStorage(CreateHtmlTextForMessage(ParametersStructure.Texts), New Deflation(9));
	
	For Each Attachment In ParametersStructure.Attachments Do
		NewAttachmentRow = OutgoingMessageObject.Attachments.Add();
		NewAttachmentRow.File = Attachment.File;
		NewAttachmentRow.PresentationInLetter = Attachment.PresentationInLetter;
	EndDo;
	If ParametersStructure.Attachments.Count() > 0 Then 
		OutgoingMessageObject.HasAttachments = True;
	EndIf;		
	
	For Each eMail In ParametersStructure.Recipients Do 
		NewReceiverRow = OutgoingMessageObject.LetterRecipients.Add();
		NewReceiverRow.Addressee = eMail;
	EndDo;
	
	Try
		OutgoingMessageObject.Write(DocumentWriteMode.Write);
		
		Structure.OutgoingMessageRef = OutgoingMessageObject.Ref;	
	Except
		Structure.Result = False;
		Structure.Error = ErrorDescription();
	EndTry;
	
	Return Structure;	
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

// Get message additional properties.
// 
// Returns:
//  Structure - Get message additional properties:
// * Attachments - Array of see GetMessageAttachmentDescription
Function GetMessageAdditionalProperties() Export
	Structure = New Structure();
	Structure.Insert("Attachments", New Array()); //Array of see GetMessageAttachmentDescription
	
	Return Structure;
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

#Region Private
// Create html text from Strings.
// 
// Parameters:
//  StringArray - Array of String
// 
// Returns:
//  String - Create html text for message
Function CreateHtmlTextForMessage(StringArray) Export
	HtmlText = 
	"<!DOCTYPE html>
	|<html dir=""ltr"">
	|<head>
	|<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
	|<meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
	|<meta name=""format-detection"" content=""telephone=no"" />
	|<style type=""text/css"">
	|body{margin:0;padding:8px;}
	|p{line-height:1.15;margin:0;white-space:pre-wrap;}
	|ol,ul{margin-top:0;margin-bottom:0;}
	|img{border:none;}
	|li>p{display:inline;}
	|</style>
	|</head>
	|<body>";
	For Each Row In StringArray Do
		HtmlText = HtmlText + StrTemplate("<p>%1</p>", Row);
	EndDo;
	HtmlText = HtmlText + 
	"</body>
	|</html>";
	
	Return HtmlText;
EndFunction
#EndRegion