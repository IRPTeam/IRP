#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "Productions");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("BusinessUnit");
	AttributesArray.Add("PlanningPeriod");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetDependentDocument(DocRef) Export
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	Production.Ref,
	|	Production.Date
	|INTO tmpProduction
	|FROM
	|	Document.Production AS Production
	|WHERE
	|	NOT Production.DeletionMark
	|	AND Production.Posted
	|	AND Production.ProductionPlanning = &ProductionPlanning
	|ORDER BY
	|	Production.Date
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	ProductionPlanningCorrection.Ref,
	|	ProductionPlanningCorrection.Date
	|INTO tmpProductionPlanningCorrection
	|FROM
	|	Document.ProductionPlanningCorrection AS ProductionPlanningCorrection
	|WHERE
	|	NOT ProductionPlanningCorrection.DeletionMark
	|	AND ProductionPlanningCorrection.Posted
	|	AND ProductionPlanningCorrection.ProductionPlanning = &ProductionPlanning
	|ORDER BY 
	|	ProductionPlanningCorrection.Date
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpProduction.Ref,
	|	tmpProduction.Date
	|INTO tmpAllDocuments
	|FROM
	|	tmpProduction AS tmpProduction
	|
	|UNION ALL
	|
	|SELECT
	|	tmpProductionPlanningCorrection.Ref,
	|	tmpProductionPlanningCorrection.Date
	|FROM
	|	tmpProductionPlanningCorrection AS tmpProductionPlanningCorrection
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	tmpAllDocuments.Ref
	|FROM
	|	tmpAllDocuments AS tmpAllDocuments
	|ORDER BY
	|	tmpAllDocuments.Date";
	Query.SetParameter("ProductionPlanning", DocRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	Return Undefined;
EndFunction
	