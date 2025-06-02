
Procedure UpdatePredefinedNames(PredefinedDataName) Export

	SystemAttribute = ChartsOfCharacteristicTypes.SystemAttributes[PredefinedDataName].GetObject();
	
	NeedSave = False;
	For Each Lang In LocalizationReuse.AllDescription() Do
		PredefinedName = R(StrSplit(Lang, "_")[1])["SystemAttribute_"+PredefinedDataName];
 		If SystemAttribute[Lang] <> PredefinedName Then
 			SystemAttribute[Lang] = PredefinedName;
 			NeedSave = True;
 		EndIf;
	EndDo;
	
	If NeedSave Then
		SystemAttribute.Write();
	EndIf;
	
EndProcedure