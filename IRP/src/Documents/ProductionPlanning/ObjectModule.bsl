Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	ProductionPlanning.Ref
	|FROM
	|	Document.ProductionPlanning AS ProductionPlanning
	|WHERE
	|	ProductionPlanning.Company = &Company
	|	AND ProductionPlanning.BusinessUnit = &BusinessUnit
	|	AND ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND ProductionPlanning.Ref <> &Ref
	|	AND NOT ProductionPlanning.DeletionMark
	|	AND ProductionPlanning.Posted";
	Query.SetParameter("Company"       , ThisObject.Company);
	Query.SetParameter("BusinessUnit"  , ThisObject.BusinessUnit);
	Query.SetParameter("PlanningPeriod", ThisObject.PlanningPeriod);
	Query.SetParameter("Ref", ThisObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_003, 
		ThisObject.Company, 
		ThisObject.BusinessUnit,  
		ThisObject.PlanningPeriod);
		CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.PlanningPeriod", "Object");
	EndIf;
	
	If Not ThisObject.Company.IsEmpty() Then
		Query = New Query;
		Query.Text =
		"SELECT
		|	BillOfMaterialsList.LineNumber AS LineNumber,
		|	CAST(BillOfMaterialsList.ReleaseStore AS Catalog.Stores) AS ReleaseStore,
		|	CAST(BillOfMaterialsList.MaterialStore AS Catalog.Stores) AS MaterialStore,
		|	CAST(BillOfMaterialsList.SemiproductStore AS Catalog.Stores) AS SemiproductStore
		|into ttList
		|FROM
		|	&BillOfMaterialsList AS BillOfMaterialsList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BillOfMaterialsList.LineNumber AS LineNumber,
		|	BillOfMaterialsList.ReleaseStore AS ReleaseStore,
		|	BillOfMaterialsList.MaterialStore AS MaterialStore,
		|	BillOfMaterialsList.SemiproductStore AS SemiproductStore,
		|	BillOfMaterialsList.ReleaseStore.Company AS ReleaseStoreCompany,
		|	BillOfMaterialsList.MaterialStore.Company AS MaterialStoreCompany,
		|	BillOfMaterialsList.SemiproductStore.Company AS SemiproductStoreCompany
		|FROM
		|	ttList AS BillOfMaterialsList
		|
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("BillOfMaterialsList", ThisObject.BillOfMaterialsList.Unload());
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			If ValueIsFilled(QuerySelection.ReleaseStoreCompany) And Not QuerySelection.ReleaseStoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.ReleaseStore,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.BillOfMaterialsList[" + (QuerySelection.LineNumber - 1) + "].ReleaseStore", 
					"Object.BillOfMaterialsList");
			EndIf;
			If ValueIsFilled(QuerySelection.MaterialStoreCompany) And Not QuerySelection.MaterialStoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.MaterialStore,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.BillOfMaterialsList[" + (QuerySelection.LineNumber - 1) + "].MaterialStore", 
					"Object.BillOfMaterialsList");
			EndIf;
			If ValueIsFilled(QuerySelection.SemiproductStoreCompany) And Not QuerySelection.SemiproductStoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.SemiproductStore,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.BillOfMaterialsList[" + (QuerySelection.LineNumber - 1) + "].SemiproductStore", 
					"Object.BillOfMaterialsList");
			EndIf;
		EndDo;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

