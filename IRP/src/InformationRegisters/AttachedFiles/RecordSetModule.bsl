
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	// Change, Add
	For Each Record In ThisObject Do
		If Documents.AllRefsType().ContainsType(TypeOf(Record.Owner)) Then
			If AuditLockPrivileged.DocumentIsLocked(Record.Owner) Then
				Cancel = True;
			EndIf;
		EndIf;
	EndDo;
	
	// Delete
	If Not Cancel Then
		If Documents.AllRefsType().ContainsType(TypeOf(ThisObject.Filter.Owner.Value)) Then
			If AuditLockPrivileged.DocumentIsLocked(ThisObject.Filter.Owner.Value) Then
				Cancel = True;
			EndIf;
		EndIf;
	EndIf;
EndProcedure
