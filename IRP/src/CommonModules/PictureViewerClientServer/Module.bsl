Function FileInfo() Export
	Return New Structure("Success,
						 |FileID,
						 |FileName,
						 |Height,
						 |Width,
						 |Size,
						 |Extension,
						 |URI,
						 |MD5,
						 |Ref,
						 |Preview");
EndFunction

Procedure SetFileInfo(FileInfo, Object) Export
	Object.Description = FileInfo.FileName;
	Object.URI = FileInfo.URI;
	Object.FileID = FileInfo.FileID;
	Object.Height = FileInfo.Height;
	Object.Width = FileInfo.Width;
	Object.SizeBytes = FileInfo.Size;
	Object.Extension = FileInfo.Extension;
	Object.MD5 = FileInfo.MD5;
EndProcedure

Function AllPictureExtensions(AddInfo = Undefined) Export
	Return StrSplit("jpeg,jpg,png,ico", ",");
EndFunction

Function FilterForPicturesDialog() Export

	Data = "*." + StrConcat(AllPictureExtensions(), ";*.");
	Return "(" + Data + ")|" + Data;

EndFunction

Function PreparePictureURL(IntegrationSettings, URI, UUID = "", AddInfo = Undefined) Export
	Return URI;
EndFunction