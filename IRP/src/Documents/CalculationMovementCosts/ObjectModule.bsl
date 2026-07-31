
Procedure Filling(FillingData, FillingText, StandardProcessing)
	If Not FOServer.IsUseBatchReallocate() Then
		ThisObject.CalculationMode = Enums.CalculationMode.LandedCost;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	ClearSelfRecords(Cancel);
		
	CalculationSettings = New Structure();
	CalculationSettings.Insert("CalculationMovementCostRef" , ThisObject.Ref);
	CalculationSettings.Insert("Company"                    , ThisObject.Company);
	CalculationSettings.Insert("CalculationMode"            , ThisObject.CalculationMode);
	CalculationSettings.Insert("BeginPeriod"                , ThisObject.BeginDate);
	CalculationSettings.Insert("EndPeriod"                  , ThisObject.EndDate);
	CalculationSettings.Insert("RaiseOnCalculationError"    , ThisObject.RaiseOnCalculationError);
	
	LandedCostServer2.Posting_BatchWiseBalance(CalculationSettings);
	For Each Records In ThisObject.RegisterRecords Do
		Records.Read();
	EndDo;
EndProcedure

Procedure UndoPosting(Cancel)
	ClearSelfRecords(Cancel);
			
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Reset(ThisObject.Company, ThisObject.BeginDate);
	LandedCostServer2.ReleaseBatchReallocateDocuments(ThisObject.Ref);
EndProcedure

Procedure ClearSelfRecords(Cancel)
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R5022T_Expenses.Expenses_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R5021T_Revenues.Revenues_Clear(ThisObject.Ref, Cancel);	
	AccumulationRegisters.R8510B_BookValueOfFixedAsset.BookValueOfFixedAsset_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R4050B_StockInventory.StockInventory_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R6510B_StockBalance.StockBalance_Clear(ThisObject.Ref, Cancel);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not ThisObject.CalculationMode = Enums.CalculationMode.LandedCostBatchReallocate Then
		CheckedAttributes.Add("Company");
	EndIf;
	
	ArrayOfErrors = PeriodClosingServer.GetOverlappingPeriods(ThisObject.Company, 
		ThisObject.BeginDate, 
		ThisObject.EndDate, 
		"CalculationMovementCosts", "BeginDate", "EndDate", ThisObject.Ref);
	For Each Error In ArrayOfErrors Do
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(Error.Msg, "BeginDate", ThisObject);
	EndDo;	
EndProcedure


