
#Region Public

// Set status.
//
// Parameters:
//  Document - DocumentRefDocumentName -
//  Status - EnumRef.DocumentFiscalStatuses
//  FiscalResponse - See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
//  DataPresentation - String - Data presentation
Procedure SetStatus(Document, Status, FiscalResponse, DataPresentation = "") Export
	
	// TODO: The parameter list needs to be refactored.
	// Temporarily read fiscal printer from CRS
	FiscalPrinter = 
		CommonFunctionsServer.GetAttributesFromRef(Document, "ConsolidatedRetailSales.FiscalPrinter")
			["ConsolidatedRetailSales"]["FiscalPrinter"];
	
	NewRecord = CreateRecordManager();
	NewRecord.Document = Document;
	NewRecord.Device = FiscalPrinter;
	NewRecord.Status = Status;
	NewRecord.DataPresentation = DataPresentation;
	
	HardwareServer.FixTypesForWrite(FiscalResponse);
	
	NewRecord.FiscalResponse = CommonFunctionsServer.SerializeJSON(FiscalResponse);
	If TypeOf(FiscalResponse) = Type("Structure") Then
		If FiscalResponse.Property("Out") 
				And FiscalResponse.Out.Property("DocumentOutputParameters") 
				And TypeOf(FiscalResponse.Out.DocumentOutputParameters) = Type("Structure") Then
			NewRecord.DeviceNumber = Format(FiscalResponse.Out.DocumentOutputParameters.DeviceNumber, "NG=");
			NewRecord.ShiftNumber = Format(FiscalResponse.Out.DocumentOutputParameters.ShiftNumber, "NG=");
			NewRecord.CheckNumber = Format(FiscalResponse.Out.DocumentOutputParameters.CheckNumber, "NG=");
			NewRecord.CheckDate = FiscalResponse.Out.DocumentOutputParameters.DateTime;
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
// * Device - CatalogRef.Hardware - 
// * DeviceNumberNumber - String - 
// * ShiftNumber - String - 
// * CheckNumber - String - 
// * CheckDate - Date - 
// * FiscalResponse - String - 
// * DataPresentation - String - 
// * IsPrinted - Boolean - 
Function GetStatusData(Document) Export
	StatusData = New Structure();
	StatusData.Insert("Status", Enums.DocumentFiscalStatuses.EmptyRef());
	StatusData.Insert("Device", Catalogs.Hardware.EmptyRef());
	StatusData.Insert("DeviceNumberNumber", "");
	StatusData.Insert("ShiftNumber", "");
	StatusData.Insert("CheckNumber", "");
	StatusData.Insert("CheckDate", Date(1,1,1));
	StatusData.Insert("FiscalResponse", "");
	StatusData.Insert("DataPresentation", "");
	StatusData.Insert("IsPrinted", False);
	
	Query = New Query;
	Query.Text = "SELECT
	|	DocumentFiscalStatus.Status AS Status,
	|	DocumentFiscalStatus.Device AS Device,
	|	DocumentFiscalStatus.DeviceNumber AS DeviceNumber,
	|	DocumentFiscalStatus.ShiftNumber AS ShiftNumber,
	|	DocumentFiscalStatus.CheckNumber AS CheckNumber,
	|	DocumentFiscalStatus.CheckDate AS CheckDate,
	|	DocumentFiscalStatus.FiscalResponse AS FiscalResponse,
	|	DocumentFiscalStatus.DataPresentation AS DataPresentation
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
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion