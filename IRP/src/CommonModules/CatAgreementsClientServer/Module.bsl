
Procedure SetVisible(Object, Form) Export
	IsStandard = Object.Kind = PredefinedValue("Enum.AgreementKinds.Standard");
	IsRegular  = Object.Kind = PredefinedValue("Enum.AgreementKinds.Regular");
	ApArByStandardAgreements = Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement");
	ApArByDocuments          = Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments");
	
	IsCustomer = Object.Type = PredefinedValue("Enum.AgreementTypes.Customer");
	IsVendor   = Object.Type = PredefinedValue("Enum.AgreementTypes.Vendor");
	
	Form.Items.ItemSegment.Visible = IsCustomer And Not IsStandard;	
	
	Form.Items.StandardAgreement.Visible = ApArByStandardAgreements;
	
	Form.Items.ApArPostingDetail.ReadOnly       = IsStandard;
	Form.Items.PriceType.Visible                = IsRegular;
	Form.Items.PriceIncludeTax.Visible          = IsRegular;
	Form.Items.NumberDaysBeforeShipment.Visible = IsRegular;
	Form.Items.Store.Visible                    = IsRegular;
	Form.Items.UseCreditLimit.ReadOnly = Not IsCustomer  Or IsStandard;
	Form.Items.CreditLimitAmount.Visible            = Object.UseCreditLimit And IsCustomer And Not IsStandard;
	Form.Items.CurrencyMovementTypeCurrency.Visible = Object.UseCreditLimit And IsCustomer And Not IsStandard;
	Form.Items.PaymentTerm.Visible = ApArByDocuments And (IsCustomer Or IsVendor) And Not IsStandard;
EndProcedure