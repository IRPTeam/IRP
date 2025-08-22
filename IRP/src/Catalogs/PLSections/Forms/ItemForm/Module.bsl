
&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;	
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountsAccountOnChange(Item)
	CurrentData = Items.Accounts.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.ExtDimensionNumber = GetExtDimensionNumber(CurrentData.Account);
EndProcedure

&AtServer
Function GetExtDimensionNumber(Account)
	ExtDimNumber = 1;
	For Each ExtDimension In Account.ExtDimensionTypes Do
		If ExtDimension.ExtDimensionType.ValueType.Types()
			.Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
				Return ExtDimNumber;
		EndIf;
		ExtDimNumber = ExtDimNumber + 1;
	EndDo;
EndFunction	

&AtClient
Procedure SectionTypeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
	If Object.SectionType = PredefinedValue("Enum.PLSectionTypes.Calculation") Then
		Object.Accounts.Clear();
	Else
		Object.Expression = "";
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsDataSelectionType = (Object.SectionType = PredefinedValue("Enum.PLSectionTypes.DataSelection"));
	Form.Items.PageDataFilter.Visible = IsDataSelectionType;
	Form.Items.PageExpression.Visible = Not IsDataSelectionType;
EndProcedure
