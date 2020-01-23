Procedure InstallPrinterComponent() Export
	NotifyDescription = New NotifyDescription("InstallAddInAfter", ThisObject);
	BeginInstallAddIn(NotifyDescription, "CommonTemplate.DriverIKSoftWarePOSHP");
EndProcedure

Procedure InstallAddInAfter(AdditionalParameters) Export
	 Return;
EndProcedure

Procedure OpenDraw() Export
	NotifyDescription = New NotifyDescription("AttachingAddInAfter", ThisObject, , "ErrorNotify", ThisObject);
	BeginAttachingAddIn(NotifyDescription, "CommonTemplate.DriverIKSoftWarePOSHP", "NonfiscalPrinter");
EndProcedure

Procedure ErrorNotify(Param1, Param2, Param3) Export
	Return;
EndProcedure

Procedure AttachingAddInAfter(Result, AdditionalParameters) Export
	Return;
EndProcedure

