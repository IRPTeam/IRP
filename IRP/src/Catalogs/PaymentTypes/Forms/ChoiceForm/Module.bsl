&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	If Parameters.Property("Filter") And Parameters.Filter.Property("BankTerm") Then
		ThisObject.FilterBankTerm = Parameters.Filter.BankTerm;
		UpdateFilters();
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Or Not ValueIsFilled(ThisObject.FilterBankTerm) Then
		Return;
	EndIf;
	Cancel = True;
	OpeningParameters = New Structure();
	FillingValues = GetFillingValues();
	If FillingValues <> Undefined Then
		OpeningParameters.Insert("FillingValues", FillingValues);
	EndIf;
	OpenForm("Catalog.PaymentTypes.ObjectForm", OpeningParameters, ThisObject, ThisObject.UUID);
EndProcedure

&AtServer
Function GetFillingValues()
	FillingValues = New Structure("Type");
	If Not ValueIsFilled(ThisObject.FilterBankTerm) Then
		FillingValues.Type = Enums.PaymentTypes.Cash;
	ElsIf ThisObject.FilterBankTerm.BankTermType = Enums.BankTermTypes.PaymentTerminal Then
		FillingValues.Type = Enums.PaymentTypes.Card;
	ElsIf ThisObject.FilterBankTerm.BankTermType = Enums.BankTermTypes.PaymentAgent Then
		FillingValues.Type = Enums.PaymentTypes.PaymentAgent;
	Else
		Return Undefined;
	EndIf;
	Return FillingValues;
EndFunction

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "PaymetTypesWrite" Then
		UpdateFilters();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateFilters()
	If Not ValueIsFilled(ThisObject.FilterBankTerm) Then
		Return;
	EndIf;
	ArrayOfRefs = ModelServer_V2.GetPaymentTypesByBankTerm(ThisObject.FilterBankTerm);
	ListOfRefs = New ValueList();
	ListOfRefs.LoadValues(ArrayOfRefs);
	
	ArrayForDelete = New Array();
	FieldRef = New DataCompositionField("Ref");
	For Each Filter In ThisObject.List.Filter.Items Do
		If Filter.LeftValue = FieldRef Then
			ArrayForDelete.Add(Filter);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.List.Filter.Items.Delete(ItemForDelete);
	EndDo;
	
	FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = New DataCompositionField("Ref");
	FilterItem.RightValue = ListOfRefs;
	FilterItem.ComparisonType = DataCompositionComparisonType.InList;	
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion