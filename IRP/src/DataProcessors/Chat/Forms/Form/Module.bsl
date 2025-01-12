
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Basis = Parameters.Basis;
	UpdateAtServer();
EndProcedure

&AtServer
Procedure UpdateAtServer()
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Logger.Period AS Period,
		|	REFPRESENTATION(Logger.User) AS User,
		|	Logger.User = &CurrentUser AS CurrentUser,
		|	Logger.Comment AS Message,
		|	Logger.ManualComment
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
	JSON = CommonFunctionsServer.SerializeJSON(CommonFunctionsServer.TableToStructure(Result));
	
	Template = DataProcessors.Chat.GetTemplate("ChatHTML").GetText();
	Chat = StrReplace(Template, "#MessageArray#", JSON);
EndProcedure

&AtClient
Procedure Update(Command)
	UpdateAtServer();
EndProcedure

&AtClient
Procedure SendMessage(Command)
	LoggerServerCall.AddLog(Basis, NewMessage, True);
	NewMessage = "";
	UpdateAtServer();
EndProcedure
