// Add log.
// 
// Parameters:
//  Basis - AnyRef - Basis
//  Comment - String - Comment
//  Manual - Boolean - Manual
//  NotifyUsers - Array Of CatalogRef.Users - Notify users
//  NotifySettings - See GetNotifySettings
Procedure AddLog(Basis, Comment, Manual = False, NotifyUsers = Undefined, NotifySettings = Undefined) Export
	SetPrivilegedMode(True);
	NewRecord = InformationRegisters.Logger.CreateRecordManager();
	NewRecord.Basis = Basis;
	NewRecord.Comment = Comment;
	NewRecord.ManualComment = Manual;
	NewRecord.User = SessionParameters.CurrentUser;
	NewRecord.TimeStamp = CurrentUniversalDateInMilliseconds();
	NewRecord.Period = CurrentSessionDate();
	
	NotifyID = String(New UUID);
	If Not NotifyUsers = Undefined Then
		NewRecord.NotifyID = NotifyID;
	EndIf;
	
	NewRecord.Write();
	
	If Not NotifyUsers = Undefined Then
		For Each User In NotifyUsers Do
			NewNotify = InformationRegisters.LoggerNotification.CreateRecordManager();
			NewNotify.NotifyID = NotifyID;
			NewNotify.Basis = Basis;
			NewNotify.User = User;
			For Each Setting In NotifySettings Do
				NewNotify[Setting.Key] = Setting.Value;
			EndDo;
			NewNotify.Write();
		EndDo;
	EndIf;
	
	SetPrivilegedMode(False);
EndProcedure

// Change notify status.
// 
// Parameters:
//  NotifyID - String -  Notify ID
//  User - CatalogRef.Users - User
//  StatusName - String -  Status name
//  Value - Boolean - Value
Procedure ChangeNotifyStatus(NotifyID, User, StatusName, Value) Export
	UpdateNotify = InformationRegisters.LoggerNotification.CreateRecordSet();
	UpdateNotify.Filter.NotifyID.Set(NotifyID);
	UpdateNotify.Filter.User.Set(User);
	UpdateNotify.Read();
	If UpdateNotify.Count() = 0 Then
		Return;
	EndIf;
	UpdateNotify[0][StatusName] = Value;
	UpdateNotify.Write();
EndProcedure

// Get notify settings.
// 
// Returns:
//  Structure - Get notify settings:
// * SendEmail - Boolean - 
// * WaitForOpenRef - Boolean - 
Function GetNotifySettings() Export
	Str = New Structure;
	Str.Insert("SendEmail", False);
	Str.Insert("WaitForOpenRef", False);
	Return Str;
EndFunction

// Send notifications.
// 
// Parameters:
//  IntegrationSettings - CatalogRef.IntegrationSettings - Integration settings
Procedure SendNotifications(IntegrationSettings) Export
	
	NotifyData = GetNotifyData();
	
	While NotifyData.Next() Do
		
		If IsBlankString(NotifyData.User.Email) Then
			Continue;
		EndIf;
		
		MessageInfo = GetMessageInfo(NotifyData.NotifyID);
		If MessageInfo = Undefined Then
			Continue;
		EndIf;
		
		Msg = EmailMessagesServer.GetMessageDescription();
		Msg.Importance = InternetMailMessageImportance.High;
		Msg.MailAccount = IntegrationSettings;
		Msg.Subject = MessageInfo.Basis.Metadata().Synonym + " #" + MessageInfo.Basis.Number;
		Msg.To.Add(NotifyData.User.Email);
		Msg.Texts.Add(String(MessageInfo.User) + " (" + MessageInfo.Period + ")" + Chars.LF + MessageInfo.Comment);
		EmailMessagesServer.SendMessage(Msg);
		
		ChangeNotifyStatus(NotifyData.NotifyID, NotifyData.User, "Sended", True);
	EndDo;
	
EndProcedure

Procedure CheckIfNeedSetOnOpen(Ref) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	LoggerNotification.NotifyID
		|FROM
		|	InformationRegister.LoggerNotification AS LoggerNotification
		|WHERE
		|	LoggerNotification.WaitForOpenRef
		|	AND NOT LoggerNotification.RefOpened
		|	AND LoggerNotification.User = &User
		|	AND LoggerNotification.Basis = &Basis";
	Query.Parameters.Insert("Basis", Ref);
	Query.Parameters.Insert("User", SessionParameters.CurrentUser);
	QueryResult = Query.Execute();
	
	If Not QueryResult.IsEmpty() Then
		NotifyID = QueryResult.Unload().UnloadColumn("NotifyID")[0];
		ChangeNotifyStatus(NotifyID, SessionParameters.CurrentUser, "RefOpened", True);
	EndIf;
EndProcedure

// Get message info.
// 
// Parameters:
//  NotifyID - String - Notify ID
// 
// Returns:
//  QueryResultSelection:
//  * Period - Date
//  * Basis - AnyRef
//  * Comment - String
//  * ManualComment - Boolean
//  * User - CatalogRef.Users
Function GetMessageInfo(NotifyID)
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Logger.Period,
		|	Logger.Basis,
		|	Logger.User,
		|	Logger.TimeStamp,
		|	Logger.Comment,
		|	Logger.ManualComment,
		|	Logger.NotifyID
		|FROM
		|	InformationRegister.Logger AS Logger
		|WHERE
		|	Logger.NotifyID = &NotifyID";
	
	Query.SetParameter("NotifyID", NotifyID);
	
	QueryResult = Query.Execute().Select();
	If QueryResult.Next() Then
		Return QueryResult;
	EndIf;
	Return Undefined;
EndFunction

Function GetNotifyData()
	Query = New Query;
	Query.Text =
		"SELECT
		|	LoggerNotification.NotifyID,
		|	LoggerNotification.User
		|FROM
		|	InformationRegister.LoggerNotification AS LoggerNotification
		|WHERE
		|	LoggerNotification.SendEmail
		|	AND NOT LoggerNotification.Sended";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	Return SelectionDetailRecords
EndFunction
