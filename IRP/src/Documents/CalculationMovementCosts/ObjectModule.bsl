
// @strict-types

Procedure Posting(Cancel, PostingMode)
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R5022T_Expenses.Expenses_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R8510B_BookValueOfFixedAsset.BookValueOfFixedAsset_Clear(ThisObject.Ref, Cancel);
		
	CalculationSettings = New Structure();
	CalculationSettings.Insert("CalculationMovementCostRef" , ThisObject.Ref);
	CalculationSettings.Insert("Company"                    , ThisObject.Company);
	CalculationSettings.Insert("CalculationMode"            , ThisObject.CalculationMode);
	CalculationSettings.Insert("BeginPeriod"                , ThisObject.BeginDate);
	CalculationSettings.Insert("EndPeriod"                  , ThisObject.EndDate);
	CalculationSettings.Insert("RaiseOnCalculationError"    , ThisObject.RaiseOnCalculationError);
	
	LandedCostServer.Posting_BatchWiseBalance(CalculationSettings);
	For Each Records In ThisObject.RegisterRecords Do
		Records.Read();
	EndDo;
EndProcedure

Procedure UndoPosting(Cancel)
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R5022T_Expenses.Expenses_Clear(ThisObject.Ref, Cancel);
	AccumulationRegisters.R8510B_BookValueOfFixedAsset.BookValueOfFixedAsset_Clear(ThisObject.Ref, Cancel);
		
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Reset(ThisObject.Company, ThisObject.BeginDate);
	LandedCostServer.ReleaseBatchReallocateDocuments(ThisObject.Ref);
EndProcedure

// Fill check processing.
// 
// Parameters:
//  Cancel - Boolean - Cancel
//  CheckedAttributes - Array of String - Checked attributes
Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not ThisObject.CalculationMode = Enums.CalculationMode.LandedCostBatchReallocate Then
		CheckedAttributes.Add("Company");
	EndIf;
EndProcedure
