
&AtClient
Procedure ShowDocument(Command)
	Items.Document.Visible = Not Items.Document.Visible;
	Items.CancelDocument.Visible = Not Items.CancelDocument.Visible;
EndProcedure
