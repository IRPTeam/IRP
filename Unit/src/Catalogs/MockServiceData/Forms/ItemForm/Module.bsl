// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	QueryBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Query_BodySize);
	AnswerBodySizePresentation = Unit_CommonFunctionsClientServer.GetSizePresentation(Object.Answer_BodySize);

EndProcedure

#EndRegion


#Region FormCommandsEventHandlers

&AtClient
Procedure Test(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Procedure Query_TryLoadBody(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Procedure Answer_TryLoadBody(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Async Procedure Query_SaveBody(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Async Procedure Answer_SaveBody(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Async Procedure Query_ReloadBody(Command)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Async Procedure Answer_ReloadBody(Command)
	//TODO: Insert the handler content
EndProcedure

#EndRegion





