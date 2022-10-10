Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If WriteMode = DocumentWriteMode.Posting Then
		ThisObject.Finished = True;
	Else
		ThisObject.Finished = False;
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
	If ValueIsFilled(ThisObject.ProductionPlanning) And ThisObject.Date < ThisObject.ProductionPlanning.Date Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_004, ThisObject.Date, ThisObject.ProductionPlanning.Date);
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
		ThisObject.ProductionType = Enums.ProductionTypes.Product;
		Return;
	EndIf;
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "ProductionPlanning" Then
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			
			ThisObject.ProductionPlanning = FillingData.ProductionPlanning;
			ThisObject.Company            = FillingData.Company;
			ThisObject.StoreProduction    = FillingData.StoreProduction;
			ThisObject.BusinessUnit       = FillingData.BusinessUnit;
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
