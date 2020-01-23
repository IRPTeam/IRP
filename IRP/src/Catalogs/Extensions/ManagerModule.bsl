
Procedure SetupExtentionInCurrentArea(Ref, OverWrite = True) Export	
	ExtensionData = Ref.FileData.Get();
	If ExtensionData = Undefined Then
		Return;
	EndIf;
	
	ArrayExt = ConfigurationExtensions.Get(New Structure("Name", Ref.Description));
	If ArrayExt.Count() Then
		If Not OverWrite Then
			Return;
		EndIf;
		Ext = ArrayExt[0];
	Else
		Ext = ConfigurationExtensions.Create();
	EndIf;

	Ext.Active = True;
	Ext.SafeMode = False;
	Ext.Write(ExtensionData);
EndProcedure