
Procedure OpenPickupItems(Object, Form, ClientModule, AddInfo = Undefined) Export
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Object", Object);
	NotifyDescription = New NotifyDescription("OpenPickupItemsEnd", ClientModule, NotifyParameters);
	OpenFormParameters = AddInfo;	
	#If MobileClient Then
	
	#Else
	FormName = "CommonForm.PickUpItems";
	#EndIf
	OpenForm(FormName, OpenFormParameters, Form, , , , NotifyDescription);
EndProcedure