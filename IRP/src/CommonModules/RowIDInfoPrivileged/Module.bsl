
Procedure FillVisibleFields(BasisesTree, VisibleFields) Export
	RowIDInfoClientServer.FillVisibleFields(BasisesTree, VisibleFields);
EndProcedure

Function CreateBasisesTreeReverse(BasisesTable, ErrorInfo = Undefined) Export
	Return RowIDInfoServer.CreateBasisesTreeReverse(BasisesTable, ErrorInfo);
EndFunction

Procedure CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, ResultsTree) Export
	RowIDInfoServer.CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, ResultsTree);
EndProcedure

Function ExtractData(BasisesTable, Ref, AddInfo = Undefined) Export
	Return RowIDInfoServer.ExtractData(BasisesTable, Ref, AddInfo);
EndFunction
	
Function ConvertDataToFillingValues(RefMetadata, ExtractedData) Export
	Return RowIDInfoServer.ConvertDataToFillingValues(RefMetadata, ExtractedData);
EndFunction

Function GetBasises(Ref, FullFilter) Export
	Return RowIDInfoServer.GetBasises(Ref, FullFilter);
EndFunction

Function GetBasisesInfo(Ref, Key1, Key2) Export 
	Return RowIDInfoServer.GetBasisesInfo(Ref, Key1, Key2);
EndFunction

Procedure CreateChildrenTree(Ref, Key, RowID, TreeRows) Export
	RowIDInfoServer.CreateChildrenTree(Ref, Key, RowID, TreeRows);
EndProcedure

Procedure FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable) Export
	RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
EndProcedure

Procedure BeforeWrite_RowID(Object, Cancel, WriteMode, PostingMode) Export
	RowIDInfoServer.BeforeWrite_RowID(Object, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite_RowID(Object, Cancel) Export
	RowIDInfoServer.OnWrite_RowID(Object, Cancel);
EndProcedure

Procedure Posting_RowID(Object, Cancel, PostingMode) Export
	RowIDInfoServer.Posting_RowID(Object, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting_RowIDUndoPosting(Object, Cancel) Export
	RowIDInfoServer.UndoPosting_RowIDUndoPosting(Object, Cancel);
EndProcedure
