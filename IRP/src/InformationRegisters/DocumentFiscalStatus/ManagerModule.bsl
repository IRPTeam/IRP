
#Region Public

// Set status.
// 
// Parameters:
//  Document - DocumentRef.RetailSalesReceipt -
//  Status - EnumRef.DocumentFiscalStatuses
//  FiscalResponse - Structure
//  DataPresentation - String - Data presentation
Procedure SetStatus(Document, Status, FiscalResponse, DataPresentation = "") Export
	NewRecord = CreateRecordManager();
	NewRecord.Document = Document;
	NewRecord.Status = Status;
	NewRecord.DataPresentation = DataPresentation;
	NewRecord.FiscalResponse = CommonFunctionsServer.SerializeJSON(FiscalResponse);
	If FiscalResponse.Property("CheckNumber") Then 
		NewRecord.CheckNumber = FiscalResponse.CheckNumber;
	EndIf;
	NewRecord.Write(True);
EndProcedure

// Get status data.
// 
// Parameters:
//  Document - DocumentRef.RetailSalesReceipt - Document
// 
// Returns:
//  Structure - Get status data:
// * Status - EnumRef.DocumentFiscalStatuses -
// * FiscalResponse - String -
// * DataPresentation - String -
// * CheckNumber - Number -
// * IsPrinted - Boolean -
// * IsPrinted - Boolean -
Function GetStatusData(Document) Export
	StatusData = New Structure();
	StatusData.Insert("Status", Enums.DocumentFiscalStatuses.EmptyRef());
	StatusData.Insert("FiscalResponse", "");
	StatusData.Insert("DataPresentation", "");
	StatusData.Insert("CheckNumber", 0);
	StatusData.Insert("IsPrinted", False);
	Query = New Query;
	Query.Text = "SELECT
	|	DocumentFiscalStatus.Status,
	|	DocumentFiscalStatus.FiscalResponse,
	|	DocumentFiscalStatus.DataPresentation,
	|	DocumentFiscalStatus.CheckNumber
	|FROM
	|	InformationRegister.DocumentFiscalStatus AS DocumentFiscalStatus
	|WHERE
	|	DocumentFiscalStatus.Document = &Document";
	Query.SetParameter("Document", Document);
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		FillPropertyValues(StatusData, QuerySelection);
		If StatusData.Status = Enums.DocumentFiscalStatuses.Printed Then
			StatusData.Insert("IsPrinted", True);
		EndIf;
	EndIf;
	Return StatusData;
EndFunction

#EndRegion