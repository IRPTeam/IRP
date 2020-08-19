#Region Service
Procedure SetupExtentionInCurrentArea(Ref, OverWrite = True) Export	
	ExtensionData = Ref.FileData.Get();
	ExtensionServer.InstallExtention(Ref.Description, ExtensionData, OverWrite);
EndProcedure
#EndRegion