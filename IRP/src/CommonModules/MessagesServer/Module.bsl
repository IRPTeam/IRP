// @strict-types

#Region Public

// Add to messages queue.
// 
// Parameters:
//  MessageRef - DocumentRef.OutgoingMessage - Message ref
//  RunSending - Boolean - Run sending
// 
// Returns:
//  Boolean - Add to messages queue
Function AddToMessagesQueue(MessageRef, RunSending = False) Export
	
	Query = New Query;
	Query.SetParameter("Message", MessageRef);
	
	Query.Text =
	"SELECT
	|	MessagesQueueToSendSliceLast.Period,
	|	MessagesQueueToSendSliceLast.Message,
	|	MessagesQueueToSendSliceLast.Sent,
	|	MessagesQueueToSendSliceLast.DateSent,
	|	MessagesQueueToSendSliceLast.NumberAttempts
	|FROM
	|	InformationRegister.MessagesQueueToSend.SliceLast(, Message = &Message) AS MessagesQueueToSendSliceLast";
	
	QuerySelect = Query.Execute().Select();
	//@skip-check property-return-type
	If QuerySelect.Next() And Not QuerySelect.Sent Then
		Return False;
	EndIf;
	
	RecordManager = InformationRegisters.MessagesQueueToSend.CreateRecordManager();
	RecordManager.Period = CommonFunctionsServer.GetCurrentSessionDate();
	RecordManager.Message = MessageRef;
	RecordManager.Write();
	
	SendMessagesFromQueue();

	Return True;
	
EndFunction

// Send messages from queue.
Procedure SendMessagesFromQueue() Export
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	MessagesQueueToSend.Period,
	|	MessagesQueueToSend.Message,
	|	MessagesQueueToSend.NumberAttempts
	|FROM
	|	InformationRegister.MessagesQueueToSend AS MessagesQueueToSend
	|WHERE
	|	NOT MessagesQueueToSend.Sent
	|	AND MessagesQueueToSend.NumberAttempts < &NumberAllowedAttempts";
	
	Query.SetParameter("NumberAllowedAttempts", 10);
	
	QuerySelection = Query.Execute().Select();
	
	//@skip-check property-return-type, statement-type-change
	While QuerySelection.Next() Do
		
		RecordManager = InformationRegisters.MessagesQueueToSend.CreateRecordManager();
		RecordManager.Period = QuerySelection.Period;
		RecordManager.Message = QuerySelection.Message;
		RecordManager.NumberAttempts = RecordManager.NumberAttempts + 1;
		
		Try
			//@skip-check invocation-parameter-type-intersect
			SendOutgoingMessage(QuerySelection.Message);
			RecordManager.DateSent = CommonFunctionsServer.GetCurrentSessionDate();
			RecordManager.Sent = True;
			RecordManager.LastWarning = "";
		Except
			RecordManager.LastWarning = QuerySelection.Message;
			Log.Write("Send messages", ErrorDescription(), , , QuerySelection.Message);
		EndTry;
		
		RecordManager.Write();
	
	EndDo;
	
EndProcedure

// Send message.
// 
// Parameters:
//  Message - DocumentRef.OutgoingMessage - Message
Procedure SendOutgoingMessage(Message) Export
	
	If Message.MessageType = Enums.MessageTypes.Email Then
		SendEmailMessage(Message);
	Else
		Raise R().ATC_001;
	EndIf;
			
EndProcedure

#EndRegion

#Region Private

// Send email message.
// 
// Parameters:
//  Message - DocumentRef.OutgoingMessage - Message
Procedure SendEmailMessage(Message)
	
	MessageDescription = EmailMessagesServer.GetMessageDescription();
	
	MessageDescription.MailAccount = Message.MailAccount;
	MessageDescription.Subject = Message.Subject;
	
	MessageDescription.Importance = 
		?(Message.Importance = Enums.MessagesImportance.High, InternetMailMessageImportance.High, 
		?(Message.Importance = Enums.MessagesImportance.Low, InternetMailMessageImportance.Low, 
			InternetMailMessageImportance.Normal));
	
	MessageDescription.RequestDeliveryReceipt = Message.NotifyDelivery;
	MessageDescription.RequestReadReceipt = Message.NotifyReading;
	
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", False, False));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.To.Add(AddressItem.Addressee);
	EndDo;
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", True, False));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.Cc.Add(AddressItem.Addressee);
	EndDo;
	AddressesRecords = Message.LetterRecipients.FindRows(New Structure("isCopy, isBlind", True, True));
	For Each AddressItem In AddressesRecords Do
		MessageDescription.Bcc.Add(AddressItem.Addressee);
	EndDo;
	
	For Each AttachmentItem In Message.Attachments Do
		AttachmentDescription = EmailMessagesServer.GetMessageAttachmentDescription();
		AttachmentDescription.BinaryData = PictureViewerServer.GetFileBinaryData(AttachmentItem.File);
		AttachmentDescription.Description = AttachmentItem.PresentationInLetter;
		MessageDescription.Attachments.Add(AttachmentDescription);
	EndDo;
	
	MailText = Message.TextLetterHTML.Get();
	If MailText = Undefined Then
		MailText = Message.Subject;
	EndIf;
		
	SavedAttachments = Message.LetterMultimedia.Get();
	If TypeOf(SavedAttachments) = Type("Structure") Then
		For Each SavedAttachmentKeyValue In SavedAttachments Do
			PictureID = SavedAttachmentKeyValue.Key; // String
			PictureData = SavedAttachmentKeyValue.Value; // Picture
			TextID = """" + PictureID + """";
			If StrFind(MailText, "src=" + TextID) Then
				AttachmentDescription = EmailMessagesServer.GetMessageAttachmentDescription();
				AttachmentDescription.CID = String(New UUID());
				AttachmentDescription.Name = PictureID;
				AttachmentDescription.Description = PictureID;
				AttachmentDescription.MIMEType = "image/png";
				
				PictureData.Convert(PictureFormat.PNG);
				AttachmentDescription.BinaryData = PictureData.GetBinaryData();
				
				MailText = StrReplace(MailText, "src=" + TextID, "src=""cid:" + AttachmentDescription.CID + """");
			EndIf; 
		EndDo;
	EndIf;
	
	MessageDescription.Texts.Add(MailText);
	
	Answer = EmailMessagesServer.SendMessage(MessageDescription);
	If Not IsBlankString(Answer) Then
		Raise Answer;
	EndIf;
			
EndProcedure

#EndRegion