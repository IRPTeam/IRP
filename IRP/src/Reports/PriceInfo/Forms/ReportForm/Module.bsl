&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not Parameters.Property("PriceOwner", Report.PriceOwner) Then
		Cancel = True;
	EndIf;

	Parameters.Property("PricePeriod", Report.PricePeriod);
	If Not ValueIsFilled(Report.PricePeriod) Then
		Report.PricePeriod = CurrentDate();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ComposeResult();
	Items.Result.StatePresentation.Visible = False;
EndProcedure

&AtClient
Procedure ResultSelection(Item, Area, StandardProcessing)
	StandardProcessing = False;
EndProcedure