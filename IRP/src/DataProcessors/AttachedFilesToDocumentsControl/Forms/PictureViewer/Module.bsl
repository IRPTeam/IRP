// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Parameters.Property("FileRef", FileRef);
	Parameters.Property("Title", ThisObject.Title);
	Parameters.Property("Description", Items.DecorationDesctiprion.Title);
	Parameters.Property("IsPdf", IsPDF);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	Items.Picture.Visible = Not IsPDF;
	Items.PDFViewer.Visible = IsPDF;
	
	If IsPDF Then
		ShowPDF();
	Else
		ShowPicture();
	EndIf;
EndProcedure

&AtServer
Function CreatePictureParameters(FileRef)
	Return PictureViewerServer.CreatePictureParameters(FileRef);
EndFunction

&AtClient
Procedure ShowPDF()
	PictureViewerClient.SetPDFForView(FileRef, PDFViewer);
EndProcedure

&AtClient
Procedure ShowPicture()
	If Not FileRef.IsEmpty() Then
		PictureParameters = CreatePictureParameters(FileRef);
		ThisObject.PictureViewHTML = "<html><img src=""" + PictureViewerClient.GetPictureURL(PictureParameters) + """ height=""100%""></html>";
	Else
		Items.Picture.Visible = False;
		Items.DecorationNoTemplate.Visible = True;
	EndIf;	
EndProcedure



