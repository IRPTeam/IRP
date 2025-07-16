
&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("UpdateChat", 1, True);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Basis = Parameters.Basis;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.AttachedFiles.Visible = (Form.AttachedFiles.Count() > 0);
EndProcedure

&AtClient
Procedure UpdateChat()
	UpdateAtServer();
	AttachIdleHandler("UpdateChat", 1, True);
EndProcedure

&AtServer
Procedure UpdateAtServer()
	
	ChatMessages = GetChatMessages();
	Data = CommonFunctionsServer.TableToStructure(ChatMessages);
	ChatNotify = GetChatNotify();
	ChatFiles = GetChatFiles();
	For Each Msg In Data Do
		If Not IsBlankString(Msg.NotifyID) Then
			ObjectNotify = ChatNotify.Copy(New Structure("NotifyID", Msg.NotifyID));
			Msg.Insert("Notify", CommonFunctionsServer.TableToStructure(ObjectNotify));
		EndIf;
		
		MessageFiles = ChatFiles.Copy(New Structure("MessageID", Msg.MessageID));
		If MessageFiles.Count() > 0 Then
			Msg.Insert("AttachedFiles", CommonFunctionsServer.TableToStructure(MessageFiles));
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
		|	Logger.NotifyID,
		|	Logger.MessageID
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
		|	InformationRegister.LoggerNotification AS LoggerNotification
		|WHERE
		|	LoggerNotification.Basis = &Basis";
	
	Query.SetParameter("Basis", Basis);
	Result = Query.Execute().Unload();
	Return Result
EndFunction

&AtServer
Function GetChatFiles()
	Query = New Query;
	Query.Text =
		"SELECT
		|	LoggerFiles.MessageID,
		|	""attached-file:"" + LoggerFiles.FileID AS FileID,
		|	LoggerFiles.FileName AS SourceFileName,
		|	LoggerFiles.FileSize
		|FROM
		|	InformationRegister.LoggerFiles AS LoggerFiles
		|WHERE
		|	LoggerFiles.Basis = &Basis";
	
	Query.SetParameter("Basis", Basis);
	Result = Query.Execute().Unload();
	Result.Columns.Add("FileName");
	Result.Columns.Add("Icon");
	Base64 = Base64String(PictureLib.DownloadFile.GetBinaryData());
	Base64 = StrReplace(Base64, Char(13), "");
	Base64 = StrReplace(Base64, Char(10), "");
	IconURL = "data:image\jpg;base64," + Base64;
	For Each Row In Result Do
		Row.FileName = GetFilePresentation(Row.SourceFileName, Row.FileSize);
		Row.Icon = IconURL;
	EndDo;
	Return Result
EndFunction

&AtServer
Function DownloadFileAtServer(FileID, FormUUID)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	LoggerFiles.File,
	|	LoggerFiles.FileName,
	|	LoggerFiles.FileSize
	|FROM
	|	InformationRegister.LoggerFiles AS LoggerFiles
	|WHERE
	|	LoggerFiles.FileID = &FileID";
	Query.SetParameter("FileID", FileID);
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Address = PutToTempStorage(QuerySelection.File.Get(), FormUUID);
		Return New Structure("Address, FileName", Address, QuerySelection.FileName);
	EndIf;
	Return Undefined;
EndFunction

&AtClient
Procedure Update(Command)
	UpdateAtServer();
EndProcedure

&AtClient
Procedure SendMessage(Command)
	LoggerServerCall.AddLog(Basis, NewMessage, AttachedFiles, True);
	NewMessage = "";
	AttachedFiles.Clear();
	UpdateAtServer();
	CurrentItem = Items.NewMessage;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure ChatOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = False;
	If IsBlankString(EventData.Href) Then
		Return;
	EndIf;
	If StrStartsWith(EventData.Href, "e1c:") Then
		GotoURL("e1cib/data/" + StrSplit(EventData.Href, "/")[StrSplit(EventData.Href, "/").UBound()]);
	ElsIf StrStartsWith(EventData.Href, "e1cib") Then
		GotoURL(EventData.Href);
	ElsIf StrStartsWith(EventData.Href, "attached-file:") Then
		DownloadFileAtClient(StrReplace(EventData.Href, "attached-file:", ""));
	EndIf;
EndProcedure

&AtClient
Procedure AttachedFilesStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	AttachFilesAtClient();
EndProcedure

&AtClient
Procedure AttachedFilesOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AttachFiles(Command)
	AttachFilesAtClient();
EndProcedure

&AtClient
Procedure AttachFilesAtClient()
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.CheckFileExistence = True;
	OpenFileDialog.Multiselect = True;
	CallbackParams = New Structure("UUID", ThisObject.UUID);
	Callback = New CallbackDescription("AttachFilesEnd", ThisObject, CallbackParams);	
	OpenFileDialog.Show(Callback);
EndProcedure

&AtClient
Procedure AttachFilesEnd(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each PathToFile In Result Do
		FileDescription = FilesClientServer.GetStoredFileDescriptionWrapper(PathToFile);
		CallbackParams = New Structure("FileDescription", FileDescription);
		Callback = New CallbackDescription("FilesUploaded", ThisObject, CallbackParams);
		BeginPutFileToServer(Callback, , , , PathToFile, Params.UUID);
	EndDo;
EndProcedure

&AtClient
Procedure FilesUploaded(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	FilePresentation = GetFilePresentation(Params.FileDescription.FileRef.Name, Params.FileDescription.Size);
	ThisObject.AttachedFiles.Add(New Structure("Address, FileDescription", Result.Address, Params.FileDescription), 
		FilePresentation, False, PictureLib.Attach);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Async Procedure DownloadFileAtClient(FileID)
	FileInfo = DownloadFileAtServer(FileID, ThisObject.UUID);
	If FileInfo <> Undefined Then
		Dialog = New GetFilesDialogParameters();
		Await GetFileFromServerAsync(FileInfo.Address, FileInfo.FileName, Dialog);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Function GetFilePresentation(FileName, FileSize)
	Return StrTemplate("%1 (%2)", FileName, CommonFunctionsClientServer.GetSizePresentation(FileSize));
EndFunction
