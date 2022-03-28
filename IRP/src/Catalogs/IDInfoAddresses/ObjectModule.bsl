Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	ArrayOfDescriptions = New Array();
	FullDescr_en(ThisObject.Ref, ArrayOfDescriptions);
	ArrayOfDescriptionsReverse = New Array();
	Count = ArrayOfDescriptions.Count() - 1;
	For i = 0 To Count Do
		ArrayOfDescriptionsReverse.Add(ArrayOfDescriptions[Count - i]);
	EndDo;
	ThisObject.FullDescription = StrConcat(ArrayOfDescriptionsReverse, ", ");
EndProcedure

Procedure FullDescr_en(_Ref, ArrayOfDescriptions)
	ArrayOfDescriptions.Add(_Ref.Description_en);
	If ValueIsFilled(_Ref.Parent) Then
		FullDescr_en(_Ref.Parent, ArrayOfDescriptions);
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure