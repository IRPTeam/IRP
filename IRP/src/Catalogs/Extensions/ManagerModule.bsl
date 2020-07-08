#Region Service
Procedure SetupExtentionInCurrentArea(Ref, OverWrite = True) Export	
	ExtensionData = Ref.FileData.Get();
	ExtentionServer.InstallExtention(Ref.Description, ExtensionData, OverWrite);
EndProcedure
#EndRegion