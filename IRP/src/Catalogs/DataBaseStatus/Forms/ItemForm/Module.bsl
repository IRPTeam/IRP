&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	Items.SelectedStyle.ChoiceList.Add("Auto");
	For Each StyleRow In Metadata.Styles Do
		Items.SelectedStyle.ChoiceList.Add(StyleRow.Name);
	EndDo;
EndProcedure