// Copyright (c) 2024. All rights reserved.
// Simple batch average cost calculation server module.
// This module implements weighted average cost calculation for SimpleBatch register (R6025B_SimpleBatch).

// @strict-types

#Region PublicAPI

// Calculate average cost for multiple simple batches at specified period.
// This function is optimized for bulk calculations.
// 
// Parameters:
//  SimpleBatchArray - Array of CatalogRef.SimpleBatch - Array of simple batch references
//  CalculationDate - Date, Boundary - Date for which calculate average cost
// 
// Returns:
//  Map - Calculation results:
//   * Key - CatalogRef.SimpleBatch - Simple batch reference
//   * Value - See CalculateAverageCost
Function CalculateAverageCostBulk(SimpleBatchArray, CalculationDate) Export
	
	Results = New Map;
	
	If SimpleBatchArray.Count() = 0 Then
		Return Results;
	EndIf;
	
	Selection = GetCurrentAmounts(SimpleBatchArray, CalculationDate);
	
	// Initialize empty results for all batches
	For Each SimpleBatch In SimpleBatchArray Do
		Results.Insert(SimpleBatch, GetEmptyCalculationResult());
	EndDo;
	
	// Fill calculation results
	While Selection.Next() Do
		Result = GetEmptyCalculationResult();
		Result.TotalQuantity = Selection.QuantityBalance;
		Result.TotalAmount = Selection.AmountBalance;
		Result.FinalAmount = Selection.FinalAmountBalance;
		Result.FinalQuantity = Selection.FinalQuantityBalance;
		
		If Result.TotalQuantity > 0 Then
			Result.AverageCost = Result.TotalAmount / Result.TotalQuantity;
		Else
			Result.AverageCost = 0;
		EndIf;
		If Result.FinalQuantity > 0 Then
			Result.FinalAverageCost = Result.FinalAmount / Result.FinalQuantity;
		Else
			Result.FinalAverageCost = 0;
		EndIf;
		
		Results.Insert(Selection.SimpleBatch, Result);
	EndDo;
	
	Return Results;
	
EndFunction

// Get current amounts.
// 
// Parameters:
//  SimpleBatchArray - Array of CatalogRef.SimpleBatch - Simple batch array
//  CalculationDate - Date, Boundary - Calculation date
// 
// Returns:
//  QueryResultSelection - Get current amounts:
//  * SimpleBatch - CatalogRef.SimpleBatch
//  * QuantityBalance - Number
//  * AmountBalance - Number
//  * FinalAmountBalance - Number
//  * FinalQuantityBalance - Number
Function GetCurrentAmounts(SimpleBatchArray, CalculationDate)
	Query = New Query;
	Query.Text = 
		"SELECT
		|	SimpleBatchTurnovers.SimpleBatch AS SimpleBatch,
		|	SimpleBatchTurnovers.QuantityBalance AS QuantityBalance,
		|	SimpleBatchTurnovers.AmountBalance AS AmountBalance,
		|	SimpleBatchTurnovers.FinalAmountBalance AS FinalAmountBalance,
		|	SimpleBatchTurnovers.FinalQuantityBalance AS FinalQuantityBalance
		|FROM
		|	AccumulationRegister.R6025B_SimpleBatch.Balance(
		|			&EndDate,
		|			SimpleBatch IN (&SimpleBatchArray)) AS SimpleBatchTurnovers";
	
	Query.SetParameter("SimpleBatchArray", SimpleBatchArray);
	Query.SetParameter("EndDate", CalculationDate);
	
	Return Query.Execute().Select();
EndFunction

