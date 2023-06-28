
#Region LockLinkedRows

Function LinkedRowsIntegrityIsEnable() Export
	Return Not Constants.DisableLinkedRowsIntegrity.Get();
EndFunction

#EndRegion
