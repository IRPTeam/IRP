
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each CompanyLadgerType In Parameters.ArrayOfLadgerTypes Do
		ThisObject.Items.LadgerType.ChoiceList.Add(CompanyLadgerType, String(CompanyLadgerType));
	EndDo;
	If Parameters.ArrayOfLadgerTypes.Count() Then
		ThisObject.LadgerType = Parameters.ArrayOfLadgerTypes[0];
	EndIf;
EndProcedure
