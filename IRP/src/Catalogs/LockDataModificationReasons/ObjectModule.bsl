Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	LockDataModificationPrivileged.SaveRuleSettings(ThisObject);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	isInitDCS = False;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DisableRule Then
		Return;
	EndIf;

	If Not ForAllUsers Then
		If Not UserList.Count() And Not AccessGroupList.Count() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_067);
			Cancel = True;
		EndIf;
	EndIf;
	If SetOneRuleForAllObjects And Not AdvancedMode Then
		If IsBlankString(Attribute) Then
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, ThisObject.Metadata().Attributes.Attribute.Synonym), "Object.Attribute");
			Cancel = True;
		EndIf;
		If IsBlankString(ComparisonType) Then
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, ThisObject.Metadata().Attributes.ComparisonType.Synonym),
				"Object.ComparisonType");
			Cancel = True;
		EndIf;
		If SetValueAsCode And IsBlankString(Value) Then
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, ThisObject.Metadata().Attributes.Value.Synonym), "Object.Value");
			Cancel = True;
		EndIf;
	ElsIf Not AdvancedMode Then
		For Index = 0 To RuleList.Count() - 1 Do
			If IsBlankString(RuleList[Index].Attribute) Then
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_010,
					ThisObject.Metadata().TabularSections.RuleList.Attributes.Attribute.Synonym), "Object.RuleList["
					+ Format(Index, "NG=") + "].Attribute");
				Cancel = True;
			EndIf;
			If IsBlankString(RuleList[Index].ComparisonType) Then
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_010,
					ThisObject.Metadata().TabularSections.RuleList.Attributes.ComparisonType.Synonym),
					"Object.RuleList[" + Format(Index, "NG=") + "].ComparisonType");
				Cancel = True;
			EndIf;
			If RuleList[Index].SetValueAsCode And IsBlankString(RuleList[Index].Value) Then
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_010, ThisObject.Metadata().TabularSections.RuleList.Attributes.Value.Synonym),
					"Object.RuleList[" + Format(Index, "NG=") + "].Value");
				Cancel = True;
			EndIf;
		EndDo;
	EndIf;
	For Index = 0 To RuleList.Count() - 1 Do
		If IsBlankString(RuleList[Index].Type) Then
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010,
				ThisObject.Metadata().TabularSections.RuleList.Attributes.Attribute.Synonym), "Object.RuleList["
				+ Format(Index, "NG=") + "].Type");
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure