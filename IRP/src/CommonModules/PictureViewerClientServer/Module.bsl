
// File info.
// 
// Returns:
//  Structure - File info:
// * Success - Boolean -
// * FileID - String -
// * FileName - String -
// * Extension - String -
// * Height - Number -
// * Width - Number -
// * Size - Number -
// * URI - String -
// * MD5 - String -
// * Ref - CatalogRef.Files -
// * Preview - Undefined, BinaryData -
// * PrintFormName - String -
Function FileInfo() Export
	FileInfo = New Structure();
	FileInfo.Insert("Success", False);
	FileInfo.Insert("FileID", "");
	FileInfo.Insert("FileName", "");
	FileInfo.Insert("Extension", "");
	FileInfo.Insert("Height", 0);
	FileInfo.Insert("Width", 0);
	FileInfo.Insert("Size", 0);
	FileInfo.Insert("URI", "");
	FileInfo.Insert("MD5", "");
	FileInfo.Insert("Ref", PredefinedValue("Catalog.Files.EmptyRef"));
	FileInfo.Insert("Preview", Undefined);
	FileInfo.Insert("PrintFormName", "");
	
	Return FileInfo;
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
	Object.PrintFormName = FileInfo.PrintFormName;
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

// Get image extensions.
// 
// Parameters:
//  Mode - Number - Mode:
// 0 - only extension
// 1 - begin on a point
// 2 - as file pattern
// 
// Returns:
//  Array - Get image extensions
Function GetImageExtensions(Mode = 1) Export
	// BSLLS:Typo-off
	ImgList = ".ase,.art,.bmp,.blp,.cd5,.cit,.cpt,.cr2,.cut,.dds,.dib,.djvu,.egt,.exif,.gif,.gpl,.grf,.icns,.ico,.iff,.jng,.jpeg,.jpg,.jfif,.jp2,.jps,.lbm,.max,.miff,.mng,.msp,.nitf,.ota,.pbm,.pc1,.pc2,.pc3,.pcf,.pcx,.pdn,.pgm,.PI1,.PI2,.PI3,.pict,.pct,.pnm,.pns,.ppm,.psb,.psd,.pdd,.psp,.px,.pxm,.pxr,.qfx,.raw,.rle,.sct,.sgi,.rgb,.int,.bw,.tga,.tiff,.tif,.vtf,.xbm,.xcf,.xpm,.3dv,.amf,.ai,.awg,.cgm,.cdr,.cmx,.dxf,.e2d,.egt,.eps,.fs,.gbr,.odg,.svg,.stl,.vrml,.x3d,.sxd,.v2d,.vnd,.wmf,.emf,.art,.xar,.png,.webp,.jxr,.hdp,.wdp,.cur,.ecw,.iff,.lbm,.liff,.nrrd,.pam,.pcx,.pgf,.sgi,.rgb,.rgba,.bw,.int,.inta,.sid,.ras,.sun,.tga";
	// BSLLS:Typo-on
	Result = StrSplit(ImgList, ",");
	If Not Mode = 1 Then
		For index = 0 To Result.UBound() Do
			If Mode = 0 Then
				Result[index] = Mid(Result[index], 2);
			ElsIf Mode = 2 Then
				Result[index] = "*" + Result[index];
			EndIf;
		EndDo;
	EndIf;
	Return Result;
EndFunction