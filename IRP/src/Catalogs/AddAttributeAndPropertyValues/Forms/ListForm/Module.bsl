&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	FormParameters = New Structure();
	FormParameters.Insert("AllowOwnerEdit", True);
	OwnerValue = PredefinedValue("ChartOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef");
	For Each Filter In List.Filter.Items Do
		isSetConditionByOwner = TypeOf(Filter) = Type("DataCompositionFilterItem") And Filter.LeftValue
			= New DataCompositionField("Owner") And Filter.Use And Filter.ComparisonType
			= DataCompositionComparisonType.Equal And ValueIsFilled(Filter.RightValue);

		If isSetConditionByOwner Then
			OwnerValue = Filter.RightValue;
			FormParameters.Insert("AllowOwnerEdit", False);
		EndIf;
	EndDo;
	OpenedForm = OpenForm("Catalog.AddAttributeAndPropertyValues.ObjectForm", FormParameters, Item, UUID);
	If ValueIsFilled(OwnerValue) Then
		OpenedFormObject = OpenedForm.Object;
		OpenedFormObject.Owner = OwnerValue;
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeRowChange(Item, Cancel)
	Cancel = True;
	FormParameters = New Structure();
	FormParameters.Insert("AllowOwnerEdit", True);
	FormParameters.Insert("Key", Items.List.CurrentRow);
	OpenForm("Catalog.AddAttributeAndPropertyValues.ObjectForm", FormParameters, Item, UUID);
EndProcedure