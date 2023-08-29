
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Errors = AdditionalDocumentTableControlReuse.GetAllErrorsDescription();
	Exceptions = Constants.AdditionalTableControlExceptions.GetData();
	
	For Each ErrorItem In Errors Do
		Record = ErrorsTable.Add();
		Record.Error = ErrorItem.Key;
		Record.Description = ErrorItem.Value.ErrorDescription;
		Record.Use = Exceptions.Find(Record.Error) = Undefined;
	EndDo;

EndProcedure

&AtClient
Procedure Save(Command)
	SaveAtServer();
	Close();
EndProcedure

&AtServer
Procedure SaveAtServer()
	
	Exceptions = New Array;
	For Each Record In ErrorsTable Do
		If Not Record.Use Then
			Exceptions.Add(Record.Error);
		EndIf;
	EndDo;
	
	Constants.AdditionalTableControlExceptions.SetData(Exceptions);

EndProcedure

