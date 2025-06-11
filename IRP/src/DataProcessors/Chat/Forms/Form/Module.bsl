
&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("UpdateChat", 1, True);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Basis = Parameters.Basis;

EndProcedure

&AtClient
Procedure UpdateChat()
	UpdateAtServer();
	AttachIdleHandler("UpdateChat", 1, True);
EndProcedure

&AtServer
Procedure UpdateAtServer()
	
	Result = GetChatMessages();
	Data = CommonFunctionsServer.TableToStructure(Result);
	ChatNotify = GetChatNotify();
	For Each Msg In Data Do
		If Not IsBlankString(Msg.NotifyID) Then
			ObjectNotify = ChatNotify.Copy(New Structure("NotifyID", Msg.NotifyID));
			Msg.Insert("Notify", CommonFunctionsServer.TableToStructure(ObjectNotify));
		EndIf;
	EndDo;
	
	JSON = CommonFunctionsServer.SerializeJSON(Data);
	Template = DataProcessors.Chat.GetTemplate("ChatHTML").GetText();
	ChatHTML = StrReplace(Template, "#MessageArray#", JSON);
	ChatHTML = StrReplace(ChatHTML, "#LocalCode#", StrReplace(GetInfoBaseRegionalSettings().LocaleCode, "_", "-"));
	
	If Not ChatHTML = Chat Then
		Chat = ChatHTML;
	EndIf;
EndProcedure

&AtServer
Function GetChatMessages()
	Query = New Query;
	Query.Text =
		"SELECT
		|	Logger.Period AS Period,
		|	REFPRESENTATION(Logger.User) AS User,
		|	Logger.User = &CurrentUser AS CurrentUser,
		|	Logger.Comment AS Message,
		|	Logger.ManualComment,
		|	Logger.NotifyID
		|FROM
		|	InformationRegister.Logger AS Logger
		|WHERE
		|	Logger.Basis = &Basis
		|
		|ORDER BY
		|	Period,
		|	Logger.TimeStamp";
	
	Query.SetParameter("Basis", Basis);
	Query.SetParameter("CurrentUser", SessionParameters.CurrentUser);
	Result = Query.Execute().Unload();
	Return Result
EndFunction

&AtServer
Function GetChatNotify()
	Query = New Query;
	Query.Text =
		"SELECT
		|	LoggerNotification.NotifyID,
		|	REFPRESENTATION(LoggerNotification.User) AS User,
		|	LoggerNotification.SendEmail,
		|	LoggerNotification.Sended,
		|	LoggerNotification.UserRead,
		|	LoggerNotification.WaitForOpenRef,
		|	LoggerNotification.RefOpened
		|FROM
		|	InformationRegister.LoggerNotification AS LoggerNotification";
	
	Query.SetParameter("Basis", Basis);
	Query.SetParameter("CurrentUser", SessionParameters.CurrentUser);
	Result = Query.Execute().Unload();
	Return Result
EndFunction

&AtClient
Procedure Update(Command)
	UpdateAtServer();
EndProcedure

&AtClient
Procedure SendMessage(Command)
	LoggerServerCall.AddLog(Basis, NewMessage, True);
	NewMessage = "";
	UpdateAtServer();
	CurrentItem = Items.NewMessage;
EndProcedure

&AtClient
Procedure ChatOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = False;
	If Not IsBlankString(EventData.Href) And StrStartsWith(EventData.Href, "e1c:") Then
		GotoURL("e1cib/data/" + StrSplit(EventData.Href, "/")[StrSplit(EventData.Href, "/").UBound()]);
	ElsIf Not IsBlankString(EventData.Href) And StrStartsWith(EventData.Href, "e1cib") Then
		GotoURL(EventData.Href);
	EndIf;
EndProcedure