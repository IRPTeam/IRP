&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each Row In Parameters.ArrayOfCountry Do
		NewRow = ThisObject.CountryTable.Add();
		NewRow.Country = Row.Country;
		NewRow.ExternalDataProc = Row.ExternalDataProc;
		NewRow.Settings = Row.Settings;
	EndDo;
EndProcedure

&AtClient
Procedure CountryTableSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	Result = New Structure();
	Result.Insert("Country", Item.CurrentData.Country);
	Result.Insert("ExternalDataProc", Item.CurrentData.ExternalDataProc);
	Result.Insert("Settings", Item.CurrentData.Settings);
	ThisObject.Close(Result);
EndProcedure