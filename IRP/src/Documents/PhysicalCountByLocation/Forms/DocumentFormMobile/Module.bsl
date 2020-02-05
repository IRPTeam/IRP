&AtClient
Procedure BarcodeOnChange(Item)
	DocPhysicalCountByLocationClient.BarcodeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SearchItemKeyByBarcode(Command)
	DocPhysicalCountByLocationClient.SearchItemKeyByBarcode(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command)
	DocPhysicalCountByLocationClient.SearchByBarcode(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPhysicalCountByLocationClient.ItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemEditTextChange(Item, Text, StandardProcessing)
	DocPhysicalCountByLocationClient.ItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemOnChange(Item)
	DocPhysicalCountByLocationClient.ItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocPhysicalCountByLocationClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure


&AtClient
Procedure ItemKeyOnChange(Item)
	DocPhysicalCountByLocationClient.ItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPhysicalCountByLocationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure BarcodeStartChoice(Item, ChoiceData, StandardProcessing)
	DocPhysicalCountByLocationClient.BarcodeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

