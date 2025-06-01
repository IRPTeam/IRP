// Copyright (c) 2024. All rights reserved.
// Simple batch average cost calculation server module.
// This module implements weighted average cost calculation for SimpleBatch register (R6025B_SimpleBatch).

// strict-types

#Region PublicAPI

// Calculate average cost for simple batch at specified period.
// This function calculates weighted average cost based on quantity and amount from R6025B_SimpleBatch register.
// 
// Parameters:
//  SimpleBatch - CatalogRef.SimpleBatch - Simple batch reference for cost calculation
//  CalculationDate - Date - Date for which calculate average cost
//  Company - CatalogRef.Companies - Company filter (optional)
// 
// Returns:
//  Structure - Calculation result:
//   * AverageCost - Number - Calculated average cost per unit
//   * TotalQuantity - Number - Total quantity in stock  
//   * TotalAmount - Number - Total amount in stock
//   * IsCalculated - Boolean - True if calculation was successful
Function CalculateAverageCost(SimpleBatch, CalculationDate, Company = Undefined) Export
	
	If Not ValueIsFilled(SimpleBatch) Then
		Return GetEmptyCalculationResult();
	EndIf;
	
	Query = New Query;
	Query.Text = 
		"SELECT
		|	SimpleBatchTurnovers.SimpleBatch AS SimpleBatch,
		|	SimpleBatchTurnovers.QuantityTurnover AS QuantityTurnover,
		|	SimpleBatchTurnovers.AmountTurnover AS AmountTurnover
		|FROM
		|	AccumulationRegister.R6025B_SimpleBatch.Turnovers(
		|			,
		|			&EndDate,
		|			,
		|			SimpleBatch = &SimpleBatch) AS SimpleBatchTurnovers
		|WHERE
		|	SimpleBatchTurnovers.SimpleBatch = &SimpleBatch";
	
	Query.SetParameter("SimpleBatch", SimpleBatch);
	Query.SetParameter("EndDate", CalculationDate);
	
	QueryResult = Query.Execute();
	Selection = QueryResult.Select();
	
	Result = GetEmptyCalculationResult();
	
	If Selection.Next() Then
		Result.TotalQuantity = Selection.QuantityTurnover;
		Result.TotalAmount = Selection.AmountTurnover;
		
		If Result.TotalQuantity > 0 And Result.TotalAmount > 0 Then
			Result.AverageCost = Result.TotalAmount / Result.TotalQuantity;
			Result.IsCalculated = True;
		EndIf;
	EndIf;
	
	Return Result;
	
EndFunction

// Calculate average cost for multiple simple batches at specified period.
// This function is optimized for bulk calculations.
// 
// Parameters:
//  SimpleBatchArray - Array of CatalogRef.SimpleBatch - Array of simple batch references
//  CalculationDate - Date - Date for which calculate average cost
//  Company - CatalogRef.Companies - Company filter (optional)
// 
// Returns:
//  Map - Calculation results:
//   * Key - CatalogRef.SimpleBatch - Simple batch reference
//   * Value - Structure - See CalculateAverageCost result
Function CalculateAverageCostBulk(SimpleBatchArray, CalculationDate, Company = Undefined) Export
	
	Results = New Map;
	
	If SimpleBatchArray.Count() = 0 Then
		Return Results;
	EndIf;
	
	Query = New Query;
	Query.Text = 
		"SELECT
		|	SimpleBatchTurnovers.SimpleBatch AS SimpleBatch,
		|	SimpleBatchTurnovers.QuantityBalance AS QuantityBalance,
		|	SimpleBatchTurnovers.AmountBalance AS AmountBalance
		|FROM
		|	AccumulationRegister.R6025B_SimpleBatch.Balance(
		|			&EndDate,
		|			SimpleBatch IN (&SimpleBatchArray)) AS SimpleBatchTurnovers";
	
	Query.SetParameter("SimpleBatchArray", SimpleBatchArray);
	Query.SetParameter("EndDate", CalculationDate);
	
	QueryResult = Query.Execute();
	Selection = QueryResult.Select();
	
	// Initialize empty results for all batches
	For Each SimpleBatch In SimpleBatchArray Do
		Results.Insert(SimpleBatch, GetEmptyCalculationResult());
	EndDo;
	
	// Fill calculation results
	While Selection.Next() Do
		Result = GetEmptyCalculationResult();
		Result.TotalQuantity = Selection.QuantityBalance;
		Result.TotalAmount = Selection.AmountBalance;
		
		If Result.TotalQuantity > 0 And Result.TotalAmount > 0 Then
			Result.AverageCost = Result.TotalAmount / Result.TotalQuantity;
		Else
			Result.AverageCost = 0;
		EndIf;
		
		Results.Insert(Selection.SimpleBatch, Result);
	EndDo;
	
	Return Results;
	
