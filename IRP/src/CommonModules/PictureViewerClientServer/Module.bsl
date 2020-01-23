Function FileInfo() Export
	Return New Structure(
		"Success,
		|FileID,
		|FileName,
		|Height,
		|Width,
		|Size,
		|Extension,
		|URI,
		|Preview1URI,
		|MD5,
		|Ref");
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
	Object.Preview1URI = FileInfo.Preview1URI;
EndProcedure

