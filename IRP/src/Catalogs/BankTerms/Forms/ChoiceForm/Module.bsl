&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	If Parameters.Property("Filter") 
		And Parameters.Filter.Property("PaymentType")
		And Parameters.Filter.Property("Branch") Then
		ThisObject.FilterPaymentType = Parameters.Filter.PaymentType;
		ThisObject.FilterBranch = Parameters.Filter.Branch;
		UpdateFilters();
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "BankTermWrite" Then
		UpdateFilters();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateFilters()
	If Not ValueIsFilled(ThisObject.FilterPaymentType)
		Or Not ValueIsFilled(ThisObject.FilterBranch)  Then
		Return;
	EndIf;
	
	ArrayOfRefs = ModelServer_V2.GetBankTermsByPaymentType(ThisObject.FilterPaymentType, ThisObject.FilterBranch);
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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion