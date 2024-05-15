
&AtServer
Procedure Unit_OnCreateAtServerAfter(Cancel, StandardProcessing)
	AddFormAttributes();
EndProcedure

Procedure AddFormAttributes()
	
	NewItem = ThisObject.Items.Add("ShowTechnicalColumns", Тип("FormField"), ThisObject.Items.GroupFilters);
	NewItem.Type			= FormFieldType.CheckBoxField;
	NewItem.DataPath		= "ShowTechnicalColumns";
	Newitem.CheckBoxType	= CheckBoxType.Switch;
	NewItem.TitleLocation	= FormItemTitleLocation.Right;
	
EndProcedure

