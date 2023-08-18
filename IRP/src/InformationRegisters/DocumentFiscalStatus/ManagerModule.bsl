
#Region Public

// Set status.
//
// Parameters:
//  Document - DocumentRefDocumentName -
//  Status - EnumRef.DocumentFiscalStatuses
//  FiscalResponse - See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
//  DataPresentation - String - Data presentation
Procedure SetStatus(Document, Status, FiscalResponse, DataPresentation = "") Export
	NewRecord = CreateRecordManager();
	NewRecord.Document = Document;
	NewRecord.Status = Status;
	NewRecord.DataPresentation = DataPresentation;
	NewRecord.FiscalResponse = CommonFunctionsServer.SerializeJSON(FiscalResponse);
	If TypeOf(FiscalResponse) = Type("Structure") Then
		If FiscalResponse.Property("Out") And FiscalResponse.Out.Property("DocumentOutputParameters") And TypeOf(FiscalResponse.Out.DocumentOutputParameters) = Type("Structure") Then
			NewRecord.CheckNumber = FiscalResponse.Out.DocumentOutputParameters.CheckNumber;
		EndIf;
	EndIf;
	NewRecord.Write(True);
EndProcedure

// Get status data.
//
// Parameters:
//  Document - DocumentRefDocumentName - Document
//
// Returns:
//  Structure - Get status data:
// * Status - EnumRef.DocumentFiscalStatuses -
// * FiscalResponse - String -
// * DataPresentation - String -
// * CheckNumber - Number -
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
			StatusData.IsPrinted = True;
		EndIf;
	EndIf;
	Return StatusData;
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
//
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion