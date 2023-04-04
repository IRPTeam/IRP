
&AtClient
Procedure BarcodeOnChange(Item)
	If Not Multiline Then
		Done();
	EndIf;
EndProcedure

&AtClient
Procedure OK(Command)
	Done();
EndProcedure

&AtClient
Procedure Done()
	If Delimiter = "" Then
		Delimiter = Chars.LF;
	EndIf;
	BarcodesStr = StrReplace(Barcode, Delimiter, "`");
	Barcodes = StrSplit(BarcodesStr, "`", False);
	Close(Barcodes);
EndProcedure

&AtClient
Procedure MultilineOnChange(Item)
	Items.Delimiter.Visible = Multiline;
	Items.Barcode.MultiLine = Multiline;
EndProcedure

