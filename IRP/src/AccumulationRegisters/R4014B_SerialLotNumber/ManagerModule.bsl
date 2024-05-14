#Region Service

Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R4014B_SerialLotNumber");
	LockInfo = New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames()));
	Result.Insert("LockInfo", LockInfo);
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Branch, ItemKey, SerialLotNumber";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R4014B_SerialLotNumber",
		RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting,
	AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4014B_SerialLotNumber") Then
		Return True;
	EndIf;

	Query = New Query();
	Query.TempTablesManager = PostingServer.PrepareRecordsTables(GetLockFieldNames(), "ItemKey", ItemList_InDocument,
		Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	RegisterBalance.Company,
	|	RegisterBalance.Branch,
	|	RegisterBalance.ItemKey,
	|	RegisterBalance.SerialLotNumber,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R4014B_SerialLotNumber.Balance(, (Company, Branch, ItemKey, SerialLotNumber) IN
	|			(SELECT
	|				ItemList.Company,
	|				ItemList.Branch,
	|				ItemList.ItemKey,
	|				ItemList.SerialLotNumber
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.Company = ItemList.Company
	|		AND RegisterBalance.Branch = ItemList.Branch
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.SerialLotNumber = ItemList.SerialLotNumber
	|WHERE
	|	RegisterBalance.QuantityBalance < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting", Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Company, Branch, ItemKey, SerialLotNumber, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns", "Company, Branch, ItemKey, SerialLotNumber, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Serial lot number");
		ErrorParameters.Insert("RecordType", RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion