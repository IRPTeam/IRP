
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each CompanyLadgerType In Parameters.ArrayOfLadgerTypes Do
		ThisObject.Items.LadgerType.ChoiceList.Add(CompanyLadgerType, String(CompanyLadgerType));
	EndDo;
	
//	If ValueIsFilled(Record.ItemKey) Then
//		ThisObject.RecordType = "ItemKey";
//	ElsIf ValueIsFilled(Record.Item) Then

EndProcedure
