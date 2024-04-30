
Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	Query = New Query();
	//@skip-check bsl-ql-hub
	Query.Text = 
	"SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.Quantity
	|INTO Records_InDocument
	|FROM
	|	&Records_InDocument AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.ItemKey,
	|	ItemList_InDocument.LineNumber
	|INTO ItemList_InDocument
	|FROM
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.Quantity
	|INTO Records_Exists
	|FROM
	|	&Records_Exists AS Records
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.RowRef.ItemKey AS ItemKey,
	|	Records.Quantity,
	|	ItemList_InDocument.LineNumber
	|INTO Records_with_LineNumbers
	|FROM
	|	Records_InDocument AS Records
	|		LEFT JOIN ItemList_InDocument AS ItemList_InDocument
	|		ON Records.RowRef.ItemKey = ItemList_InDocument.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.Quantity,
	|	Records.LineNumber,
	|	Records.ItemKey
	|INTO RowIDInfo_All
	|FROM
	|	Records_with_LineNumbers AS Records
	|
	|UNION ALL
	|
	|SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.Quantity,
	|	UNDEFINED,
	|	Records.RowRef.ItemKey AS ItemKey
	|FROM
	|	Records_Exists AS Records
	|		LEFT JOIN Records_with_LineNumbers AS Records_with_LineNumbers
	|		ON Records.RowRef.ItemKey = Records_with_LineNumbers.ItemKey
	|		AND Records.RowRef = Records_with_LineNumbers.RowRef
	|		AND Records.RowID = Records_with_LineNumbers.RowID
	|		AND Records.Step = Records_with_LineNumbers.Step
	|		AND Records.Basis = Records_with_LineNumbers.Basis
	|		AND Records.BasisKey = Records_with_LineNumbers.BasisKey
	|WHERE
	|	Records_with_LineNumbers.ItemKey IS NULL
	|	AND NOT &Unposting
	|;
	|//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.ItemKey,
	|	MIN(Records.LineNumber) AS LineNumber,
	|	SUM(Records.Quantity) AS Quantity
	|INTO RowIDInfo
	|FROM
	|	RowIDInfo_All AS Records
	|GROUP BY
	|	Records.RowRef,
	|	Records.RowID,
	|	Records.Step,
	|	Records.Basis,
	|	Records.BasisKey,
	|	Records.ItemKey
	|;
	|SELECT
	|	TM1010T_RowIDMovementsTurnovers.RowRef,
	|	TM1010T_RowIDMovementsTurnovers.RowID,
	|	TM1010T_RowIDMovementsTurnovers.Step,
	|	TM1010T_RowIDMovementsTurnovers.Basis,
	|	TM1010T_RowIDMovementsTurnovers.BasisKey,
	|	SUM(TM1010T_RowIDMovementsTurnovers.QuantityTurnover) AS QuantityBalance
	|INTO RowIDInfoBalance
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements.Turnovers(, , , (RowRef, RowID, Step, Basis, BasisKey) IN
	|		(SELECT
	|			RowIDInfo.RowRef,
	|			RowIDInfo.RowID,
	|			RowIDInfo.Step,
	|			RowIDInfo.Basis,
	|			RowIDInfo.BasisKey
	|		FROM
	|			RowIDInfo AS RowIDInfo)) AS TM1010T_RowIDMovementsTurnovers
	|GROUP BY
	|	TM1010T_RowIDMovementsTurnovers.RowRef,
	|	TM1010T_RowIDMovementsTurnovers.RowID,
	|	TM1010T_RowIDMovementsTurnovers.Step,
	|	TM1010T_RowIDMovementsTurnovers.Basis,
	|	TM1010T_RowIDMovementsTurnovers.BasisKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.RowRef.ItemKey.Item AS Item,
	|	RowIDInfo.RowRef.ItemKey AS ItemKey,
	|	RowIDInfoBalance.RowRef.Company AS Company,
	|	RowIDInfoBalance.RowRef.Branch AS Branch,
	|	RowIDInfoBalance.QuantityBalance AS QuantityBalance,
	|	RowIDInfo.Quantity,
	|	-RowIDInfoBalance.QuantityBalance AS LackOfBalance,
	|	RowIDInfo.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	RowIDInfo AS RowIDInfo
	|		INNER JOIN RowIDInfoBalance AS RowIDInfoBalance
	|		ON RowIDInfo.RowRef = RowIDInfoBalance.RowRef
	|		AND RowIDInfo.RowID = RowIDInfoBalance.RowID
	|		AND RowIDInfo.Step = RowIDInfoBalance.Step
	|		AND RowIDInfo.Basis = RowIDInfoBalance.Basis
	|		AND RowIDInfo.BasisKey = RowIDInfoBalance.BasisKey
	|WHERE
	|	RowIDInfoBalance.QuantityBalance < 0
	|
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Records_InDocument", Records_InDocument);
	Query.SetParameter("ItemList_InDocument", ItemList_InDocument);
	Query.SetParameter("Records_Exists", Records_Exists);
	Query.SetParameter("Unposting", Unposting);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Company, Branch, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns", "Company, Branch, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Return");
		ErrorParameters.Insert("RecordType", RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction

#Region AccessObject

// Get access key.
// 	See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
//  
// Returns:
//  Structure
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure