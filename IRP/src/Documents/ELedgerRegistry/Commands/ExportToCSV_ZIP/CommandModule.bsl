
&AtClient
Async Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	csv = DocELedgerRegistryServer.CreateCSV(CommandParameter);
	
	csv_catalog = TempFilesDir() + New UUID;
	CreateDirectory(csv_catalog);
	
	csv_FileName = StrTemplate("eLedger_%1.csv", 
		Format(CommonFunctionsServer.GetRefAttribute(CommandParameter, "EndDate"), "DF=yyyyMMdd"));
	csv_FullFileName = csv_catalog + "\" + csv_FileName;
	csv.Write(csv_FullFileName);
	csv = Undefined;
	
	Dialog = New FileDialog(FileDialogMode.Save);
	Dialog.FullFileName = csv_FileName + ".zip";
	Dialog.Filter = "CSV.ZIP|*.csv.zip";
	Dialog.Multiselect = False;
	
	ZipPath = Await Dialog.ChooseAsync();
	If ZipPath = Undefined Then
		DeleteFiles(csv_catalog);
		Return;
	EndIf;
	
	ZipFileWriter = New ZipFileWriter(ZipPath[0]);
	ZipFileWriter.Add(csv_FullFileName);
	ZipFileWriter.Write();
	
	DeleteFiles(csv_catalog);
	
EndProcedure
