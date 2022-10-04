Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If WriteMode = DocumentWriteMode.Posting Then
		If ThisObject.Stages.Count() Then
			ThisObject.Finished = ThisObject.Stages[ThisObject.Stages.Count()-1].Done;
		Else
			ThisObject.Finished = True;
		EndIf;
	Else
		ThisObject.Finished = False;
	EndIf;
	For Each Row In ThisObject.Stages Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ValueIsFilled(ThisObject.ProductionPlanning)
		And ThisObject.Date < ThisObject.ProductionPlanning.Date Then
			Cancel = True;
			MessageText = StrTemplate(R().MF_Error_004, 
			ThisObject.Date, 
			ThisObject.ProductionPlanning.Date);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.Date", "Object");
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		ThisObject.Finished = True;
		ThisObject.ProductionType = Enums.MF_ProductionTypes.Product;
		Return;
	EndIf;
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "MF_ProductionPlanning" Then
			ThisObject.ProductionPlanning = FillingData.ProductionPlanning;
			ThisObject.Company           = FillingData.Company;
			ThisObject.StoreProduction   = FillingData.StoreProduction;
			ThisObject.BusinessUnit      = FillingData.BusinessUnit;
			ThisObject.Item              = FillingData.Item;
			ThisObject.ItemKey           = FillingData.ItemKey;
			ThisObject.Unit              = FillingData.Unit;
			ThisObject.Quantity          = FillingData.Quantity;
			ThisObject.BillOfMaterials   = FillingData.BillOfMaterials;
			ThisObject.ProductionType    = FillingData.ProductionType;
			ThisObject.PlanningPeriod    = FillingData.PlanningPeriod;
			
			BillOfMaterials_UUID = String(ThisObject.BillOfMaterials.UUID());
			For Each Row In FillingData.Materials Do
				NewRow = ThisObject.Materials.Add();
				NewRow.Item         = Row.Item;
				NewRow.ItemKey      = Row.ItemKey;
				NewRow.Unit         = Row.Unit;
				NewRow.Quantity     = Row.Quantity;
				NewRow.Procurement  = Row.Procurement;
				NewRow.MaterialType = Row.MaterialType;
				NewRow.WriteoffStore= Row.WriteoffStore;
				
				NewRow.ItemBOM     = Row.Item;
				NewRow.ItemKeyBOM  = Row.ItemKey;
				NewRow.UnitBOM     = Row.Unit;
				NewRow.QuantityBOM = Row.Quantity;
				
				RowUniqueID = String(Row.ItemKey.UUID()) + "-" + BillOfMaterials_UUID;
				NewRow.UniqueID = RowUniqueID;
				
			EndDo;
			
			For Each Row In FillingData.Stages Do
				NewRow = ThisObject.Stages.Add();
				NewRow.Stage = Row.Stage;
			EndDo;
		EndIf;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	If ThisObject.ProductionType = Enums.MF_ProductionTypes.Product Then
		Try
			PostSemiproductsProduction();
		Except
			Cancel = True;
			GetUserMessages(ErrorDescription());
		EndTry;
	EndIf;
EndProcedure

Procedure PostSemiproductsProduction()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	MF_Procurements.OutputID
	|FROM
	|	InformationRegister.MF_Procurements AS MF_Procurements
	|WHERE
	|	MF_Procurements.Document = &Ref
	|	AND MF_Procurements.ProcurementType = VALUE(Enum.MF_ProcurementTypes.Produce)";
	Query.SetParameter("Ref", ThisObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ArrayOfSemiproductProduction = New Array();
	While QuerySelection.Next() Do
		GetSemiproductProductionRecursive(ArrayOfSemiproductProduction, QuerySelection.OutputID);
	EndDo;
	For Each ItemOfSemiproductProduction In ArrayOfSemiproductProduction Do
		ObjectProduction = ItemOfSemiproductProduction.GetObject();
		ObjectProduction.Write(DocumentWriteMode.Posting);
	EndDo;
EndProcedure

Procedure GetSemiproductProductionRecursive(ArrayOfSemiproductProduction, OutputID)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	MF_Procurements.Document,
	|	MF_Procurements.OutputID
	|FROM
	|	InformationRegister.MF_Procurements AS MF_Procurements
	|WHERE
	|	MF_Procurements.InputID = &OutputID
	|	AND MF_Procurements.ProcurementType = VALUE(Enum.MF_ProcurementTypes.Produce)
	|	AND MF_Procurements.Document.Posted";
	Query.SetParameter("OutputID", OutputID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.OutputID) Then
			GetSemiproductProductionRecursive(ArrayOfSemiproductProduction, QuerySelection.OutputID);
		EndIf;
		ArrayOfSemiproductProduction.Add(QuerySelection.Document);
	EndDo;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure
