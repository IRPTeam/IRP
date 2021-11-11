
&AtClient
Procedure CreateSC(Command)
	CreateSCAtServer();
EndProcedure

&AtServer
Procedure CreateSCAtServer()
	RefPartner = Catalogs.Partners.FindByCode(64);
//	RefItemKey = Catalogs.ItemKeys.FindByCode(159);
//	RefStore   = Catalogs.Stores.FindByCode(5);
	
	Builder = BuilderServer_V2;
	Doc = Builder.CreateDocument(Metadata.Documents.ShipmentConfirmation);
	
	Builder.SetProperty(Doc, Doc.Atr.TransactionType, Enums.ShipmentConfirmationTransactionTypes.Sales);
	Builder.SetProperty(Doc, Doc.Atr.Partner, RefPartner);
	
//	ItemList = Doc.Table.ItemList;
//	
//	Row = Builder.AddRow(Doc, ItemList);
//	
//	Builder.SetRowProperty(Doc, Row, ItemList.ItemKey, RefItemKey);
//	Builder.SetRowProperty(Doc, Row, ItemList.Store, RefStore);
//	Builder.SetRowProperty(Doc, Row, ItemList.Quantity, 10);
//	
//	Builder.Write(Doc);
EndProcedure

