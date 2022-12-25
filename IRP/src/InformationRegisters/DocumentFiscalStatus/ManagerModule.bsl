
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

#EndRegion