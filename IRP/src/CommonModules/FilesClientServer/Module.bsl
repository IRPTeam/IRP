// @strict-types

#Region WorkWithFileInfo

// File info.
// 
// Returns:
//  Structure - File info:
// * Success - Boolean - 
// * MD5 - String - 
// * FileID - String - 
// * Ref - CatalogRef.Files - 
// * URI - String - 
// * FileName - String - 
// * Extension - String - 
// * PrintFormName - ChartOfCharacteristicTypesRef.AddAttributeAndProperty - 
// * Height - Number - 
// * Width - Number - 
// * Size - Number - 
// * Volume - CatalogRef.FileStorageVolumes - 
// * IntegrationSettings - CatalogRef.IntegrationSettings - 
// * Preview - Undefined, ValueStorage - 
// * BinaryBody - Undefined, BinaryData - 
Function GetFileInfo() Export
	
	FileInfo = New Structure();
	
	FileInfo.Insert("Success", False);
	
	FileInfo.Insert("MD5", "");
	FileInfo.Insert("FileID", "");
	FileInfo.Insert("Ref", PredefinedValue("Catalog.Files.EmptyRef"));
	
	FileInfo.Insert("URI", "");
	FileInfo.Insert("FileName", "");
	FileInfo.Insert("Extension", "");
	FileInfo.Insert("PrintFormName", PredefinedValue("ChartOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef"));
	
	FileInfo.Insert("Height", 0);
	FileInfo.Insert("Width", 0);
	FileInfo.Insert("Size", 0);
	
	FileInfo.Insert("Volume", PredefinedValue("Catalog.FileStorageVolumes.EmptyRef"));
	FileInfo.Insert("IntegrationSettings", PredefinedValue("Catalog.IntegrationSettings.EmptyRef"));	
	
	FileInfo.Insert("Preview", Undefined);
	FileInfo.Insert("BinaryBody", Undefined);
	
	Return FileInfo;
	
EndFunction

// Set file info.
// 
// Parameters:
//  FileInfo - See GetFileInfo
//  Object - CatalogObject.Files - Object
Procedure SetFileInfo(FileInfo, Object) Export
	Object.Description = FileInfo.FileName;
	Object.Volume = FileInfo.Volume;
	Object.URI = FileInfo.URI;
	Object.FileID = FileInfo.FileID;
	Object.Height = FileInfo.Height;
	Object.Width = FileInfo.Width;
	Object.SizeBytes = FileInfo.Size;
	Object.Extension = FileInfo.Extension;
	Object.MD5 = FileInfo.MD5;
	Object.PrintFormName = FileInfo.PrintFormName;
	
	#IF NOT Client THEN
	
	If TypeOf(FileInfo.Preview) = Type("ValueStorage") Then
		Object.Preview = FileInfo.Preview;
		Object.isPreviewSet = (Object.Preview.Get() <> Undefined);
	ElsIf TypeOf(FileInfo.Preview) = Type("BinaryData") Then
		Object.Preview = New ValueStorage(FileInfo.Preview);
		Object.isPreviewSet = True;
	Else
		Object.Preview = Undefined;
		Object.isPreviewSet = False;
	EndIf;
	
	#ENDIF
	
EndProcedure

// Get StoredFileDescription wrapper
// 
// Parameters:
//  PathToFile - String - Path to file
// 
// Returns:
//  Structure - Get stored file description wrapper:
// * PathToFile - String - 
// * Size - Number - 
// * Address - String - 
// * PutFileCanceled - Boolean - 
// * FileRef - Structure - :
// ** FileID - UUID - 
// ** Name - String - 
// ** Extension - String - 
// ** File  - Structure - :
// *** Name - String -
// *** BaseName - String -
// *** Extension - String -
// *** FullName - String -
// *** Path - String -
Function GetStoredFileDescriptionWrapper(PathToFile) Export
	
	FileInfo = New File(PathToFile);
	
	FileDescription = New Structure;
	FileDescription.Insert("Name", FileInfo.Name);
	FileDescription.Insert("BaseName", FileInfo.BaseName);
	FileDescription.Insert("Extension", FileInfo.Extension);
	FileDescription.Insert("FullName", FileInfo.FullName);
	FileDescription.Insert("Path", FileInfo.Path);
	
	FileRef = New Structure();
	FileRef.Insert("FileID", New UUID("00000000-0000-0000-0000-000000000000"));
	FileRef.Insert("Name", FileInfo.Name);
	FileRef.Insert("Extension", FileInfo.Extension);
	FileRef.Insert("File", FileDescription);
	
	Result = New Structure();
	Result.Insert("Address", "");
	Result.Insert("PutFileCanceled", False);
	Result.Insert("FileRef", FileRef);
	
	Result.Insert("PathToFile", PathToFile);
	Result.Insert("Size", FileInfo.Size());
	
	Return Result;
	