EndFunction

// Update cost for outgoing movements based on average cost calculation.
// This procedure should be called during posting of documents with expense movements.
// 
// Parameters:
//  Ref - DocumentRefDocumentName -
//  CurrentMovements - ValueTable -
//  BatchForCheck - Array Of CatalogRef.SimpleBatch -
//  BatchWithErrors - Array Of CatalogRef.SimpleBatch -
//  Cancel - Boolean -
//  AddInfo - Structure - Additional information (optional)
Function UpdateOutgoingMovementsCost(Val Ref, Val CurrentMovements, Cancel, BatchForCheck = Undefined, BatchWithErrors = Undefined, AddInfo = Undefined) Export
	
	If Not GetFunctionalOption("UseSimpleBatch") Then
		Return Undefined;
	EndIf;
	
	If CurrentMovements.Count() = 0 Then
		Return Undefined;
	EndIf;
	
	If Not Sequences.SimpleBatch.BelongsTo(Ref) Then
		Return Undefined;
	EndIf;
	
	PointInTime = Ref.PointInTime();
	
	// Calculate average costs for all simple batches
	If BatchForCheck = Undefined Then
		BatchForCheck = CurrentMovements.UnloadColumn("SimpleBatch");
	EndIf;
	CostCalculations = CalculateAverageCostBulk(BatchForCheck, New Boundary(PointInTime, BoundaryType.Excluding));
	
	// Update amounts in VT copy
	OutgoingMovements = CurrentMovements.Copy();
	For Each Movement In OutgoingMovements Do
		Filter = New Structure("SimpleBatch", Movement.SimpleBatch);
		isValid = Sequences.SimpleBatch.Validate(PointInTime, Filter);
		
		If Not isValid Then
			Continue;
		EndIf;
		
		CostInfo = CostCalculations.Get(Movement.SimpleBatch); // See GetEmptyCalculationResult
		If CostInfo.TotalQuantity > Movement.Quantity Then
			Movement.Amount = Movement.Quantity * CostInfo.AverageCost;
			Sequences.SimpleBatch.SetBound(PointInTime, Filter);
		ElsIf CostInfo.TotalQuantity = Movement.Quantity Then
			Movement.Amount = CostInfo.TotalAmount;
			Sequences.SimpleBatch.SetBound(PointInTime, Filter);
		Else
			If Not BatchWithErrors = Undefined Then
				BatchWithErrors.Add(Movement.SimpleBatch);				
			EndIf;
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().SB_NotEnoughBatch, Movement.SimpleBatch, CostInfo.TotalQuantity, Movement.Quantity));
		EndIf;
	EndDo;
	
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
//  * TotalQuantity - Number
//  * TotalAmount - Number
Function GetEmptyCalculationResult()
	
	Result = New Structure;
	Result.Insert("AverageCost", 0);
	Result.Insert("TotalQuantity", 0);
	Result.Insert("TotalAmount", 0);
	
	Return Result;
	
EndFunction


#EndRegion 