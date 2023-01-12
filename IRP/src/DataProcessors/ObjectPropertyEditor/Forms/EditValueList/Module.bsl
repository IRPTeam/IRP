
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	List = Parameters.List;
	List.ValueType = Parameters.ItemType;
EndProcedure

&AtClient
Procedure OK(Command)
	Close(List);
EndProcedure
