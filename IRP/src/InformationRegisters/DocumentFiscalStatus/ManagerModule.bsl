
#Region Public

Procedure SetStatus(Document, Status, FiscalResponse = "", DataPresentation = "") Export
	SetPrivilegedMode(True);
	NewRecord = CreateRecordManager();
	NewRecord.Document = Document;
	NewRecord.Status = Status;
	NewRecord.FiscalResponse = FiscalResponse;
	NewRecord.DataPresentation = DataPresentation;
	NewRecord.Write(True);
	SetPrivilegedMode(False);	
EndProcedure

Function GetStatusData(Document) Export
	StatusData = New Structure();
	StatusData.Insert("Status", Enums.DocumentFiscalStatuses.EmptyRef());
	StatusData.Insert("FiscalResponse", "");
	StatusData.Insert("DataPresentation", "");
	StatusData.Insert("IsPrinted", False);
	Query = New Query;
	Query.Text = "SELECT
	|	DocumentFiscalStatus.Status,
	|	DocumentFiscalStatus.FiscalResponse,
	|	DocumentFiscalStatus.DataPresentation
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