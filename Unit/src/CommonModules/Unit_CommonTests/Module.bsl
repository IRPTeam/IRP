// @strict-types

#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CommonFunctionsServer_GetAttributesFromRef");	
	Return TestList;
EndFunction

#EndRegion

#Region Test

Function CommonFunctionsServer_GetAttributesFromRef() Export
	ArrayOfErrors = New Array();
	
	EmptyRef = Catalogs.Items.EmptyRef();
	
	Result = CommonFunctionsServer.GetAttributesFromRef(EmptyRef, "Code, Ref.Code, Ref.Ref.Ref, Ref.Ref.Code");
	
	If Not TypeOf(Result) = Type("Structure") Then
		ArrayOfErrors.Add("Unknown response type");
	Else
		If Not Result.Property("Code") Then
			ArrayOfErrors.Add("Property ""Code"" not found");
		ElsIf Not Result["Code"] = Undefined Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;
		
		If Not Result.Property("Ref") Then
			ArrayOfErrors.Add("Property ""Ref"" not found");
		ElsIf Not TypeOf(Result["Ref"]) = Type("Structure") Then
			ArrayOfErrors.Add("Property ""Ref"" has an unknown type");
		Else
			If Not Result["Ref"].Property("Ref") Then
				ArrayOfErrors.Add("Property ""Ref.Ref"" not found");
			ElsIf Not TypeOf(Result["Ref"]["Ref"]) = Type("Structure") Then
				ArrayOfErrors.Add("Property ""Ref.Ref"" has an unknown type");
			Else
				If Not Result["Ref"]["Ref"].Property("Code") Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Code"" not found");
				ElsIf Not Result["Ref"]["Ref"]["Code"] = Undefined Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Code"" has an invalid value");
				EndIf;
				If Not Result["Ref"]["Ref"].Property("Ref") Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Ref"" not found");
				ElsIf Not Result["Ref"]["Ref"]["Ref"] = Undefined Then
					ArrayOfErrors.Add("Property ""Ref.Ref.Ref"" has an invalid value");
				EndIf;
			EndIf;
		EndIf;
	EndIf;
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - String" + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	
	Attributes = New Array;
	Attributes.Add("Ref");
	Attributes.Add("Code");
	
	Result = CommonFunctionsServer.GetAttributesFromRef(EmptyRef, Attributes);
	
	If Not TypeOf(Result) = Type("Structure") Then
		ArrayOfErrors.Add("Unknown response type");
	Else
		If Not Result.Property("Code") Then
			ArrayOfErrors.Add("Property ""Code"" not found");
		ElsIf Not Result["Code"] = Undefined Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;
		If Not Result.Property("Ref") Then
			ArrayOfErrors.Add("Property ""Ref"" not found");
		ElsIf Not Result["Ref"] = Undefined Then
			ArrayOfErrors.Add("Property ""Ref"" has an invalid value");
		EndIf;
	EndIf;
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - Array" + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	
	Selection = Catalogs.Items.Select();
	If Selection.Next() Then
		Result = CommonFunctionsServer.GetAttributesFromRef(Selection.Ref, Attributes);
		
		If Not Selection.Ref = Result["Ref"] Then
			ArrayOfErrors.Add("Property ""Ref"" has an invalid value");
		EndIf;
		If Not Selection.Code = Result["Code"] Then
			ArrayOfErrors.Add("Property ""Code"" has an invalid value");
		EndIf;
		
		If ArrayOfErrors.Count() Then
			Unit_Service.assertFalse("Errors in : CommonFunctionsServer.GetAttributesFromRef() - Exist Ref" + Chars.LF +
				StrConcat(ArrayOfErrors, Chars.LF));
		EndIf;
	EndIf;
	
	Return Undefined;
EndFunction

#EndRegion