EndFunction

#EndRegion

#Region WorkWithFileInWEB

// Get link for file in WEB.
// 
// Parameters:
//  URI - String - File URI
//  ConnectionSettings - See IntegrationServer.ConnectionSettingTemplate
// 
// Returns:
//  String - Get link for file in WEB
Function GetFullLinkForFileInWEB(URI, ConnectionSettings) Export
	
	Result = "";
	
	If ConnectionSettings.Property("SecureConnection") And ConnectionSettings.SecureConnection = True Then
		Result = "https://";
	Else
		Result = "http://";
	EndIf;

	If ConnectionSettings.Property("User") And Not IsBlankString(ConnectionSettings.User) Then
		LinkLogin = ConnectionSettings.User;
		If ConnectionSettings.Property("Password") And Not IsBlankString(ConnectionSettings.Password) Then
			LinkLogin = LinkLogin + ":" + ConnectionSettings.Password;
		EndIf;
		Result = Result + LinkLogin + "@";
	EndIf;

	If ConnectionSettings.Property("Ip") And Not IsBlankString(ConnectionSettings.Ip) Then
		Result = Result + String(ConnectionSettings.Ip);
	Else
		Result = Result + "127.0.0.1";
	EndIf;

	If ConnectionSettings.Property("Port") Then
		Result = Result + ":" + Format(ConnectionSettings.Port, "NDS=; NG=;");
	EndIf;

	If ConnectionSettings.Property("ResourceAddress") And Not IsBlankString(ConnectionSettings.ResourceAddress) Then
		ArrayOfSegments = StrSplit(ConnectionSettings.ResourceAddress, "/");
		ArrayOfNewSegments = New Array(); // Array of String
		For Each Segment In ArrayOfSegments Do
			If StrStartsWith(Segment, "{") And StrEndsWith(Segment, "}") Then
				Continue;
			EndIf;
			If ValueIsFilled(Segment) Then
				ArrayOfNewSegments.Add(Segment);
			EndIf;
		EndDo;
		Result = Result + "/" + StrConcat(ArrayOfNewSegments, "/");
	EndIf;
	
	Result = Result + "/" + URI;
	
	Return Result;
	
EndFunction

// Get file body from WEB.
// 
// Parameters:
//  FileURL - String - File URL
// 
// Returns:
//  Undefined, BinaryData - Get file body from WEB
Function GetBinaryDataFromFileInWEB(FileURL) Export

	OpenSSLSecureConnection = Undefined;
	PortHTTP = 80;
	If StrFind(Lower(FileURL), "https://") > 0 Then
		OpenSSLSecureConnection = New OpenSSLSecureConnection();
		PortHTTP = 443;
	EndIf;
	
	IpPart = FileURL;
	If StrFind(IpPart, "://") > 0 Then
		IpPart = Mid(IpPart, StrFind(IpPart, "://") + 3);
	EndIf;
	If StrFind(IpPart, "/") > 0 Then
		IpPart = Mid(IpPart, 1, StrFind(IpPart, "/") - 1);
	EndIf;
	If StrFind(IpPart, "@") > 0 Then
		IpPart = Mid(IpPart, StrFind(IpPart, "@") + 1);
	EndIf;
	If StrFind(IpPart, ":") > 0 Then
		IpPart = Mid(IpPart, 1, StrFind(IpPart, ":") - 1);
	EndIf;
	
	HTTPConnection = New HTTPConnection(IpPart, PortHTTP,,,,, OpenSSLSecureConnection);
	HTTPRequest = New HTTPRequest(FileURL);
	HTTPResponse = HTTPConnection.Get(HTTPRequest);
	
	Return HTTPResponse.GetBodyAsBinaryData();

EndFunction

#EndRegion
