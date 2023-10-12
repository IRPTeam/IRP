Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If WriteMode = DocumentWriteMode.Posting Then
		ThisObject.Finished = True;
	Else
		ThisObject.Finished = False;
	EndIf;
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
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
	
	MaterialQuantity = 0;
	For Each Row In ThisObject.Materials Do
		MaterialQuantity = MaterialQuantity + Row.Quantity;
	EndDo;

	If MaterialQuantity = 0 Then
		Cancel = True;
		MessageText = R().Error_127;
		If ThisObject.Materials.Count() > 0 Then
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, 
					"Object.Materials[0].Quantity", 
					"Object.Materials");
		Else
			CommonFunctionsClientServer.ShowUsersMessage(MessageText);
		EndIf;
	EndIf;
		
	If ThisObject.TransactionType <> Enums.ProductionTransactionTypes.Produce Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "BillOfMaterials");
	EndIf;
	
	If ValueIsFilled(ThisObject.ProductionPlanning) And ThisObject.Date < ThisObject.ProductionPlanning.Date Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_004, ThisObject.Date, ThisObject.ProductionPlanning.Date);
		CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.Date", "Object");
	EndIf;
	
	If Not ThisObject.Company.IsEmpty() Then
		If Not ThisObject.StoreProduction.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreProduction, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreProduction,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreProduction", 
					"Object");
			EndIf;
		EndIf;
		
		Query = New Query;
		Query.Text =
		"SELECT
		|	Materials.LineNumber AS LineNumber,
		|	CAST(Materials.WriteoffStore AS Catalog.Stores) AS Store
		|into ttMaterials
		|FROM
		|	&Materials AS Materials
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Materials.LineNumber AS LineNumber,
		|	Materials.Store AS Store,
		|	Materials.Store.Company AS StoreCompany
		|FROM
		|	ttMaterials AS Materials
		|
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("Materials", ThisObject.Materials.Unload());
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			If ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.Store,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.Materials[" + (QuerySelection.LineNumber - 1) + "].WriteoffStore", 
					"Object.Materials");
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		ThisObject.Finished = True;
		ThisObject.ProductionType = Enums.ProductionTypes.Product;
		ThisObject.TransactionType = Enums.ProductionTransactionTypes.Produce;
		Return;
	EndIf;
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "ProductionPlanning" Then
			FillingData.Insert("TransactionType", Enums.ProductionTransactionTypes.Produce);
			
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			
			ThisObject.TransactionType    = FillingData.TransactionType;
			ThisObject.ProductionPlanning = FillingData.ProductionPlanning;
			ThisObject.Company            = FillingData.Company;
			ThisObject.StoreProduction    = FillingData.StoreProduction;
			ThisObject.BusinessUnit       = FillingData.BusinessUnit;
			ThisObject.Branch             = FillingData.Branch;
			ThisObject.Item               = FillingData.Item;
			ThisObject.ItemKey            = FillingData.ItemKey;
			ThisObject.Unit               = FillingData.Unit;
			ThisObject.Quantity           = FillingData.Quantity;
			ThisObject.BillOfMaterials    = FillingData.BillOfMaterials;
			ThisObject.ProductionType     = FillingData.ProductionType;
			ThisObject.PlanningPeriod     = FillingData.PlanningPeriod;
			
			BillOfMaterials_UUID = String(ThisObject.BillOfMaterials.UUID());
			For Each Row In FillingData.Materials Do
				NewRow = ThisObject.Materials.Add();
				NewRow.Key          = String(New UUID());
				NewRow.Item         = Row.Item;
				NewRow.ItemKey      = Row.ItemKey;
				NewRow.Unit         = Row.Unit;
				NewRow.Quantity     = Row.Quantity;

				NewRow.MaterialType = Row.MaterialType;
				NewRow.WriteoffStore= Row.WriteoffStore;
				
				NewRow.ItemBOM     = Row.Item;
				NewRow.ItemKeyBOM  = Row.ItemKey;
				NewRow.UnitBOM     = Row.Unit;
				NewRow.QuantityBOM = Row.Quantity;
				
				RowUniqueID = String(Row.ItemKey.UUID()) + "-" + BillOfMaterials_UUID;
				NewRow.UniqueID = RowUniqueID;
			EndDo;
		EndIf;
	EndIf;
EndProcedure
