
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data["Description_" + LocalizationReuse.UserLanguageCode()]);
EndProcedure

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields = Fields = New Array();
	For Each DescriptionName In LocalizationServer.AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
EndProcedure
