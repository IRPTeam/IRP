
Function LinkedRowsIntegrityIsEnable() Export
	Return Not Constants.DisableLinkedRowsIntegrity.Get();
EndFunction

Function GetUseRowIDRegister() Export
	Return Constants.UseRowIDRegister.Get();
EndFunction