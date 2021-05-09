Function Strings(Lang) Export
	
	Strings = New Structure();
	
	#Region Equipment
	Strings.Insert("Eq_001", NStr("en='2ACBE9CB-918E-5CA4-4B54-448D14B89456'", Lang));
	Strings.Insert("Eq_002", NStr("en='F1E13A8D-2ED8-ADC2-2374-402EFA2B3E5B'", Lang));
	Strings.Insert("Eq_003", NStr("en='08EDF311-D69B-6D9B-B217-7C92285099FC'", Lang));
	Strings.Insert("Eq_004", NStr("en='1B1C29F9-989F-9FC7-784C-C6DD7A294E48'", Lang));
	Strings.Insert("Eq_005", NStr("en='6F232456-B4CB-8DAE-ECA7-7C3058380217'", Lang));
	Strings.Insert("Eq_006", NStr("en='63274FFF-2508-818E-E2F8-8E41BB4B8192'", Lang));
	
	Strings.Insert("EqError_001", NStr("en='12AF2C44-1C6C-67F9-9662-2B9957D8A02B______________________________________'", Lang));

	Strings.Insert("EqError_002", NStr("en='BDB6874B-4FED-EAC0-0FEA-A8A16F1FA39D______
	                                   |_________________________________________________________________________'", Lang));
	
	Strings.Insert("EqError_003", NStr("en='7AB8D3F6-7A36-1C4A-A2A3-3C2F5B3F7F71___'", Lang));
	Strings.Insert("EqError_004", NStr("en='CC3865AA-6A99-BD43-3620-0D8FC532E98D________'", Lang));
	Strings.Insert("EqError_005", NStr("en='68BB357C-8B23-FC0F-F8CC-C6C098F55087______________%1,%2'", Lang));
	#EndRegion
	
	#Region POS
	
	Strings.Insert("POS_s1", NStr("en='C15B90DE-68AD-3EBA-AD98-8EEF3FDC0321___________'", Lang));
	Strings.Insert("POS_s2", NStr("en='F4F3AE64-CE81-7FC0-07DF-F7A5695AFDCE______________'", Lang));
	Strings.Insert("POS_s3", NStr("en='32F2458A-3533-19C4-48E8-820C070706BD________________________________'", Lang));
	Strings.Insert("POS_s4", NStr("en='C651CCA6-C776-2F3C-C2A9-9147EC84C906'", Lang));
	#EndRegion
	
	#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en='98C73CFE-FE0F-F69C-C6F7-727C78259421%1,%2,%3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("en='79F8EFE1-7E8F-2C76-6A1D-D8000BA60160%1,%2'", Lang));
	Strings.Insert("S_004", NStr("en='8C65C9E2-3A01-7928-8AE1-1E2BD440332C'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en='8A7F3B77-DE4D-114C-CCE0-02FBBCB31116__________%1'", Lang));
	Strings.Insert("S_006", NStr("en='F61A10D4-15D3-5E52-2CB0-093C51FEC9E0__'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("en='EB919343-C448-AB04-4CA5-59170E2D70E9%1'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en='1A9E4676-663D-3ABD-D03C-C301085DBAD0'", Lang));
	Strings.Insert("S_015", NStr("en='2EBC3422-D630-9AF9-9DB8-8C57217ED72D'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("en='8A6925D9-C33E-111C-CCE0-03D2919B3B22%1,%2,%3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("en='A5E55F5C-E6A5-4CD2-2BD6-6B85CA908DD0'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en='FF8DA589-E0EE-573A-A632-26DD7254335D%1'", Lang));
	Strings.Insert("S_022", NStr("en='231A83D3-BA44-3BC2-2BD1-1D36072D6BC4________'", Lang));
	Strings.Insert("S_023", NStr("en='5C861201-7421-FC59-95BA-A53F5DBFCF5D'", Lang));
	
	Strings.Insert("S_026", NStr("en='73DE04EC-9D4E-577F-F131-11E80A3FCB02______'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en='93B84AB4-8908-FB5E-E6FE-EF29DC51B661'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en='05DFDF96-ED3A-86C2-2113-308BD08F51E2'", Lang));
	Strings.Insert("S_029", NStr("en='D7B37F17-CC11-34E9-950A-A3CC7889BF78'", Lang));
	Strings.Insert("S_030", NStr("en='3C022A3A-8B10-D4FF-F9A6-6F1B2CA8F08C'", Lang));
	Strings.Insert("S_031", NStr("en='6D47E737-CB85-FD15-5757-7EA5E6D5C177'", Lang));
	Strings.Insert("S_032", NStr("en='663BEFD5-929A-A204-43BA-A97A56E57344'", Lang));
	#EndRegion
	
	#Region Service
	Strings.Insert("Form_001", NStr("en='227B2DD1-03AA-8EA0-0130-07913DEAA02F'", Lang));
	Strings.Insert("Form_002", NStr("en='84ADEDC7-D2D9-875F-FB00-081005992A16'", Lang));
	Strings.Insert("Form_003", NStr("en='51E1E7E3-9C72-BEB1-1C62-233C85FF58E4'", Lang));
	Strings.Insert("Form_004", NStr("en='C9ACF1DE-33F5-B49A-A261-1A9CBD1A850D'", Lang));
	Strings.Insert("Form_005", NStr("en='9394DC76-A7E8-AA35-5FC6-6517717CEECF'", Lang));
	Strings.Insert("Form_006", NStr("en='B0A85FF6-4C94-A282-28AD-D851313053EA'", Lang));
	Strings.Insert("Form_007", NStr("en='CB24FD49-510A-71E3-3C26-6B092CEE53EA'", Lang));
	Strings.Insert("Form_008", NStr("en='76C447B0-C7AF-4EE9-9529-9D625A59668E'", Lang));
	Strings.Insert("Form_009", NStr("en='3C31AAC3-37C3-4A7F-FC55-5277B640ED15'", Lang));
	Strings.Insert("Form_013", NStr("en='3D008872-6735-3A1E-E347-7972676B69B3'", Lang));
	Strings.Insert("Form_014", NStr("en='DE5C20EC-29F2-7402-284B-BF659223D0EC'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("en='74E5F6E1-D312-680E-EFD2-2CD9FE8D3E87'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en='01A3C395-0082-6352-2C6D-DE29579D0ED6'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("en='DDD7EF50-72B0-BFA5-5330-0591CFF31B84'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en='5165ACC2-B401-935D-D480-00C1904631D1'", Lang));
	Strings.Insert("Form_023", NStr("en='DAA047BB-B2DE-61DC-C271-1FC693A09820'", Lang));
	Strings.Insert("Form_024", NStr("en='D6FA468B-E15B-393A-AB44-4E88EA28492D'", Lang));
	
	Strings.Insert("Form_025", NStr("en='AC4FAC5D-1C6A-FF08-8762-2C4DE1F2F498'", Lang));
	
	Strings.Insert("Form_026", NStr("en='E0AC9FCC-9D45-D0DC-C9C7-7D6C190CAF86'", Lang));
	Strings.Insert("Form_027", NStr("en='E11A9633-AAB7-9E79-9E1F-F2F41A079399'", Lang));
	Strings.Insert("Form_028", NStr("en='BD0CF784-FA96-07CD-DF4C-C8E40971F21D'", Lang));
	Strings.Insert("Form_029", NStr("en='D77E20E9-9717-F4C1-1730-0C0927F7C2F3'", Lang));
	Strings.Insert("Form_030", NStr("en='89F2DDF5-67A1-438C-CE0D-D3DA5F4FD3E7'", Lang));
	Strings.Insert("Form_031", NStr("en='BFEEFF52-20AD-AF77-7C32-23C3B5F10C45'", Lang));
	Strings.Insert("Form_032", NStr("en='E87BDF37-8430-6F7D-D38B-BF761F0A337D'", Lang));
	#EndRegion
	
	#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("en='0113D0EB-C466-2577-7BC4-44B6F56FDFF1%1'", Lang));
	Strings.Insert("Error_003", NStr("en='BA266C05-3421-D0EE-EE7A-A406CBA08DEB'", Lang));
	Strings.Insert("Error_004", NStr("en='0AC17093-CA57-8467-757E-ECD5B5FE0A5F'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en='ED4444FA-3815-FC1A-A954-4F173D88D88F_______________%1'", Lang));
	Strings.Insert("Error_008", NStr("en='D0827563-58BE-1583-37C8-826C2C629735___'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en='EA95834D-E092-EEEF-FA52-2933AB601FE8%1'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en='426FD697-FBB8-3173-315D-D2CF4EB3C542%1'", Lang));
	Strings.Insert("Error_011", NStr("en='E524A3AE-2C0F-106A-A841-1B595B2191D6'", Lang));
	Strings.Insert("Error_012", NStr("en='6FE6133A-B423-683F-F705-58E5954B0C8F_________'", Lang));
	Strings.Insert("Error_013", NStr("en='660E5F0E-F220-AFD0-09B3-371796A45A18'", Lang));
	Strings.Insert("Error_014", NStr("en='0DCD9C17-D710-8DB4-42B1-120B1053E5F4____________'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr("en='BFAD82ED-0F41-C433-3DE6-67E2994069BE_______________________________________________%1'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr("en='5B76BA8D-C9B6-A3D1-1AFD-DE27FFD6061C___________________________________________________%1,%1,%2'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr("en='5B76BA8D-C9B6-A3D1-1AFD-DE27FFD6061C___________________________________________________%1,%1,%2'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr("en='685ECF3B-3B2E-5094-4D7F-F4EF6469DD03_________________________________________________%1,%2'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("en='B37C787D-20E4-3A0B-BB9B-BC029F565C96%1'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr("en='2897AB70-DADB-B465-5BE8-89288A1D7BDD____________________________________________________%1'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr("en='BFAD82ED-0F41-C433-3DE6-67E2994069BE_______________________________________________%1'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("en='62F69A0E-BD98-8E96-6C78-869CEC550794___________________%1,%2'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("en='CEECB2D4-E76F-BF9C-C846-6AA80E30C6D6%1,%2,%3'", Lang));

	Strings.Insert("Error_031", NStr("en='85C069F4-A2F1-FCF2-2C65-521182900709__________________________________________'", Lang));
	Strings.Insert("Error_032", NStr("en='D7AF204D-B470-1AA4-4396-631F642F8D64'", Lang));
	Strings.Insert("Error_033", NStr("en='78FCD961-C2C4-65D2-2F5D-D72E820DB4A4'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("en='221A5633-F1E0-FA3C-C825-5CD1D7327A8F%1'", Lang));
	Strings.Insert("Error_035", NStr("en='75433875-3AEE-131C-C081-14134780F698'", Lang));
	Strings.Insert("Error_037", NStr("en='FBAA655F-62A0-9C36-6DE4-4E581E7F8479____________'", Lang));	
	Strings.Insert("Error_040", NStr("en='6492349E-23E0-C216-62AC-C12DAB5F732F'", Lang));
	Strings.Insert("Error_041", NStr("en='4DC7D4A3-FA69-DD32-23A6-6D1C8F65C7A2___________________%1,%2'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("en='F06C605D-FBE4-8036-6AE0-03F9C7B2CA1A_%1'", Lang));
	Strings.Insert("Error_043", NStr("en='E698AD41-9633-95B1-1D8A-A0B4BEC55E57'", Lang));
	Strings.Insert("Error_044", NStr("en='9C25EA1F-74B2-D733-38AD-D09AC2A82F79'", Lang));
	Strings.Insert("Error_045", NStr("en='D287FB4A-BE14-8C4A-AC64-46267916F2CA'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("en='62D03E8E-7153-150C-CEFB-B19B92466273%1'", Lang));
	Strings.Insert("Error_049", NStr("en='62B7B9E4-7030-AF40-0A01-15ED9C977D9E______'", Lang));
	Strings.Insert("Error_050", NStr("en='6FCA17B9-D80A-FB7C-C09C-C0B006FA5097____________________________________________________________'", Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr("en='5C064016-A587-32EE-EE32-243636898AD0___________________________________________________________________%1,%1'", Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en='AA54EC0E-91B6-F64A-AC84-452B19083EBA%2,%3,%1
	                                 |_________________________________________________'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr("en='169F34CA-EC97-C3B6-6CB1-1978E41FBC37_______________________________________________%2,%3,%1'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en='CF54FBB4-F580-1E54-439C-CFF317E3F114______________________%1'", Lang));
															  
	Strings.Insert("Error_055", NStr("en='B39F867D-8289-A9EF-F9F2-2D1A791FDE8F_________________'", Lang));

	Strings.Insert("Error_056", NStr("en='4F8126BF-FACE-C6EE-E0DA-AC2B1276301D_____________________________________'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr("en='EF671ACB-DE09-7407-740B-B7952CB05E4E__________________________________________%1,%2'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr("en='E81EDDF1-3A75-365B-B5F7-702C41D776E9________________________________________%1,%2'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr("en='C90EA75D-D03B-0AB7-7AE3-3E4D5BEC24B0__________________________________________________________%2,%1'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("en='D4900E23-9ED2-96F1-1044-4843DB60D1B3________________________________________________%2,%1,%1
	                                 |______________________________________________'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr("en='EF70A607-8DE8-1437-74EA-A835F2D1E999______________________________________________________________%2,%1'", Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr("en='99D8460D-37CE-73BC-C5F3-3FD860DF3695________________________________________________________________________%2,%1,%3'", Lang));
	
	Strings.Insert("Error_065", NStr("en='A22626EC-2501-45E7-725B-BD5122E7B488'", Lang));
	Strings.Insert("Error_066", NStr("en='39549BA4-46F3-8465-58D7-769D778D1770'", Lang));
	Strings.Insert("Error_067", NStr("en='3602983B-E5E0-4DB4-4328-8B8FBEC87B98'", Lang));


	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr("en='89E56E12-B988-990F-F809-9AE241FE5927_______________________________________%1,%2,%3,%4,%5,%8,%6,%8,%7,%8'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("en='0C44E77F-1114-B0A6-67EA-A574ED3CF2D0%1'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("en='19ADB838-653D-FC1F-F1C7-7A42F37E2B84%1'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr("en='689661E2-280E-50A4-4ABF-FEE0701B3EB3______________________________________________%1,%2'", Lang));
	Strings.Insert("Error_074", NStr("en='25155807-E759-A7A0-0F4B-BDC01355603A_______________________'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en='8CA034FB-FA39-6087-768D-D79F93988CE7_________%1'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("en='C59C12B6-13A5-3E7B-B48A-A0425358ACF9%1'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en='0654D34F-29A1-F79B-B728-80803A689DF1________________________________%1,%2'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("en='6DEE7EA6-AC39-4E5A-ABF6-605951A834EB________________%1,%2'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en='9D0AB0BD-0953-A023-39F3-3AB8F3C93191________%1,%2,%3,%4'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en='F27E926B-DDC0-9890-06AC-C40A42FAA626__________________________________%1,%2,%3,%4,%5'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en='F27E926B-DDC0-9890-06AC-C40A42FAA626__________________________________%1,%2,%3,%4,%5'", Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en='CC4350DA-2E1F-070E-E22B-BF252BA831BD%1'", Lang));
	
	Strings.Insert("Error_084", NStr("en='3EAE74B0-6DEE-76C3-39A5-5C529790AF29__'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr("en='CB15E49E-A257-013C-C0B6-6C73739E5CD1_____________________________________________%1,%2,%3,%4,%5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("en='01D919AA-D46D-B211-161E-E040C3A2BD6E_________%1,%2'", Lang));
	
	Strings.Insert("Error_087", NStr("en='FEA8078F-3330-6DC8-8DB1-15FDBBF7F2A6'", Lang));
	Strings.Insert("Error_088", NStr("en='F6E12406-C2AB-7DF4-443B-BC6672A2C932_____________'", Lang));
	
	Strings.Insert("Error_089", NStr("en='8BD39D29-9CF1-2B40-01C1-1F3C0500D1FC_%1,%2'", Lang));
	Strings.Insert("Error_090", NStr("en='D815617C-4C65-369D-D068-882877F95002%1'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("en='4504BC02-6927-6C01-1940-0295B36AA5AA_________________________%1,%2,%3,%4,%7,%5,%7,%6,%7'", Lang));
	
	Strings.Insert("Error_091", NStr("en='1DC46B3F-55F4-0A71-163D-D283EA1C8CFC'", Lang));
	
	Strings.Insert("Error_092", NStr("en='66160944-996A-61EB-B113-372A5BFD863B%1'", Lang));
	Strings.Insert("Error_093", NStr("en='4DC4DD14-4A21-E402-2A48-85D093815400_________________'", Lang));
	Strings.Insert("Error_094", NStr("en='7D7D21EA-278D-C488-8F57-74A65992A2A1______________________'", Lang));
	
	
	#EndRegion
	
	#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("en='FFC804AB-4AE0-6E2C-C1F0-0A2295C6F202_____________________________%1,%2,%1,%2
	                                       |________________________________________________________________________________'", Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("en='B0701656-DF69-8DAB-B913-3D7486267528%1'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en='9AE27686-C33D-E8C9-9F98-84B1433D8EF6'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en='8BBA90B8-E049-1EDA-A975-576A423FAF11'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en='807FB5AE-34C6-44DE-EA92-24F5987DFE40'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr("en='EA9DDDB9-C870-7B2A-ABC3-3DCB122E0286______________________________%1'", Lang));
	
	Strings.Insert("InfoMessage_007", NStr("en='69B878AE-601E-EE40-0978-8F8AC2CCB78A%1,%2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("en='69B878AE-601E-EE40-0978-8F8AC2CCB78A%1,%2'", Lang));
	
	Strings.Insert("InfoMessage_009", NStr("en='814171D6-98E9-E3AD-D26F-F053E0883C60___________________________________________'", Lang));
	Strings.Insert("InfoMessage_010", NStr("en='D429D4BF-C7AA-341A-A330-0ECB099A86ED______________________________________________________'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en='B0B00E1E-120C-A9CE-E28D-D6EE7982275A______________________'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("en='676D356D-A381-935C-CAF0-0B9A9392CABE______________________%1,%2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr("en='76186C2D-0ACA-88A3-39E9-99721B565458____________________________________________%1'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr("en='FC8EDAC2-45F6-5A6B-BB68-88E10461AD8A__________________________________________%1'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("en='D64BCB30-B45B-5141-171B-B623CBD815AF____%1'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("en='2A8AB474-72F0-FFEA-A775-5B506C9C4940____________%1,%2'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("en='7E590F4D-F249-7B01-1874-4171E8F5DCCF__________________%1'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en='3D8F680C-F2D3-0D04-4A51-197C02E19800'", Lang));
	
	Strings.Insert("InfoMessage_019", NStr("en='FBEC7A8C-D8E6-ABCC-C161-1BB773D5C2DF'", Lang));
	
  	Strings.Insert("InfoMessage_020", NStr("en='5CC35B61-5B4D-D65C-C44B-BF05879F7AD6%1'", Lang));
  
  	// %1 - 42
  	Strings.Insert("InfoMessage_021", NStr("en='3B58AABB-DC28-0521-196A-A414033C0487__________________________%1'", Lang));
  	// %1 - 
  	Strings.Insert("InfoMessage_022", NStr("en='894C97CF-D822-FB2B-B50D-D6A0D3240864%1'", Lang));
	Strings.Insert("InfoMessage_023", NStr("en='33745A3E-B854-7AD5-59F1-1582CFDB2D1F__________________________________________________________'", Lang));
	#EndRegion
	
	#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en='A9E96B84-50BF-39F8-8912-294ABA32F584___'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("en='84F9EDB0-7FE7-BB53-3DFF-FEDC60A73F53'", Lang));
	Strings.Insert("QuestionToUser_003", NStr("en='D20C8C9D-71C4-2AF6-6B4A-AF80E1EE3BC9_______________________________________________%1'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en='42913706-A1D1-9035-54E7-78FFD2D603A0__________________________'", Lang));
	Strings.Insert("QuestionToUser_005", NStr("en='79090F78-B86C-8CA9-9EC7-7121335DC155'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("en='84DA2153-50FD-514A-A75A-A6C873B298CD__'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en='B6FF0C07-C95C-AE7B-B49B-BDED479A01C0________'", Lang));
	Strings.Insert("QuestionToUser_008", NStr("en='1F6CF3E5-261C-8567-7E7F-F298C5ED4457_____________________________________________'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en='5D0A9502-D09D-EE19-92BB-BF2C3A688AB2_______________%1'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en='3ED3D8EC-4717-EB96-6E92-2862D69EC297_________________________%1'", Lang));
	Strings.Insert("QuestionToUser_012", NStr("en='584DFA8C-67CE-A827-7591-11A73CA166A1'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en='EC5E82AF-314A-FC2C-CBC5-58E3F19865B6'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en='EF54791F-6E5C-3357-70BF-F35441FE3636___________________________'", Lang));
	Strings.Insert("QuestionToUser_015", NStr("en='566C8F1D-37C4-4F01-1E27-7C34EFE6EE8E__'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("en='462DDA43-7262-0C57-7236-6DEEF7A29A8D____'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("en='500EB9FD-0360-1554-41AF-F9E4A54F9817'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en='2584DE9A-9DA7-4DB1-18E6-66D706013F7A'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en='DF7B3259-79B0-DEF6-6E57-7D9A1BD8315C'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("en='C3694019-9A38-4FF9-93A3-3746C62EAE65__'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("en='3CF7325D-B570-FF56-6785-531A3A1238E0_____________________'", Lang));
	#EndRegion
	
	#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en='959143D6-AEDC-7727-7F74-4AC4E38771F0'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en='9A13DD97-963E-1BC4-427D-DCC49DAF6A86'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en='B6C062DB-F7F2-6A70-0283-3DA0593F6509'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en='C1EA5B18-606D-9845-5FFB-BE95CCE2E9AD'", Lang));
	#EndRegion
	
	#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en='0561B68D-7DE2-D9CB-B279-958454D654EC__%1,%2'", Lang));
	Strings.Insert("UsersEvent_002", NStr("en='A4FE5236-C977-BFD7-7393-3CF3845B0F6A%1,%2'", Lang));
	#EndRegion
	
	#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en='CF633766-69D6-AC22-2FA2-21DF61CB554C'", Lang));
	
	Strings.Insert("I_2", NStr("en='32E494B2-65BC-82E2-2C9A-AD050D13A222'", Lang));
	
	Strings.Insert("I_3", NStr("en='30ED1AA4-EE80-2D37-761C-C9A1182FF786'", Lang));
	Strings.Insert("I_4", NStr("en='F2138751-DA6B-23D8-82FC-C37ECA25E82A%1,%2'", Lang));
	Strings.Insert("I_5", NStr("en='A7E7DC5A-9A28-D58F-F9DB-BC040736D241'", Lang));
	Strings.Insert("I_6", NStr("en='8D7BF2D6-40CA-54B9-9902-2A1A50E618EB'", Lang));
	#EndRegion
	
	#Region Exceptions
	Strings.Insert("Exc_001", NStr("en='ED473741-2816-8D61-1759-9A23648A446A'", Lang));
	Strings.Insert("Exc_002", NStr("en='FB8F183A-146C-7563-3CED-DA024E0C096C'", Lang));
	Strings.Insert("Exc_003", NStr("en='9FCB2D44-93CE-0C6F-F1F2-218EF8A5B8AA%1'", Lang));
	Strings.Insert("Exc_004", NStr("en='C92F5C9D-DC5B-A472-2C20-0691AA1F9BAE____'", Lang));
	Strings.Insert("Exc_005", NStr("en='F3624115-6397-0461-1E34-4683C18F5999'", Lang));
	Strings.Insert("Exc_006", NStr("en='7BF9C2B5-6EC8-8B12-2354-4754CCACE8E8____'", Lang));
	Strings.Insert("Exc_007", NStr("en='D3DA9ECB-25AB-ECDB-B8EB-B8ACF0294F7A__%1'", Lang));
	Strings.Insert("Exc_008", NStr("en='5704C566-1EE3-0F55-5988-86D9EF107C79'", Lang));
	Strings.Insert("Exc_009", NStr("en='12A174BD-4463-6BE7-7E7A-AB27FB0CAF50%1'", Lang));
	#EndRegion
	
	#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("en='2F405459-6649-0EB0-0733-30635AF2054E%1'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("en='ACECB33F-8161-5912-22EC-CB10F5A9E443%1'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en='4BB22BA6-4B72-4624-488D-DA3D974083CF____________%1'", Lang));
	
	Strings.Insert("Saas_004", NStr("en='536C7FB7-6FB9-B20F-F41E-E78B94AC7029'", Lang));
	#EndRegion
	
	#Region FillingFromClassifiers
    // Do not modify "en" strings
    Strings.Insert("Class_001", NStr("en='383F84AA-6C94-9CF2-282E-ECBAABFE25C4'", Lang));
    Strings.Insert("Class_002", NStr("en='9048D720-30FF-481F-FC3C-C69763E3108A'", Lang));
    Strings.Insert("Class_003", NStr("en='B9E76F2E-CEEC-C606-659F-F85495D82DFD'", Lang));
    Strings.Insert("Class_004", NStr("en='4765EBF3-4BD5-C7D2-2F1A-A12A24B44756'", Lang));
    Strings.Insert("Class_005", NStr("en='C8EB8E41-4CB5-CC12-24BB-BC19A061172B'", Lang));
    Strings.Insert("Class_006", NStr("en='78C6CA81-3F7B-1050-0EA7-70628D95C5FA'", Lang));
    Strings.Insert("Class_007", NStr("en='3E4C4E38-16F1-5382-2B30-0D2F4B0EB586'", Lang));
    Strings.Insert("Class_008", NStr("en='5073B496-F747-0E7F-FE83-33CF32FDCCE0'", Lang));
    #EndRegion
    
    #Region PredefinedObjectDescriptions
	PredefinedDescriptions(Strings, Lang);
	#EndRegion
    
	#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en='AEE4D090-D941-7C7F-F863-38D420349377_______%1'", Lang));	// Form PickUpDocuments
	#EndRegion
	
	#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("en='43FD3975-BF22-AC9B-BFAE-E4E7C6F06735'", Lang));
	#EndRegion
	
	#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en='1CECCA8B-87DF-341E-EB6A-A071CE31293A'", Lang));
	#EndRegion	
	Return Strings;
EndFunction

Procedure PredefinedDescriptions(Strings, CodeLanguage)

	Strings.Insert("Description_A001", NStr("en='2051577F-C50B-6546-6DA2-20E0CE24AA12'", CodeLanguage));
	Strings.Insert("Description_A003", NStr("en='187B0DFC-6EE3-50B4-490A-A4A518C70BFC'", CodeLanguage));
	Strings.Insert("Description_A004", NStr("en='9186BE19-CDFD-143A-A511-1215DCCD0C9D'", CodeLanguage));
	Strings.Insert("Description_A005", NStr("en='15DB5892-FA5D-63BC-CD6B-B6959923E363'", CodeLanguage));
	Strings.Insert("Description_A006", NStr("en='816CADDC-184A-0A38-8FED-DE5718FAB415'", CodeLanguage));
	Strings.Insert("Description_A007", NStr("en='06471A1C-7089-72DD-D011-10012DC4CF2A'", CodeLanguage));
	Strings.Insert("Description_A008", NStr("en='E4B38FAB-E1AC-DE3E-EC9E-E2454E2C001E'", CodeLanguage));
	Strings.Insert("Description_A009", NStr("en='8FC686D4-44BA-77E6-6011-1BB861E8C215'", CodeLanguage));
	Strings.Insert("Description_A010", NStr("en='37855256-BE21-B832-2EEA-A7439CF169C9'", CodeLanguage));
	Strings.Insert("Description_A011", NStr("en='EB1C33B2-B01A-28E4-401A-ADD22DD14506'", CodeLanguage));
	Strings.Insert("Description_A012", NStr("en='3EDA209D-4CBC-6C63-34FF-F782CABB2099'", CodeLanguage));
	Strings.Insert("Description_A013", NStr("en='462DDC8F-4862-A0F3-3088-846ACD965FD1'", CodeLanguage));
	Strings.Insert("Description_A014", NStr("en='C179E671-8DDE-6F2B-BF62-232892E0283A'", CodeLanguage));
	Strings.Insert("Description_A015", NStr("en='D5C44832-D055-1AA2-2DBE-E186060152E9'", CodeLanguage));
	Strings.Insert("Description_A016", NStr("en='4F82D112-A45D-EEA2-2193-30F08441B154'", CodeLanguage));
	Strings.Insert("Description_A017", NStr("en='5B188215-77CB-F10C-C03E-E8EDE5A1AF2B'", CodeLanguage));
	Strings.Insert("Description_A018", NStr("en='84ACD6D5-B0FF-573B-B472-23681BB76993'", CodeLanguage));
	Strings.Insert("Description_A019", NStr("en='D2F066E0-0561-2C4C-C759-94C19EFB580B'", CodeLanguage));
	Strings.Insert("Description_A020", NStr("en='2DBE2BF6-289B-5EBE-E8D6-6110921AF14E'", CodeLanguage));
	Strings.Insert("Description_A021", NStr("en='108F6FBF-7269-34EA-ADAD-DFD86F58E916'", CodeLanguage));
	Strings.Insert("Description_A022", NStr("en='FE49E86F-8842-0D25-5B35-54E9A7957650'", CodeLanguage));
	Strings.Insert("Description_A023", NStr("en='9A7F43FB-4F13-A9DD-DB9E-E95314C3B5DC'", CodeLanguage));
	Strings.Insert("Description_A024", NStr("en='7CA1A8D9-4541-B717-7532-2278F7081760'", CodeLanguage));
	Strings.Insert("Description_A025", NStr("en='AC40C452-B8B1-A8BC-C58C-CFC547C5F60E'", CodeLanguage));
	Strings.Insert("Description_A026", NStr("en='CC393C24-9767-7D67-75AC-CCB0B8FB0499'", CodeLanguage));
	Strings.Insert("Description_A027", NStr("en='DFB95B97-E069-9B6B-BAF0-0A20CB22B306'", CodeLanguage));
	Strings.Insert("Description_A028", NStr("en='8D00C5CF-B26E-C926-622B-BFC7398E29EF'", CodeLanguage));
	Strings.Insert("Description_A029", NStr("en='5954DB68-1275-37F2-2CC6-6759FCCF7E04'", CodeLanguage));
	Strings.Insert("Description_A030", NStr("en='9E42A9EF-A1B0-2B18-8996-63B37397A521'", CodeLanguage));
	Strings.Insert("Description_A031", NStr("en='9B274517-14A4-B4F7-75C0-08DF58DCFE50'", CodeLanguage));
	Strings.Insert("Description_A032", NStr("en='C262E1A8-7E52-0401-18D1-1618381CAD21'", CodeLanguage));
	Strings.Insert("Description_A033", NStr("en='58CEFE62-7BA4-3DF3-3C3F-FCD0C87C7D54'", CodeLanguage));
	Strings.Insert("Description_A034", NStr("en='6786BEE4-90FC-AA54-477C-CCCA0BC6EE21'", CodeLanguage));
	Strings.Insert("Description_A035", NStr("en='C598EA96-FD46-2DD9-963F-F93AEF3F9E90'", CodeLanguage));
	Strings.Insert("Description_A036", NStr("en='C2E48A3B-4EB4-DD6C-CC04-4EAC7C8C96E9'", CodeLanguage));
	Strings.Insert("Description_A037", NStr("en='1BE2462A-D758-D5BA-A083-3C98B4321671'", CodeLanguage));
	Strings.Insert("Description_A038", NStr("en='CFF7082D-CFC8-E829-9C35-535649A2D1F7'", CodeLanguage));
	Strings.Insert("Description_A039", NStr("en='EADBC4B8-2FDC-7174-43AA-A55C60D6FB71'", CodeLanguage));
	Strings.Insert("Description_A040", NStr("en='2424B36C-055A-01CB-B418-8CE2BB1874D2'", CodeLanguage));
	Strings.Insert("Description_A041", NStr("en='9B4E5EF8-801A-3192-2A66-6819CF18E27E'", CodeLanguage));
	Strings.Insert("Description_A042", NStr("en='A0F60566-7197-2C5C-C157-7718ADC1C945'", CodeLanguage));
	Strings.Insert("Description_A043", NStr("en='B13DFC97-268E-560B-BC6D-D7E975E0A022'", CodeLanguage));
	Strings.Insert("Description_A044", NStr("en='1F8669C2-31F7-EF3A-A4DD-DE6E00D3ED32'", CodeLanguage));
	Strings.Insert("Description_A045", NStr("en='9C8F01DA-8F77-837D-D6CA-A92537250A7F'", CodeLanguage));
	Strings.Insert("Description_A046", NStr("en='B1678B96-EEC0-5AEC-CE81-1BE93BCAD904'", CodeLanguage));
	Strings.Insert("Description_A047", NStr("en='5BF75F52-CB0C-CF46-6989-949D3745A30D'", CodeLanguage));
	Strings.Insert("Description_A048", NStr("en='EE47793F-9D29-62BD-D61D-DD406C0CB339'", CodeLanguage));
	Strings.Insert("Description_A049", NStr("en='DA01CBFD-3852-5AD2-2440-0B1CD26BE016'", CodeLanguage));
	Strings.Insert("Description_A050", NStr("en='EE7DFAEE-AE9F-011C-CF63-3732C19330FE'", CodeLanguage));
	Strings.Insert("Description_A051", NStr("en='525D65B0-4170-98C3-3DD3-36D809348407'", CodeLanguage));
	Strings.Insert("Description_A052", NStr("en='B9AFF3DD-86C6-ECEC-CB72-25A7DA57E707'", CodeLanguage));
	Strings.Insert("Description_A053", NStr("en='23DAA625-F382-EE7F-F86C-CDF8CEA75CBA'", CodeLanguage));
	Strings.Insert("Description_A054", NStr("en='0B7A0F4E-A9B0-D8AB-B5B7-72A46E677C2D__'", CodeLanguage));
	Strings.Insert("Description_A056", NStr("en='807F2088-04A1-4D4A-ADA9-9F2B7DFF3172'", CodeLanguage));
	Strings.Insert("Description_A057", NStr("en='2D36C6CE-6673-046B-BA5B-B96D18500D38'", CodeLanguage));
	Strings.Insert("Description_A058", NStr("en='73049E71-BDD5-EB1C-C754-4FBF71664F77'", CodeLanguage));
	Strings.Insert("Description_A059", NStr("en='5504F34F-8167-5DB6-6D92-2087D4FE0106'", CodeLanguage));
	Strings.Insert("Description_A060", NStr("en='3C677367-364D-7469-9286-612C4E40BD10'", CodeLanguage));
	Strings.Insert("Description_A061", NStr("en='3EE08F55-CAA0-F7F6-6731-1B70968DCC8B'", CodeLanguage));
	Strings.Insert("Description_A062", NStr("en='318109D6-4A5A-FE3F-F49D-DAA26CBCE715'", CodeLanguage));
	Strings.Insert("Description_A063", NStr("en='6E92E382-152F-2417-786F-FB466140002E'", CodeLanguage));
		
EndProcedure
