
// Is PDF.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
// 
// Returns:
//  Boolean - Is PDF
Function IsPDF(FileRef) Export
	
	Extension = CommonFunctionsServer.GetRefAttribute(FileRef, "Extension"); // String
	Return Not StrCompare(Extension, "pdf");
	
EndFunction

// Set data in PDFViewer.
// 
// Parameters:
//  PDFViewer - PDFDocument - PDFViewer
//  Data - BinaryData - Data
//  IsAsync - Boolean - Is async
Procedure SetDataInPDFViewer(PDFViewer, Data, IsAsync = False) Export
	
	Try
		Buffer = GetBinaryDataBufferFromBinaryData(Data);
		Stream = New MemoryStream(Buffer);
		If IsAsync Then 
			PDFViewer.ReadAsync(Stream);
		Else
			PDFViewer.Read(Stream);
		EndIf;
	Except
		Raise R().Error_ReadingPDF + Chars.CR + ErrorDescription();
	EndTry;
	
EndProcedure

// Read data from PDFViewer.
// 
// Parameters:
//  PDFViewer - PDFDocument - PDFViewer
///  IsAsync - Boolean - Is async
// 
// Returns:
//  Undefined, BinaryData - Read data from PDFViewer
Function ReadDataFromPDFViewer(PDFViewer, IsAsync = False) Export
	
	Try
		If PDFViewer.PageCount() = 0 Then
			Return Undefined;
		EndIf;
		
		MemoryStream = New MemoryStream();
		
		If IsAsync Then
			PDFViewer.WriteAsync(MemoryStream);
		Else
			PDFViewer.Write(MemoryStream);
		EndIf;
		
		Data = MemoryStream.CloseAndGetBinaryData();
	Except
		// document not set
		Return Undefined;
	EndTry;
	
	Return Data;
	
EndFunction

// Create PDF from HTML.
// 
// Parameters:
//  HTML - String - HTML
// 
// Returns:
//  Structure - Create PDFFrom HTML:
// * BinaryData - BinaryData, Undefined - PDF from HTML 
// * Error - String - error text
Function CreatePDFFromHTML(HTML) Export
	
	Result = New Structure("BinaryData, Error", Undefined, "");
	
	PathToChromium = GetPathToChromium();
	If IsBlankString(PathToChromium) Then
		Result.Error =  R().Error_ChromiumNotFound;
		Return Result;
	EndIf;
	
	PDFtmp = GetTempFileName(".pdf");
	HTMLtmp = GetTempFileName(".html");
	
	TextFile = New TextWriter(HTMLtmp);
	TextFile.Write(HTML);
	TextFile.Close();
	
	PathToChromium = """" + PathToChromium + """";
	Args = " --headless --disable-gpu --run-all-compositor-stages-before-draw --no-sandbox --print-to-pdf=" + PDFtmp + " " + HTMLtmp;
	
	Try
		RunApp(PathToChromium + Args, , True);
		Result.BinaryData = New BinaryData(PDFtmp);
	Except 
		Result.Error = R().Error_CreatingPDF + Chars.LF + ErrorProcessing.DetailErrorDescription(ErrorInfo());
	EndTry;

	DeleteFiles(HTMLtmp);
	DeleteFiles(PDFtmp);
	
	Return Result;

EndFunction

// Get path to chromium.
// 
// Returns:
//  String - Get path to chromium
Function GetPathToChromium()
	// On the server side, the path can be set as Constant, 
	// but on the client side, the paths may differ.
	// Let's try to find it by enumeration.
	
	PossiblePaths = New Array; // Array of String
	PossiblePaths.Add("C:\Program Files\Google\Chrome\Application\chrome.exe");
	PossiblePaths.Add("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe");
	PossiblePaths.Add("C:\Program Files\Chromium\Application\chrome.exe");
	PossiblePaths.Add("C:\Program Files (x86)\Chromium\Application\chrome.exe");
	PossiblePaths.Add("C:\Chromium\Application\chrome.exe");
	
	For Each Path In PossiblePaths Do
		PathFile = New File(Path);
		If PathFile.Exists() Then
			Return Path;
		EndIf;
	EndDo;
	
	Return "";
EndFunction