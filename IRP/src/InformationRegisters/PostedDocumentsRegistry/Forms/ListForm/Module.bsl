
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetListParameters();
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	SetListParameters();
EndProcedure

&AtClient
Procedure DocumentTypeStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	
	ArrayOfDocumentNames = New Array();
	For Each Row In ThisObject.DocumentType Do
		ArrayOfDocumentNames.Add(Row.Value);
	EndDo;
	FormParameters = New Structure("DocumentNames", ArrayOfDocumentNames);
	
	Notify = New NotifyDescription("ChoiceDocumentTypeEnd", ThisObject);
	
	OpenForm("InformationRegister.PostedDocumentsRegistry.Form.ChoiceDocumentType",FormParameters, 
		ThisObject, , , ,Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure DocumentTypeOnChange(Item)
	SetListParameters();	
EndProcedure

&AtClient
Procedure ChoiceDocumentTypeEnd(Result, Params) Export
	ThisObject.DocumentType.Clear();
	For Each ListItem In Result.SelectedDocuments Do
		ThisObject.DocumentType.Add(ListItem.Value, ListItem.Presentation);
	EndDo;
	SetListParameters();
EndProcedure

&AtServer
Procedure SetListParameters()
	ArrayOfDocumentTypes = New Array();
	
	For Each ListItem In ThisObject.DocumentType Do
		ArrayOfDocumentTypes.Add(Type("DocumentRef." + ListItem.Value));
	EndDo;
	
	ThisObject.List.Parameters.SetParameterValue("Filter_DocumentType"  , ArrayOfDocumentTypes.Count() > 0);
	ThisObject.List.Parameters.SetParameterValue("ArrayOfDocumentTypes" , ArrayOfDocumentTypes);
	ThisObject.List.Parameters.SetParameterValue("Filter_StartDate"     , ValueIsFilled(ThisObject.Period.StartDate));
	ThisObject.List.Parameters.SetParameterValue("StartDate"            , ThisObject.Period.StartDate);
	ThisObject.List.Parameters.SetParameterValue("Filter_EndDate"       , ValueIsFilled(ThisObject.Period.EndDate));
	ThisObject.List.Parameters.SetParameterValue("EndDate"              , ThisObject.Period.EndDate);
EndProcedure