// Update cost for outgoing movements based on average cost calculation.
// This procedure should be called during posting of documents with expense movements.
// 
// Parameters:
//  Ref - DocumentRefDocumentName -
//  CurrentMovements - ValueTable - :
//  * SimpleBatch - CatalogRef.SimpleBatch
//  * Quantity - Number 
//  * Amount - Number 
//  * FinalAmount - Number 
//  * FinalQuantity - Number 
//  Cancel - Boolean -
//  BatchForCheck - Array Of CatalogRef.SimpleBatch -
//  BatchWithErrors - Array Of CatalogRef.SimpleBatch -
//  AddInfo - Structure - Additional information (optional)
Function UpdateOutgoingMovementsCost(Val Ref, Val CurrentMovements, Cancel, BatchForCheck = Undefined, BatchWithErrors = Undefined, AddInfo = Undefined) Export
	
	If Not GetFunctionalOption("UseSimpleBatch") Then
		Return Undefined;
	EndIf;
	
	If CurrentMovements.Count() = 0 Then
		Return Undefined;
	EndIf;
	
	If Not Metadata.Sequences.SimpleBatch.Documents.Contains(Ref.Metadata()) Then
		Return Undefined;
	EndIf;
	
	PointInTime = Ref.PointInTime();
	
	// Calculate average costs for all simple batches
	If BatchForCheck = Undefined Then
		BatchForCheck = CurrentMovements.UnloadColumn("SimpleBatch"); // Array Of CatalogRef.SimpleBatch
	EndIf;
	CostCalculations = CalculateAverageCostBulk(BatchForCheck, New Boundary(PointInTime, BoundaryType.Excluding));
	
	// Update amounts in VT copy
	OutgoingMovements = CurrentMovements.Copy();
	
	CalculatedBatchs = New Array; // Array Of Structure
	
	For Each Movement In OutgoingMovements Do
		Filter = New Structure("SimpleBatch", Movement.SimpleBatch);
		isValid = Sequences.SimpleBatch.Validate(PointInTime, Filter);
		
		If Not isValid Then
			Continue;
		EndIf;
		
		CostInfo = CostCalculations.Get(Movement.SimpleBatch); // See GetEmptyCalculationResult
		
		If CostInfo = Undefined Then
			Continue;
		EndIf;
		
		If CostInfo.TotalQuantity > Movement.Quantity Then
			Movement.Amount = Movement.Quantity * CostInfo.AverageCost;
		ElsIf CostInfo.TotalQuantity = Movement.Quantity Then
			Movement.Amount = CostInfo.TotalAmount;
		Else
			If Not BatchWithErrors = Undefined Then
				BatchWithErrors.Add(Movement.SimpleBatch);				
			EndIf;
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().SB_NotEnoughBatch, Movement.SimpleBatch, CostInfo.TotalQuantity, Movement.Quantity));
		EndIf;
		
		If CostInfo.FinalQuantity > Movement.Quantity Then
			Movement.FinalAmount = Movement.Quantity * CostInfo.FinalAverageCost;
		ElsIf CostInfo.FinalQuantity = Movement.Quantity Then
			Movement.FinalAmount = CostInfo.FinalAmount;
		Else
			Movement.FinalAmount = CostInfo.FinalAmount;
			Movement.FinalQuantity = CostInfo.FinalQuantity;
		EndIf;
		
		CalculatedBatchs.Add(Filter);
	EndDo;
	
	If Not Cancel Then
		For Each BatchFilter In CalculatedBatchs Do
			Sequences.SimpleBatch.SetBound(PointInTime, BatchFilter);
		EndDo;
	EndIf;
	
	// Update the register record set with calculated amounts
	Return OutgoingMovements;
	
EndFunction

#EndRegion

#Region PrivateAPI

// Get empty calculation result structure.
// 
// Returns:
//  Structure - Empty calculation result:
//  * AverageCost - Number
//  * FinalAverageCost - Number
//  * TotalQuantity - Number
//  * TotalAmount - Number
//  * FinalQuantity - Number
//  * FinalAmount - Number
Function GetEmptyCalculationResult()
	
	Result = New Structure;
	Result.Insert("AverageCost", 0);
	Result.Insert("FinalAverageCost", 0);
	Result.Insert("TotalQuantity", 0);
	Result.Insert("TotalAmount", 0);
	Result.Insert("FinalAmount", 0);
	Result.Insert("FinalQuantity", 0);
	
	Return Result;
	
EndFunction

#EndRegion 