Procedure Filling(FillingData, FillingText, StandardProcessing)
	If Not ThisObject.IsFolder Then
		ThisObject.Type = Enums.SpecialOfferTypes.ForDocument;
	EndIf;
EndProcedure