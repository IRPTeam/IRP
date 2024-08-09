
&AtServer
Procedure OnReadAtServer(CurrentObject)
	If ValueIsFilled(Record.SourceLedgerType) Then
		ThisObject.SourceLedgerTypeVariant = Record.SourceLedgerType.LedgerTypeVariant;
	EndIf;

	If ValueIsFilled(Record.TargetLedgerType) Then
		ThisObject.TargetLedgerTypeVariant = Record.TargetLedgerType.LedgerTypeVariant;
	EndIf;

	SetVisible();
EndProcedure

&AtClient
Procedure SourceAccountOnChange(Item)
	SourceAccountOnChangeAtServer();
EndProcedure

&AtServer
Procedure SourceAccountOnChangeAtServer()
	If Not ValueIsFilled(Record.SourceAccount) Then
		Record.ExtDimensionType1 = Undefined;
		Record.ExtDimensionType2 = Undefined;
		Record.ExtDimensionType3 = Undefined;
		
		Record.ExtDimensionValue1 = Undefined;
		Record.ExtDimensionValue2 = Undefined;
		Record.ExtDimensionValue3 = Undefined;
		
		Record.AllExtDimensionValues1 = False;
		Record.AllExtDimensionValues2 = False;
		Record.AllExtDimensionValues3 = False;
		
		SetVisible();
		Return;
	EndIf;
	
	For i = 0 To 2 Do
		If Record.SourceAccount.ExtDimensionTypes.Count() > i Then
			Record["ExtDimensionType" +  String(i + 1)] = Record.SourceAccount.ExtDimensionTypes[i].ExtDimensionType;
		Else
			Record["ExtDimensionType" +  String(i + 1)] = Undefined;
		EndIf;
	EndDo;
	SetVisible();
EndProcedure

&AtClient
Procedure SourceLedgerTypeOnChange(Item)
	SourceLedgerTypeOnChangeAtServer();
EndProcedure

&AtServer
Procedure SourceLedgerTypeOnChangeAtServer()
	If ValueIsFilled(Record.SourceLedgerType) Then
		ThisObject.SourceLedgerTypeVariant = Record.SourceLedgerType.LedgerTypeVariant;
		If Record.SourceAccount.LedgerTypeVariant <> ThisObject.SourceLedgerTypeVariant Then
			Record.SourceAccount = Undefined;
		EndIf;
	Else
		ThisObject.SourceLedgerTypeVariant = Undefined;
		Record.SourceAccount = Undefined;
	EndIf;
	SourceAccountOnChangeAtServer();
EndProcedure

&AtClient
Procedure TargetLedgerTypeOnChange(Item)
	TargetLedgerTypeOnChangeAtServer();
EndProcedure

&AtServer
Procedure TargetLedgerTypeOnChangeAtServer()
	If ValueIsFilled(Record.TargetLedgerType) Then
		ThisObject.TargetLedgerTypeVariant = Record.TargetLedgerType.LedgerTypeVariant;
		If Record.TargetAccount.LedgerTypeVariant <> ThisObject.TargetLedgerTypeVariant Then
			Record.TargetAccount = Undefined;
		EndIf;
		
	Else
		ThisObject.TargetLedgerTypeVariant = Undefined;
		Record.TargetAccount = Undefined;
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure AllExtDimensionValues1OnChange(Item)
	Record.ExtDimensionValue1 = Undefined;
	SetVisible();
EndProcedure

&AtClient
Procedure AllExtDimensionValues2OnChange(Item)
	Record.ExtDimensionValue2 = Undefined;
	SetVisible();
EndProcedure

&AtClient
Procedure AllExtDimensionValues3OnChange(Item)
	Record.ExtDimensionValue3 = Undefined;
	SetVisible();
EndProcedure

&AtServer
Procedure SetVisible()
	Items.ExtDimensionValue1.ReadOnly = Record.AllExtDimensionValues1 Or Not ValueIsFilled(Record.ExtDimensionType1);
	Items.ExtDimensionValue2.ReadOnly = Record.AllExtDimensionValues2 Or Not ValueIsFilled(Record.ExtDimensionType2);
	Items.ExtDimensionValue3.ReadOnly = Record.AllExtDimensionValues3 Or Not ValueIsFilled(Record.ExtDimensionType3);
EndProcedure

