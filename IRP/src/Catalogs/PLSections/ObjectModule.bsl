
Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	SetSafeMode(True);
	Try
		Execute(ThisObject.SectionName + " = 0");
	Except
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_012, "SectionName", ThisObject);
		Cancel = True;
	EndTry;
	SetSafeMode(False);
	
	If Cancel Then
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	PLSections.Ref
	|FROM
	|	Catalog.PLSections AS PLSections
	|WHERE
	|	NOT PLSections.DeletionMark
	|	AND PLSections.SectionName = &SectionName
	|	AND PLSections.Ref <> &Ref";
	Query.SetParameter("Ref", ThisObject.Ref);
	Query.SetParameter("SectionName", ThisObject.SectionName);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Message = StrTemplate(R().Error_188, ThisObject.SectionName);
		CommonFunctionsClientServer.ShowUsersMessage(Message, "SectionName", ThisObject);
		Cancel = True;
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;

	For Each Row In ThisObject.Accounts Do
		If ValueIsFilled(Row.ExtDimensionValue) And Not ValueIsFilled(Row.ExtDimensionNumber) Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_189, 
					"Object.Accounts[" + (Row.LineNumber - 1) + "].ExtDimensionNumber", 
					"Object.Accounts");
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		ThisObject.SectionType = Enums.PLSectionTypes.DataSelection;
	EndIf;
EndProcedure



