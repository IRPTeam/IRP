Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	If ThisObject.Status.Posting And Not ValueIsFilled(ThisObject.ApprovedDate) Then
		ThisObject.ApprovedDate = CurrentSessionDate();
	EndIf;
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
	
	If Cancel = True Then
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	MF_ProductionPlanningCorrection.Ref,
	|	MF_ProductionPlanningCorrection.Date
	|FROM
	|	Document.MF_ProductionPlanningCorrection AS MF_ProductionPlanningCorrection
	|WHERE
	|	MF_ProductionPlanningCorrection.ProductionPlanning = &ProductionPlanning
	|	AND NOT MF_ProductionPlanningCorrection.DeletionMark
	|	AND MF_ProductionPlanningCorrection.Posted
	|	AND MF_ProductionPlanningCorrection.Ref <> &Ref
	|	AND MF_ProductionPlanningCorrection.Date > &Date
	|ORDER BY
	|	MF_ProductionPlanningCorrection.Date DESC";
	Query.SetParameter("ProductionPlanning" , ThisObject.ProductionPlanning);
	Query.SetParameter("Ref", ThisObject.Ref);
	Query.SetParameter("Date", ThisObject.Date);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_005, 
		ThisObject.Date,   
		QuerySelection.Date);
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
	ThisObject.Status = MF_ObjectStatusesServer.GetDefaultStatus(ThisObject.Ref);
	
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "MF_ProductionPlanning" Then
			ThisObject.ProductionPlanning = FillingData.ProductionPlanning;
			ThisObject.PlanningPeriod     = FillingData.PlanningPeriod;
			ThisObject.Company            = FillingData.Company;
			ThisObject.BusinessUnit       = FillingData.BusinessUnit;
			
			For Each Row In FillingData.Productions Do
				NewRow = ThisObject.Productions.Add();
				NewRow.Key             = String(New UUID());
				NewRow.Item            = Row.Item;
				NewRow.ItemKey         = Row.ItemKey;
				NewRow.Unit            = Row.Unit;
				NewRow.CurrentQuantity = Row.CurrentQuantity;
				NewRow.Quantity        = Row.CurrentQuantity;
				NewRow.BillOfMaterials = Row.BillOfMaterials;
				
				Parameters = New Structure("Key, Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit, Quantity, CurrentQuantity");
				FillPropertyValues(Parameters, NewRow);
				Parameters.PlanningPeriod = FillingData.PlanningPeriod;
				Parameters.Company        = FillingData.Company;
				BillOfMaterialRows = MF_BillOfMaterialsCalculationsServer.FillBillOfMaterialsTableCorrection(Parameters);
				For Each RowBOM In BillOfMaterialRows Do
					NewRowBOM = ThisObject.BillOfMaterials.Add();
					FillPropertyValues(NewRowBOM, RowBOM);
				EndDo;
				
			EndDo;
		EndIf;
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
