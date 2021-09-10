#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export

	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);

	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);

	Form.DataPeriod.StartDate = Object.BegOfPeriod;
	Form.DataPeriod.EndDate = Object.EndOfPeriod;
EndProcedure

#EndRegion

#Region ItemFormEvents

Procedure DataPeriodOnChange(Object, Period, AddInfo = Undefined) Export

	Object.BegOfPeriod = Period.StartDate;
	Object.EndOfPeriod = Period.EndDate;

EndProcedure

Procedure StatusOnChange(Object, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure BranchOnChange(Object, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure CompanyOnChange(Object, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure DateOnChange(Object, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure NumberOnChange(Object, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

#Region FinancialMovementType

Procedure PaymentListFinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListFinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion