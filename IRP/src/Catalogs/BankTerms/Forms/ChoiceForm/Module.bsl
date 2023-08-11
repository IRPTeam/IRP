&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
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
