Function ObjectHasAttribute(AttributeName, Object) Export
	If Object = Undefined Then
		Return False;
	EndIf;
	ValueKey = New UUID();
	Str = New Structure(AttributeName, ValueKey);
	FillPropertyValues(Str, Object);
	Return Str[AttributeName] <> ValueKey;
EndFunction